-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW relat_proj_rec_v (nr_seq, nr_sequencia, tipo_projeto, nr_seq_superior, nr_seq_tipo, dt_projeto, dt_liberacao, dt_inicio_exec, dt_suspensa, dt_fim_exec, ds_projeto, ie_origem_recurso, origem_recurso, nr_processo, ds_convenio_ano, cd_pf_representante, pf_representante, ds_elemento_despesa, ds_projeto_origem, vl_projeto, vl_inicio_projeto, vl_verba_propria, vl_subprojetos, vl_entrada, vl_trans_entrada, vl_trans_saida, dt_fim_prest_conta, nr_seq_conta_bco, ds_conta_bancaria, estab, centro_custo, setor_investimento, nm_usuario_fim_exec) AS SELECT (coalesce(NR_SEQ_SUPERIOR,NR_SEQUENCIA)) NR_SEQ, NR_SEQUENCIA,
 CASE WHEN ie_tipo_projeto='P' THEN  'Geral' WHEN ie_tipo_projeto='S' THEN  'Subprojeto' END  TIPO_PROJETO,  
 NR_SEQ_SUPERIOR, 
 NR_SEQ_TIPO, 
 DT_PROJETO, 
 DT_LIBERACAO, 
 DT_INICIO_EXEC, 
 DT_SUSPENSA, 
 DT_FIM_EXEC, 
 DS_PROJETO, 
 IE_ORIGEM_RECURSO, 
 CASE WHEN ie_origem_recurso='F' THEN 'Federal' WHEN ie_origem_recurso='E' THEN 'Estadual' WHEN ie_origem_recurso='M' THEN 'Municipal' WHEN ie_origem_recurso='P' THEN 'Privado' END  origem_recurso, 
 NR_PROCESSO, 
 DS_CONVENIO_ANO, 
 CD_PF_REPRESENTANTE,  
 OBTER_NOME_PF_PJ(CD_PF_REPRESENTANTE,null) pf_representante, 
 DS_ELEMENTO_DESPESA, 
 DS_PROJETO_ORIGEM, 
 VL_PROJETO, 
 VL_INICIO_PROJETO, 
 VL_VERBA_PROPRIA, 
 projeto_recurso_pck.obter_vls_sub_proj_rec(NR_SEQUENCIA) vl_subprojetos, 
 projeto_recurso_pck.obter_vl_entrada_proj_rec(NR_SEQUENCIA) vl_entrada, 
 projeto_recurso_pck.obter_vl_trans_proj_rec(NR_SEQUENCIA, 'E') vl_trans_entrada, 
 projeto_recurso_pck.obter_vl_trans_proj_rec(NR_SEQUENCIA, 'S') vl_trans_saida, 
 DT_FIM_PREST_CONTA, 
 NR_SEQ_CONTA_BCO,  
 substr(Obter_Nome_Conta_Estab(NR_SEQ_CONTA_BCO),1,255) DS_CONTA_BANCARIA, 
 substr(obter_nome_estabelecimento(CD_ESTABELECIMENTO),1,255) estab, 
 substr(obter_desc_centro_custo(CD_CENTRO_CUSTO),1,255) centro_custo, 
 substr(obter_nome_setor(CD_SETOR_INVESTIMENTO),1,255) setor_investimento, 
 NM_USUARIO_FIM_EXEC 
FROM	PROJETO_RECURSO;
