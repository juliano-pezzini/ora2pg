-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION wheb_sms.obter_status_sms (ID_SMS_P bigint,DT_ENVIO_P text,NM_USUARIO_P text) RETURNS varchar AS $body$
DECLARE

	cd_status_sms 		varchar(10);
	ie_forma_w				varchar(1);
	parametros_sms_w	LT_PARAMETROS_SMS;
	lista_retorno_xml	t_list_of_xml;
	retorno_w				  lt_retorno;
	
BEGIN
		if (current_setting('wheb_sms.cd_empresa_w')::coalesce(bigint::text, '') = '' ) then
			CALL wheb_sms.armazena_configuracoes_sms(NM_USUARIO_P);
		end if;

		ie_forma_w	 		:= obter_valor_param_usuario(0,202,coalesce(wheb_usuario_pck.get_cd_perfil,0),NM_USUARIO_P, coalesce(wheb_usuario_pck.get_cd_estabelecimento,1));


		parametros_sms_w := LT_PARAMETROS_SMS(	null, null, null, null,null,
												null,null,null,null,null,
												null,null,null,null,null,
												null,null,null,null);

		parametros_sms_w.DS_OPERACAO			:= 'STATUS';
		parametros_sms_w.NM_USUARIO				:= current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255);
		parametros_sms_w.DS_SENHA				:= current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255);
		parametros_sms_w.DS_URL_SMS			:= current_setting('wheb_sms.ds_url_sms_w')::varchar(255);
		parametros_sms_w.ID_SMS					:= ID_SMS_P;
		parametros_sms_w.IP_SERVIDOR_PROXY		:= current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255);
		parametros_sms_w.CD_EMPRESA				:= current_setting('wheb_sms.cd_empresa_w')::bigint;
		parametros_sms_w.NM_USUARIO_PROXY		:= current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255);
		parametros_sms_w.DS_SENHA_PROXY			:= current_setting('wheb_sms.ds_senha_proxy_w')::varchar(255);
		parametros_sms_w.ie_consistir_destinatario := OBTER_VALOR_PARAM_USUARIO(0,214,coalesce(wheb_usuario_pck.get_cd_perfil,0),nm_usuario_p,coalesce(wheb_usuario_pck.get_cd_estabelecimento,1));


		if (coalesce(ie_forma_w, 'B') = 'B') then
			begin
			if (current_setting('wheb_sms.cd_empresa_w')::bigint = 1 ) then
				return 'Nao implementado (Vola)';
			elsif ( current_setting('wheb_sms.cd_empresa_w')::bigint = 2) then
				return tww_get_status_sms(current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255),current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255),current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255),current_setting('wheb_sms.ds_senha_proxy_w')::varchar(255),current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255),id_sms_p,dt_envio_p);
			elsif ( current_setting('wheb_sms.cd_empresa_w')::bigint = 3) then
				return tww_2_02_get_status_sms(current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255),current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255),current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255),current_setting('wheb_sms.ds_senha_proxy_w')::varchar(255),current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255),id_sms_p,dt_envio_p);
			elsif ( current_setting('wheb_sms.cd_empresa_w')::bigint = 9) then
				return tww_padrao_get_status_sms(current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255),current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255),current_setting('wheb_sms.ds_url_sms_w')::varchar(255),current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255),current_setting('wheb_sms.ds_senha_proxy_w')::varchar(255),current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255),id_sms_p,dt_envio_p);
			elsif ( current_setting('wheb_sms.cd_empresa_w')::bigint = 4) then
				return human_get_status_sms(ID_SMS_P, current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255), current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255), current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255),current_setting('wheb_sms.ds_senha_proxy_w')::varchar(255),current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255));
			elsif ( current_setting('wheb_sms.cd_empresa_w')::bigint = 5) and ( current_setting('wheb_sms.exibemsg_w')::varchar(1) = 'S' ) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(248883); --Operacao nao implementada para a Spring Wireless
			elsif ( current_setting('wheb_sms.cd_empresa_w')::bigint = 8) then
				return digital_get_status_sms(
						id_sms_p,
						current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255),
						current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255),
						current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255),
						current_setting('wheb_sms.ds_senha_proxy_w')::varchar(255),
						current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255));
			end if;
			end;
		else
			begin
				lista_retorno_xml := wheb_sms.obter_retorno_operacao_sms(nm_usuario_p, parametros_sms_w);

				retorno_w := wheb_sms.obter_retorno(lista_retorno_xml(1));

				return retorno_w.valor;
			end;

		end if;
	end;


$body$
LANGUAGE PLPGSQL
 STABLE;
-- REVOKE ALL ON FUNCTION wheb_sms.obter_status_sms (ID_SMS_P bigint,DT_ENVIO_P text,NM_USUARIO_P text) FROM PUBLIC;
