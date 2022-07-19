-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_duplicar_regra_preco ( nr_seq_regra_p bigint, dt_inicio_p timestamp, ie_tipo_regra_p text, nm_usuario_p text, ie_checado_p text, ie_excecao_p text) AS $body$
DECLARE


/*
Opcoes
P  - Procedimento
M - Material
S - Servico 
*/
dt_inicio_w		timestamp;
nr_seq_regra_proc_w	pls_regra_preco_proc.nr_sequencia%type;					
nr_seq_regra_mat_w	pls_regra_preco_mat.nr_sequencia%type;	
nr_seq_regra_serv_w	pls_regra_preco_servico.nr_sequencia%type;			

	

BEGIN
dt_inicio_w := dt_inicio_p;


if (ie_tipo_regra_p = 'P') then
	begin

	select nextval('pls_regra_preco_proc_seq')
	into STRICT nr_seq_regra_proc_w
	;
	
	if (ie_checado_p = 'N') then
		select dt_inicio_vigencia
		into STRICT	dt_inicio_w
		from	pls_regra_preco_proc
		where	nr_sequencia = nr_seq_regra_p;
	end if;
	
	insert into pls_regra_preco_proc(nr_sequencia,
		dt_atualizacao,                 
		nm_usuario,                     
		dt_atualizacao_nrec,            
		nm_usuario_nrec,                
		nr_seq_prestador,               
		nr_seq_plano,                   
		nr_seq_categoria,               
		nr_seq_clinica,                 
		nr_seq_tipo_acomodacao,
		nr_seq_tipo_atendimento,        
		cd_edicao_amb,       
		cd_procedimento,                
		ie_origem_proced,               
		cd_area_procedimento,           
		cd_especialidade,               
		cd_grupo_proc,                  
		tx_ajuste_geral,                
		vl_ch_honorarios,               
		vl_ch_custo_oper,              
		vl_filme,                       
		tx_ajuste_custo_oper,
		tx_ajuste_partic,          
		vl_proc_negociado,              
		ie_situacao,             
		dt_inicio_vigencia,
		cd_estabelecimento,            
		dt_fim_vigencia,            
		tx_ajuste_filme,               
		tx_ajuste_ch_honor,
		ie_tipo_tabela,
		vl_medico,                
		vl_auxiliares,
		vl_anestesista,                 
		vl_custo_operacional,
		vl_materiais,          
		ie_preco_informado,
		nr_seq_outorgante,
		nr_seq_contrato,             
		ie_preco,               
		nr_seq_congenere,
		cd_convenio,              
		cd_categoria,                   
		ie_tipo_contratacao,
		qt_dias_inter_inicio,           
		qt_dias_inter_final,          
		nr_seq_regra_ant,           
		cd_moeda_ch_medico,
		cd_moeda_ch_co,            
		ie_tipo_vinculo,                
		nr_seq_classificacao,
		ie_tipo_segurado,          
		ds_observacao,              
		nr_seq_grupo_contrato,
		nr_seq_grupo_servico,         
		nr_seq_grupo_prestador,
		nr_seq_grupo_produto,        
		cd_moeda_filme,          
		cd_moeda_anestesista,
		ie_cooperado,          
		nr_seq_tipo_prestador,
		ie_internado,         
		nr_seq_cbhpm_edicao,
		ie_tecnica_utilizada,          
		ie_tipo_guia,          
		nr_seq_tipo_acomod_prod,
		ie_acomodacao,       
		ie_tipo_intercambio,
		ie_franquia,           
		nr_seq_grupo_rec,
		sg_uf_operadora_intercambio,
		nr_seq_setor_atend,   
		nr_seq_cbo_saude,            
		nr_seq_grupo_intercambio,
		nr_seq_intercambio,      
		cd_prestador,            
		ie_autogerado,                  
		nr_seq_congenere_prot,
		ie_carater_internacao,         
		nr_contrato,         
		ie_taxa_coleta,
		ie_origem_procedimento,
		nr_seq_ops_congenere,        
		ie_tipo_contrato,          
		ie_pcmso,              
		nr_seq_regra_proc_ref,
		ie_tipo_acomodacao_ptu,         
		qt_idade_inicial,        
		qt_idade_final,              
		cd_especialidade_prest,         
		ie_proc_tabela,                 
		ds_regra,                       
		nr_seq_rp_combinada,            
		ie_nao_gera_tx_inter,           
		ie_tipo_prestador,              
		nr_seq_categoria_plano,         
		cd_prestador_prot,              
		nr_seq_tipo_prestador_prot,     
		nr_seq_regra_atend_cart,        
		nr_seq_cp_combinada,           
		ie_tipo_consulta,               
		ie_ch_padrao_anestesista,       
		nr_seq_edicao_tuss,             
		ie_atend_pcmso,                 
		ie_origem_protocolo,            
		nr_seq_grupo_operadora,         
		ie_ref_guia_internacao,                   
		nr_seq_prest_inter,             
		cd_versao_tiss,                 
		cd_prestador_solic,             
		dt_inicio_vigencia_ref,         
		dt_fim_vigencia_ref,            
		ie_acomodacao_autorizada,       
		cd_medico,                      
		nr_seq_tipo_atend_princ,        
		ie_tipo_atendimento,            
		nr_seq_grupo_prest_int,         
		nr_seq_mot_reembolso,
		nr_seq_cbo_saude_solic,
		nr_seq_grupo_med_exec,
        ie_gerar_remido,
		ie_regime_atendimento_princ,
		ie_regime_atendimento,
		ie_saude_ocupacional)
	SELECT	nr_seq_regra_proc_w,
		clock_timestamp(),                 
		nm_usuario_p,                     
		clock_timestamp(),            
		nm_usuario_p,                
		nr_seq_prestador,               
		nr_seq_plano,                   
		nr_seq_categoria,               
		nr_seq_clinica,                 
		nr_seq_tipo_acomodacao,
		nr_seq_tipo_atendimento,        
		cd_edicao_amb,       
		cd_procedimento,                
		ie_origem_proced,               
		cd_area_procedimento,           
		cd_especialidade,               
		cd_grupo_proc,                  
		tx_ajuste_geral,                
		vl_ch_honorarios,               
		vl_ch_custo_oper,              
		vl_filme,                       
		tx_ajuste_custo_oper,
		tx_ajuste_partic,          
		vl_proc_negociado,              
		ie_situacao,             
		dt_inicio_w,
		cd_estabelecimento,            
		dt_fim_vigencia,            
		tx_ajuste_filme,               
		tx_ajuste_ch_honor,
		ie_tipo_tabela,
		vl_medico,                
		vl_auxiliares,
		vl_anestesista,                 
		vl_custo_operacional,
		vl_materiais,          
		ie_preco_informado,
		nr_seq_outorgante,
		nr_seq_contrato,             
		ie_preco,               
		nr_seq_congenere,
		cd_convenio,              
		cd_categoria,                   
		ie_tipo_contratacao,
		qt_dias_inter_inicio,           
		qt_dias_inter_final,          
		nr_seq_regra_ant,           
		cd_moeda_ch_medico,
		cd_moeda_ch_co,            
		ie_tipo_vinculo,                
		nr_seq_classificacao,
		ie_tipo_segurado,          
		ds_observacao,              
		nr_seq_grupo_contrato,
		nr_seq_grupo_servico,         
		nr_seq_grupo_prestador,
		nr_seq_grupo_produto,        
		cd_moeda_filme,          
		cd_moeda_anestesista,
		ie_cooperado,          
		nr_seq_tipo_prestador,
		ie_internado,         
		nr_seq_cbhpm_edicao,
		ie_tecnica_utilizada,          
		ie_tipo_guia,          
		nr_seq_tipo_acomod_prod,
		ie_acomodacao,       
		ie_tipo_intercambio,
		ie_franquia,           
		nr_seq_grupo_rec,
		sg_uf_operadora_intercambio,
		nr_seq_setor_atend,   
		nr_seq_cbo_saude,            
		nr_seq_grupo_intercambio,
		nr_seq_intercambio,      
		cd_prestador,            
		ie_autogerado,                  
		nr_seq_congenere_prot,
		ie_carater_internacao,         
		nr_contrato,         
		ie_taxa_coleta,
		ie_origem_procedimento,
		nr_seq_ops_congenere,        
		ie_tipo_contrato,          
		ie_pcmso,              
		nr_seq_regra_p,
		ie_tipo_acomodacao_ptu,         
		qt_idade_inicial,        
		qt_idade_final,              
		cd_especialidade_prest,         
		ie_proc_tabela,                 
		ds_regra,                       
		nr_seq_rp_combinada,            
		ie_nao_gera_tx_inter,           
		ie_tipo_prestador,              
		nr_seq_categoria_plano,         
		cd_prestador_prot,              
		nr_seq_tipo_prestador_prot,     
		nr_seq_regra_atend_cart,        
		nr_seq_cp_combinada,           
		ie_tipo_consulta,               
		ie_ch_padrao_anestesista,       
		nr_seq_edicao_tuss,             
		ie_atend_pcmso,                 
		ie_origem_protocolo,            
		nr_seq_grupo_operadora,         
		ie_ref_guia_internacao,                  
		nr_seq_prest_inter,             
		cd_versao_tiss,                 
		cd_prestador_solic,             
		dt_inicio_vigencia_ref,         
		dt_fim_vigencia_ref,            
		ie_acomodacao_autorizada,       
		cd_medico,                      
		nr_seq_tipo_atend_princ,        
		ie_tipo_atendimento,            
		nr_seq_grupo_prest_int,         
		nr_seq_mot_reembolso,
		nr_seq_cbo_saude_solic,
		nr_seq_grupo_med_exec,
        ie_gerar_remido,
		ie_regime_atendimento_princ,
		ie_regime_atendimento,
		ie_saude_ocupacional
	from	pls_regra_preco_proc
	where	nr_sequencia	= nr_seq_regra_p;
	
	if (ie_excecao_p = 'S')	then
		insert into pls_excecao_preco_proc(nr_sequencia,
			nr_seq_regra,
			ie_situacao,
			dt_inicio_vigencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_fim_vigencia,
			cd_procedimento,                
			ie_origem_proced,               
			nr_seq_prestador,               
			nr_seq_contrato,                
			ie_preco,                       
			ie_tipo_contratacao,            
			ie_tipo_segurado,               
			nr_seq_grupo_contrato,          
			nr_seq_grupo_servico,           
			nr_seq_grupo_prestador,         
			nr_seq_tipo_prestador,          
			nr_seq_grupo_intercambio,       
			nr_seq_classificacao,           
			nr_seq_congenere,               
			nr_seq_grupo_material,          
			nr_contrato,                    
			nr_seq_congenere_prot,          
			nr_seq_tipo_prestador_prot,
			ie_origem_protocolo,            
			ie_tipo_intercambio,            
			nr_seq_tipo_atend_princ,        
			nr_seq_grupo_rec,               
			ie_tipo_guia,                   
			nr_seq_grupo_operadora,
			ie_regime_atendimento,
			ie_saude_ocupacional			
			)
		SELECT	nextval('pls_excecao_preco_proc_seq'),
			nr_seq_regra_proc_w,
			ie_situacao,
			dt_inicio_vigencia,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			dt_fim_vigencia,                
			cd_procedimento,                
			ie_origem_proced,               
			nr_seq_prestador,               
			nr_seq_contrato,                
			ie_preco,                       
			ie_tipo_contratacao,            
			ie_tipo_segurado,               
			nr_seq_grupo_contrato,          
			nr_seq_grupo_servico,           
			nr_seq_grupo_prestador,         
			nr_seq_tipo_prestador,          
			nr_seq_grupo_intercambio,       
			nr_seq_classificacao,           
			nr_seq_congenere,               
			nr_seq_grupo_material,          
			nr_contrato,                    
			nr_seq_congenere_prot,          
			nr_seq_tipo_prestador_prot,
			ie_origem_protocolo,            
			ie_tipo_intercambio,            
			nr_seq_tipo_atend_princ,        
			nr_seq_grupo_rec,               
			ie_tipo_guia,                   
			nr_seq_grupo_operadora,			
			ie_regime_atendimento,
			ie_saude_ocupacional
		from	pls_excecao_preco_proc
		where	nr_seq_regra	= nr_seq_regra_p;
	end if;
