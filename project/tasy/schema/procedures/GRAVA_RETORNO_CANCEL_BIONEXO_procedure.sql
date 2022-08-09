-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_retorno_cancel_bionexo ( nr_cot_compra_p bigint, ie_status_p text, ds_retorno_p text, nm_usuario_p text) AS $body$
DECLARE


ds_mensagem_w		varchar(4000);


BEGIN

if (ie_status_p = '1') then
	ds_mensagem_w	:= substr(wheb_mensagem_pck.get_texto(312717,'DS_RETORNO=' || ds_retorno_p),1,4000);

elsif (ie_status_p = '0') then
	ds_mensagem_w	:= substr(wheb_mensagem_pck.get_texto(312721),1,255);

else
	ds_mensagem_w	:= substr(wheb_mensagem_pck.get_texto(312722,'DS_RETORNO=' || ds_retorno_p),1,4000);
end if;

CALL gerar_historico_cotacao(
		nr_cot_compra_p,
		substr(wheb_mensagem_pck.get_texto(312724),1,255),
		ds_mensagem_w,
		'S',
		nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_retorno_cancel_bionexo ( nr_cot_compra_p bigint, ie_status_p text, ds_retorno_p text, nm_usuario_p text) FROM PUBLIC;
