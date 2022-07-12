-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_filtro_regra_preco_cta_pck.obter_restricao_vinc_regra ( ie_somente_regra_vinc_p text, ie_destino_regra_p text, ie_tipo_regra_p pls_cp_cta_combinada.ie_tipo_regra%type, ds_tabela_vinc_p out text) AS $body$
DECLARE


ds_restricao_w	varchar(400);

BEGIN

-- se tem ou NAO valor informado nas tabelas de regras

if (ie_somente_regra_vinc_p = 'N') then

	-- monta o select de acordo com o tipo de regra

	case(ie_tipo_regra_p)

		-- Procedimento

		when 'P' then
			
			-- faz a ligacao da tabela de regras

			ds_tabela_vinc_p := ', ' || pls_util_pck.enter_w || 
						'	pls_conta_proc_regra ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('proc_regra') || pls_util_pck.enter_w;
			ds_restricao_w := ds_restricao_w || 	' and	' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('proc_regra') || '.nr_sequencia = ' ||
								pls_filtro_regra_preco_cta_pck.obter_alias_tabela('procedimento') || '.nr_sequencia ' || pls_util_pck.enter_w;
						
			-- verifica se e para filtrar pelo campo de coparticipacao

			if (ie_destino_regra_p = 'C') then
				ds_restricao_w := ds_restricao_w || '	and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('proc_regra') || '.nr_seq_cp_comb_filtro_cop is null ' || pls_util_pck.enter_w ||
								'	and exists (select 1 ' || pls_util_pck.enter_w ||
								'		from 	pls_segurado seg, ' || pls_util_pck.enter_w ||
								'			pls_plano plan ' || pls_util_pck.enter_w ||
								'		where 	seg.nr_sequencia = ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.nr_seq_segurado ' || pls_util_pck.enter_w ||
								'		and	plan.nr_sequencia = seg.nr_seq_plano ' || pls_util_pck.enter_w ||
								'		and	plan.ie_preco = ''1'' ) ' || pls_util_pck.enter_w;
			else
				-- qualquer coisa que NAO for coparticipacao e por este campo

				ds_restricao_w := ds_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('proc_regra') || '.nr_seq_cp_comb_filtro is null ' || pls_util_pck.enter_w;
			end if;
		
		-- Material			

		when 'M' then
		
			-- faz a ligacao da tabela de regras

			ds_tabela_vinc_p := ', ' || pls_util_pck.enter_w ||
						'	pls_conta_mat_regra ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('mat_regra') || pls_util_pck.enter_w;
			ds_restricao_w := ds_restricao_w || 	' and	' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('mat_regra') || '.nr_sequencia = ' ||
								pls_filtro_regra_preco_cta_pck.obter_alias_tabela('material') || '.nr_sequencia ' || pls_util_pck.enter_w;
			
			-- verifica se e para filtrar pelo campo de coparticipacao

			if (ie_destino_regra_p = 'C') then
				ds_restricao_w := ds_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('mat_regra') || '.nr_seq_cp_comb_filtro_cop is null ' || pls_util_pck.enter_w;
			else
				-- qualquer coisa que NAO for coparticipacao e por este campo

				ds_restricao_w := ds_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('mat_regra') || '.nr_seq_cp_comb_filtro is null ' || pls_util_pck.enter_w;
			end if;
		-- servico

		when 'S' then
		
			-- faz a ligacao da tabela de regras

			ds_tabela_vinc_p := ', ' || pls_util_pck.enter_w ||
						'	pls_conta_proc_regra ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('proc_regra') || pls_util_pck.enter_w;
			ds_restricao_w := ds_restricao_w || 	' and	' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('proc_regra') || '.nr_sequencia = ' ||
								pls_filtro_regra_preco_cta_pck.obter_alias_tabela('procedimento') || '.nr_sequencia ' || pls_util_pck.enter_w;

			-- se for para considerar o que NAO tem regra vinculada

			-- verifica se e para filtrar pelo campo de coparticipacao

			if (ie_destino_regra_p = 'C') then
				ds_restricao_w := ds_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('proc_regra') || '.nr_seq_cp_comb_filtro_cop is null ' || pls_util_pck.enter_w;
			else
				-- qualquer coisa que NAO for coparticipacao e por este campo

				ds_restricao_w := ds_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('proc_regra') || '.nr_seq_cp_comb_filtro is null ' || pls_util_pck.enter_w;
			end if;

		-- Participante do procedimento

		when 'PP' then
			
			ds_tabela_vinc_p := null;
			
			-- participante NAO precisa da tabela e da ligacao pois o campo da regra ja esta na tabela participante		

			-- se for para considerar o que NAO tem regra vinculada

			-- verifica se e para filtrar pelo campo de coparticipacao

			if (ie_destino_regra_p = 'C') then
				ds_restricao_w := ds_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('participante') || '.nr_seq_cp_comb_filtro_cop is null ' || pls_util_pck.enter_w;
			else
				-- qualquer coisa que NAO for coparticipacao e por este campo

				ds_restricao_w := ds_restricao_w || ' and nvl(' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('participante') || '.nr_seq_cp_comb_filtro, -1) = -1 ' || pls_util_pck.enter_w;
			end if;

		else
			null;
	end case;

-- monta o filtro para retornar somente os registros que NAO tenham registros nas tabelas de regra

-- participante de procedimento NAO deve entrar aqui pois eles sao gravados na tabela pls_proc_participante (NAO tem tabela de regra)

elsif (ie_somente_regra_vinc_p = 'Z' and ie_tipo_regra_p != 'PP') then

	-- se for material

	if (ie_tipo_regra_p = 'M') then
		ds_restricao_w := ds_restricao_w || 	' and not exists (	select	1' || pls_util_pck.enter_w ||
							'			from	pls_conta_mat_regra ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('mat_regra') || pls_util_pck.enter_w ||
							'			where	' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('mat_regra') || '.nr_sequencia = ' ||
							'				' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('material') || '.nr_sequencia)' || pls_util_pck.enter_w;
	else
		-- tudo o que for procedimento vai aqui (procedimento, servico e talvez pacote)

		ds_restricao_w := ds_restricao_w || 	' and not exists (	select	1' || pls_util_pck.enter_w ||
							'			from	pls_conta_proc_regra ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('proc_regra') || pls_util_pck.enter_w ||
							'			where	' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('proc_regra') || '.nr_sequencia = ' ||
							'				' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('procedimento') || '.nr_sequencia)' || pls_util_pck.enter_w;
	end if;
end if;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_filtro_regra_preco_cta_pck.obter_restricao_vinc_regra ( ie_somente_regra_vinc_p text, ie_destino_regra_p text, ie_tipo_regra_p pls_cp_cta_combinada.ie_tipo_regra%type, ds_tabela_vinc_p out text) FROM PUBLIC;