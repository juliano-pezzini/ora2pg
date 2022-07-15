-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_w_importa_rateio_nf ( nr_seq_nf_p bigint, cd_centro_custo_p text, cd_conta_contabil_p text, cd_conta_financ_p text, vl_rateio_p bigint, vl_frete_p bigint, vl_desconto_p bigint, vl_seguro_p bigint, vl_despesa_acessoria_p bigint, vl_tributo_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into w_importa_rateio_nf(
	nr_sequencia,
	nm_usuario,
	nr_seq_nf,
	cd_centro_custo,
	cd_conta_contabil,
	cd_conta_financ,
	vl_rateio,
	vl_frete,
	vl_desconto,
	vl_seguro,
	vl_despesa_acessoria,
	vl_tributo,
	dt_atualizacao)
values (	nextval('w_importa_rateio_nf_seq'),
	nm_usuario_p,
	nr_seq_nf_p,
	cd_centro_custo_p,
	cd_conta_contabil_p,
	cd_conta_financ_p,
	vl_rateio_p,
	vl_frete_p,
	vl_desconto_p,
	vl_seguro_p,
	vl_despesa_acessoria_p,
	vl_tributo_p,
	clock_timestamp());

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_w_importa_rateio_nf ( nr_seq_nf_p bigint, cd_centro_custo_p text, cd_conta_contabil_p text, cd_conta_financ_p text, vl_rateio_p bigint, vl_frete_p bigint, vl_desconto_p bigint, vl_seguro_p bigint, vl_despesa_acessoria_p bigint, vl_tributo_p bigint, nm_usuario_p text) FROM PUBLIC;

