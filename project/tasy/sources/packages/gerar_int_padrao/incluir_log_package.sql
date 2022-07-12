-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE gerar_int_padrao.incluir_log ( reg_integracao_conv_p INOUT reg_integracao_conv, ds_log_p intpd_log_recebimento.ds_log%type, cd_default_message_p intpd_log_recebimento.cd_default_message%type, ie_tipo_p intpd_log_recebimento.ie_tipo%type default 'E') AS $body$
DECLARE

i integer;	

BEGIN
if (ie_tipo_p = 'W') then
	begin
	i	:=	reg_integracao_conv_p.intpd_warning_receb.count;	

	reg_integracao_conv_p.intpd_warning_receb[i].ds_log		:=	ds_log_p;
	reg_integracao_conv_p.intpd_warning_receb[i].cd_default_message	:=	cd_default_message_p;
	reg_integracao_conv_p.qt_reg_warning				:=	coalesce(reg_integracao_conv_p.qt_reg_warning,0) + 1;
	end;
else
	begin
	i	:=	reg_integracao_conv_p.intpd_log_receb.count;	

	reg_integracao_conv_p.intpd_log_receb[i].ds_log			:=	ds_log_p;
	reg_integracao_conv_p.intpd_log_receb[i].cd_default_message	:=	cd_default_message_p;
	reg_integracao_conv_p.qt_reg_log				:=	coalesce(reg_integracao_conv_p.qt_reg_log,0) + 1;	
	end;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_int_padrao.incluir_log ( reg_integracao_conv_p INOUT reg_integracao_conv, ds_log_p intpd_log_recebimento.ds_log%type, cd_default_message_p intpd_log_recebimento.cd_default_message%type, ie_tipo_p intpd_log_recebimento.ie_tipo%type default 'E') FROM PUBLIC;