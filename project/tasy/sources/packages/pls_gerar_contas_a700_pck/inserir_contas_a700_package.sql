-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/




CREATE OR REPLACE PROCEDURE pls_gerar_contas_a700_pck.inserir_contas_a700 ( dados_conta_p pls_gerar_contas_a700_pck.dados_conta, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_conta_table_p INOUT dbms_sql.number_table) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Rotina responsavel por gerar contas medicas e retornar a sequencia das contas criadas.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */



BEGIN

if (dados_conta_p.nr_seq_protocolo.count > 0) then
	forall i in dados_conta_p.nr_seq_protocolo.first..dados_conta_p.nr_seq_protocolo.last	
		insert into pls_conta(	
			nr_sequencia, 					ie_tipo_atendimento_imp, 			nr_seq_saida_spsadt,
			cd_guia, 					cd_guia_referencia, 				nm_usuario, 
			dt_atualizacao,					nm_usuario_nrec, 				dt_atualizacao_nrec, 
			nr_seq_protocolo, 				cd_estabelecimento,				nr_seq_prestador_exec, 
			dt_emissao, 					ie_status, 					ie_tipo_guia, 
			nr_seq_segurado, 				nr_seq_fatura,					cd_cooperativa, 
			ie_tipo_conta, 					cd_medico_solicitante,				nr_seq_nota_cobranca, 
			nr_seq_prestador_exec_imp, 			nr_seq_prestador_imp, 				cd_usuario_plano_imp, 
			ie_origem_conta, 				dt_atendimento,					ie_carater_internacao, 
			dt_entrada, 					dt_alta,					nr_seq_clinica, 
			nr_seq_saida_int, 				ie_indicacao_acidente,				cd_senha,
			cd_senha_externa, 				nr_seq_tipo_atendimento,			cd_prestador_solic_imp, 
			nm_prestador_imp, 				cd_prestador_exec_imp,				nm_prestador_exec_imp, 
			dt_atendimento_imp, 				ie_tipo_acomodacao_ptu,				ds_indicacao_clinica, 
			ds_observacao,					ie_gestacao,					ie_aborto,
			ie_parto_normal,				ie_complicacao_puerperio,			ie_complicacao_neonatal,
			ie_parto_cesaria,				ie_baixo_peso,					ie_atend_rn_sala_parto,
			ie_transtorno, 					ie_obito_mulher,				qt_obito_precoce,
			qt_obito_tardio,				qt_nasc_vivos_termo, 				qt_nasc_mortos,
			qt_nasc_vivos_prematuros, 			nr_seq_serv_pre_pagto,				ie_tipo_consulta,
			nr_seq_tipo_acomodacao,				ie_recem_nascido,				nr_seq_nota_hospitalar,
 			ie_tipo_faturamento, 				ie_regime_internacao,				nr_seq_prest_inter,
			ie_vinc_internacao,				nr_seq_plano,					nr_guia_tiss_operadora,
			nr_guia_tiss_prestador,				nr_guia_tiss_principal,				ie_cobertura_especial,
			ie_regime_atendimento,				ie_saude_ocupacional
		) values (
			nextval('pls_conta_seq'), 				dados_conta_p.ie_tipo_atendimento_imp(i), 	dados_conta_p.nr_seq_saida_spsadt(i), 
			dados_conta_p.cd_guia(i), 			dados_conta_p.cd_guia_referencia(i), 		dados_conta_p.nm_usuario(i), 
			dados_conta_p.dt_atualizacao(i), 		dados_conta_p.nm_usuario_nrec(i), 		dados_conta_p.dt_atualizacao_nrec(i), 
			dados_conta_p.nr_seq_protocolo(i), 		dados_conta_p.cd_estabelecimento(i),		dados_conta_p.nr_seq_prestador_exec(i), 
			dados_conta_p.dt_emissao(i), 			dados_conta_p.ie_status(i),			dados_conta_p.ie_tipo_guia(i), 
			dados_conta_p.nr_seq_segurado(i), 		dados_conta_p.nr_seq_fatura(i),			dados_conta_p.cd_cooperativa(i), 
			dados_conta_p.ie_tipo_conta(i), 		dados_conta_p.cd_medico_solicitante(i),		dados_conta_p.nr_seq_nota_cobranca(i), 
			dados_conta_p.nr_seq_prestador_exec_imp(i), 	dados_conta_p.nr_seq_prestador_imp(i), 		dados_conta_p.cd_usuario_plano_imp(i), 
			dados_conta_p.ie_origem_conta(i), 		dados_conta_p.dt_atendimento(i),		dados_conta_p.ie_carater_internacao(i), 
			dados_conta_p.dt_entrada(i), 			dados_conta_p.dt_alta(i),			dados_conta_p.nr_seq_clinica(i), 
			dados_conta_p.nr_seq_saida_int(i), 		dados_conta_p.ie_indicacao_acidente(i),		dados_conta_p.cd_senha(i),
			dados_conta_p.cd_senha_externa(i), 		dados_conta_p.nr_seq_tipo_atendimento(i),	dados_conta_p.cd_prestador_solic_imp(i), 
			dados_conta_p.nm_prestador_imp(i), 		dados_conta_p.cd_prestador_exec_imp(i),		dados_conta_p.nm_prestador_exec_imp(i), 
			dados_conta_p.dt_atendimento_imp(i), 		dados_conta_p.ie_tipo_acomodacao_ptu(i),	dados_conta_p.ds_indicacao_clinica(i), 
			dados_conta_p.ds_observacao(i),			dados_conta_p.ie_gestacao(i),			dados_conta_p.ie_aborto(i),
			dados_conta_p.ie_parto_normal(i),		dados_conta_p.ie_complicacao_puerperio(i),	dados_conta_p.ie_complicacao_neonatal(i),
			dados_conta_p.ie_parto_cesaria(i),		dados_conta_p.ie_baixo_peso(i),			dados_conta_p.ie_atend_rn_sala_parto(i),
			dados_conta_p.ie_transtorno(i), 		dados_conta_p.ie_obito_mulher(i),		dados_conta_p.qt_obito_precoce(i),
			dados_conta_p.qt_obito_tardio(i),		dados_conta_p.qt_nasc_vivos_termo(i), 		dados_conta_p.qt_nasc_mortos(i),
			dados_conta_p.qt_nasc_vivos_prematuros(i), 	dados_conta_p.nr_seq_serv_pre_pagto(i),		dados_conta_p.ie_tipo_consulta(i),
			dados_conta_p.nr_seq_tipo_acomodacao(i),	dados_conta_p.ie_recem_nascido(i),		dados_conta_p.nr_seq_nota_hospitalar(i),
			dados_conta_p.ie_tipo_faturamento(i),		dados_conta_p.ie_regime_internacao(i),		dados_conta_p.nr_seq_prest_inter(i),
			dados_conta_p.ie_vinc_internacao(i),		dados_conta_p.nr_seq_plano(i),			dados_conta_p.nr_guia_tiss_operadora(i),
			dados_conta_p.nr_guia_tiss_prestador(i),	dados_conta_p.nr_guia_tiss_principal(i),	dados_conta_p.ie_cobertura_especial(i),
			dados_conta_p.ie_regime_atendimento(i),		dados_conta_p.ie_saude_ocupacional(i)
		) returning nr_sequencia bulk collect into nr_seq_conta_table_p;
	commit;	
end if;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_contas_a700_pck.inserir_contas_a700 ( dados_conta_p pls_gerar_contas_a700_pck.dados_conta, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_conta_table_p INOUT dbms_sql.number_table) FROM PUBLIC;