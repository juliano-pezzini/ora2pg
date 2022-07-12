-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_conv_xml_cta_pck.processa_reg_conv_tab_tiss (cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


ds_campos_w		varchar(500);
ds_restricao_w		varchar(3500);
ds_select_w		varchar(4000);
cursor_w		sql_pck.t_cursor;
bind_sql_valor_w	sql_pck.t_dado_bind;
tb_nr_seq_item_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_regra_w	pls_util_cta_pck.t_number_table;
tb_ie_tipo_tabela_w	pls_util_cta_pck.t_varchar2_table_10;
tb_ie_tipo_desp_tiss_w	pls_util_cta_pck.t_varchar2_table_10;

C01 CURSOR(cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type) FOR
	SELECT	a.nr_sequencia nr_seq_regra,
		a.dt_inicio_vigencia,
		a.dt_fim_vigencia,
		a.ie_tipo_tabela_imp,
		a.ie_tipo_despesa_tiss,
		a.cd_material_orig_inicial,
		a.cd_material_orig_final,
		a.nr_seq_material,
		a.ie_tipo_despesa_mat,
		a.nr_seq_tipo_prestador,
		a.nr_seq_grupo_prestador,
		a.nr_seq_prestador,
		a.ie_tipo_tabela,
		a.ie_tipo_despesa_tiss_conv,
		a.nr_seq_grupo_rec,
		a.cd_area_procedimento,
		a.cd_especialidade,
		a.cd_grupo_proc,
		a.cd_procedimento,
		a.nr_seq_estrutura_mat,
		a.nr_seq_grupo_material
	from	pls_regra_conv_tab_tmp b,
		pls_conversao_tabela_tiss a
	where	a.nr_sequencia = b.nr_seq_regra
	and	a.cd_estabelecimento = cd_estabelecimento_pc
	order by
		coalesce(a.nr_ordem_exec_regra, 9999999999),
		a.nr_sequencia;
		
BEGIN





-- faz o select do item, da regra e dos campos ent_o, restringe pelo campo da regra

-- para caso j_ tenha entrado em alguma regra n_o processe novamente para respeitar (nr_seq_regra is null

-- a ordenacao definida pelo usu_rio

ds_campos_w := 	' select a.nr_sequencia nr_seq_item, '|| pls_util_pck.enter_w ||
			' :nr_seq_regra nr_seq_regra_conv, '|| pls_util_pck.enter_w ||
			' :ie_tipo_tabela cd_tipo_tabela_conv, '|| pls_util_pck.enter_w ||
			' nvl(:ie_tipo_despesa_tiss_conv, a.ie_tipo_despesa_conv) ie_tipo_despesa_conv '|| pls_util_pck.enter_w ||
		' from pls_conta_item_imp_tmp a ' || pls_util_pck.enter_w ||
		' where decode(a.nr_seq_regra, null, -1, -2) = -1 ' || pls_util_pck.enter_w;
	
for r_c01_w in C01(cd_estabelecimento_p) loop
	-- limpa os dados da bind

	bind_sql_valor_w.delete;
	ds_restricao_w := '';
	ds_select_w := '';
	
	bind_sql_valor_w := sql_pck.bind_variable(':nr_seq_regra', r_c01_w.nr_seq_regra, bind_sql_valor_w);
	-- atribui os valores do ent_o da regra para retornar no select

	bind_sql_valor_w := sql_pck.bind_variable(':ie_tipo_tabela', r_c01_w.ie_tipo_tabela, bind_sql_valor_w);
	bind_sql_valor_w := sql_pck.bind_variable(':ie_tipo_despesa_tiss_conv', r_c01_w.ie_tipo_despesa_tiss_conv, bind_sql_valor_w);

	-- monta a restricao de acordo com os dados da regra que esta sendo processada

	bind_sql_valor_w := pls_conv_xml_cta_pck.obter_restricao_regra_tab_tiss(	'a', r_c01_w.dt_inicio_vigencia, r_c01_w.dt_fim_vigencia, r_c01_w.ie_tipo_tabela_imp, r_c01_w.ie_tipo_despesa_tiss, r_c01_w.cd_material_orig_inicial, r_c01_w.cd_material_orig_final, r_c01_w.nr_seq_material, r_c01_w.ie_tipo_despesa_mat, r_c01_w.nr_seq_prestador, r_c01_w.nr_seq_tipo_prestador, r_c01_w.nr_seq_grupo_prestador, r_c01_w.nr_seq_grupo_rec, r_c01_w.cd_area_procedimento, r_c01_w.cd_especialidade, r_c01_w.cd_grupo_proc, r_c01_w.cd_procedimento, r_c01_w.nr_seq_estrutura_mat, r_c01_w.nr_seq_grupo_material, bind_sql_valor_w);

	-- monta o select

	ds_select_w := ds_campos_w || ds_restricao_w;

	bind_sql_valor_w := sql_pck.executa_sql_cursor(ds_select_w, bind_sql_valor_w);
	
	-- pega tudo que retornar e atribui o ent_o da regra

	loop
		fetch cursor_w bulk collect into tb_nr_seq_item_w, tb_nr_seq_regra_w,
						tb_ie_tipo_tabela_w, tb_ie_tipo_desp_tiss_w
		limit pls_util_pck.qt_registro_transacao_w;
		exit when tb_nr_seq_item_w.count = 0;

		
		forall i in tb_nr_seq_item_w.first..tb_nr_seq_item_w.last
			update 	pls_conta_item_imp_tmp
			set     nr_seq_regra = tb_nr_seq_regra_w(i),
				cd_tipo_tabela_conv = tb_ie_tipo_tabela_w(i),
				ie_tipo_despesa_conv = tb_ie_tipo_desp_tiss_w(i)
			where  	nr_sequencia = tb_nr_seq_item_w(i);
		commit;	
	end loop;
	close cursor_w;

end loop; -- C01

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_conv_xml_cta_pck.processa_reg_conv_tab_tiss (cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
