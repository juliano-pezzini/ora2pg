-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ocupacao_setores_hig_v (cd_setor_atendimento, ds_setor_atendimento, cd_estabelecimento_base, cd_classif_setor, nm_unidade, ds_ocup_hosp, nr_seq_apresentacao, nr_unidades_setor, nr_unidades_temporarias, nr_unidades_ocupadas, qt_unidade_acomp, nr_unidades_interditadas, nr_unidades_livres, nr_unidades_higienizacao, nr_unidades_reservadas, qt_unidades_isolamento, qt_unidades_alta, qt_unidade_saida_inter, qt_unidade_chamad_manut, qt_unidade_manutencao, nr_unid_temp_ocup, nr_unid_temp_ocupadas, qt_unid_temp_acomp, nr_unid_temp_interditadas, nr_unid_temp_livres, nr_unid_temp_higienizacao, nr_unid_temp_reservadas, qt_unid_temp_isolamento, qt_unid_temp_said_interd, qt_unid_temp_alta, ie_ocup_hospitalar, ie_situacao, qt_disponiveis, qt_pac_isolado) AS select /*+ ordered */	c.cd_setor_atendimento,  
	c.ds_setor_atendimento,  
	c.cd_estabelecimento_base, 
	c.cd_classif_setor,  
	c.nm_unidade_basica ||c.nm_unidade_compl nm_unidade, 
	c.ds_ocup_hosp, 
	c.nr_seq_apresentacao, 
	count(*) nr_unidades_setor, 
	sum(CASE WHEN b.ie_temporario='S' THEN  1  ELSE 0 END ) nr_unidades_temporarias,   
	sum(CASE WHEN b.ie_status_unidade='P' THEN  1  ELSE 0 END ) nr_unidades_ocupadas,  
	sum(CASE WHEN b.ie_status_unidade='M' THEN  1  ELSE 0 END ) qt_unidade_acomp,   
	sum(CASE WHEN b.ie_status_unidade='I' THEN  1  ELSE 0 END ) nr_unidades_interditadas,   
	sum(CASE WHEN b.ie_status_unidade='L' THEN  1  ELSE 0 END ) nr_unidades_livres,   
	sum(CASE WHEN b.ie_status_unidade='H' THEN  1  ELSE 0 END ) nr_unidades_higienizacao, 
	sum(CASE WHEN b.ie_status_unidade='R' THEN  1  ELSE 0 END ) nr_unidades_reservadas, 
	sum(CASE WHEN b.ie_status_unidade='O' THEN  1  ELSE 0 END ) qt_unidades_isolamento, 
	sum(CASE WHEN b.ie_status_unidade='A' THEN  1  ELSE 0 END ) qt_unidades_alta, 
	sum(CASE WHEN b.ie_status_unidade='S' THEN  1  ELSE 0 END ) qt_unidade_saida_inter, 
	sum(CASE WHEN b.ie_status_unidade='C' THEN  1  ELSE 0 END ) qt_unidade_chamad_manut, 
	sum(CASE WHEN b.ie_status_unidade='E' THEN  1  ELSE 0 END ) qt_unidade_manutencao, 
	sum(CASE WHEN b.ie_temporario='S' THEN  CASE WHEN b.ie_status_unidade='P' THEN  1  ELSE 0 END   ELSE 0 END ) nr_unid_temp_ocup,  
	sum(CASE WHEN b.ie_temporario='S' THEN  CASE WHEN b.ie_status_unidade='P' THEN  1  ELSE 0 END   ELSE 0 END ) nr_unid_temp_ocupadas,  
	sum(CASE WHEN b.ie_temporario='S' THEN  CASE WHEN b.ie_status_unidade='M' THEN  1  ELSE 0 END   ELSE 0 END ) qt_unid_temp_acomp,   
	sum(CASE WHEN b.ie_temporario='S' THEN  CASE WHEN b.ie_status_unidade='I' THEN  1  ELSE 0 END   ELSE 0 END ) nr_unid_temp_interditadas,   
	sum(CASE WHEN b.ie_temporario='S' THEN  CASE WHEN b.ie_status_unidade='L' THEN  1  ELSE 0 END   ELSE 0 END ) nr_unid_temp_livres,   
	sum(CASE WHEN b.ie_temporario='S' THEN  CASE WHEN b.ie_status_unidade='H' THEN  1  ELSE 0 END   ELSE 0 END ) nr_unid_temp_higienizacao, 
	sum(CASE WHEN b.ie_temporario='S' THEN  CASE WHEN b.ie_status_unidade='R' THEN  1  ELSE 0 END   ELSE 0 END ) nr_unid_temp_reservadas, 
	sum(CASE WHEN b.ie_temporario='S' THEN  CASE WHEN b.ie_status_unidade='O' THEN  1  ELSE 0 END   ELSE 0 END ) qt_unid_temp_isolamento, 
	sum(CASE WHEN b.ie_temporario='S' THEN  CASE WHEN b.ie_status_unidade='S' THEN  1  ELSE 0 END   ELSE 0 END ) qt_unid_temp_said_interd, 
	sum(CASE WHEN b.ie_temporario='S' THEN  CASE WHEN b.ie_status_unidade='A' THEN  1  ELSE 0 END   ELSE 0 END ) qt_unid_temp_alta, 
	ie_ocup_hospitalar, c.ie_situacao, 
	sum(CASE WHEN obter_se_leito_disp(b.cd_setor_atendimento, b.cd_unidade_basica, b.cd_unidade_compl)='S' THEN  1  ELSE 0 END ) qt_disponiveis, 
	(sum(CASE WHEN OBTER_SE_PAC_ISOLAMENTO(b.nr_atendimento)='S' THEN 1  ELSE 0 END )) qt_pac_isolado 
FROM	setor_atendimento c, 
	unidade_atendimento b 
where	b.cd_setor_atendimento   = c.cd_setor_atendimento 
 and	b.ie_situacao       = 'A' 
 and	c.cd_classif_setor in (2,3,4) 
group by c.cd_classif_setor,    
	c.cd_setor_atendimento,  
	c.ds_setor_atendimento, 
	c.cd_estabelecimento_base, 
	c.ds_ocup_hosp, c.ie_situacao, 
	(c.nm_unidade_basica ||c.nm_unidade_compl), 
	ie_ocup_hospitalar, 
	c.nr_seq_apresentacao;

