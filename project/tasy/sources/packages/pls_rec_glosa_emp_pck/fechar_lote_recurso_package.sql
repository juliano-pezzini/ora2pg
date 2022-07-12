-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_rec_glosa_emp_pck.fechar_lote_recurso ( nr_seq_lote_p pls_grg_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Marca o lote de recurso como "Fechado"

-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

	
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


BEGIN

-- Verifica se pode fechar o lote

CALL pls_rec_glosa_emp_pck.valida_fechar_lote_rec(nr_seq_lote_p);


update	pls_grg_lote
set	ie_status		= 'F',
	dt_fechamento		= clock_timestamp(),
	nm_usuario_nrec		= nm_usuario_p,
	dt_atualizacao_nrec	= clock_timestamp()
where	nr_sequencia		= nr_seq_lote_p;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rec_glosa_emp_pck.fechar_lote_recurso ( nr_seq_lote_p pls_grg_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
