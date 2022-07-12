-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_mens_itens_pck.obter_se_item_vetor ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, ie_tipo_item_p pls_mensalidade_seg_item.ie_tipo_item%type, nr_seq_pagador_p pls_contrato_pagador.nr_sequencia%type, nr_seq_sca_vinculo_p pls_sca_vinculo.nr_sequencia%type, nr_seq_lanc_aut_mens_p pls_segurado_mensalidade.nr_sequencia%type) RETURNS varchar AS $body$
BEGIN

if (current_setting('pls_mens_itens_pck.tb_nr_seq_segurado_w')::pls_util_cta_pck.t_number_table.count > 0) then
	for i in current_setting('pls_mens_itens_pck.tb_nr_seq_segurado_w')::pls_util_cta_pck.t_number_table.first..tb_nr_seq_segurado_w.last loop
		if (current_setting('pls_mens_itens_pck.tb_nr_seq_segurado_w')::pls_util_cta_pck.t_number_table(i) = nr_seq_segurado_p) and (current_setting('pls_mens_itens_pck.tb_ie_tipo_item_w')::pls_util_cta_pck.t_varchar2_table_5(i) = ie_tipo_item_p) then
			
			if	(ie_tipo_item_p = '25' AND nr_seq_sca_vinculo_p IS NOT NULL AND nr_seq_sca_vinculo_p::text <> '') then --Se for reajuste por variacao de custo de preco pre, e tiver sca, precisa percorrer os vetores que armazenam  os SCA embutidos
				if (current_setting('pls_mens_itens_pck.tb_sca_indice_preco_pre_w')::pls_util_cta_pck.t_number_table.count > 0) then
					for j in current_setting('pls_mens_itens_pck.tb_sca_indice_preco_pre_w')::pls_util_cta_pck.t_number_table.first..tb_sca_indice_preco_pre_w.last loop
						if (current_setting('pls_mens_itens_pck.tb_sca_indice_preco_pre_w')::pls_util_cta_pck.t_number_table(j) = i) and (current_setting('pls_mens_itens_pck.tb_sca_nr_seq_vinculo_sca_w')::pls_util_cta_pck.t_number_table(j) = nr_seq_sca_vinculo_p) then
							return 'S';
						end if;
					end loop;
				end if;
			elsif	((ie_tipo_item_p = '25') and (current_setting('pls_mens_itens_pck.tb_nr_seq_pagador_compl_w')::pls_util_cta_pck.t_number_table.count > 0)) then
				for j in current_setting('pls_mens_itens_pck.tb_nr_seq_pagador_compl_w')::pls_util_cta_pck.t_number_table.first..tb_nr_seq_pagador_compl_w.last loop
					begin
					if	((current_setting('pls_mens_itens_pck.tb_ie_tipo_item_compl_w')::pls_util_cta_pck.t_varchar2_table_5(j) = ie_tipo_item_p) and (current_setting('pls_mens_itens_pck.tb_nr_seq_pagador_compl_w')::pls_util_cta_pck.t_number_table(j) = nr_seq_pagador_p)) then
						if (current_setting('pls_mens_itens_pck.tb_apropriacao_item_w')::tb_apropriacao_item_t[i].count > 0) then
							for y in current_setting('pls_mens_itens_pck.tb_apropriacao_item_w')::tb_apropriacao_item_t[i].first..tb_apropriacao_item_w[i].last loop
								begin
								if	(current_setting('pls_mens_itens_pck.tb_apropriacao_item_w')::tb_apropriacao_item_t(i)(y).nr_seq_centro_apropriacao = current_setting('pls_mens_itens_pck.tb_nr_seq_centro_aprop_comp_w')::pls_util_cta_pck.t_number_table(j)) then
									return 'S';
								end if;
								end;
							end loop;
						end if;
					end if;
					end;
				end loop;
			elsif ((nr_seq_sca_vinculo_p IS NOT NULL AND nr_seq_sca_vinculo_p::text <> '') and current_setting('pls_mens_itens_pck.tb_nr_seq_vinculo_sca_w')::pls_util_cta_pck.t_number_table(i) = nr_seq_sca_vinculo_p) then
				return 'S';
			elsif ((nr_seq_lanc_aut_mens_p IS NOT NULL AND nr_seq_lanc_aut_mens_p::text <> '') and current_setting('pls_mens_itens_pck.tb_nr_seq_lanc_aut_mens_w')::pls_util_cta_pck.t_number_table(i) = nr_seq_lanc_aut_mens_p) then
				return 'S';
			elsif	((coalesce(nr_seq_lanc_aut_mens_p::text, '') = '') and (coalesce(nr_seq_sca_vinculo_p::text, '') = '')) then
				return 'S';
			end if;
		end if;
	end loop;
end if;

return 'N';

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_mens_itens_pck.obter_se_item_vetor ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, ie_tipo_item_p pls_mensalidade_seg_item.ie_tipo_item%type, nr_seq_pagador_p pls_contrato_pagador.nr_sequencia%type, nr_seq_sca_vinculo_p pls_sca_vinculo.nr_sequencia%type, nr_seq_lanc_aut_mens_p pls_segurado_mensalidade.nr_sequencia%type) FROM PUBLIC;
