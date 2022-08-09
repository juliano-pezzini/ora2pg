-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_copia_preco_reembolso ( nr_seq_prest_origem_p bigint, dt_inicio_vigencia_p timestamp, nm_tabela_p text, ie_excluir_p text, nm_usuario_p text, ie_inseriu_nova_regra_p INOUT text) AS $body$
DECLARE

				
nr_seq_nova_regra_w	pls_regra_preco_proc.nr_sequencia%type;
qt_regras_w		integer;


BEGIN

ie_inseriu_nova_regra_p := 'N';
qt_regras_w	:= 0;

/* PLS_REGRA_PRECO_PROC */

if (nm_tabela_p	= 'PLS_REGRA_PRECO_PROC') then
	
	--Somente exclui as regras existentes, caso  o select retornar informacoes e inserir nova regra
	if	(ie_excluir_p = 'S' AND qt_regras_w IS NOT NULL AND qt_regras_w::text <> '') then
		delete	from pls_regra_preco_proc
		where 	ie_tipo_tabela = 'R';
	end if;
	
	insert into pls_regra_preco_proc( nr_sequencia, dt_atualizacao, nm_usuario,
		dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_prestador,               
		nr_seq_plano, nr_seq_categoria, nr_seq_clinica, 
		nr_seq_tipo_acomodacao, nr_seq_tipo_atendimento, cd_edicao_amb,                  
		cd_procedimento, ie_origem_proced, cd_area_procedimento, 
		cd_especialidade, cd_grupo_proc, tx_ajuste_geral,                
		vl_ch_honorarios, vl_ch_custo_oper, vl_filme, 
		tx_ajuste_custo_oper, tx_ajuste_partic, vl_proc_negociado,              
		ie_situacao, dt_inicio_vigencia, cd_estabelecimento, 
		dt_fim_vigencia, tx_ajuste_filme, tx_ajuste_ch_honor,             
		ie_tipo_tabela, vl_medico, vl_auxiliares, 
		vl_anestesista, vl_custo_operacional, vl_materiais, 
		ie_preco_informado, nr_seq_outorgante, nr_seq_contrato, 
		ie_preco, nr_seq_congenere, cd_convenio, 
		cd_categoria, ie_tipo_contratacao, qt_dias_inter_inicio, 
		qt_dias_inter_final, nr_seq_regra_ant, cd_moeda_ch_medico, 
		cd_moeda_ch_co, ie_tipo_vinculo, nr_seq_classificacao, 
		ie_tipo_segurado, ds_observacao, nr_seq_grupo_contrato, 
		nr_seq_grupo_servico, nr_seq_grupo_prestador, nr_seq_grupo_produto, 
		cd_moeda_filme, cd_moeda_anestesista, ie_cooperado,                   
		nr_seq_tipo_prestador, ie_internado, nr_seq_cbhpm_edicao, 
		ie_tecnica_utilizada, ie_tipo_guia, nr_seq_tipo_acomod_prod,        
		ie_acomodacao, ie_tipo_intercambio, ie_franquia, 
		nr_seq_grupo_rec, sg_uf_operadora_intercambio, nr_seq_setor_atend,             
		nr_seq_cbo_saude,nr_seq_ops_congenere,ie_tipo_contrato,
		ie_tipo_consulta, nr_seq_grupo_med_exec, ie_gerar_remido, 
		ie_regime_atendimento, ie_regime_atendimento_princ, ie_saude_ocupacional)
	SELECT	nextval('pls_regra_preco_proc_seq'), clock_timestamp(), nm_usuario_p, 
		clock_timestamp(), nm_usuario_p, nr_seq_prestador,
		nr_seq_plano, nr_seq_categoria, nr_seq_clinica, 
		nr_seq_tipo_acomodacao, nr_seq_tipo_atendimento, cd_edicao_amb,
		cd_procedimento, ie_origem_proced, cd_area_procedimento, 
		cd_especialidade, cd_grupo_proc, tx_ajuste_geral,
		vl_ch_honorarios, vl_ch_custo_oper, vl_filme, 
		tx_ajuste_custo_oper, tx_ajuste_partic, vl_proc_negociado,
		ie_situacao, dt_inicio_vigencia, cd_estabelecimento, 
		dt_fim_vigencia, tx_ajuste_filme, tx_ajuste_ch_honor,
		'R', vl_medico, vl_auxiliares, 
		vl_anestesista, vl_custo_operacional, vl_materiais, 
		ie_preco_informado, nr_seq_outorgante, nr_seq_contrato, 
		ie_preco, nr_seq_congenere, cd_convenio, 
		cd_categoria, ie_tipo_contratacao, qt_dias_inter_inicio, 
		qt_dias_inter_final, nr_seq_regra_ant, cd_moeda_ch_medico, 
		cd_moeda_ch_co, ie_tipo_vinculo, nr_seq_classificacao, 
		ie_tipo_segurado, ds_observacao, nr_seq_grupo_contrato, 
		nr_seq_grupo_servico, nr_seq_grupo_prestador, nr_seq_grupo_produto, 
		cd_moeda_filme, cd_moeda_anestesista, ie_cooperado,                   
		nr_seq_tipo_prestador, ie_internado, nr_seq_cbhpm_edicao, 
		ie_tecnica_utilizada, ie_tipo_guia, nr_seq_tipo_acomod_prod,        
		ie_acomodacao, ie_tipo_intercambio, ie_franquia, 
		nr_seq_grupo_rec , sg_uf_operadora_intercambio, nr_seq_setor_atend,             
		nr_seq_cbo_saude,nr_seq_ops_congenere,ie_tipo_contrato,
		ie_tipo_consulta, nr_seq_grupo_med_exec, ie_gerar_remido,
		ie_regime_atendimento, ie_regime_atendimento_princ, ie_saude_ocupacional
	from	pls_regra_preco_proc
	where	nr_seq_prestador	= nr_seq_prest_origem_p
	and	trunc(dt_inicio_vigencia,'dd')	>= dt_inicio_vigencia_p;
	
	select  count(1)
	into STRICT	qt_regras_w
	from	pls_regra_preco_proc
	where	nr_seq_prestador	= nr_seq_prest_origem_p
	and	trunc(dt_inicio_vigencia,'dd')	>= dt_inicio_vigencia_p;
	
