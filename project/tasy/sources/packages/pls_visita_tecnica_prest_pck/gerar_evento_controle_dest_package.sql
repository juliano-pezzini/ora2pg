-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_visita_tecnica_prest_pck.gerar_evento_controle_dest ( nr_seq_evento_controle_p pls_alerta_evento_controle.nr_sequencia%type, ie_forma_envio_p pls_alerta_evento_cont_des.ie_forma_envio%type, ie_tipo_pessoa_dest_p pls_alerta_evento_cont_des.ie_tipo_pessoa_dest%type, nm_usuario_destino_p pls_alerta_evento_cont_des.nm_usuario_destino%type, ds_mensagem_p pls_comunic_externa_web.ds_texto%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN
if (nr_seq_evento_controle_p IS NOT NULL AND nr_seq_evento_controle_p::text <> '') then
	insert	into	pls_alerta_evento_cont_des(	nr_sequencia, nr_seq_evento_controle, dt_atualizacao,
			nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
			ie_status_envio, ie_forma_envio, ie_tipo_pessoa_dest,
			nm_usuario_destino, dt_envio_mensagem, ds_mensagem )
		values (nextval('pls_alerta_evento_cont_des_seq'), nr_seq_evento_controle_p, clock_timestamp(),
			nm_usuario_p, clock_timestamp(), nm_usuario_p,
			'E', ie_forma_envio_p, ie_tipo_pessoa_dest_p,
			nm_usuario_destino_p, clock_timestamp(), ds_mensagem_p );
end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_visita_tecnica_prest_pck.gerar_evento_controle_dest ( nr_seq_evento_controle_p pls_alerta_evento_controle.nr_sequencia%type, ie_forma_envio_p pls_alerta_evento_cont_des.ie_forma_envio%type, ie_tipo_pessoa_dest_p pls_alerta_evento_cont_des.ie_tipo_pessoa_dest%type, nm_usuario_destino_p pls_alerta_evento_cont_des.nm_usuario_destino%type, ds_mensagem_p pls_comunic_externa_web.ds_texto%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
