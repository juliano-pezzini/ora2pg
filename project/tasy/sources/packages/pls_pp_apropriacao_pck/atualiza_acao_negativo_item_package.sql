-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_apropriacao_pck.atualiza_acao_negativo_item ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, tb_nr_sequencia_p INOUT pls_util_cta_pck.t_number_table, tb_ie_acao_pgto_p INOUT pls_util_cta_pck.t_varchar2_table_5, nr_cont_p INOUT integer) AS $body$
BEGIN
-- se tiver algo atualiza
if (tb_nr_sequencia_p.count > 0) then

	forall i in tb_nr_sequencia_p.first..tb_nr_sequencia_p.last
		update	pls_pp_item_lote
		set	ie_acao_pgto_negativo = tb_ie_acao_pgto_p(i)
		where	nr_seq_lote = nr_seq_lote_p
		and	nr_sequencia = tb_nr_sequencia_p(i);
	commit;
end if;

-- limpa as variáveis
tb_nr_sequencia_p.delete;
tb_ie_acao_pgto_p.delete;
nr_cont_p := 0;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_apropriacao_pck.atualiza_acao_negativo_item ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, tb_nr_sequencia_p INOUT pls_util_cta_pck.t_number_table, tb_ie_acao_pgto_p INOUT pls_util_cta_pck.t_varchar2_table_5, nr_cont_p INOUT integer) FROM PUBLIC;