end;
elsif (ie_tipo_regra_p = 'M') then

	select nextval('pls_regra_preco_mat_seq')
	into STRICT nr_seq_regra_mat_w
	;
	
	if (ie_checado_p = 'N') then
		select dt_inicio_vigencia
		into STRICT	dt_inicio_w
		from	pls_regra_preco_mat
		where	nr_sequencia = nr_seq_regra_p;
	end if;
	insert into pls_regra_preco_mat(nr_sequencia,
		cd_estabelecimento,             
		dt_atualizacao,                 
		nm_usuario,                     
		dt_atualizacao_nrec ,           
		nm_usuario_nrec,                
		nr_seq_prestador,               
		dt_inicio_vigencia,             
		dt_fim_vigencia,                
		tx_ajuste,                      
		ie_situacao,                    
		vl_negociado,                   
		tx_ajuste_pfb,                  
		tx_ajuste_pmc_neut,             
		tx_ajuste_pmc_pos,             
		tx_ajuste_pmc_neg,              
		tx_ajuste_simpro_pfb,           
		tx_ajuste_simpro_pmc,           
		ie_origem_preco,                
		ie_tipo_despesa,                
		nr_seq_material_preco,          
		tx_ajuste_tab_propria,          
		ie_tipo_tabela,                 
		nr_seq_outorgante,              
		nr_seq_contrato,                
		tx_ajuste_benef_lib,            
		nr_seq_congenere,               
		nr_seq_regra_ant,               
		ds_observacao,                  
		nr_seq_plano,                   
		ie_tipo_vinculo,                
		nr_seq_classificacao,           
		nr_seq_grupo_prestador,         
		ie_tipo_contratacao,            
		ie_preco,                       
		ie_tipo_segurado,               
		nr_seq_grupo_contrato,          
		nr_seq_grupo_produto,          
		nr_seq_material,                
		nr_seq_estrutura_mat,           
		ie_tabela_adicional ,           
		cd_material,                   
		sg_uf_operadora_intercambio,    
		ie_tipo_intercambio,            
		cd_convenio,                    
		cd_categoria,                   
		nr_seq_categoria,               
		nr_seq_tipo_acomodacao,         
		nr_seq_tipo_atendimento,        
		nr_seq_clinica,                 
		nr_seq_tipo_prestador,          
		ie_tipo_guia,                   
		dt_base_fixo,                   
		ie_generico_unimed ,            
		nr_seq_grupo_uf,                
		nr_seq_tipo_uso,                
		ie_mat_autorizacao_esp,         
		cd_prestador ,                  
		nr_seq_grupo_material,          
		ie_internado,                   
		nr_contrato,                    
		nr_seq_congenere_prot,          
		ie_pcmso,                       
		ie_tipo_preco_simpro ,          
		ie_tipo_preco_brasindice,       
		nr_seq_regra_mat_ref,           
		ie_tipo_acomodacao_ptu ,        
		nr_seq_grupo_operadora,         
		ie_tipo_ajuste_pfb,             
		vl_pfb_neutra_simpro,           
		vl_pfb_positiva_simpro,         
		vl_pfb_negativa_simpro,         
		vl_pfb_nao_aplicavel_simpro,    
		vl_pfb_neutra_brasindice,       
		vl_pfb_positiva_brasindice ,    
		vl_pfb_negativa_brasindice ,    
		nr_seq_intercambio ,            
		cd_especialidade_prest ,        
		ie_cooperado ,                  
		ds_regra ,                      
		ie_nao_gera_tx_inter,           
		ie_tipo_prestador ,             
		cd_prestador_prot,              
		nr_seq_tipo_prestador_prot,     
		nr_seq_regra_atend_cart,        
		nr_seq_cp_combinada,            
		ie_atend_pcmso ,                
		ie_origem_protocolo,            
		ie_ref_guia_internacao ,        
		nr_seq_prestador_inter,         
		ie_tipo_preco_tab_adic,         
		cd_versao_tiss,                 
		cd_prestador_solic,             
		dt_inicio_vigencia_ref,         
		dt_fim_vigencia_ref ,           
		ie_acomodacao_autorizada,       
		ie_restringe_hosp,              
		nr_seq_tipo_atend_princ,        
		ie_tipo_atendimento,            
		nr_seq_grupo_ajuste ,           
		nr_seq_grupo_prest_int ,        
		pr_icms ,                       
		nr_seq_mot_reembolso,
		ie_med_oncologico,
		qt_idade_inicial,
		qt_idade_final,
        ie_gerar_remido,		
		ie_regime_atendimento_princ,
		ie_regime_atendimento,
		ie_saude_ocupacional
		)
	SELECT	nr_seq_regra_mat_w,	
		cd_estabelecimento,             
		clock_timestamp(),                 
		nm_usuario_p,                     
		clock_timestamp() ,           
		nm_usuario_p,                
		nr_seq_prestador,               
		dt_inicio_w,             
		dt_fim_vigencia,                
		tx_ajuste,                      
		ie_situacao,                    
		vl_negociado,                   
		tx_ajuste_pfb,                  
		tx_ajuste_pmc_neut,             
		tx_ajuste_pmc_pos,             
		tx_ajuste_pmc_neg,              
		tx_ajuste_simpro_pfb,           
		tx_ajuste_simpro_pmc,           
		ie_origem_preco,                
		ie_tipo_despesa,                
		nr_seq_material_preco,          
		tx_ajuste_tab_propria,          
		ie_tipo_tabela,                 
		nr_seq_outorgante,              
		nr_seq_contrato,                
		tx_ajuste_benef_lib,            
		nr_seq_congenere,               
		nr_seq_regra_ant,               
		ds_observacao,                  
		nr_seq_plano,                   
		ie_tipo_vinculo,                
		nr_seq_classificacao,           
		nr_seq_grupo_prestador,         
		ie_tipo_contratacao,            
		ie_preco,                       
		ie_tipo_segurado,               
		nr_seq_grupo_contrato,          
		nr_seq_grupo_produto,          
		nr_seq_material,                
		nr_seq_estrutura_mat,           
		ie_tabela_adicional ,           
		cd_material,                   
		sg_uf_operadora_intercambio,    
		ie_tipo_intercambio,            
		cd_convenio,                    
		cd_categoria,                   
		nr_seq_categoria,               
		nr_seq_tipo_acomodacao,         
		nr_seq_tipo_atendimento,        
		nr_seq_clinica,                 
		nr_seq_tipo_prestador,          
		ie_tipo_guia,                   
		dt_base_fixo,                   
		ie_generico_unimed ,            
		nr_seq_grupo_uf,                
		nr_seq_tipo_uso,                
		ie_mat_autorizacao_esp,         
		cd_prestador ,                  
		nr_seq_grupo_material,          
		ie_internado,                   
		nr_contrato,                    
		nr_seq_congenere_prot,          
		ie_pcmso,                       
		ie_tipo_preco_simpro ,          
		ie_tipo_preco_brasindice,       
		nr_seq_regra_mat_ref,           
		ie_tipo_acomodacao_ptu ,        
		nr_seq_grupo_operadora,         
		ie_tipo_ajuste_pfb,             
		vl_pfb_neutra_simpro,           
		vl_pfb_positiva_simpro,         
		vl_pfb_negativa_simpro,         
		vl_pfb_nao_aplicavel_simpro,    
		vl_pfb_neutra_brasindice,       
		vl_pfb_positiva_brasindice ,    
		vl_pfb_negativa_brasindice ,    
		nr_seq_intercambio ,            
		cd_especialidade_prest ,        
		ie_cooperado ,                  
		ds_regra ,                      
		ie_nao_gera_tx_inter,           
		ie_tipo_prestador ,             
		cd_prestador_prot,              
		nr_seq_tipo_prestador_prot,     
		nr_seq_regra_atend_cart,        
		nr_seq_cp_combinada,            
		ie_atend_pcmso ,                
		ie_origem_protocolo,            
		ie_ref_guia_internacao ,        
		nr_seq_prestador_inter,         
		ie_tipo_preco_tab_adic,         
		cd_versao_tiss,                 
		cd_prestador_solic,             
		dt_inicio_vigencia_ref,         
		dt_fim_vigencia_ref ,           
		ie_acomodacao_autorizada,       
		ie_restringe_hosp,              
		nr_seq_tipo_atend_princ,        
		ie_tipo_atendimento,            
		nr_seq_grupo_ajuste ,           
		nr_seq_grupo_prest_int ,        
		pr_icms ,                       
		nr_seq_mot_reembolso,
		ie_med_oncologico,
		qt_idade_inicial,
		qt_idade_final,
        ie_gerar_remido,
		ie_regime_atendimento_princ,
		ie_regime_atendimento,
		ie_saude_ocupacional
	from	pls_regra_preco_mat
	where	nr_sequencia	= nr_seq_regra_p;
	
	if (ie_excecao_p = 'S')	then
		insert into pls_excecao_preco_mat(cd_material,
			dt_atualizacao,              
			dt_atualizacao_nrec,                   
			dt_fim_vigencia,                      
			dt_inicio_vigencia,            
			ie_origem_protocolo,                     
			ie_preco,                            
			ie_situacao,
			ie_tipo_contratacao,                     
			ie_tipo_despesa,                         
			ie_tipo_intercambio,                    
			ie_tipo_segurado,                        
			nm_usuario,                   
			nm_usuario_nrec,                         
			nr_contrato,                             
			nr_seq_classificacao,                    
			nr_seq_congenere,                       
			nr_seq_congenere_prot,                   
			nr_seq_contrato,                        
			nr_seq_grupo_contrato,                  
			nr_seq_grupo_intercambio,                
			nr_seq_grupo_material,                  
			nr_seq_grupo_operadora,                  
			nr_seq_grupo_prestador,                 
			nr_seq_material,                         
			nr_seq_prestador,                       
			nr_seq_regra,                  
			nr_seq_tipo_atend_princ,                 
			nr_seq_tipo_prestador,                   
			nr_seq_tipo_prestador_prot,              
			nr_sequencia,			
			ie_regime_atendimento,
			ie_saude_ocupacional
			)
		SELECT	cd_material,                             
			clock_timestamp(),              
			clock_timestamp(),                   
			dt_fim_vigencia,                      
			dt_inicio_vigencia,            
			ie_origem_protocolo,                     
			ie_preco,                            
			ie_situacao,
			ie_tipo_contratacao,                     
			ie_tipo_despesa,                         
			ie_tipo_intercambio,                    
			ie_tipo_segurado,                        
			nm_usuario_p,                   
			nm_usuario_p,                         
			nr_contrato,                             
			nr_seq_classificacao,                    
			nr_seq_congenere,                       
			nr_seq_congenere_prot,                   
			nr_seq_contrato,                        
			nr_seq_grupo_contrato,                  
			nr_seq_grupo_intercambio,                
			nr_seq_grupo_material,                  
			nr_seq_grupo_operadora,                  
			nr_seq_grupo_prestador,                 
			nr_seq_material,                         
			nr_seq_prestador,                       
			nr_seq_regra_mat_w,                  
			nr_seq_tipo_atend_princ,                 
			nr_seq_tipo_prestador,                   
			nr_seq_tipo_prestador_prot,              
			nextval('pls_excecao_preco_mat_seq'),			
			ie_regime_atendimento,
			ie_saude_ocupacional
		from	pls_excecao_preco_mat
		where	nr_seq_regra	= nr_seq_regra_p;
	end if;
	
