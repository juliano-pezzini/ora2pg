-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_lote_pagamento_pck.limpa_itens_origem_lote ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, tb_seq_item_p pls_util_cta_pck.t_number_table, ie_tipo_item_p pls_pp_item_lote_origem.ie_tipo_item%type) AS $body$
BEGIN

-- limpa o que for do mesmo tipo e lote quando existir lotes

if (tb_seq_item_p.count > 0) then
	
	forall i in tb_seq_item_p.first..tb_seq_item_p.last
		delete 	from pls_pp_item_lote_origem
		where	nr_seq_lote = nr_seq_lote_p
		and	nr_seq_item_origem = tb_seq_item_p(i)
		and	ie_tipo_item = ie_tipo_item_p;
	commit;
	
	forall i in tb_seq_item_p.first..tb_seq_item_p.last
		delete 	from pls_pp_item_lote_origem
		where	nr_seq_lote = nr_seq_lote_p
		and	nr_seq_item = tb_seq_item_p(i)
		and	ie_tipo_item = ie_tipo_item_p;
	commit;

end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_lote_pagamento_pck.limpa_itens_origem_lote ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, tb_seq_item_p pls_util_cta_pck.t_number_table, ie_tipo_item_p pls_pp_item_lote_origem.ie_tipo_item%type) FROM PUBLIC;