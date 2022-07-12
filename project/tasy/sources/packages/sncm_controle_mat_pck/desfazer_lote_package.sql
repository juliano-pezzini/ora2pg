-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE sncm_controle_mat_pck.desfazer_lote (nr_seq_lote_p controle_mat_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) AS $body$
DECLARE

				
	nr_seq_mat_arq_w	controle_mat_arquivo.nr_sequencia%type;

	
BEGIN
	select	max(nr_sequencia)
	into STRICT	nr_seq_mat_arq_w
	from	controle_mat_arquivo
	where	nr_seq_lote	= nr_seq_lote_p
	and	ie_status	= '3'; -- Enviado com sucesso
	
	if (nr_seq_mat_arq_w IS NOT NULL AND nr_seq_mat_arq_w::text <> '') then
		-- Nao e permitido desfazer o lote, pois o arquivo ja foi enviado.
		CALL wheb_mensagem_pck.exibir_mensagem_abort(nr_seq_mensagem_p => 1201309);
	end if;
	
	update	controle_mat_evento
	set	nr_seq_arquivo	 = NULL,
		nr_seq_lote	 = NULL,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_seq_arquivo	in (	SELECT	nr_sequencia
					from	controle_mat_arquivo
					where	nr_seq_lote	= nr_seq_lote_p);
					
	-- excluir retorno
	delete	FROM controle_mat_arquivo_ret
	where	nr_seq_arquivo in (	SELECT	nr_sequencia
					from	controle_mat_arquivo
					where	nr_seq_lote = nr_seq_lote_p);
	
	-- excluir XML
	delete	FROM controle_mat_arq_xml
	where	nr_seq_arquivo in (	SELECT	nr_sequencia
					from	controle_mat_arquivo
					where	nr_seq_lote = nr_seq_lote_p);

	delete	FROM controle_mat_arquivo
	where	nr_seq_lote	= nr_seq_lote_p;

	update	controle_mat_lote
	set	dt_ini_geracao	 = NULL,
		dt_fim_geracao	 = NULL,
		dt_ini_envio	 = NULL,
		dt_fim_envio	 = NULL,
		nm_id_job	 = NULL,
		ie_status	= '7', -- Provisorio
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where  nr_sequencia	= nr_seq_lote_p;

	commit;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sncm_controle_mat_pck.desfazer_lote (nr_seq_lote_p controle_mat_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) FROM PUBLIC;