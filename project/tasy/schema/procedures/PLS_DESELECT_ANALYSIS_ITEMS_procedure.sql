-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_deselect_analysis_items (nr_seq_analise_p w_pls_analise_item.nr_seq_analise%type, nr_id_transacao_p w_pls_analise_item.nr_id_transacao%type, nr_seq_w_item_p w_pls_analise_item.nr_sequencia%type, ie_selecionado_p w_pls_analise_item.ie_selecionado%type, nm_usuario_p text) AS $body$
BEGIN

	update  w_pls_analise_item
	set		ie_selecionado = ie_selecionado_p
	where 	nr_seq_analise = nr_seq_analise_p
			and nm_usuario = nm_usuario_p
			and  nr_id_transacao = nr_id_transacao_p
			and nr_sequencia <> nr_seq_w_item_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_deselect_analysis_items (nr_seq_analise_p w_pls_analise_item.nr_seq_analise%type, nr_id_transacao_p w_pls_analise_item.nr_id_transacao%type, nr_seq_w_item_p w_pls_analise_item.nr_sequencia%type, ie_selecionado_p w_pls_analise_item.ie_selecionado%type, nm_usuario_p text) FROM PUBLIC;
