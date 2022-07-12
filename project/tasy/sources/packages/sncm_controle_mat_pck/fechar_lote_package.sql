-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE sncm_controle_mat_pck.fechar_lote ( nr_seq_lote_p controle_mat_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN
	CALL sncm_controle_mat_pck.valida_se_existe_arquivo(nr_seq_lote_p => nr_seq_lote_p);
	
	update	controle_mat_lote
	set	ie_status	= '8', -- Definitivo
		nm_usuario 	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		dt_fechamento	= clock_timestamp()
	where	nr_sequencia	= nr_seq_lote_p;
	commit;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sncm_controle_mat_pck.fechar_lote ( nr_seq_lote_p controle_mat_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;