-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerar_alerta_web_pck.pls_gerar_notificacao_web ( ds_titulo_p pls_comunic_externa_web.ds_titulo%type, ds_mensagem_p pls_comunic_externa_web.ds_texto%type, nm_usuario_prestador_p pls_comunic_externa_web.nm_usuario_prestador%type, nm_usuario_tasy_p pls_comunic_externa_web.nm_usuario_tasy%type, ie_tipo_login_p pls_comunic_externa_web.ie_tipo_login%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN
	insert into pls_comunic_externa_web(
	 	nr_sequencia, ie_situacao, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		ds_titulo, ds_texto, dt_criacao,
		dt_liberacao, dt_fim_liberacao, nm_usuario_prestador,
		nm_usuario_tasy, ie_tipo_login, ie_tipo_comunicado_web)
	values (	nextval('pls_comunic_externa_web_seq'), 'A', clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nm_usuario_p,
		ds_titulo_p, ds_mensagem_p, clock_timestamp(),
		clock_timestamp(), (clock_timestamp() + interval '60 days'), nm_usuario_prestador_p,
		nm_usuario_tasy_p, ie_tipo_login_p,'N');

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_alerta_web_pck.pls_gerar_notificacao_web ( ds_titulo_p pls_comunic_externa_web.ds_titulo%type, ds_mensagem_p pls_comunic_externa_web.ds_texto%type, nm_usuario_prestador_p pls_comunic_externa_web.nm_usuario_prestador%type, nm_usuario_tasy_p pls_comunic_externa_web.nm_usuario_tasy%type, ie_tipo_login_p pls_comunic_externa_web.ie_tipo_login%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
