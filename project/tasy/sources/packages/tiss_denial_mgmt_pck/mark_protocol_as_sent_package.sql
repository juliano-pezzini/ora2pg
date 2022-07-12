-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tiss_denial_mgmt_pck.mark_protocol_as_sent (nr_seq_tiss_protocol_p tiss_recurso_glosa_prot.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN
	
	update 	tiss_recurso_glosa_prot
	set 	dt_envio_operadora = clock_timestamp(),
		ie_enviado_operadora =  'S',
		nm_usuario = coalesce(nm_usuario_p, wheb_usuario_pck.get_nm_usuario),
		dt_atualizacao = clock_timestamp()
	where nr_sequencia = nr_seq_tiss_protocol_p;
	
	commit;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_denial_mgmt_pck.mark_protocol_as_sent (nr_seq_tiss_protocol_p tiss_recurso_glosa_prot.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;