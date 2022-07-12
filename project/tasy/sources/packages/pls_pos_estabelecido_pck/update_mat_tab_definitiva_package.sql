-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Faz atualizacao de registros j_ existentes na pls_conta_pos_mat



CREATE OR REPLACE PROCEDURE pls_pos_estabelecido_pck.update_mat_tab_definitiva ( result_cursor_p INOUT table_dados_mat_persistir, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
BEGIN

		--Se tiver registros nas estruturas, ent_o prossegue com o update.

	if ( result_cursor_p.cd_ref_fabricante.count > 0) then
		
		forall i in result_cursor_p.cd_ref_fabricante.first..result_cursor_p.cd_ref_fabricante.last
			
			update	pls_conta_pos_mat
			set 	nm_usuario			= nm_usuario_p,
				dt_atualizacao			= clock_timestamp(),
				cd_ref_fabricante		= result_cursor_p.cd_ref_fabricante(i), 
				cd_ref_material_fab_opme	= result_cursor_p.cd_ref_material_fab_opme(i), 
				det_reg_anvisa_opme		= result_cursor_p.det_reg_anvisa_opme(i),	
				dt_item				= result_cursor_p.dt_item(i), 
				nr_registro_anvisa		= result_cursor_p.nr_registro_anvisa(i),	 
				nr_seq_analise			 = NULL,		
				nr_seq_cabecalho		= result_cursor_p.nr_seq_cabecalho(i), 
				nr_seq_conta			= result_cursor_p.nr_seq_conta(i), 
				nr_seq_conta_mat		= result_cursor_p.nr_seq_conta_mat(i),	
				nr_seq_lote_fat			 = NULL, 
				nr_seq_material			= result_cursor_p.nr_seq_material(i), 
				nr_seq_pos_estab_interc		= result_cursor_p.nr_seq_pos_estab_interc(i),	
				nr_seq_regra_pos_estab		= result_cursor_p.nr_seq_regra_pos_estab(i), 
				qt_item				= result_cursor_p.qt_item(i), 
				qt_original			= result_cursor_p.qt_original(i),		
				tx_administracao		= result_cursor_p.tx_administracao(i), 
				vl_administracao		= result_cursor_p.vl_administracao(i), 
				vl_glosa_material_fat		 = NULL,	
				vl_liberado_material_fat	= result_cursor_p.vl_liberado_material_fat(i), 
				vl_lib_taxa_material		= result_cursor_p.vl_lib_taxa_material(i), 
				vl_materiais			= result_cursor_p.vl_materiais(i), 		
				vl_materiais_calc		= result_cursor_p.vl_materiais_calc(i), 
				vl_material_tab			= result_cursor_p.vl_material_tab(i), 
				vl_provisao			= CASE WHEN  	result_cursor_p.ie_atualiza_prov(i)='S' THEN result_cursor_p.vl_provisao(i)  ELSE result_cursor_p.vl_provisao_old(i) END , 
				vl_taxa_material		= result_cursor_p.vl_taxa_material(i),	 
				nr_seq_regra_conv		= result_cursor_p.nr_seq_regra_conv(i),
				ds_item_convertido		= result_cursor_p.ds_item_convertido(i), 
				cd_item_convertido		= result_cursor_p.cd_item_convertido(i)	,
				ie_origem_conta			= result_cursor_p.ie_origem_conta(i)	
			where	nr_seq_conta_mat 		= result_cursor_p.nr_seq_conta_mat(i);
			
	end if;
	result_cursor_p.cd_ref_fabricante.delete;
	result_cursor_p.cd_ref_material_fab_opme.delete;
	result_cursor_p.det_reg_anvisa_opme.delete;
	result_cursor_p.dt_item.delete;
	result_cursor_p.nr_registro_anvisa.delete;
	result_cursor_p.nr_seq_cabecalho.delete;
	result_cursor_p.nr_seq_conta.delete;
	result_cursor_p.nr_seq_conta_mat.delete;
	result_cursor_p.nr_seq_material.delete;
	result_cursor_p.nr_seq_pos_estab_interc.delete;
	result_cursor_p.nr_seq_regra_pos_estab.delete;
	result_cursor_p.qt_item.delete;
	result_cursor_p.qt_original.delete;
	result_cursor_p.tx_administracao.delete;
	result_cursor_p.vl_administracao.delete;
	result_cursor_p.vl_liberado_material_fat.delete;
	result_cursor_p.vl_lib_taxa_material.delete;
	result_cursor_p.vl_materiais.delete;
	result_cursor_p.vl_materiais_calc.delete;
	result_cursor_p.vl_material_tab.delete;
	result_cursor_p.vl_taxa_material.delete;
	result_cursor_p.nr_seq_regra_conv.delete;
	result_cursor_p.ds_item_convertido.delete;
	result_cursor_p.cd_item_convertido.delete;
	result_cursor_p.nr_seq_conta_mat.delete;
	result_cursor_p.ie_origem_conta.delete;
	result_cursor_p.vl_provisao.delete;
	result_cursor_p.vl_provisao_old.delete;
	result_cursor_p.ie_atualiza_prov.delete;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pos_estabelecido_pck.update_mat_tab_definitiva ( result_cursor_p INOUT table_dados_mat_persistir, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;