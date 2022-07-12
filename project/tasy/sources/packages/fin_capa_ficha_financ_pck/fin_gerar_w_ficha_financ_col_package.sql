-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE fin_capa_ficha_financ_pck.fin_gerar_w_ficha_financ_col ( nr_seq_capa_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, nr_seq_superior_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_linha_w		bigint;
nr_seq_linha_sup_w	bigint;
nr_seq_superior_w		bigint;
nr_seq_coluna_w		bigint;
nr_seq_formula_w		bigint;
vl_resultado_w		double precision;
nr_coluna_w		integer;
ie_apres_linha_w	varchar(1);

vl_coluna_1_w	double precision;
vl_coluna_2_w	double precision;
vl_coluna_3_w	double precision;
vl_coluna_4_w	double precision;
vl_coluna_5_w	double precision;
vl_coluna_6_w	double precision;
vl_coluna_7_w	double precision;
vl_coluna_8_w	double precision;
vl_coluna_9_w	double precision;
vl_coluna_10_w	double precision;

c01 CURSOR FOR
SELECT	nr_sequencia,
	nr_seq_superior
from	capa_ficha_financ_lin
where	nr_seq_capa = nr_seq_capa_p
and	((coalesce(nr_seq_superior_p::text, '') = '' and coalesce(nr_seq_superior::text, '') = '') or (nr_seq_superior = nr_seq_superior_p))
order by	coalesce(nr_ordem_apres,0) asc,
	nr_sequencia asc;

c02 CURSOR FOR
SELECT	nr_sequencia
from	capa_ficha_financ_col
where	nr_seq_capa = nr_seq_capa_p
order by	coalesce(nr_ordem_apres,0) asc,
	nr_sequencia LIMIT 10;

c03 CURSOR FOR
SELECT	nr_sequencia,
	nr_seq_superior
from	capa_ficha_financ_lin
where	nr_seq_capa = nr_seq_capa_p;


BEGIN
if (coalesce(nr_seq_superior_p::text, '') = '') then
	delete	FROM w_ficha_financ_coluna
	where	nm_usuario = nm_usuario_p;
end if;

open c01;
loop
fetch c01 into
	nr_seq_linha_w,
	nr_seq_linha_sup_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	vl_coluna_1_w	:= 0;
	vl_coluna_2_w	:= 0;
	vl_coluna_3_w	:= 0;
	vl_coluna_4_w	:= 0;
	vl_coluna_5_w	:= 0;
	vl_coluna_6_w	:= 0;
	vl_coluna_7_w	:= 0;
	vl_coluna_8_w	:= 0;
	vl_coluna_9_w	:= 0;
	vl_coluna_10_w	:= 0;

	nr_coluna_w	:= 1;

	open c02;
	loop
	fetch c02 into
		nr_seq_coluna_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin

		select	max(nr_seq_formula)
		into STRICT	nr_seq_formula_w
		from	capa_ficha_financ_val
		where	nr_seq_linha = nr_seq_linha_w
		and	nr_seq_coluna = nr_seq_coluna_w
		and	nr_seq_capa = nr_seq_capa_p;

		select	coalesce(max(vl_resultado),0)
		into STRICT	vl_resultado_w
		from	w_fin_valor_capa
		where	nr_seq_formula = nr_seq_formula_w
		and	nm_usuario = nm_usuario_p;

		if (nr_coluna_w = 1) then
			vl_coluna_1_w := vl_resultado_w;
		elsif (nr_coluna_w = 2) then
			vl_coluna_2_w := vl_resultado_w;
		elsif (nr_coluna_w = 3) then
			vl_coluna_3_w := vl_resultado_w;
		elsif (nr_coluna_w = 4) then
			vl_coluna_4_w := vl_resultado_w;
		elsif (nr_coluna_w = 5) then
			vl_coluna_5_w := vl_resultado_w;
		elsif (nr_coluna_w = 6) then
			vl_coluna_6_w := vl_resultado_w;
		elsif (nr_coluna_w = 7) then
			vl_coluna_7_w := vl_resultado_w;
		elsif (nr_coluna_w = 8) then
			vl_coluna_8_w := vl_resultado_w;
		elsif (nr_coluna_w = 9) then
			vl_coluna_9_w := vl_resultado_w;
		elsif (nr_coluna_w = 10) then
			vl_coluna_10_w := vl_resultado_w;
		end if;

		nr_coluna_w := nr_coluna_w + 1;
		end;
	end loop;
	close c02;

	insert into w_ficha_financ_coluna(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_superior,
		cd_pessoa_fisica,
		cd_cgc,
		vl_coluna_1,
		vl_coluna_2,
		vl_coluna_3,
		vl_coluna_4,
		vl_coluna_5,
		vl_coluna_6,
		vl_coluna_7,
		vl_coluna_8,
		vl_coluna_9,
		vl_coluna_10,
		nr_seq_linha,
		ie_exibir)
	values (	nextval('w_ficha_financ_coluna_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		null,
		cd_pessoa_fisica_p,
		cd_cgc_p,
		vl_coluna_1_w,
		vl_coluna_2_w,
		vl_coluna_3_w,
		vl_coluna_4_w,
		vl_coluna_5_w,
		vl_coluna_6_w,
		vl_coluna_7_w,
		vl_coluna_8_w,
		vl_coluna_9_w,
		vl_coluna_10_w,
		nr_seq_linha_w,
		'S');

	CALL fin_capa_ficha_financ_pck.fin_gerar_w_ficha_financ_col(
		nr_seq_capa_p,
		cd_pessoa_fisica_p,
		cd_cgc_p,
		nr_seq_linha_w,
		nm_usuario_p);
	end;
end loop;
close c01;

select	coalesce(ie_apres_linha,'T')
into STRICT	ie_apres_linha_w
from	capa_ficha_financ
where	nr_sequencia = nr_seq_capa_p;

if (coalesce(nr_seq_superior_p::text, '') = '') then
	open c03;
	loop
	fetch c03 into
		nr_seq_linha_w,
		nr_seq_linha_sup_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin
		select	max(nr_sequencia)
		into STRICT	nr_seq_superior_w
		from	w_ficha_financ_coluna
		where	nr_seq_linha = nr_seq_linha_sup_w
		and	nm_usuario = nm_usuario_p;

		if (ie_apres_linha_w = 'T') then
			update	w_ficha_financ_coluna
			set	nr_seq_superior = nr_seq_superior_w,
				ie_exibir = 'S'
			where	nr_seq_linha = nr_seq_linha_w
			and	nm_usuario = nm_usuario_p;
		else
			update	w_ficha_financ_coluna
			set	nr_seq_superior = nr_seq_superior_w,
				ie_exibir = CASE WHEN nr_seq_superior_w = NULL THEN  'S'  ELSE 'N' END
			where	nr_seq_linha = nr_seq_linha_w
			and	nm_usuario = nm_usuario_p;
		end if;
		end;
	end loop;
	close c03;
end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fin_capa_ficha_financ_pck.fin_gerar_w_ficha_financ_col ( nr_seq_capa_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, nr_seq_superior_p bigint, nm_usuario_p text) FROM PUBLIC;