elsif (ie_tipo_regra_p = 'S') then
	
	select nextval('pls_regra_preco_servico_seq')
	into STRICT nr_seq_regra_serv_w
	;
	
	if (ie_checado_p = 'N') then
		select dt_inicio_vigencia
		into STRICT	dt_inicio_w
		from	pls_regra_preco_servico
		where	nr_sequencia = nr_seq_regra_p;
	end if;
	insert into pls_regra_preco_servico(nr_sequencia,
		cd_estabelecimento,     
		dt_atualizacao,         
		nm_usuario,             
		dt_atualizacao_nrec,    
		nm_usuario_nrec,        
		nr_seq_prestador,              
		dt_inicio_vigencia,             
		dt_fim_vigencia,                
		cd_tabela_servico,              
		tx_ajuste,                      
		cd_procedimento,                
		ie_origem_proced ,              
		ie_situacao,                    
		cd_area_procedimento,           
		cd_especialidade ,              
		cd_grupo_proc,                  
		vl_negociado,                   
		ie_tipo_tabela,                 
		nr_seq_outorgante,              
		nr_seq_contrato,                
		nr_seq_congenere ,              
		nr_seq_regra_ant,               
		ds_observacao,                  
		ie_preco,                       
		ie_tipo_contratacao,            
		nr_seq_plano,                   
		ie_tipo_vinculo,                
		nr_seq_grupo_produto,           
		nr_seq_grupo_contrato,          
		ie_internado,                   
		nr_seq_categoria,               
		nr_seq_classificacao ,          
		nr_seq_grupo_prestador,         
		ie_tipo_segurado ,              
		nr_seq_grupo_servico,           
		cd_prestador ,                  
		nr_contrato,                    
		ie_taxa_coleta,                 
		nr_seq_grupo_rec,               
		ie_tipo_intercambio,            
		ie_autogerado,                  
		ie_acomodacao,                  
		nr_seq_intercambio,             
		nr_seq_grupo_intercambio,       
		nr_seq_cbo_saude,               
		ie_tipo_guia,                   
		ie_carater_internacao ,         
		nr_seq_tipo_prestador ,         
		nr_seq_clinica ,                
		nr_seq_tipo_atendimento,        
		nr_seq_tipo_acomodacao,         
		tx_ajuste_preco,                
		nr_seq_referencia ,             
		nr_seq_congenere_prot ,         
		cd_moeda ,                      
		ie_pcmso ,                      
		nr_seq_serv_ref ,               
		ie_tipo_acomodacao_ptu,         
		cd_especialidade_prest,         
		ie_cooperado,                   
		ds_regra ,                      
		ie_nao_gera_tx_inter,           
		ie_tipo_prestador ,             
		cd_prestador_prot,              
		nr_seq_tipo_prestador_prot,
		nr_seq_regra_atend_cart,        
		nr_seq_cp_combinada,            
		ie_atend_pcmso,                 
		ie_origem_protocolo,            
		nr_seq_grupo_operadora,         
		ie_ref_guia_internacao,         
		nr_seq_prestador_inter,         
		cd_versao_tiss,                 
		cd_prestador_solic,             
		dt_inicio_vigencia_ref,         
		dt_fim_vigencia_ref,            
		ie_acomodacao_autorizada ,      
		nr_seq_tipo_atend_princ,        
		ie_tipo_atendimento,            
		nr_seq_grupo_prest_int,         
		nr_seq_mot_reembolso,
		qt_idade_inicial,
		qt_idade_final,
        ie_gerar_remido,
		ie_regime_atendimento_princ,
		ie_regime_atendimento,
		ie_saude_ocupacional)
	SELECT	nr_seq_regra_serv_w,
		cd_estabelecimento,     
		clock_timestamp(),         
		nm_usuario_p,             
		clock_timestamp(),    
		nm_usuario_p,        
		nr_seq_prestador,              
		dt_inicio_w,             
		dt_fim_vigencia,                
		cd_tabela_servico,              
		tx_ajuste,                      
		cd_procedimento,                
		ie_origem_proced ,              
		ie_situacao,                    
		cd_area_procedimento,           
		cd_especialidade ,              
		cd_grupo_proc,                  
		vl_negociado,                   
		ie_tipo_tabela,                 
		nr_seq_outorgante,              
		nr_seq_contrato,                
		nr_seq_congenere ,              
		nr_seq_regra_ant,               
		ds_observacao,                  
		ie_preco,                       
		ie_tipo_contratacao,            
		nr_seq_plano,                   
		ie_tipo_vinculo,                
		nr_seq_grupo_produto,           
		nr_seq_grupo_contrato,          
		ie_internado,                   
		nr_seq_categoria,               
		nr_seq_classificacao ,          
		nr_seq_grupo_prestador,         
		ie_tipo_segurado ,              
		nr_seq_grupo_servico,           
		cd_prestador ,                  
		nr_contrato,                    
		ie_taxa_coleta,                 
		nr_seq_grupo_rec,               
		ie_tipo_intercambio,            
		ie_autogerado,                  
		ie_acomodacao,                  
		nr_seq_intercambio,             
		nr_seq_grupo_intercambio,       
		nr_seq_cbo_saude,               
		ie_tipo_guia,                   
		ie_carater_internacao ,         
		nr_seq_tipo_prestador ,         
		nr_seq_clinica ,                
		nr_seq_tipo_atendimento,        
		nr_seq_tipo_acomodacao,         
		tx_ajuste_preco,                
		nr_seq_referencia ,             
		nr_seq_congenere_prot ,         
		cd_moeda ,                      
		ie_pcmso ,                      
		nr_seq_serv_ref ,               
		ie_tipo_acomodacao_ptu,         
		cd_especialidade_prest,         
		ie_cooperado,                   
		ds_regra ,                      
		ie_nao_gera_tx_inter,           
		ie_tipo_prestador ,             
		cd_prestador_prot,              
		nr_seq_tipo_prestador_prot,
		nr_seq_regra_atend_cart,        
		nr_seq_cp_combinada,            
		ie_atend_pcmso,                 
		ie_origem_protocolo,            
		nr_seq_grupo_operadora,         
		ie_ref_guia_internacao,         
		nr_seq_prestador_inter,         
		cd_versao_tiss,                 
		cd_prestador_solic,             
		dt_inicio_vigencia_ref,         
		dt_fim_vigencia_ref,            
		ie_acomodacao_autorizada ,      
		nr_seq_tipo_atend_princ,        
		ie_tipo_atendimento,            
		nr_seq_grupo_prest_int,         
		nr_seq_mot_reembolso,
		qt_idade_inicial,
		qt_idade_final,
        ie_gerar_remido,
		ie_regime_atendimento_princ,
		ie_regime_atendimento,
		ie_saude_ocupacional
	from	pls_regra_preco_servico
	where	nr_sequencia = nr_seq_regra_p;
	
	if (ie_excecao_p = 'S')	then
		insert into pls_excecao_preco_servico(cd_procedimento,
			dt_atualizacao,                 
			dt_atualizacao_nrec,                    
			dt_fim_vigencia,                         
			dt_inicio_vigencia,             
			ie_origem_proced,              
			ie_origem_protocolo,                    
			ie_preco,                               
			ie_situacao,                   
			ie_tipo_contratacao,                    
			ie_tipo_intercambio,                   
			ie_tipo_segurado,                        
			nm_usuario,                     
			nm_usuario_nrec,                         
			nr_contrato,                            
			nr_seq_classificacao,                    
			nr_seq_congenere,                       
			nr_seq_congenere_prot,                   
			nr_seq_contrato,                         
			nr_seq_grupo_contrato,                   
			nr_seq_grupo_intercambio,               
			nr_seq_grupo_material,                   
			nr_seq_grupo_operadora,                 
			nr_seq_grupo_prestador,                  
			nr_seq_grupo_rec,                       
			nr_seq_grupo_servico,                   
			nr_seq_prestador,                       
			nr_seq_regra,                   
			nr_seq_tipo_atend_princ,                 
			nr_seq_tipo_prestador,                   
			nr_seq_tipo_prestador_prot,              
			nr_sequencia,
			ie_regime_atendimento,
			ie_saude_ocupacional			
			)
		SELECT	cd_procedimento,                         
			clock_timestamp(),                 
			clock_timestamp(),                    
			dt_fim_vigencia,                         
			dt_inicio_vigencia,             
			ie_origem_proced,              
			ie_origem_protocolo,                    
			ie_preco,                               
			ie_situacao,                   
			ie_tipo_contratacao,                    
			ie_tipo_intercambio,                   
			ie_tipo_segurado,                        
			nm_usuario_p,                     
			nm_usuario_p,                         
			nr_contrato,                            
			nr_seq_classificacao,                    
			nr_seq_congenere,                       
			nr_seq_congenere_prot,                   
			nr_seq_contrato,                         
			nr_seq_grupo_contrato,                   
			nr_seq_grupo_intercambio,               
			nr_seq_grupo_material,                   
			nr_seq_grupo_operadora,                 
			nr_seq_grupo_prestador,                  
			nr_seq_grupo_rec,                       
			nr_seq_grupo_servico,                   
			nr_seq_prestador,                       
			nr_seq_regra_serv_w,                   
			nr_seq_tipo_atend_princ,                 
			nr_seq_tipo_prestador,                   
			nr_seq_tipo_prestador_prot,              
			nextval('pls_excecao_preco_servico_seq'),
			ie_regime_atendimento,
			ie_saude_ocupacional
		from	pls_excecao_preco_servico
		where	nr_seq_regra	= nr_seq_regra_p;
	end if;
	
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_duplicar_regra_preco ( nr_seq_regra_p bigint, dt_inicio_p timestamp, ie_tipo_regra_p text, nm_usuario_p text, ie_checado_p text, ie_excecao_p text) FROM PUBLIC;