end if;

/* PLS_REGRA_PRECO_MAT */

if (nm_tabela_p	= 'PLS_REGRA_PRECO_MAT') then
	
	select	count(1)
	into STRICT	qt_regras_w
	from	pls_regra_preco_mat
	where	nr_seq_prestador	= nr_seq_prest_origem_p
	and	trunc(dt_inicio_vigencia,'dd')	>= dt_inicio_vigencia_p;
	
	
	--Somente exclui as regras existentes, caso  o select retornar informacoes e inserir nova regra
	if	( ie_excluir_p = 'S'  AND qt_regras_w IS NOT NULL AND qt_regras_w::text <> '') then
		delete	from pls_regra_preco_mat
		where 	ie_tipo_tabela = 'R';
	end if;
	
	insert into pls_regra_preco_mat(nr_sequencia, cd_estabelecimento, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		nr_seq_prestador, dt_inicio_vigencia, dt_fim_vigencia, 
		tx_ajuste, ie_situacao, vl_negociado, 
		tx_ajuste_pfb, tx_ajuste_pmc_neut, tx_ajuste_pmc_pos, 
		tx_ajuste_pmc_neg, tx_ajuste_simpro_pfb, tx_ajuste_simpro_pmc, 
		ie_origem_preco, ie_tipo_despesa, nr_seq_material_preco, 
		tx_ajuste_tab_propria, ie_tipo_tabela, nr_seq_outorgante, 
		nr_seq_contrato, tx_ajuste_benef_lib, nr_seq_congenere, 
		nr_seq_regra_ant, ds_observacao, nr_seq_plano, 
		ie_tipo_vinculo, nr_seq_classificacao, nr_seq_grupo_prestador,         
		ie_tipo_contratacao, ie_preco, ie_tipo_segurado,
		nr_seq_grupo_contrato, nr_seq_grupo_produto, nr_seq_material, 
		nr_seq_estrutura_mat, ie_tabela_adicional, cd_material, 
		sg_uf_operadora_intercambio, ie_tipo_intercambio, cd_convenio, 
		cd_categoria, nr_seq_categoria, nr_seq_tipo_acomodacao,         
		nr_seq_tipo_atendimento, nr_seq_clinica, nr_seq_tipo_prestador, 
		ie_tipo_guia, dt_base_fixo, ie_generico_unimed, 
		nr_seq_grupo_uf, nr_seq_tipo_uso, ie_mat_autorizacao_esp,
		qt_idade_inicial, qt_idade_final, ie_gerar_remido,
		ie_regime_atendimento, ie_regime_atendimento_princ, ie_saude_ocupacional)
	SELECT	nextval('pls_regra_preco_mat_seq'), cd_estabelecimento, clock_timestamp(), 
		nm_usuario_p, clock_timestamp(), nm_usuario_p, 
		nr_seq_prestador, dt_inicio_vigencia, dt_fim_vigencia, 
		tx_ajuste, ie_situacao, vl_negociado,
		tx_ajuste_pfb, tx_ajuste_pmc_neut, tx_ajuste_pmc_pos, 
		tx_ajuste_pmc_neg, tx_ajuste_simpro_pfb, tx_ajuste_simpro_pmc, 
		ie_origem_preco, ie_tipo_despesa, nr_seq_material_preco, 
		tx_ajuste_tab_propria, 'R', nr_seq_outorgante, 
		nr_seq_contrato, tx_ajuste_benef_lib, nr_seq_congenere, 
		nr_seq_regra_ant, ds_observacao, nr_seq_plano, 
		ie_tipo_vinculo, nr_seq_classificacao, nr_seq_grupo_prestador,         
		ie_tipo_contratacao, ie_preco, ie_tipo_segurado, 
		nr_seq_grupo_contrato, nr_seq_grupo_produto, nr_seq_material, 
		nr_seq_estrutura_mat, ie_tabela_adicional, cd_material, 
		sg_uf_operadora_intercambio, ie_tipo_intercambio, cd_convenio, 
		cd_categoria, nr_seq_categoria, nr_seq_tipo_acomodacao,         
		nr_seq_tipo_atendimento, nr_seq_clinica, nr_seq_tipo_prestador, 
		ie_tipo_guia, dt_base_fixo, ie_generico_unimed, 
		nr_seq_grupo_uf, nr_seq_tipo_uso, ie_mat_autorizacao_esp,
		qt_idade_inicial, qt_idade_final, ie_gerar_remido,
		ie_regime_atendimento, ie_regime_atendimento_princ, ie_saude_ocupacional
	from	pls_regra_preco_mat
	where	nr_seq_prestador	= nr_seq_prest_origem_p
	and	trunc(dt_inicio_vigencia,'dd')	>= dt_inicio_vigencia_p;
		
