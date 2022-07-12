-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_pp_filtro_ocor_fin_pck.obter_restricao_reg_selecao ( ie_considera_selecao_p boolean, nr_id_transacao_p pls_pp_rp_ofin_selecao.nr_id_transacao%type, ie_excecao_p pls_pp_rp_cta_filtro.ie_excecao%type, nr_seq_filtro_p pls_pp_rp_cta_filtro.nr_sequencia%type, ds_campo_p out text, ds_tabela_p out text, valor_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE


ds_restricao_w		varchar(1000);
ds_alias_sel_w		varchar(60);
ds_alias_prest_w	varchar(60);
ds_alias_event_w	varchar(60);


BEGIN

ds_alias_sel_w := pls_pp_filtro_ocor_fin_pck.obter_alias_tabela('selecao');
ds_alias_prest_w := pls_pp_filtro_ocor_fin_pck.obter_alias_tabela('prestador');
ds_alias_event_w := pls_pp_filtro_ocor_fin_pck.obter_alias_tabela('evento');

ds_restricao_w := ds_restricao_w || ' and ' || ds_alias_sel_w || '.nr_id_transacao = :nr_id_transacao_pc' || pls_util_pck.enter_w;
valor_bind_p := sql_pck.bind_variable(':nr_id_transacao_pc', nr_id_transacao_p, valor_bind_p);

-- se for regra ou filtro de exceção, seleciona somente o que estiver marcado com o ie_excecao
if (ie_excecao_p = 'S') then
	ds_restricao_w := ds_restricao_w || ' and ' || ds_alias_sel_w || '.ie_excecao = ''S''' || pls_util_pck.enter_w;
else
	-- aplica a filtragem pelo filtro
	ds_restricao_w := ds_restricao_w || ' and ' || ds_alias_sel_w || '.nr_seq_filtro = :nr_seq_filtro_pc' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_filtro_pc', nr_seq_filtro_p, valor_bind_p);
end if;

ds_restricao_w := ds_restricao_w || ' and	' || ds_alias_sel_w || '.ie_valido = ''S''' || pls_util_pck.enter_w;

-- joins entre a seleção e a pls_conta_medica_resumo
ds_restricao_w := ds_restricao_w || ' and ' || ds_alias_sel_w || '.nr_seq_prestador = ' || ds_alias_prest_w || '.nr_sequencia' || pls_util_pck.enter_w ||
				    ' and ' || ds_alias_sel_w || '.nr_seq_evento = ' || ds_alias_event_w || '.nr_sequencia' || pls_util_pck.enter_w;

-- só restringe os registros com a tabela de seleção se for para considerar a seleção
if (ie_considera_selecao_p = true) then
	ds_tabela_p := ds_tabela_p || ', ' || pls_util_pck.enter_w ||
			' pls_pp_rp_ofin_selecao ' || ds_alias_sel_w;
	ds_campo_p := ds_campo_p || ', ' || pls_util_pck.enter_w || ds_alias_sel_w || '.nr_sequencia nr_seq_selecao ';
			
else
	ds_tabela_p := null;
	ds_campo_p := ds_campo_p || 	', ' || pls_util_pck.enter_w ||
					' ( select	max(' || ds_alias_sel_w || '.nr_sequencia)' || pls_util_pck.enter_w ||
					'   from 	pls_pp_rp_ofin_selecao ' || ds_alias_sel_w || pls_util_pck.enter_w ||
					'   where	1 = 1' || pls_util_pck.enter_w ||
					ds_restricao_w || ') nr_seq_selecao ' || pls_util_pck.enter_w;
					
	-- zera a restrição pois a mesma não deve ser retornada quando for fazer select via campo
	ds_restricao_w := null;
end if;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_pp_filtro_ocor_fin_pck.obter_restricao_reg_selecao ( ie_considera_selecao_p boolean, nr_id_transacao_p pls_pp_rp_ofin_selecao.nr_id_transacao%type, ie_excecao_p pls_pp_rp_cta_filtro.ie_excecao%type, nr_seq_filtro_p pls_pp_rp_cta_filtro.nr_sequencia%type, ds_campo_p out text, ds_tabela_p out text, valor_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;