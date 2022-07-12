-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mov_benef_imp_pck.desfazer_lote ( nr_seq_lote_p pls_mov_benef_lote.nr_sequencia%type, ie_opcao_p text, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

delete from pls_mov_benef_lote_incons
where 	nr_seq_lote = nr_seq_lote_p;

delete from pls_mov_benef_seg_compl
where	nr_seq_mov_segurado in (SELECT	a.nr_sequencia
				from	pls_mov_benef_segurado a
				where	a.nr_seq_lote = nr_seq_lote_p);

delete from pls_mov_benef_seg_sca
where	nr_seq_mov_segurado in (SELECT	a.nr_sequencia
				from	pls_mov_benef_segurado a
				where	a.nr_seq_lote = nr_seq_lote_p);

delete from pls_mov_benef_seg_carencia
where	nr_seq_mov_segurado in (SELECT	a.nr_sequencia
				from	pls_mov_benef_segurado a
				where	a.nr_seq_lote = nr_seq_lote_p);

delete from pls_mov_benef_segurado
where	nr_seq_lote = nr_seq_lote_p;

delete from pls_mov_benef_plano
where	nr_seq_lote = nr_seq_lote_p;

delete from pls_mov_benef_contrato
where	nr_seq_lote = nr_seq_lote_p;

delete from pls_mov_benef_lote
where	nr_sequencia = nr_seq_lote_p;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mov_benef_imp_pck.desfazer_lote ( nr_seq_lote_p pls_mov_benef_lote.nr_sequencia%type, ie_opcao_p text, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
