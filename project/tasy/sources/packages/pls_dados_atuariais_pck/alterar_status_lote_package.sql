-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_dados_atuariais_pck.alterar_status_lote ( nr_seq_lote_p pls_atuarial_lote.nr_sequencia%type, ie_status_p pls_atuarial_lote.ie_status%type, ds_log_p pls_atuarial_lote.ds_log%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Altera o status do lote, e registra o log passado

-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

	
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


BEGIN

update	pls_atuarial_lote
set	ie_status	= ie_status_p,
	ds_log		= ds_log_p,
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_lote_p;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_dados_atuariais_pck.alterar_status_lote ( nr_seq_lote_p pls_atuarial_lote.nr_sequencia%type, ie_status_p pls_atuarial_lote.ie_status%type, ds_log_p pls_atuarial_lote.ds_log%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;