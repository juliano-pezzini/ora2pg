-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_valores_peona ( nr_seq_peona_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_competencia_w		timestamp;
dt_comp_inicial_w		timestamp;
dt_referencia_w			timestamp;
vl_despesa_w			double precision;
vl_receita_w			double precision;
ie_tipo_plano_w			pls_peona_v.ie_tipo_plano%type;

C01 CURSOR FOR
	SELECT	trunc(a.dt_referencia, 'month') dt_referencia,
		coalesce(sum(CASE WHEN a.ie_tipo_valor='D' THEN a.vl_peona END ),0) vl_despesa,
		coalesce(sum(CASE WHEN a.ie_tipo_valor='R' THEN a.vl_peona END ),0) vl_receita,
		coalesce(sum(CASE WHEN a.ie_tipo_valor='G' THEN a.vl_peona END ),0) vl_glosa,
		coalesce(sum(CASE WHEN a.ie_tipo_valor='C' THEN a.vl_peona END ),0) vl_coparticipacao,
		a.ie_tipo_plano
	from	pls_peona_v	a
	where	trunc(a.dt_referencia,'month') between dt_comp_inicial_w and dt_competencia_w
	group by trunc(a.dt_referencia, 'month'), a.ie_tipo_plano;

TYPE 		fetch_array IS TABLE OF c01%ROWTYPE;
s_array 	fetch_array;
i		integer := 1;
type Vetor is table of fetch_array index by integer;
Vetor_c01_w			Vetor;

BEGIN

delete from pls_valores_peona
where	nr_seq_peona	= nr_seq_peona_p;

/* Obter dados da PEONA */

select	trunc(dt_competencia, 'month'),
	trunc(add_months(dt_competencia, -11),'month')
into STRICT	dt_competencia_w,
	dt_comp_inicial_w
from	pls_peona
where	nr_sequencia	= nr_seq_peona_p;

open c01;
loop
FETCH C01 BULK COLLECT INTO s_array LIMIT 1000;
	Vetor_c01_w(i) := s_array;
	i := i + 1;
EXIT WHEN NOT FOUND; /* apply on C01 */
END LOOP;
CLOSE C01;

for i in 1..Vetor_c01_w.COUNT loop
	s_array := Vetor_c01_w(i);
	for z in 1..s_array.COUNT loop
		begin
		dt_referencia_w	:= s_array[z].dt_referencia;
		vl_despesa_w	:= s_array[z].vl_despesa - s_array[z].vl_glosa - s_array[z].vl_coparticipacao;
		vl_receita_w	:= s_array[z].vl_receita;
		ie_tipo_plano_w	:= s_array[z].ie_tipo_plano;

		insert into pls_valores_peona(nr_sequencia,
			nr_seq_peona,
			dt_referencia,
			vl_receita,
			vl_despesa,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_tipo_plano)
		values (nextval('pls_valores_peona_seq'),
			nr_seq_peona_p,
			dt_referencia_w,
			vl_receita_w,
			vl_despesa_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			ie_tipo_plano_w);

		end;
	end loop;
end loop;

/*open C01;
loop
fetch C01 into
	dt_referencia_w,
	vl_despesa_w,
	vl_receita_w;
exit when C01%notfound;
	begin
	insert into pls_valores_peona
		(nr_sequencia, nr_seq_peona, dt_referencia,
		vl_receita, vl_despesa, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec)
	values(	pls_valores_peona_seq.nextval, nr_seq_peona_p, dt_referencia_w,
		vl_receita_w, vl_despesa_w, sysdate,
		nm_usuario_p, sysdate, nm_usuario_p);
	end;
end loop;
close C01;*/
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_valores_peona ( nr_seq_peona_p bigint, nm_usuario_p text) FROM PUBLIC;
