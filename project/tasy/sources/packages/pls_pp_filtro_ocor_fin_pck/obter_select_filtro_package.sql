-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_pp_filtro_ocor_fin_pck.obter_select_filtro ( ie_considera_selecao_p boolean, nr_id_transacao_p pls_pp_rp_ofin_selecao.nr_id_transacao%type, ie_excecao_p pls_pp_rp_ofin_selecao.ie_excecao%type, nr_seq_filtro_p pls_pp_rp_ofin_selecao.nr_sequencia%type, cd_condicao_pagamento_p pls_pp_lote.cd_condicao_pagamento%type, ds_campo_filtro_p text, ds_tabela_p text, ds_restricao_filtro_p text, valor_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE

				
_ora2pg_r RECORD;
ds_select_w		varchar(20000);
ds_restricao_mat_w	varchar(4000);
ds_restricao_proc_w	varchar(4000);
ds_restricao_reg_sel_w	varchar(2000);
ds_campo_sel_w		varchar(500);
ds_tabela_sel_w		varchar(60);

ds_alias_pre_w		varchar(60);
ds_alias_eve_w		varchar(60);


BEGIN

-- inicia a variável como null
ds_select_w := null;
ds_alias_pre_w := pls_pp_filtro_ocor_fin_pck.obter_alias_tabela('prestador');
ds_alias_eve_w := pls_pp_filtro_ocor_fin_pck.obter_alias_tabela('evento');
							
-- tratamento para filtro de exists da tabela de seleção, isso é feito para considerar somente os registros que estão na tabela de seleção
ds_restricao_reg_sel_w := ds_restricao_reg_sel_w || SELECT * FROM pls_pp_filtro_ocor_fin_pck.obter_restricao_reg_selecao(	ie_considera_selecao_p, nr_id_transacao_p, ie_excecao_p, nr_seq_filtro_p, valor_bind_p) INTO STRICT _ora2pg_r;
 ds_campo_sel_w := _ora2pg_r.ds_campo_p; ds_tabela_sel_w := _ora2pg_r.ds_tabela_p; valor_bind_p := _ora2pg_r.valor_bind_p;

-- este select pode parecer estranho, pois não existe ligação entre as tabelas pls_pp_prestador_tmp e pls_evento
-- mais é isto mesmo, buscamos todos os prestadores e eventos ativos e aplicamos os filtros conforme cadastro
ds_select_w := 	' select ' || ds_alias_pre_w || '.nr_sequencia nr_seq_prestador,' || pls_util_pck.enter_w ||
		' 	 ' || ds_alias_eve_w || '.nr_sequencia nr_seq_evento' || pls_util_pck.enter_w ||
		ds_campo_sel_w ||
		ds_campo_filtro_p || pls_util_pck.enter_w ||
		' from	pls_pp_prestador_tmp ' || ds_alias_pre_w || ',' || pls_util_pck.enter_w ||
		'	pls_evento ' || ds_alias_eve_w || pls_util_pck.enter_w ||
		ds_tabela_sel_w ||
		ds_tabela_p || pls_util_pck.enter_w ||
		' where	' || ds_alias_eve_w || '.ie_situacao = ''A'' ' || pls_util_pck.enter_w ||
		' and ' || ds_alias_eve_w ||'.ie_tipo_evento = ''F'' ' || pls_util_pck.enter_w ||
		ds_restricao_filtro_p ||
		ds_restricao_reg_sel_w;

-- retorna o select que foi montado
return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_pp_filtro_ocor_fin_pck.obter_select_filtro ( ie_considera_selecao_p boolean, nr_id_transacao_p pls_pp_rp_ofin_selecao.nr_id_transacao%type, ie_excecao_p pls_pp_rp_ofin_selecao.ie_excecao%type, nr_seq_filtro_p pls_pp_rp_ofin_selecao.nr_sequencia%type, cd_condicao_pagamento_p pls_pp_lote.cd_condicao_pagamento%type, ds_campo_filtro_p text, ds_tabela_p text, ds_restricao_filtro_p text, valor_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;
