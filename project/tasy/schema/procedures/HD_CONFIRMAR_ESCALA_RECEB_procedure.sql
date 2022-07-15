-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_confirmar_escala_receb (nr_seq_escala_p bigint, nr_seq_unidade_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_pessoa_fisica_p text, nr_escala_p bigint, nr_turno_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_escala_w		bigint;
nr_seq_turno_w		bigint;
ie_dia_semana_w		varchar(3);
dt_fim_escala_w		timestamp;
nr_seq_escala_aux_w	bigint;
ie_insere_escala_w	varchar(2);

C01 CURSOR FOR
	SELECT	nr_seq_turno,
		ie_dia_semana
	from	hd_escala_dialise_temp
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	order by 1;


BEGIN

select	max(dt_fim)
into STRICT	dt_fim_escala_w
from	hd_escala_dialise
where	nr_sequencia = nr_seq_escala_p;

/*if	(dt_fim_p is not null) then
	hd_encerrar_escalas_tratamento(cd_pessoa_fisica_p);
end if;*/
if (dt_fim_escala_w IS NOT NULL AND dt_fim_escala_w::text <> '') or (coalesce(nr_seq_escala_p::text, '') = '') or (nr_seq_escala_p = 0) then

	select	nextval('hd_escala_dialise_seq')
	into STRICT	nr_seq_escala_w
	;

	insert into hd_escala_dialise(nr_sequencia,
		cd_estabelecimento,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_pessoa_fisica,
		dt_inicio,
		dt_fim,
		nr_seq_unid_dialise,
		nr_seq_escala,
		nr_seq_turno)
	values (nr_seq_escala_w,
		cd_estabelecimento_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_pessoa_fisica_p,
		dt_inicio_p,
		dt_fim_p,
		nr_seq_unidade_p,
		nr_escala_p,
		nr_turno_p);

elsif (dt_fim_p IS NOT NULL AND dt_fim_p::text <> '') then
	CALL hd_encerrar_escalas_tratamento(cd_pessoa_fisica_p);

end if;

nr_seq_escala_aux_w	:= coalesce(nr_seq_escala_w, nr_seq_escala_p);

open C01;
loop
fetch C01 into
	nr_seq_turno_w,
	ie_dia_semana_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
	into STRICT	ie_insere_escala_w
	from	hd_escala_dialise_dia
	where	ie_dia_semana	= ie_dia_semana_w
	and	nr_seq_turno	= nr_seq_turno_w
	and	nr_seq_escala	= nr_seq_escala_aux_w;

	if (ie_insere_escala_w = 'S') then

		insert into hd_escala_dialise_dia(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_turno,
			ie_dia_semana,
			dt_inicio_escala_dia,
			nr_seq_escala)
		values (nextval('hd_escala_dialise_dia_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_turno_w,
			ie_dia_semana_w,
			clock_timestamp(),
			nr_seq_escala_aux_w);
	end if;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_confirmar_escala_receb (nr_seq_escala_p bigint, nr_seq_unidade_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_pessoa_fisica_p text, nr_escala_p bigint, nr_turno_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

