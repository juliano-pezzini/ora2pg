-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importar_convenio_retorno_item ( nr_seq_retorno_p bigint, vl_pago_p bigint, vl_glosado_p bigint, ie_glosa_p text, nr_conta_p bigint, cd_autoriz_p text, vl_adicional_p bigint, nr_titulo_p bigint, vl_amenor_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into convenio_retorno_item(
	nr_sequencia,
	nr_seq_retorno,
	vl_pago,
	vl_glosado,
	dt_atualizacao,
	nm_usuario,
	ie_glosa,
	nr_interno_conta,
	cd_autorizacao,
	cd_motivo_glosa,
	ds_observacao,
	vl_adicional,
	nr_titulo,
	vl_amenor,
	ie_analisada)
values (	nextval('convenio_retorno_item_seq'),
	nr_seq_retorno_p,
	vl_pago_p,
	vl_glosado_p,
	clock_timestamp(),
	nm_usuario_p,
	ie_glosa_p,
	nr_conta_p,
	cd_autoriz_p,
	null,
	null,
	vl_adicional_p,
	nr_titulo_p,
	vl_amenor_p,
	'N');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importar_convenio_retorno_item ( nr_seq_retorno_p bigint, vl_pago_p bigint, vl_glosado_p bigint, ie_glosa_p text, nr_conta_p bigint, cd_autoriz_p text, vl_adicional_p bigint, nr_titulo_p bigint, vl_amenor_p bigint, nm_usuario_p text) FROM PUBLIC;

