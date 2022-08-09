-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE recebe_confirmacao_envio_solic (nr_solic_compra_p bigint, ie_status_p bigint, nr_documento_externo_p text, ds_retorno_integracao_p text, nm_usuario_p text) AS $body$
DECLARE

 
ds_enter_w		varchar(10) := chr(13) || chr(10);
					

BEGIN 
 
if (ie_status_p = 1) then 
 
	update	solic_compra 
	set	nr_documento_externo	= nr_documento_externo_p 
	where	nr_solic_compra		= nr_solic_compra_p;
 
 
	CALL gerar_historico_solic_compra( 
		nr_solic_compra_p, 
		WHEB_MENSAGEM_PCK.get_texto(306416), 
		substr(WHEB_MENSAGEM_PCK.get_texto(306418,'DS_RETORNO_INTEGRACAO_P='||ds_retorno_integracao_p),1,4000), 
		'V', 
		nm_usuario_p);
 
elsif (ie_status_p = 0) then 
	CALL gerar_historico_solic_compra( 
		nr_solic_compra_p, 
		WHEB_MENSAGEM_PCK.get_texto(306416), 
		substr(WHEB_MENSAGEM_PCK.get_texto(306419,'DS_RETORNO_INTEGRACAO_P='||ds_retorno_integracao_p),1,4000), 
		'V', 
		nm_usuario_p);
 
elsif (ie_status_p < 0) then 
	CALL gerar_historico_solic_compra( 
		nr_solic_compra_p, 
		WHEB_MENSAGEM_PCK.get_texto(306416), 
		substr(WHEB_MENSAGEM_PCK.get_texto(306420,'NR_DOCUMENTO_EXTERNO_P='||nr_documento_externo_p|| 
					';DS_RETORNO_INTEGRACAO_P='||ds_retorno_integracao_p),1,4000), 
		'V', 
		nm_usuario_p);
end if;
 
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE recebe_confirmacao_envio_solic (nr_solic_compra_p bigint, ie_status_p bigint, nr_documento_externo_p text, ds_retorno_integracao_p text, nm_usuario_p text) FROM PUBLIC;
