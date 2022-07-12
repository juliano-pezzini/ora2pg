-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pos_estabelecido_pck.insere_mat_tab_temp ( rec_dados_mat_p INOUT table_conta_mat_temp, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN
	if (rec_dados_mat_p.cd_estabelecimento.count > 0) then

		forall i in rec_dados_mat_p.cd_estabelecimento.first..rec_dados_mat_p.cd_estabelecimento.last
			insert into w_pls_conta_pos_mat(cd_estabelecimento, cd_ref_fabricante, cd_ref_material_fab_opme,
				det_reg_anvisa_opme, dt_item, nr_registro_anvisa,
				nr_seq_cabecalho, nr_seq_conta, nr_seq_conta_mat,        
				nr_seq_material, nr_seq_pos_estab_interc, nr_seq_regra_pos_estab,  
				nr_sequencia, qt_item, qt_original,             
				tx_administracao, vl_administracao, vl_liberado_material_fat,
				vl_lib_taxa_material, vl_materiais, vl_materiais_calc,       
				vl_material_tab, vl_taxa_material, ie_tipo_despesa,
				nr_seq_congenere_seg, nr_seq_segurado, nr_seq_intercambio, 
				nr_seq_plano, nr_seq_grupo_coop, ie_tipo_segurado, 
				ie_pcmso, ie_obito, dt_postagem_fatura, 
				dt_recebimento_fatura, nr_seq_fatura,	ie_origem_conta, 
				ie_tipo_conta, ie_tipo_guia, dt_alta, 
				dt_atendimento, ie_tipo_intercambio, vl_prestador_apresentado, 
				vl_prestador_pag, dt_mes_competencia, ie_status,
				cd_senha_externa, cd_guia, nr_seq_clinica, 		
				nr_seq_tipo_acomodacao, ie_carater_internacao, nr_seq_prestador_prot,	
				nr_seq_protocolo, nr_seq_tipo_atendimento, nr_seq_sca, 
				nr_seq_ajuste_fat, nr_seq_mat_princ, nr_seq_contrato
				)
			values ( rec_dados_mat_p.cd_estabelecimento(i), rec_dados_mat_p.cd_ref_fabricante(i), null,
				null, rec_dados_mat_p.dt_item(i), rec_dados_mat_p.nr_registro_anvisa(i),
				rec_dados_mat_p.nr_seq_cabecalho(i), rec_dados_mat_p.nr_seq_conta(i), rec_dados_mat_p.nr_seq_conta_mat(i),        
				rec_dados_mat_p.nr_seq_material(i), null, null,  
				rec_dados_mat_p.nr_sequencia(i), rec_dados_mat_p.qt_item(i), rec_dados_mat_p.qt_original(i),             
				0, 0, 0,
				rec_dados_mat_p.vl_lib_taxa_material(i), 0, rec_dados_mat_p.vl_materiais_calc(i),       
				0, rec_dados_mat_p.vl_taxa_material(i), rec_dados_mat_p.ie_tipo_despesa(i), 
				rec_dados_mat_p.nr_seq_congenere_seg(i), rec_dados_mat_p.nr_seq_segurado(i), rec_dados_mat_p.nr_seq_intercambio(i), 
				rec_dados_mat_p.nr_seq_plano(i), rec_dados_mat_p.nr_seq_grupo_coop(i), rec_dados_mat_p.ie_tipo_segurado(i), 
				rec_dados_mat_p.ie_pcmso(i), rec_dados_mat_p.ie_obito(i), rec_dados_mat_p.dt_postagem_fatura(i), 
				rec_dados_mat_p.dt_recebimento_fatura(i), rec_dados_mat_p.nr_seq_fatura(i), rec_dados_mat_p.ie_origem_conta(i),	
				rec_dados_mat_p.ie_tipo_conta(i), rec_dados_mat_p.ie_tipo_guia(i), rec_dados_mat_p.dt_alta(i),	
				rec_dados_mat_p.dt_atendimento(i), rec_dados_mat_p.ie_tipo_intercambio(i), rec_dados_mat_p.vl_prestador_apresentado(i),
				rec_dados_mat_p.vl_prestador_pag(i), rec_dados_mat_p.dt_mes_competencia(i), rec_dados_mat_p.ie_status(i),
				rec_dados_mat_p.cd_senha_externa(i), rec_dados_mat_p.cd_guia(i), rec_dados_mat_p.nr_seq_clinica(i), 		
				rec_dados_mat_p.nr_seq_tipo_acomodacao(i), rec_dados_mat_p.ie_carater_internacao(i), rec_dados_mat_p.nr_seq_prestador_prot(i),
				rec_dados_mat_p.nr_seq_protocolo(i), rec_dados_mat_p.nr_seq_tipo_atendimento(i), rec_dados_mat_p.nr_seq_sca(i),
				rec_dados_mat_p.nr_seq_ajuste_fat(i), rec_dados_mat_p.nr_seq_mat_princ(i), rec_dados_mat_p.nr_seq_contrato(i)
				);
		
	end if;
	rec_dados_mat_p.nr_sequencia.delete;
	rec_dados_mat_p.cd_estabelecimento.delete;
	rec_dados_mat_p.cd_ref_fabricante.delete;
	rec_dados_mat_p.dt_item.delete;
	rec_dados_mat_p.nr_registro_anvisa.delete;
	rec_dados_mat_p.nr_seq_conta.delete;
	rec_dados_mat_p.nr_seq_conta_mat.delete;
	rec_dados_mat_p.nr_seq_material.delete;
	rec_dados_mat_p.qt_item.delete;
	rec_dados_mat_p.qt_original.delete;
	rec_dados_mat_p.vl_lib_taxa_material.delete;
	rec_dados_mat_p.vl_taxa_material.delete;
	rec_dados_mat_p.ie_tipo_despesa.delete;
	rec_dados_mat_p.nr_seq_congenere_seg.delete;
	rec_dados_mat_p.nr_seq_segurado.delete;
	rec_dados_mat_p.nr_seq_intercambio.delete;
	rec_dados_mat_p.nr_seq_plano.delete;
	rec_dados_mat_p.nr_seq_grupo_coop.delete;
	rec_dados_mat_p.ie_tipo_segurado.delete;
	rec_dados_mat_p.ie_pcmso.delete;
	rec_dados_mat_p.ie_obito.delete;
	rec_dados_mat_p.dt_postagem_fatura.delete;
	rec_dados_mat_p.dt_recebimento_fatura.delete;
	rec_dados_mat_p.nr_seq_fatura.delete;
	rec_dados_mat_p.ie_origem_conta.delete;
	rec_dados_mat_p.ie_tipo_conta.delete;
	rec_dados_mat_p.ie_tipo_guia.delete;
	rec_dados_mat_p.dt_alta.delete;
	rec_dados_mat_p.dt_atendimento.delete;
	rec_dados_mat_p.ie_tipo_intercambio.delete;
	rec_dados_mat_p.vl_prestador_apresentado.delete;
	rec_dados_mat_p.vl_prestador_pag.delete;
	rec_dados_mat_p.dt_mes_competencia.delete;
	rec_dados_mat_p.ie_status.delete;
	rec_dados_mat_p.cd_senha_externa.delete;
	rec_dados_mat_p.cd_guia.delete;
	rec_dados_mat_p.nr_seq_clinica.delete;
	rec_dados_mat_p.nr_seq_tipo_acomodacao.delete;
	rec_dados_mat_p.ie_carater_internacao.delete;
	rec_dados_mat_p.nr_seq_prestador_prot.delete;
	rec_dados_mat_p.nr_seq_protocolo.delete;
	rec_dados_mat_p.nr_seq_tipo_atendimento.delete;
	rec_dados_mat_p.nr_seq_cabecalho.delete;
	rec_dados_mat_p.nr_seq_sca.delete;
	rec_dados_mat_p.nr_seq_mat_princ.delete;
	rec_dados_mat_p.nr_seq_contrato.delete;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pos_estabelecido_pck.insere_mat_tab_temp ( rec_dados_mat_p INOUT table_conta_mat_temp, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
