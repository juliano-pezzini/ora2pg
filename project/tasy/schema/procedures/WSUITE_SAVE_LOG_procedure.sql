-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE wsuite_save_log ( ie_acao_p wsuite_log_portal.ie_acao%type, ds_observacao_p wsuite_log_portal.ds_observacao%type, ds_endereco_ip_p wsuite_log_portal.ds_endereco_ip%type, ds_login_p wsuite_usuario.ds_login%type, ie_aplicacao_p wsuite_log_portal.ie_aplicacao%type default null) AS $body$
DECLARE

				
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finality: Save the logs of the actions done by users
Caution:  IE_ACAO = Domain 8076
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

if (ie_acao_p IS NOT NULL AND ie_acao_p::text <> '' AND ds_login_p IS NOT NULL AND ds_login_p::text <> '') then

	insert into  wsuite_log_portal(	nr_sequencia, dt_atualizacao, nm_usuario,
					dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_usuario_wsuite,
					ie_acao, ds_observacao, ds_endereco_ip,
					ds_login, dt_geracao_log, ie_aplicacao)
				values (	nextval('wsuite_log_portal_seq'), clock_timestamp(), ds_login_p,
					clock_timestamp(), ds_login_p, null,
					ie_acao_p, ds_observacao_p,ds_endereco_ip_p,
					ds_login_p, clock_timestamp(), ie_aplicacao_p);
	commit;
	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE wsuite_save_log ( ie_acao_p wsuite_log_portal.ie_acao%type, ds_observacao_p wsuite_log_portal.ds_observacao%type, ds_endereco_ip_p wsuite_log_portal.ds_endereco_ip%type, ds_login_p wsuite_usuario.ds_login%type, ie_aplicacao_p wsuite_log_portal.ie_aplicacao%type default null) FROM PUBLIC;

