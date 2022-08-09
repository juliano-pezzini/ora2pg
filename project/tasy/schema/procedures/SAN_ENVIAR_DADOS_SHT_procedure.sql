-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_enviar_dados_sht (ds_bifrost_event_p text, nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE

						
	ds_param_integ_res_w 	text;
	json_dados_w			text;
    data_w                  text;
    data_auth_w             text;	
    json_dados_envio_w      philips_json;
    json_body_w             philips_json;
	elapsed_time_w			bigint;
	
	
	c_itens_lote CURSOR FOR
		SELECT nr_sequencia,
			cd_id_token,
			dt_gravacao_token,
			qt_expirar_token,
			nm_pessoa_fisica, 
			nm_mae
		from san_lote_item
		where nr_seq_lote = nr_seq_lote_p
        and (coalesce(ds_mensagem_retorno::text, '') = '' or coalesce(ie_status_envio, 'N') = 'N');

BEGIN	
    json_dados_envio_w  := philips_json();
	
	CALL san_solicita_token_sht('integracao.sht.accesstoken', nr_seq_lote_p, nm_usuario_p);

    DBMS_LOCK.sleep(15);
	
	for c_item_lote_w in c_itens_lote loop
	begin
				
		select san_obter_dados_json_sht(nr_seq_lote_p, c_item_lote_w.nr_sequencia, nm_usuario_p)
		into STRICT json_dados_w
		;

        json_body_w := philips_json(json_dados_w);
        json_dados_envio_w.put('access_token', c_item_lote_w.cd_id_token);
        json_dados_envio_w.put('body', json_body_w);
		json_dados_envio_w.put('sequence', c_item_lote_w.nr_sequencia);

		dbms_lob.createtemporary(lob_loc => data_w, cache => true, dur => dbms_lob.call);
        json_dados_envio_w.(data_w);
		

		select (((clock_timestamp()) - (c_item_lote_w.dt_gravacao_token)) * 24 * 60 * 60)
		into STRICT elapsed_time_w
		;
        		
		begin
			if (elapsed_time_w <= c_item_lote_w.qt_expirar_token) then
				select bifrost.send_integration_content(ds_bifrost_event_p, data_w, nm_usuario_p)
                into STRICT ds_param_integ_res_w
;
			else
				CALL san_solicita_token_sht('integracao.sht.accesstoken', nr_seq_lote_p, nm_usuario_p);
				DBMS_LOCK.sleep(15);
				
				select bifrost.send_integration_content(ds_bifrost_event_p, data_w, nm_usuario_p)
                into STRICT ds_param_integ_res_w
;
            end if;			
		exception
			when others then
			rollback;
		end;
	end;
	end loop;
  	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_enviar_dados_sht (ds_bifrost_event_p text, nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;
