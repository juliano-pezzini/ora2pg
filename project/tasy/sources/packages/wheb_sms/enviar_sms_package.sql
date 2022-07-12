-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


CREATE TYPE lista AS (
		nr_celular varchar(50));


CREATE OR REPLACE PROCEDURE wheb_sms.enviar_sms (DS_REMETENTE_P text,DS_DESTINATARIO_P text,DS_MENSAGEM_p text,NM_USUARIO_P text,ID_SMS_P INOUT bigint) AS $body$
DECLARE

	/*
	DS_DESTINARATIO_P -> Para enviar para mais de um destinatario , separar o telefone por ( ; )  ponto e virgula
	*/

	ds_destinatario_w		varchar(50);
	ds_destinatarios_w		varchar(512);
	ds_mensagem_w			varchar(512);
	id_sms_quebra_w			numeric(20);
	ds_mensagem_quebra_w	varchar(512);
	ds_sep_cel_w			varchar(10);
	nr_pos_separador_w		bigint;
	qt_controle_w			bigint;
	qt_tam_sep_w			bigint;
	ds_servidor_w			varchar(2000);
	ie_provider_w			varchar(10);
	ie_forma_w				varchar(1);
	parametros_sms_w		LT_PARAMETROS_SMS;
	ds_retorno_sms_w		varchar(255);
  ie_consistir_destinatario_w    varchar(1);
	retorno_w			lt_retorno;
	lista_retorno_xml		t_list_of_xml;
	nr_ddi_celular_w varchar(5);
	nr_tel_sem_ddi_w varchar(50);

	type myArray is table of lista index by integer;

	/*Contem os parametros do SQL*/


	ar_destinatario_w myArray;

	
