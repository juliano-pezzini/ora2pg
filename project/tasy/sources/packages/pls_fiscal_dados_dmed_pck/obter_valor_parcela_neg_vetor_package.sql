-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_fiscal_dados_dmed_pck.obter_valor_parcela_neg_vetor ( nr_seq_parcela_p negociacao_cr_parcela.nr_sequencia%type, ie_tipo_p text) RETURNS bigint AS $body$
DECLARE


vl_parcela_neg_w	double precision;

BEGIN

vl_parcela_neg_w := 0;

if (tb_nr_seq_parcela_neg_w.count > 0) then
	for i in tb_nr_seq_parcela_neg_w.first..tb_nr_seq_parcela_neg_w.last loop
		begin
		if (tb_nr_seq_parcela_neg_w(i) = nr_seq_parcela_p) then
			if (ie_tipo_p = 'I') then
				vl_parcela_neg_w := vl_parcela_neg_w + current_setting('pls_fiscal_dados_dmed_pck.tb_vl_item_w')::pls_util_cta_pck.t_number_table(i);
			elsif (ie_tipo_p = 'D') then
				vl_parcela_neg_w := vl_parcela_neg_w + current_setting('pls_fiscal_dados_dmed_pck.tb_vl_desconto_negociacao_w')::pls_util_cta_pck.t_number_table(i);
			elsif (ie_tipo_p = 'T') then
				vl_parcela_neg_w := vl_parcela_neg_w + current_setting('pls_fiscal_dados_dmed_pck.tb_vl_taxa_negociacao_w')::pls_util_cta_pck.t_number_table(i);
			elsif (ie_tipo_p = 'J') then
				vl_parcela_neg_w := vl_parcela_neg_w + current_setting('pls_fiscal_dados_dmed_pck.tb_vl_juros_negociacao_w')::pls_util_cta_pck.t_number_table(i);
			elsif (ie_tipo_p = 'M') then
				vl_parcela_neg_w := vl_parcela_neg_w + current_setting('pls_fiscal_dados_dmed_pck.tb_vl_multa_negociacao_w')::pls_util_cta_pck.t_number_table(i);
			elsif (ie_tipo_p = 'MA') then
				vl_parcela_neg_w := vl_parcela_neg_w + tb_vl_multa_negociacao_ant_w(i);
			elsif (ie_tipo_p = 'JA') then
				vl_parcela_neg_w := vl_parcela_neg_w + tb_vl_juros_negociacao_ant_w(i);
			elsif (ie_tipo_p = 'DA') then
				vl_parcela_neg_w := vl_parcela_neg_w + tb_vl_desconto_negoc_ant_w(i);
			elsif (ie_tipo_p = 'TA') then
				vl_parcela_neg_w := vl_parcela_neg_w + tb_vl_taxa_negociacao_ant_w(i);
			end if;
		end if;
		end;
	end loop;
end if;

return vl_parcela_neg_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_fiscal_dados_dmed_pck.obter_valor_parcela_neg_vetor ( nr_seq_parcela_p negociacao_cr_parcela.nr_sequencia%type, ie_tipo_p text) FROM PUBLIC;
