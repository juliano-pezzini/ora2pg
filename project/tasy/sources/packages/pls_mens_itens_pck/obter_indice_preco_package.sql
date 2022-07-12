-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_mens_itens_pck.obter_indice_preco ( nr_seq_mensalidade_seg_p pls_mensalidade_segurado.nr_sequencia%type, ie_tipo_item_p pls_mensalidade_seg_item.ie_tipo_item%type) RETURNS bigint AS $body$
BEGIN
if (current_setting('pls_mens_itens_pck.tb_nr_seq_mensalidade_seg_w')::pls_util_cta_pck.t_number_table.count > 0) then
	for i in current_setting('pls_mens_itens_pck.tb_nr_seq_mensalidade_seg_w')::pls_util_cta_pck.t_number_table.first..tb_nr_seq_mensalidade_seg_w.last loop
		begin
		if (current_setting('pls_mens_itens_pck.tb_nr_seq_mensalidade_seg_w')::pls_util_cta_pck.t_number_table(i) = nr_seq_mensalidade_seg_p) and (current_setting('pls_mens_itens_pck.tb_ie_tipo_item_w')::pls_util_cta_pck.t_varchar2_table_5(i) = ie_tipo_item_p) then
			return i;
		end if;
		end;
	end loop;
end if;
return -1; --Se nao encontrou o item do preco pre, retorna -1 para tratamento de excecao
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_mens_itens_pck.obter_indice_preco ( nr_seq_mensalidade_seg_p pls_mensalidade_segurado.nr_sequencia%type, ie_tipo_item_p pls_mensalidade_seg_item.ie_tipo_item%type) FROM PUBLIC;