end if;

/* PLS_REGRA_PRECO_SERVICO */

if (nm_tabela_p	= 'PLS_REGRA_PRECO_SERVICO') then
	
	select count(1)
	into STRICT	qt_regras_w
	from	pls_regra_preco_servico
	where	nr_seq_prestador	= nr_seq_prest_origem_p
	and	trunc(dt_inicio_vigencia,'dd')	>= dt_inicio_vigencia_p;
			
	--Somente exclui as regras existentes, caso  o select retornar informacoes e inserir nova regra
	if	(ie_excluir_p = 'S' AND qt_regras_w IS NOT NULL AND qt_regras_w::text <> '') then
		delete	from pls_regra_preco_servico
		where 	ie_tipo_tabela = 'R';
	end if;
	
	insert into pls_regra_preco_servico(nr_sequencia, cd_estabelecimento, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		nr_seq_prestador, dt_inicio_vigencia, dt_fim_vigencia, 
		cd_tabela_servico, tx_ajuste, cd_procedimento,
		ie_origem_proced, ie_situacao, cd_area_procedimento, 
		cd_especialidade, cd_grupo_proc, vl_negociado,
		ie_tipo_tabela, nr_seq_outorgante, nr_seq_contrato, 
		nr_seq_congenere, nr_seq_regra_ant, ds_observacao,          
		ie_preco, ie_tipo_contratacao, nr_seq_plano, 
		ie_tipo_vinculo, nr_seq_grupo_produto, nr_seq_grupo_contrato,  
		ie_internado, nr_seq_categoria, nr_seq_classificacao, 
		nr_seq_grupo_prestador, ie_tipo_segurado, nr_seq_grupo_servico,
		qt_idade_inicial, qt_idade_final, ie_gerar_remido,
		ie_regime_atendimento, ie_regime_atendimento_princ, ie_saude_ocupacional,
		nr_seq_tipo_atendimento)
	SELECT	nextval('pls_regra_preco_servico_seq'), cd_estabelecimento, clock_timestamp(), 
		nm_usuario_p, clock_timestamp(), nm_usuario_p, 
		nr_seq_prestador, dt_inicio_vigencia, dt_fim_vigencia, 
		cd_tabela_servico, tx_ajuste, cd_procedimento,
		ie_origem_proced, ie_situacao, cd_area_procedimento, 
		cd_especialidade, cd_grupo_proc, vl_negociado,
		'R', nr_seq_outorgante, nr_seq_contrato, 
		nr_seq_congenere, nr_seq_regra_ant, ds_observacao,          
		ie_preco, ie_tipo_contratacao, nr_seq_plano, 
		ie_tipo_vinculo, nr_seq_grupo_produto, nr_seq_grupo_contrato,  
		ie_internado, nr_seq_categoria, nr_seq_classificacao, 
		nr_seq_grupo_prestador, ie_tipo_segurado, nr_seq_grupo_servico,
		qt_idade_inicial, qt_idade_final, ie_gerar_remido,
		ie_regime_atendimento, ie_regime_atendimento_princ, ie_saude_ocupacional,
		nr_seq_tipo_atendimento
	from	pls_regra_preco_servico
	where	nr_seq_prestador	= nr_seq_prest_origem_p
	and	trunc(dt_inicio_vigencia,'dd')	>= dt_inicio_vigencia_p;
		
end if;

if (qt_regras_w > 0 ) then
	ie_inseriu_nova_regra_p := 'S';
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_copia_preco_reembolso ( nr_seq_prest_origem_p bigint, dt_inicio_vigencia_p timestamp, nm_tabela_p text, ie_excluir_p text, nm_usuario_p text, ie_inseriu_nova_regra_p INOUT text) FROM PUBLIC;
