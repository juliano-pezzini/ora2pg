-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_pp_filtro_rec_glosa_pck.obter_select_filtro ( ie_considera_selecao_p boolean, ie_incidencia_filtro_p text, nr_id_transacao_p pls_pp_cta_rec_selecao.nr_id_transacao%type, ie_excecao_p pls_pp_rp_cta_filtro.ie_excecao%type, nr_seq_filtro_p pls_pp_rp_cta_filtro.nr_sequencia%type, ie_tipo_data_ref_p pls_pp_lote.ie_tipo_dt_referencia%type, dt_inicio_referencia_p pls_pp_lote.dt_referencia_inicio%type, dt_fim_referencia_p pls_pp_lote.dt_referencia_fim%type, cd_condicao_pagamento_p pls_pp_lote.cd_condicao_pagamento%type, ie_recurso_proprio_p pls_pp_lote.ie_recurso_proprio%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ds_campo_filtro_p text, ds_tabela_p text, ds_restricao_filtro_p text, valor_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE

				
_ora2pg_r RECORD;
ds_select_w		varchar(20000);
ds_restricao_padrao_w	varchar(4000);
ds_restricao_mat_w	varchar(4000);
ds_restricao_proc_w	varchar(4000);
ds_restricao_reg_sel_w	varchar(2000);
ds_campo_sel_w		varchar(500);
ds_tabela_sel_w		varchar(60);

ds_alias_pcl_w		varchar(60);
ds_alias_con_w		varchar(60);
ds_alias_mat_w		varchar(60);
ds_alias_pro_w		varchar(60);
ds_alias_res_w		varchar(60);
ds_alias_pre_w		varchar(60);
ds_alias_eve_w		varchar(60);

ds_alias_pcl_orig_w	varchar(60);
ds_alias_con_orig_w	varchar(60);
ds_alias_mat_orig_w	varchar(60);
ds_alias_pro_orig_w	varchar(60);


BEGIN

-- inicia a variavel como null

ds_select_w := null;
ds_alias_pcl_w := pls_pp_filtro_rec_glosa_pck.obter_alias_tabela('protocolo');
ds_alias_con_w := pls_pp_filtro_rec_glosa_pck.obter_alias_tabela('conta');
ds_alias_mat_w := pls_pp_filtro_rec_glosa_pck.obter_alias_tabela('material');
ds_alias_pro_w := pls_pp_filtro_rec_glosa_pck.obter_alias_tabela('procedimento');
ds_alias_res_w := pls_pp_filtro_rec_glosa_pck.obter_alias_tabela('resumo');
ds_alias_pre_w := pls_pp_filtro_rec_glosa_pck.obter_alias_tabela('prestador');
ds_alias_eve_w := pls_pp_filtro_rec_glosa_pck.obter_alias_tabela('evento');

ds_alias_pcl_orig_w := pls_pp_filtro_rec_glosa_pck.obter_alias_tabela('protocolo_original');
ds_alias_con_orig_w := pls_pp_filtro_rec_glosa_pck.obter_alias_tabela('conta_original');
ds_alias_mat_orig_w := pls_pp_filtro_rec_glosa_pck.obter_alias_tabela('material_original');
ds_alias_pro_orig_w := pls_pp_filtro_rec_glosa_pck.obter_alias_tabela('procedimento_original');

-- obtem os filtros que sao padrao da selecao

SELECT * FROM pls_pp_filtro_rec_glosa_pck.obter_restricao_padrao(	ie_considera_selecao_p, ie_tipo_data_ref_p, dt_inicio_referencia_p, dt_fim_referencia_p, cd_condicao_pagamento_p, ie_recurso_proprio_p, cd_estabelecimento_p, valor_bind_p) INTO STRICT _ora2pg_r;
 ds_restricao_mat_w := _ora2pg_r.ds_restricao_mat_p; ds_restricao_proc_w := _ora2pg_r.ds_restricao_proc_p; valor_bind_p := _ora2pg_r.valor_bind_p;
							
-- tratamento para filtro de exists da tabela de selecao, isso e feito para considerar somente os registros que estao na tabela de selecao

ds_restricao_reg_sel_w := ds_restricao_reg_sel_w || SELECT * FROM pls_pp_filtro_rec_glosa_pck.obter_restricao_reg_selecao(	ie_considera_selecao_p, nr_id_transacao_p, ie_excecao_p, nr_seq_filtro_p, valor_bind_p) INTO STRICT _ora2pg_r;
 ds_campo_sel_w := _ora2pg_r.ds_campo_p; ds_tabela_sel_w := _ora2pg_r.ds_tabela_p; valor_bind_p := _ora2pg_r.valor_bind_p;

-- nr_seq_lote_pgto => lote de pagamento do modelo antigo

-- nr_seq_pp_lote => lote de pagamento atual

											
-- monta o select de acordo com a incidencia de selecao

case(ie_incidencia_filtro_p)
	-- conta

	when 'C' then
		ds_select_w := 	' select ' || ds_alias_res_w || '.nr_seq_conta_rec,' || pls_util_pck.enter_w ||
				'	'  || ds_alias_res_w || '.nr_sequencia nr_seq_resumo,' || pls_util_pck.enter_w ||
				'	null nr_seq_proc_rec,' || pls_util_pck.enter_w ||
				'	null nr_seq_mat_rec,' || pls_util_pck.enter_w ||
				'	' || ds_alias_con_orig_w || '.dt_atendimento_referencia dt_ref' || pls_util_pck.enter_w ||
				ds_campo_sel_w ||
				ds_campo_filtro_p || pls_util_pck.enter_w ||
				' from	pls_rec_glosa_protocolo ' || ds_alias_pcl_w || ',' || pls_util_pck.enter_w ||
				'	pls_rec_glosa_conta ' || ds_alias_con_w || ',' || pls_util_pck.enter_w ||
				'	pls_conta ' || ds_alias_con_orig_w || ',' || pls_util_pck.enter_w ||
				'	pls_protocolo_conta ' || ds_alias_pcl_orig_w  || ',' || pls_util_pck.enter_w ||
				'	pls_conta_rec_resumo_item ' || ds_alias_res_w || ',' || pls_util_pck.enter_w ||
				'	pls_prestador ' || ds_alias_pre_w || pls_util_pck.enter_w ||
				ds_tabela_sel_w ||
				ds_tabela_p || pls_util_pck.enter_w ||
				' where	' || ds_alias_pcl_w || '.ie_status in (''3'',''4'')' || pls_util_pck.enter_w ||
				' and   ' || ds_alias_con_w || '.nr_seq_protocolo = ' || ds_alias_pcl_w || '.nr_sequencia ' || pls_util_pck.enter_w ||
				' and 	' || ds_alias_con_orig_w || '.nr_sequencia = ' || ds_alias_con_w || '.nr_seq_conta' || pls_util_pck.enter_w ||
				' and 	' || ds_alias_pcl_orig_w || '.nr_sequencia = ' || ds_alias_con_orig_w || '.nr_seq_protocolo' || pls_util_pck.enter_w ||
				' and 	' || ds_alias_res_w || '.nr_seq_conta_rec = ' || ds_alias_con_w || '.nr_sequencia' || pls_util_pck.enter_w ||
				' and	' || ds_alias_res_w || '.nr_seq_lote_pgto is null' || pls_util_pck.enter_w ||
				' and	' || ds_alias_res_w || '.nr_seq_pp_lote is null' || pls_util_pck.enter_w ||
				' and	' || ds_alias_res_w || '.nr_seq_pp_evento is not null' || pls_util_pck.enter_w ||
				' and	' || ds_alias_res_w || '.vl_liberado >= 0' || pls_util_pck.enter_w ||
				' and	' || ds_alias_res_w || '.ie_situacao = ''A''' || pls_util_pck.enter_w ||
				' and	' || ds_alias_pre_w || '.nr_sequencia = ' || ds_alias_res_w || '.nr_seq_prestador_pgto'  || pls_util_pck.enter_w ||
				ds_restricao_padrao_w ||
				ds_restricao_filtro_p ||
				ds_restricao_reg_sel_w;

	-- material

	when 'M' then
		ds_select_w := 	' select ' || ds_alias_res_w || '.nr_seq_conta_rec,' || pls_util_pck.enter_w ||
				'	'  || ds_alias_res_w || '.nr_sequencia nr_seq_resumo,' || pls_util_pck.enter_w ||
				'	null nr_seq_proc_rec,' || pls_util_pck.enter_w ||
				'	' || ds_alias_res_w || '.nr_seq_mat_rec,' || pls_util_pck.enter_w ||
				'	' || ds_alias_con_orig_w || '.dt_atendimento_referencia dt_ref' || pls_util_pck.enter_w ||
				ds_campo_sel_w ||
				ds_campo_filtro_p || pls_util_pck.enter_w ||
				' from	pls_rec_glosa_protocolo ' || ds_alias_pcl_w || ',' || pls_util_pck.enter_w ||
				'	pls_rec_glosa_conta ' || ds_alias_con_w || ',' || pls_util_pck.enter_w ||
				'	pls_conta ' || ds_alias_con_orig_w || ',' || pls_util_pck.enter_w ||
				'	pls_protocolo_conta ' || ds_alias_pcl_orig_w  || ',' || pls_util_pck.enter_w ||
				'	pls_conta_rec_resumo_item ' || ds_alias_res_w || ',' || pls_util_pck.enter_w ||
				'	pls_rec_glosa_mat ' || ds_alias_mat_w || ',' || pls_util_pck.enter_w ||
				'	pls_conta_mat ' || ds_alias_mat_orig_w || ',' || pls_util_pck.enter_w ||
				'	pls_prestador ' || ds_alias_pre_w || pls_util_pck.enter_w ||
				ds_tabela_sel_w ||
				ds_tabela_p || pls_util_pck.enter_w ||
				' where	' || ds_alias_pcl_w || '.ie_status in (''3'',''4'')' || pls_util_pck.enter_w ||
				' and   ' || ds_alias_con_w || '.nr_seq_protocolo = ' || ds_alias_pcl_w || '.nr_sequencia ' || pls_util_pck.enter_w ||
				' and 	' || ds_alias_con_orig_w || '.nr_sequencia = ' || ds_alias_con_w || '.nr_seq_conta' || pls_util_pck.enter_w ||
				' and 	' || ds_alias_pcl_orig_w || '.nr_sequencia = ' || ds_alias_con_orig_w || '.nr_seq_protocolo' || pls_util_pck.enter_w ||
				' and 	' || ds_alias_res_w || '.nr_seq_conta_rec = ' || ds_alias_con_w || '.nr_sequencia' || pls_util_pck.enter_w ||
				' and	' || ds_alias_res_w || '.nr_seq_lote_pgto is null' || pls_util_pck.enter_w ||
				' and	' || ds_alias_res_w || '.nr_seq_pp_lote is null' || pls_util_pck.enter_w ||
				' and	' || ds_alias_res_w || '.nr_seq_pp_evento is not null' || pls_util_pck.enter_w ||
				' and	' || ds_alias_res_w || '.vl_liberado >= 0' || pls_util_pck.enter_w ||
				' and	' || ds_alias_res_w || '.ie_situacao = ''A''' || pls_util_pck.enter_w ||
				' and 	' || ds_alias_mat_w || '.nr_sequencia = ' || ds_alias_res_w || '.nr_seq_mat_rec' || pls_util_pck.enter_w ||
				' and 	' || ds_alias_mat_orig_w || '.nr_sequencia = ' || ds_alias_mat_w || '.nr_seq_conta_mat' || pls_util_pck.enter_w ||
				' and	' || ds_alias_pre_w || '.nr_sequencia = ' || ds_alias_res_w || '.nr_seq_prestador_pgto'  || pls_util_pck.enter_w ||
				ds_restricao_padrao_w ||
				ds_restricao_mat_w ||
				ds_restricao_filtro_p ||
				ds_restricao_reg_sel_w;

	-- procedimento

	when 'P' then
		ds_select_w := 	' select ' || ds_alias_res_w || '.nr_seq_conta_rec,' || pls_util_pck.enter_w ||
				'	'  || ds_alias_res_w || '.nr_sequencia nr_seq_resumo,' || pls_util_pck.enter_w ||
				'	' || ds_alias_res_w || '.nr_seq_proc_rec,' || pls_util_pck.enter_w ||
				'	null nr_seq_mat_rec,' || pls_util_pck.enter_w ||
				'	' || ds_alias_con_orig_w || '.dt_atendimento_referencia dt_ref' || pls_util_pck.enter_w ||
				ds_campo_sel_w ||
				ds_campo_filtro_p || pls_util_pck.enter_w ||
				' from	pls_rec_glosa_protocolo ' || ds_alias_pcl_w || ',' || pls_util_pck.enter_w ||
				'	pls_rec_glosa_conta ' || ds_alias_con_w || ',' || pls_util_pck.enter_w ||
				'	pls_conta ' || ds_alias_con_orig_w || ',' || pls_util_pck.enter_w ||
				'	pls_protocolo_conta ' || ds_alias_pcl_orig_w  || ',' || pls_util_pck.enter_w ||
				'	pls_conta_rec_resumo_item ' || ds_alias_res_w || ',' || pls_util_pck.enter_w ||
				'	pls_rec_glosa_proc ' || ds_alias_pro_w || ',' || pls_util_pck.enter_w ||
				'	pls_conta_proc ' || ds_alias_pro_orig_w || ',' || pls_util_pck.enter_w ||
				'	pls_prestador ' || ds_alias_pre_w || pls_util_pck.enter_w ||
				ds_tabela_sel_w ||
				ds_tabela_p || pls_util_pck.enter_w ||
				' where	' || ds_alias_pcl_w || '.ie_status in (''3'',''4'')' || pls_util_pck.enter_w ||
				' and   ' || ds_alias_con_w || '.nr_seq_protocolo = ' || ds_alias_pcl_w || '.nr_sequencia ' || pls_util_pck.enter_w ||
				' and 	' || ds_alias_con_orig_w || '.nr_sequencia = ' || ds_alias_con_w || '.nr_seq_conta' || pls_util_pck.enter_w ||
				' and 	' || ds_alias_pcl_orig_w || '.nr_sequencia = ' || ds_alias_con_orig_w || '.nr_seq_protocolo' || pls_util_pck.enter_w ||
				' and 	' || ds_alias_res_w || '.nr_seq_conta_rec = ' || ds_alias_con_w || '.nr_sequencia' || pls_util_pck.enter_w ||
				' and	' || ds_alias_res_w || '.nr_seq_lote_pgto is null' || pls_util_pck.enter_w ||
				' and	' || ds_alias_res_w || '.nr_seq_pp_lote is null' || pls_util_pck.enter_w ||
				' and	' || ds_alias_res_w || '.nr_seq_pp_evento is not null' || pls_util_pck.enter_w ||
				' and	' || ds_alias_res_w || '.vl_liberado >= 0' || pls_util_pck.enter_w ||
				' and	' || ds_alias_res_w || '.ie_situacao = ''A''' || pls_util_pck.enter_w ||
				' and 	' || ds_alias_pro_w || '.nr_sequencia = ' || ds_alias_res_w || '.nr_seq_proc_rec' || pls_util_pck.enter_w ||
				' and 	' || ds_alias_pro_orig_w || '.nr_sequencia = ' || ds_alias_pro_w || '.nr_seq_conta_proc' || pls_util_pck.enter_w ||
				' and	' || ds_alias_pre_w || '.nr_sequencia = ' || ds_alias_res_w || '.nr_seq_prestador_pgto'  || pls_util_pck.enter_w ||
				ds_restricao_padrao_w ||
				ds_restricao_proc_w ||
				ds_restricao_filtro_p ||
				ds_restricao_reg_sel_w;

	else
		null;
end case;

-- retorna o select que foi montado

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_pp_filtro_rec_glosa_pck.obter_select_filtro ( ie_considera_selecao_p boolean, ie_incidencia_filtro_p text, nr_id_transacao_p pls_pp_cta_rec_selecao.nr_id_transacao%type, ie_excecao_p pls_pp_rp_cta_filtro.ie_excecao%type, nr_seq_filtro_p pls_pp_rp_cta_filtro.nr_sequencia%type, ie_tipo_data_ref_p pls_pp_lote.ie_tipo_dt_referencia%type, dt_inicio_referencia_p pls_pp_lote.dt_referencia_inicio%type, dt_fim_referencia_p pls_pp_lote.dt_referencia_fim%type, cd_condicao_pagamento_p pls_pp_lote.cd_condicao_pagamento%type, ie_recurso_proprio_p pls_pp_lote.ie_recurso_proprio%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ds_campo_filtro_p text, ds_tabela_p text, ds_restricao_filtro_p text, valor_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;
