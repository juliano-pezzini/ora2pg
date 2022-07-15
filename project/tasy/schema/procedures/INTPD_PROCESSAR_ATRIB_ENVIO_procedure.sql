-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_processar_atrib_envio ( reg_integracao_p INOUT gerar_int_padrao.reg_integracao_conv, nm_atributo_base_p text, nm_atributo_xml_p text, ie_campo_verificador_p text, ds_valor_p text, ie_conversao_p text, ds_valor_retorno_p INOUT text) AS $body$
DECLARE
_ora2pg_r RECORD;
BEGIN
reg_integracao_p.ie_envio_recebe	:=	'E';
reg_integracao_p.ie_campo_verificador	:=	ie_campo_verificador_p;
reg_integracao_p.nm_atributo_xml	:=	nm_atributo_xml_p;

SELECT * FROM intpd_processar_atributo(
	reg_integracao_p, nm_atributo_base_p, ds_valor_p, ie_conversao_p, ds_valor_retorno_p) INTO STRICT _ora2pg_r;

	reg_integracao_p := _ora2pg_r.reg_integracao_p; ds_valor_retorno_p := _ora2pg_r.ds_valor_retorno_p;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_processar_atrib_envio ( reg_integracao_p INOUT gerar_int_padrao.reg_integracao_conv, nm_atributo_base_p text, nm_atributo_xml_p text, ie_campo_verificador_p text, ds_valor_p text, ie_conversao_p text, ds_valor_retorno_p INOUT text) FROM PUBLIC;

