-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tie_sms.envia_sms_tie (ds_destinatario_p log_envio_sms.nr_telefone%type, ds_mensagem_p log_envio_sms.ds_mensagem%type, nm_usuario_p log_envio_sms.nm_usuario%type, ds_remetente_p log_envio_sms.nr_telefone%type, nm_usuario_auth_p text, ds_senha_auth_p text, ds_url_base_sms_p text, cd_empresa_p bigint) AS $body$
DECLARE


ds_erro_w          log_sms_tie.ds_erro%type;
qt_exec_w 		   bigint;						
json_data_w 	   text;
nr_enviado_w 	   bigint;
json_message_w     philips_json;
ds_event_tie_w     log_sms_tie.ds_evento_tie%type;
nr_sequencia_log_w log_sms_tie.nr_sequencia%type;


BEGIN
	  
	if (cd_empresa_p = 15) then
		ds_event_tie_w := 'api.send.sms.infobip';
	end if;
	
	if (ds_event_tie_w IS NOT NULL AND ds_event_tie_w::text <> '') then
	
		json_message_w := philips_json();
		
		select nextval('log_sms_tie_seq')
		into STRICT nr_sequencia_log_w
		;
		
		json_message_w.put('ds_message', ds_mensagem_p);
		json_message_w.put('nr_sender_number', ds_remetente_p);
		json_message_w.put('nr_sms_log_id', nr_sequencia_log_w); --Envia uma unique id para validar se foi inserida
		json_message_w.put('nr_destination_number', ds_destinatario_p);
		json_message_w.put('ds_url_base_sms', ds_url_base_sms_p);
		json_message_w.put('nm_usuario_auth', nm_usuario_auth_p);
		json_message_w.put('ds_senha_auth', ds_senha_auth_p);
	
		dbms_lob.createtemporary(json_data_w, true);
		json_message_w.(json_data_w);
		json_data_w := bifrost.send_integration_content(ds_event_tie_w, json_data_w, nm_usuario_p);
	
		--loop de 10s pra esperar gravar na tabela de log pelo tasy-interfaces seja de sucesso ou erro
		qt_exec_w := dbms_utility.get_time + (1 * 100); -- maximo 10 segundos de execucao ate obter a resposta
	
		BEGIN
			
			loop

				select coalesce(max(nr_sequencia), 0),
					   max(ds_erro)
				into STRICT nr_enviado_w,
					 ds_erro_w
				from log_sms_tie
				where nr_sequencia = nr_sequencia_log_w;
			
				if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(213824, 'ds_retorno_sms_w=' || ds_erro_w || ';ds_remetente_p=' || ds_remetente_p || ';ds_destinatario_w=' || ds_destinatario_p);
				end if;
			
				exit when dbms_utility.get_time > qt_exec_w or nr_enviado_w <> 0;
			end loop;
		end;
	end if;
END;

$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE tie_sms.envia_sms_tie (ds_destinatario_p log_envio_sms.nr_telefone%type, ds_mensagem_p log_envio_sms.ds_mensagem%type, nm_usuario_p log_envio_sms.nm_usuario%type, ds_remetente_p log_envio_sms.nr_telefone%type, nm_usuario_auth_p text, ds_senha_auth_p text, ds_url_base_sms_p text, cd_empresa_p bigint) FROM PUBLIC;