BEGIN

	ie_forma_w	 		:= obter_valor_param_usuario(0,202,coalesce(wheb_usuario_pck.get_cd_perfil,0),NM_USUARIO_P, coalesce(wheb_usuario_pck.get_cd_estabelecimento,1));
  ie_consistir_destinatario_w := OBTER_VALOR_PARAM_USUARIO(0,214,coalesce(wheb_usuario_pck.get_cd_perfil,0),nm_usuario_p,coalesce(wheb_usuario_pck.get_cd_estabelecimento,1));
	CALL wheb_sms.armazena_configuracoes_sms(NM_USUARIO_P);
	ds_mensagem_w 		:= elimina_acentuacao(ds_mensagem_p);
	ds_sep_cel_w		:= ';';
	ds_destinatarios_w	:= ds_destinatario_p;

  CALL wheb_sms.logmodo_debug('EnviaSMS1: ie_forma_w=' || ie_forma_w || '#ie_consistir_destinatario_w= ' || ie_consistir_destinatario_w || '#ds_mensagem_w=' || ds_mensagem_w || '#ds_destinatarios_w=' || ds_destinatarios_w);

	/*INICIO - TRATAMENTO PARA ENVIAR PARA VARIOS DESTINARIOS*/


	if (substr(ds_destinatarios_w,length(ds_destinatarios_w),1) <> ds_sep_cel_w) then
		ds_destinatarios_w := ds_destinatarios_w || ds_sep_cel_w;
	end if;

	nr_pos_separador_w := position(ds_sep_cel_w in ds_destinatarios_w);
	qt_controle_w	   := 0;
	qt_tam_sep_w 	   := length(ds_sep_cel_w);
	while(nr_pos_separador_w > 0 ) loop
		begin
		qt_controle_w 		:= qt_controle_w + 1;
		ds_destinatario_w  	:= substr(ds_destinatarios_w,1,nr_pos_separador_w-1);
		ds_destinatarios_w   	:= substr(ds_destinatarios_w,nr_pos_separador_w+qt_tam_sep_w,length(ds_destinatarios_w));
		ar_destinatario_w[qt_controle_w].nr_celular := ds_destinatario_w;
		nr_pos_separador_w := position(ds_sep_cel_w in ds_destinatarios_w);
		if (qt_controle_w > 20) then
			nr_pos_separador_w := 0;
		end if;
		end;
	end loop;
	/*FIM - TRATAMENTO PARA ENVIAR PARA VARIOS DESTINARIOS*/



	if (ar_destinatario_w.count = 0) then
		ar_destinatario_w[1].nr_celular := ds_destinatarios_w;
	end if;

	for contador_w IN 1..ar_destinatario_w.count loop
		ds_destinatario_w := ar_destinatario_w[contador_w].nr_celular;
		
		
		if (current_setting('wheb_sms.cd_empresa_w')::bigint	= 11) then --Garantir que o SMS da australia tenha o +61 no numero enviado. Message Media Documentation
			
			ds_destinatario_w	:= replace(ds_destinatario_w,' ','');
			ds_destinatario_w	:= replace(ds_destinatario_w,'+','');
			
			
			if (substr(ds_destinatario_w,1,2)	= '55') and (length(ds_destinatario_w) > 9)then --Caso alguma procedure do Tasy envie com o DDI do Brazil devemos remover
				ds_destinatario_w	:= substr(ds_destinatario_w,3,999);
			end if;
			
			if	((substr(ds_destinatario_w,1,2))	<> '61') and (length(ds_destinatario_w)	=	9) then -- Verificar se foi enviado o numero sem o DDI
				ds_destinatario_w	:= '+61'||ds_destinatario_w;	
			else
				ds_destinatario_w	:= '+'||ds_destinatario_w;
			end if;

		elsif (ie_consistir_destinatario_w = 'I') then
			ds_destinatario_w := ds_destinatario_w;
		else
		if ((ie_consistir_destinatario_w <> 'N') and (substr(ds_destinatario_w,1,2) = '55') and ( Length(ds_destinatario_w) > 11))  then
			ds_destinatario_w := substr(ds_destinatario_w,3,length(ds_destinatario_w));
		else
		  begin
			if
			  (
				((substr(ds_destinatario_w,1,3) = '055') OR (substr(ds_destinatario_w,1,3) = '+55')) and (Length(ds_destinatario_w) > 11)
			  )
			  then
			  ds_destinatario_w := substr(
				ds_destinatario_w, 2, Length(ds_destinatario_w)-1
			  )
			;
			else
			  if
				((Length(ds_destinatario_w) <= 11) and (substr(ds_destinatario_w,1,2) <> '55')) then
				   begin
					  nr_tel_sem_ddi_w :=  substr(ds_destinatario_w, 3, Length(ds_destinatario_w));

					  select max(nr_ddi_celular) into STRICT nr_ddi_celular_w
					  from pessoa_fisica
					  where nr_telefone_celular = nr_tel_sem_ddi_w  LIMIT 1;

					  if coalesce(nr_ddi_celular_w::text, '') = '' then
						ds_destinatario_w := '55' || ds_destinatario_w;


					  end if;
				   end;
			  end if;
			end if;
		  end;
		end if;
		end if;


		ie_forma_w	 		:= obter_valor_param_usuario(0,202,coalesce(wheb_usuario_pck.get_cd_perfil,0),NM_USUARIO_P, coalesce(wheb_usuario_pck.get_cd_estabelecimento,1));
		ie_provider_w 		:= obter_valor_param_usuario(0,210,coalesce(wheb_usuario_pck.get_cd_perfil,0),NM_USUARIO_P, coalesce(wheb_usuario_pck.get_cd_estabelecimento,1));
		ds_servidor_w 		:= obter_valor_param_usuario(0,206,coalesce(wheb_usuario_pck.get_cd_perfil,0),NM_USUARIO_P, coalesce(wheb_usuario_pck.get_cd_estabelecimento,1));

    CALL wheb_sms.logmodo_debug('EnviaSMS2: ie_forma_w=' || ie_forma_w || '#ie_provider_w=' || ie_provider_w || '#ds_servidor_w=' || ds_servidor_w );

		select 	nextval('wheb_sms_seq')
		into STRICT	id_sms_p
		;



		parametros_sms_w := LT_PARAMETROS_SMS(	null, null, null, null,null,
												null,null,null,null,null,
												null,null,null,null,null,
												null,null,null,null);

		parametros_sms_w.DS_OPERACAO			:= 'ENVIAR';
		parametros_sms_w.NM_USUARIO				:= current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255);
		parametros_sms_w.DS_SENHA				:= current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255);
		parametros_sms_w.DS_URL_SMS			:= current_setting('wheb_sms.ds_url_sms_w')::varchar(255);
		parametros_sms_w.DS_REMETENTE			:= elimina_acentuacao(ds_remetente_p);
		if (current_setting('wheb_sms.cd_empresa_w')::bigint	= 11) and (substr(trim(both parametros_sms_w.DS_REMETENTE),1,3)	<> '+61') then
			parametros_sms_w.DS_REMETENTE	:= null;
		end if;
		parametros_sms_w.DS_DESTINATARIO		:= ds_destinatario_w;
		parametros_sms_w.DS_MENSAGEM			:= ds_mensagem_w;
		parametros_sms_w.ID_SMS					:= id_sms_p;
		parametros_sms_w.CD_SMS_PROVIDER		:= ie_provider_w;
		parametros_sms_w.IP_SERVIDOR_PROXY		:= current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255);
		parametros_sms_w.CD_EMPRESA				:= current_setting('wheb_sms.cd_empresa_w')::bigint;
		parametros_sms_w.DS_DOMINIO_SERVIDOR	:= ds_servidor_w; --GOIP
		parametros_sms_w.NM_USUARIO_PROXY		:= current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255);
		parametros_sms_w.DS_SENHA_PROXY			:= current_setting('wheb_sms.ds_senha_proxy_w')::varchar(255);
		parametros_sms_w.ie_consistir_destinatario := ie_consistir_destinatario_w;

    CALL wheb_sms.logmodo_debug('EnviaSMS3: NM_USUARIO=' || current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255) || '#DS_URL_SMS=' || current_setting('wheb_sms.ds_url_sms_w')::varchar(255) || '#ds_destinatario_w=' || ds_destinatario_w );
    CALL wheb_sms.logmodo_debug('EnviaSMS4: ip_servidor_proxy_w=' || current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255) || '#nm_usuario_proxy_w=' || current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255) || '#ds_senha_proxy_w=' || '' );
    CALL wheb_sms.logmodo_debug('EnviaSMS5: DS_DOMINIO_SERVIDOR=' || ds_servidor_w  );


    CALL wheb_sms.logmodo_debug('EnviaSMS6: 1/2 - Etapa registro PHILIPS_AUDIT_PCK.SmsEvent'  );
        	CALL PHILIPS_AUDIT_PCK.SmsEvent(
            			parametros_sms_w.DS_REMETENTE,
            			parametros_sms_w.DS_DESTINATARIO,
            			parametros_sms_w.DS_MENSAGEM,
            			parametros_sms_w.IP_SERVIDOR_PROXY,
            			parametros_sms_w.NM_USUARIO,
            			parametros_sms_w.DS_SENHA,
            			parametros_sms_w.ID_SMS);
    CALL wheb_sms.logmodo_debug('EnviaSMS6: 2/2 - Etapa registro PHILIPS_AUDIT_PCK.SmsEvent'  );

		if (coalesce(ie_forma_w, 'B') = 'T') then 
			
  			CALL tie_sms.envia_sms_tie(ds_destinatario_w, ds_mensagem_w, nm_usuario_p, ds_remetente_p, current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255), current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255), current_setting('wheb_sms.ds_url_sms_w')::varchar(255), current_setting('wheb_sms.cd_empresa_w')::bigint);

		elsif (coalesce(ie_forma_w, 'B') = 'B') then
			begin
			if (current_setting('wheb_sms.cd_empresa_w')::bigint = 1 ) then
				comunika_conectar(current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255), current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255), 0);
				if (coalesce(ie_consistir_destinatario_w::text, '') = '' or upper(ie_consistir_destinatario_w) <> 'N') then
					ds_retorno_sms_w := comunika_enviar_sms(ds_remetente_p, ds_destinatario_w, ds_mensagem_w, '');
				else ds_retorno_sms_w := comunika_enviar_sms(ds_remetente_p, ds_destinatario_w, ds_mensagem_w, '', ie_consistir_destinatario_w);
				end if;
				if (ds_retorno_sms_w not in (0,5))  and ( current_setting('wheb_sms.exibemsg_w')::varchar(1) = 'S' ) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(213824, 'DS_RETORNO_SMS_W='||comunika_get_ds_resultado(ds_retorno_sms_w)||';DS_REMETENTE_P='||ds_remetente_p||';DS_DESTINATARIO_W='||ds_destinatario_w);
				end if;
			elsif ( current_setting('wheb_sms.cd_empresa_w')::bigint = 2) then
				if (coalesce(ie_consistir_destinatario_w::text, '') = '' or upper(ie_consistir_destinatario_w) <> 'N') then
					ds_retorno_sms_w := tww_enviar_sms(current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255),current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255),id_sms_p,ds_destinatario_w,ds_mensagem_w,current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255),current_setting('wheb_sms.ds_senha_proxy_w')::varchar(255),current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255));
				else  ds_retorno_sms_w := tww_enviar_sms(current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255),current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255),id_sms_p,ds_destinatario_w,ds_mensagem_w,current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255),current_setting('wheb_sms.ds_senha_proxy_w')::varchar(255),current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255),ie_consistir_destinatario_w);
				end if;
				if (ds_retorno_sms_w not in (0))  and ( current_setting('wheb_sms.exibemsg_w')::varchar(1) = 'S' ) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(213824, 'DS_RETORNO_SMS_W='||tww_verifica_erro(ds_retorno_sms_w)||';DS_REMETENTE_P='||ds_remetente_p||';DS_DESTINATARIO_W='||ds_destinatario_w);
				end if;
			elsif ( current_setting('wheb_sms.cd_empresa_w')::bigint = 3) then
				if (coalesce(ie_consistir_destinatario_w::text, '') = '' or upper(ie_consistir_destinatario_w) <> 'N') then
					ds_retorno_sms_w := tww_2_02_enviar_sms(current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255),current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255),id_sms_p,ds_destinatario_w,ds_mensagem_w,current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255),current_setting('wheb_sms.ds_senha_proxy_w')::varchar(255),current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255));
				else ds_retorno_sms_w := tww_2_02_enviar_sms(current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255),current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255),id_sms_p,ds_destinatario_w,ds_mensagem_w,current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255),current_setting('wheb_sms.ds_senha_proxy_w')::varchar(255),current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255),ie_consistir_destinatario_w);
				end if;
				if (ds_retorno_sms_w not in (0))  and ( current_setting('wheb_sms.exibemsg_w')::varchar(1) = 'S' ) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(213824, 'DS_RETORNO_SMS_W='||tww_verifica_erro(ds_retorno_sms_w)||';DS_REMETENTE_P='||ds_remetente_p||';DS_DESTINATARIO_W='||ds_destinatario_w);
				end if;
			elsif ( current_setting('wheb_sms.cd_empresa_w')::bigint = 9) then
				if (coalesce(ie_consistir_destinatario_w::text, '') = '' or upper(ie_consistir_destinatario_w) <> 'N') then
					ds_retorno_sms_w := tww_padrao_enviar_sms(current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255),current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255),current_setting('wheb_sms.ds_url_sms_w')::varchar(255),id_sms_p,ds_destinatario_w,ds_mensagem_w,current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255),current_setting('wheb_sms.ds_senha_proxy_w')::varchar(255),current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255));
				else ds_retorno_sms_w := tww_padrao_enviar_sms(current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255),current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255),current_setting('wheb_sms.ds_url_sms_w')::varchar(255),id_sms_p,ds_destinatario_w,ds_mensagem_w,current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255),current_setting('wheb_sms.ds_senha_proxy_w')::varchar(255),current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255),ie_consistir_destinatario_w);
				end if;
				if (ds_retorno_sms_w not in (0))  and ( current_setting('wheb_sms.exibemsg_w')::varchar(1) = 'S' ) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(213824, 'DS_RETORNO_SMS_W='||tww_verifica_erro(ds_retorno_sms_w)||';DS_REMETENTE_P='||ds_remetente_p||';DS_DESTINATARIO_W='||ds_destinatario_w);
				end if;
			elsif ( current_setting('wheb_sms.cd_empresa_w')::bigint = 4) then
				if (coalesce(ie_consistir_destinatario_w::text, '') = '' or upper(ie_consistir_destinatario_w) <> 'N') then
					ds_retorno_sms_w := human_enviar_sms(current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255),current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255),ds_remetente_p,id_sms_p,ds_destinatario_w,ds_mensagem_w,current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255),current_setting('wheb_sms.ds_senha_proxy_w')::varchar(255),current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255));
				else ds_retorno_sms_w := human_enviar_sms(current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255),current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255),ds_remetente_p,id_sms_p,ds_destinatario_w,ds_mensagem_w,current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255),current_setting('wheb_sms.ds_senha_proxy_w')::varchar(255),current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255),ie_consistir_destinatario_w);
				end if;
				if (ds_retorno_sms_w not in (0))  and ( current_setting('wheb_sms.exibemsg_w')::varchar(1) = 'S' ) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(213824, 'DS_RETORNO_SMS_W='||human_verifica_erro(ds_retorno_sms_w)||';DS_REMETENTE_P='||ds_remetente_p||';DS_DESTINATARIO_W='||ds_destinatario_w);
				end if;

			elsif ( current_setting('wheb_sms.cd_empresa_w')::bigint = 7) then



				if (coalesce(ie_provider_w, '1') <> '1') then
					begin
					ds_retorno_sms_w := goip_enviar_sms(
							ds_servidor_w,
							current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255),
							current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255),
							ds_remetente_p,
							ds_destinatario_w,
							ds_mensagem_w,
							current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255),
							current_setting('wheb_sms.ds_senha_proxy_w')::varchar(255),
							current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255),
							ie_provider_w);
					end;
				else
					begin
					ds_retorno_sms_w := goip_enviar_sms(
							ds_servidor_w,
							current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255),
							current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255),
							ds_remetente_p,
							ds_destinatario_w,
							ds_mensagem_w,
							current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255),
							current_setting('wheb_sms.ds_senha_proxy_w')::varchar(255),
							current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255));
					end;
				end if;

				if (ds_retorno_sms_w in (0)) and ( current_setting('wheb_sms.exibemsg_w')::varchar(1) = 'S' ) then
					--Erro ao enviar SMS! Verifique a comunicacao com o servidor GOIP ou se as credenciais estao corretas! ...

					CALL wheb_mensagem_pck.exibir_mensagem_abort(370160, 'DS_REMETENTE_P='||ds_remetente_p||';DS_DESTINATARIO_W='||ds_destinatario_w);
				end if;

			elsif ( current_setting('wheb_sms.cd_empresa_w')::bigint = 8) then

				if ((trim(both ds_remetente_p) IS NOT NULL AND (trim(both ds_remetente_p))::text <> '')) then
					ds_mensagem_w	:= ds_remetente_p || ': ' || ds_mensagem_w;
				end if;

				ds_retorno_sms_w := digital_enviar_sms(
							current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255),
							current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255),
							ds_remetente_p,
							ds_destinatario_w,
							ds_mensagem_w,
							current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255),
							current_setting('wheb_sms.ds_senha_proxy_w')::varchar(255),
							current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255));

				if (ds_retorno_sms_w in (1)) and ( current_setting('wheb_sms.exibemsg_w')::varchar(1) = 'S' ) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(213824, 'DS_RETORNO_SMS_W='||ds_retorno_sms_w||';DS_REMETENTE_P='||ds_remetente_p||';DS_DESTINATARIO_W='||ds_destinatario_w);
				end if;
			else

				ds_retorno_sms_w := spring_enviar_sms(current_setting('wheb_sms.nm_usuario_sms_w')::varchar(255),current_setting('wheb_sms.ds_senha_usuario_sms_w')::varchar(255), id_sms_p,ds_destinatario_w,ds_mensagem_w,current_setting('wheb_sms.nm_usuario_proxy_w')::varchar(255),current_setting('wheb_sms.ds_senha_proxy_w')::varchar(255),current_setting('wheb_sms.ip_servidor_proxy_w')::varchar(255),
				OBTER_VALOR_PARAM_USUARIO(9041,5,coalesce(wheb_usuario_pck.get_cd_perfil,0),nm_usuario_p,coalesce(wheb_usuario_pck.get_cd_estabelecimento,1)),
				OBTER_VALOR_PARAM_USUARIO(9041,6,coalesce(wheb_usuario_pck.get_cd_perfil,0),nm_usuario_p,coalesce(wheb_usuario_pck.get_cd_estabelecimento,1)), current_setting('wheb_sms.cd_empresa_w')::bigint);

				if (ds_retorno_sms_w not in (0))  and ( current_setting('wheb_sms.exibemsg_w')::varchar(1) = 'S' ) then

					CALL wheb_mensagem_pck.exibir_mensagem_abort(213824, 'DS_RETORNO_SMS_W='||spring_verifica_erro(ds_retorno_sms_w)||';DS_REMETENTE_P='||ds_remetente_p||';DS_DESTINATARIO_W='||ds_destinatario_w);					end if;
			end if;
			end;
		else
			begin
			    --Webservice WhebServidorSMS nao possui conexao ao banco, desta forma, deve reservar aqui mesmo as sequencias que serao utilizadas caso a mensagem quebre devido ao tamanho:

				--Inicialmente apenas para a empresa 4 Human, para nao gerar impacto nas demais:

				if (current_setting('wheb_sms.cd_empresa_w')::bigint = 4) then
					ds_mensagem_quebra_w := ds_mensagem_w;
					while(length(ds_mensagem_quebra_w) > 147 ) loop
					begin
						ds_mensagem_quebra_w := substr(ds_mensagem_quebra_w, 144, length(ds_mensagem_quebra_w));

						select nextval('wheb_sms_seq') into STRICT id_sms_quebra_w;

						parametros_sms_w.id_sms := parametros_sms_w.id_sms || ';' || id_sms_quebra_w;
					end;
					end loop;
				end if;

				lista_retorno_xml := wheb_sms.obter_retorno_operacao_sms(nm_usuario_p, parametros_sms_w);

				retorno_w := wheb_sms.obter_retorno(lista_retorno_xml(1));
        CALL wheb_sms.logmodo_debug('EnviaSMS8: retorno_w ( 0 = Ok )='  || retorno_w.valor   );

				if (coalesce(retorno_w.valor, '0') != '0')  and ( current_setting('wheb_sms.exibemsg_w')::varchar(1) = 'S' ) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(213824, 'DS_RETORNO_SMS_W='||retorno_w.valor||';DS_REMETENTE_P='||ds_remetente_p||';DS_DESTINATARIO_W='||ds_destinatario_w);
				end if;
			end;
		end if;

	end loop;
	end;


$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE wheb_sms.enviar_sms (DS_REMETENTE_P text,DS_DESTINATARIO_P text,DS_MENSAGEM_p text,NM_USUARIO_P text,ID_SMS_P INOUT bigint) FROM PUBLIC;
