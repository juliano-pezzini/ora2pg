-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Fazer a carga dos beneficiarios e demais dados necessarios no portal do beneficiario
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
CREATE OR REPLACE PROCEDURE hpms_configurar_portal_tws_pck.tws_configurar_beneficiario ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE



ds_mensagem_w varchar(255);					

BEGIN


if ( (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and cd_estabelecimento_p > 0 ) then

	CALL hpms_configurar_portal_tws_pck.configurar_localidade(cd_estabelecimento_p);	
	
	begin
		ds_mensagem_w := 'IMPORT_USERS_TO_PSA_TWS_PACK';
		CALL import_users_to_psa_tws_pack.import_beneficiaries();
	exception
	when others then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1112449,'DS_ROTINA='||ds_mensagem_w);
	end;
	
	
	begin
		ds_mensagem_w := 'IMPORT_USERS_TO_PSA_TWS_PACK';
		CALL hpms_configurar_portal_tws_pck.atualizar_mensagens();
	exception
	when others then
		CALL wheb_mensagem_pck.exibir_mensagem_abort( 1112449,'DS_ROTINA='||ds_mensagem_w);
	end;	
	
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hpms_configurar_portal_tws_pck.tws_configurar_beneficiario ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;