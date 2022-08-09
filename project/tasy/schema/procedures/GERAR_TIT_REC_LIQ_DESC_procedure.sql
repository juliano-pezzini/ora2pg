-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_tit_rec_liq_desc (nr_titulo_p bigint, nr_seq_baixa_p bigint, nm_usuario_p text) AS $body$
DECLARE


-- Não dar Commit!!!!!!!!!!!!
vl_desconto_w		double precision;
vl_perdas_w		double precision;
nr_seq_desc_w		bigint;
nr_seq_ret_item_w	bigint;
cd_pessoa_fisica_w	varchar(10);
cd_cgc_w		varchar(14);
cd_centro_custo_desc_w	integer;
nr_seq_motivo_desc_w	bigint;

c01 CURSOR FOR
SELECT	cd_cgc,
	cd_pessoa_fisica
from	convenio_ret_item_desc a
where	nr_seq_ret_item		= nr_seq_ret_item_w;

c02 CURSOR FOR
SELECT	a.cd_pessoa_fisica,
	a.cd_cgc,
	a.cd_centro_custo,
	a.nr_seq_motivo_desc
from	titulo_Receber_liq_desc a
where	a.nr_titulo	= nr_titulo_p
and	coalesce(a.nr_seq_liq::text, '') = ''
and	coalesce(a.nr_bordero::text, '') = '';


BEGIN

select	max(nr_seq_ret_item)
into STRICT	nr_seq_ret_item_w
from	titulo_receber_liq
where	nr_titulo	= nr_titulo_p
and	nr_sequencia	= nr_seq_baixa_p;

select	coalesce(max(vl_desconto),0),
	coalesce(max(vl_perdas),0),
	max(nr_seq_motivo_desc),
	max(cd_centro_custo_desc)
into STRICT	vl_desconto_w,
	vl_perdas_w,
	nr_seq_motivo_desc_w,
	cd_centro_custo_desc_w
from	convenio_retorno_item
where	nr_sequencia	= nr_seq_ret_item_w;

if (vl_desconto_w <> 0) or (vl_perdas_w <> 0) then

	open c01;
	loop
	fetch c01 into
		cd_cgc_w,
		cd_pessoa_fisica_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		select	nextval('titulo_receber_liq_desc_seq')
		into STRICT	nr_seq_desc_w
		;

		insert	into titulo_receber_liq_desc(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_pessoa_fisica,
			cd_cgc,
			nr_titulo,
			nr_seq_liq,
			nr_seq_motivo_desc,
			cd_centro_custo)
		values (nr_seq_desc_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_fisica_w,
			cd_cgc_w,
			nr_titulo_p,
			nr_seq_baixa_p,
			nr_seq_motivo_desc_w,
			cd_centro_custo_desc_w);
	end loop;
	close c01;

end if;

if (coalesce(cd_centro_custo_desc_w::text, '') = '') and (coalesce(nr_seq_ret_item_w::text, '') = '') then

open c02;
loop
fetch c02 into
	cd_pessoa_fisica_w,
	cd_cgc_w,
	cd_centro_custo_desc_w,
	nr_seq_motivo_desc_w;
EXIT WHEN NOT FOUND; /* apply on c02 */

	insert	into titulo_receber_liq_desc(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_pessoa_fisica,
		cd_cgc,
		nr_titulo,
		nr_seq_liq,
		nr_seq_motivo_desc,
		cd_centro_custo)
	values (nextval('titulo_receber_liq_desc_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_pessoa_fisica_w,
		cd_cgc_w,
		nr_titulo_p,
		nr_seq_baixa_p,
		nr_seq_motivo_desc_w,
		cd_centro_custo_desc_w);

end loop;
close c02;

end if;

-- Não dar Commit!!!!!!!!!!!!
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_tit_rec_liq_desc (nr_titulo_p bigint, nr_seq_baixa_p bigint, nm_usuario_p text) FROM PUBLIC;
