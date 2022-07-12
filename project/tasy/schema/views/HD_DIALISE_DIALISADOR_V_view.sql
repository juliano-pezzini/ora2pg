-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hd_dialise_dialisador_v (nr_sequencia, nr_seq_dialise, dt_montagem, ie_troca_emergencia, qt_reuso_atual, ds_estabelecimento, nr_seq_dialisador, ds_dialisador, ds_modelo, ds_maquina_dialise, ds_ponto_acesso, nm_pf_montagem, nm_pf_retirada, dt_retirada, ds_motivo_sub_maq, ds_motivo_subst, nm_usuario_nrec, dt_atualizacao_nrec, ie_opcao) AS SELECT	a.NR_SEQUENCIA,
	a.NR_SEQ_DIALISE, 
	a.DT_MONTAGEM, 
	a.IE_TROCA_EMERGENCIA, 
	a.QT_REUSO_ATUAL, 
	SUBSTR(obter_nome_estabelecimento(a.CD_ESTABELECIMENTO), 1, 100) DS_ESTABELECIMENTO, 
	a.NR_SEQ_DIALISADOR,	 
	(SUBSTR(obter_descricao_padrao('HD_DIALIZADOR','NR_DIALIZADOR',a.NR_SEQ_DIALISADOR),1,80))::numeric  DS_DIALISADOR, 
	SUBSTR(hd_obter_modelo_dialisador(a.nr_seq_dialisador),1,80) DS_MODELO, 
	SUBSTR(hd_obter_dados_maquina(a.nr_seq_maquina,'C')||' - '||hd_obter_dados_maquina(a.nr_seq_maquina,'D'),1,80) DS_MAQUINA_DIALISE, 
	SUBSTR(obter_descricao_padrao('HD_PONTO_ACESSO','DS_PONTO_ACESSO',NR_SEQ_PONTO_ACESSO),1,80) DS_PONTO_ACESSO, 
	SUBSTR(obter_nome_pf(a.CD_PF_MONTAGEM),1,200) NM_PF_MONTAGEM, 
	null NM_PF_RETIRADA, 
	null DT_RETIRADA, 
	null DS_MOTIVO_SUB_MAQ, 
	null DS_MOTIVO_SUBST, 
	SUBSTR(obter_nome_usuario(a.NM_USUARIO_NREC),1,200) NM_USUARIO_NREC, 
	a.DT_ATUALIZACAO_NREC, 
	'MD' IE_OPCAO 
FROM	HD_DIALISE_DIALISADOR a 

UNION
 
SELECT	a.NR_SEQUENCIA, 
	a.NR_SEQ_DIALISE, 
	a.DT_MONTAGEM, 
	a.IE_TROCA_EMERGENCIA, 
	a.QT_REUSO_ATUAL, 
	SUBSTR(obter_nome_estabelecimento(a.CD_ESTABELECIMENTO), 1, 100) DS_ESTABELECIMENTO, 
	a.NR_SEQ_DIALISADOR, 
	null DS_DIALISADOR, 
	null DS_MODELO, 
	null DS_MAQUINA_DIALISE, 
	null DS_PONTO_ACESSO, 
	null NM_PF_MONTAGEM, 
	SUBSTR(obter_nome_pf(a.CD_PF_RETIRADA),1,200) NM_PF_RETIRADA, 
	a.DT_RETIRADA, 
	null DS_MOTIVO_SUB_MAQ, 
	null DS_MOTIVO_SUBST, 
	SUBSTR(obter_nome_usuario(a.NM_USUARIO_NREC),1,200) NM_USUARIO_NREC, 
	a.DT_ATUALIZACAO_NREC, 
	'TI' IE_OPCAO 
FROM	HD_DIALISE_DIALISADOR a 

UNION
 
SELECT	a.NR_SEQUENCIA, 
	a.NR_SEQ_DIALISE, 
	a.DT_MONTAGEM, 
	a.IE_TROCA_EMERGENCIA, 
	a.QT_REUSO_ATUAL, 
	SUBSTR(obter_nome_estabelecimento(a.CD_ESTABELECIMENTO), 1, 100) DS_ESTABELECIMENTO, 
	a.NR_SEQ_DIALISADOR, 
	(SUBSTR(obter_descricao_padrao('HD_DIALIZADOR','NR_DIALIZADOR',a.NR_SEQ_DIALISADOR),1,80))::numeric  DS_DIALISADOR, 
	SUBSTR(hd_obter_modelo_dialisador(a.nr_seq_dialisador),1,80) DS_MODELO, 
	SUBSTR(hd_obter_dados_maquina(a.nr_seq_maquina,'C')||' - '||hd_obter_dados_maquina(a.nr_seq_maquina,'D'),1,80) DS_MAQUINA_DIALISE, 
	SUBSTR(obter_descricao_padrao('HD_PONTO_ACESSO','DS_PONTO_ACESSO',a.NR_SEQ_PONTO_ACESSO),1,80) DS_PONTO_ACESSO, 
	SUBSTR(obter_nome_pf(a.CD_PF_MONTAGEM),1,200) NM_PF_MONTAGEM, 
	SUBSTR(obter_nome_pf(a.CD_PF_RETIRADA),1,200) NM_PF_RETIRADA, 
	a.DT_RETIRADA, 
	null DS_MOTIVO_SUB_MAQ, 
	a.DS_MOTIVO_SUBST, 
	SUBSTR(obter_nome_usuario(a.NM_USUARIO_NREC),1,200) NM_USUARIO_NREC, 
	a.DT_ATUALIZACAO_NREC, 
	'SD' IE_OPCAO 
FROM	hd_dialise_dialisador a 

UNION
 
SELECT	a.NR_SEQUENCIA, 
	a.NR_SEQ_DIALISE, 
	a.DT_MONTAGEM, 
	a.IE_TROCA_EMERGENCIA, 
	a.QT_REUSO_ATUAL, 
	SUBSTR(obter_nome_estabelecimento(a.CD_ESTABELECIMENTO), 1, 100) DS_ESTABELECIMENTO, 
	a.NR_SEQ_DIALISADOR, 
	(SUBSTR(obter_descricao_padrao('HD_DIALIZADOR','NR_DIALIZADOR',a.NR_SEQ_DIALISADOR),1,80))::numeric  DS_DIALISADOR, 
	SUBSTR(hd_obter_modelo_dialisador(a.nr_seq_dialisador),1,80) DS_MODELO, 
	null DS_MAQUINA_DIALISE, 
	null DS_PONTO_ACESSO, 
	null NM_PF_MONTAGEM, 
	SUBSTR(obter_nome_pf(a.CD_PF_RETIRADA),1,200) NM_PF_RETIRADA, 
	a.DT_RETIRADA, 
	null DS_MOTIVO_SUB_MAQ, 
	a.DS_MOTIVO_SUBST, 
	SUBSTR(obter_nome_usuario(a.NM_USUARIO_NREC),1,200) NM_USUARIO_NREC, 
	a.DT_ATUALIZACAO_NREC, 
	'RD' IE_OPCAO 
FROM	HD_DIALISE_DIALISADOR a 

UNION
 
SELECT	a.NR_SEQUENCIA, 
	a.NR_SEQ_DIALISE, 
	a.DT_MONTAGEM, 
	a.IE_TROCA_EMERGENCIA, 
	a.QT_REUSO_ATUAL, 
	SUBSTR(obter_nome_estabelecimento(a.CD_ESTABELECIMENTO), 1, 100) DS_ESTABELECIMENTO, 
	a.NR_SEQ_DIALISADOR, 
	(SUBSTR(obter_descricao_padrao('HD_DIALIZADOR','NR_DIALIZADOR',a.NR_SEQ_DIALISADOR),1,80))::numeric  DS_DIALISADOR, 
	SUBSTR(hd_obter_modelo_dialisador(a.nr_seq_dialisador),1,80) DS_MODELO, 
	SUBSTR(hd_obter_dados_maquina(a.nr_seq_maquina,'C')||' - '||hd_obter_dados_maquina(a.nr_seq_maquina,'D'),1,80) DS_MAQUINA_DIALISE, 
	SUBSTR(obter_descricao_padrao('HD_PONTO_ACESSO','DS_PONTO_ACESSO',a.NR_SEQ_PONTO_ACESSO),1,80) DS_PONTO_ACESSO, 
	SUBSTR(obter_nome_pf(a.CD_PF_MONTAGEM),1,200) NM_PF_MONTAGEM, 
	SUBSTR(obter_nome_pf(a.CD_PF_RETIRADA),1,200) NM_PF_RETIRADA, 
	a.DT_RETIRADA, 
	SUBSTR(hd_obter_desc_motivo_subst_maq(a.nr_seq_motivo_sub),1,255) DS_MOTIVO_SUB_MAQ, 
	a.DS_MOTIVO_SUBST, 
	SUBSTR(obter_nome_usuario(a.NM_USUARIO_NREC),1,200) NM_USUARIO_NREC, 
	a.DT_ATUALIZACAO_NREC, 
	'SM' IE_OPCAO 
FROM	hd_dialise_dialisador a 

UNION
 
SELECT	a.NR_SEQUENCIA, 
	a.NR_SEQ_DIALISE, 
	a.DT_MONTAGEM, 
	a.IE_TROCA_EMERGENCIA, 
	a.QT_REUSO_ATUAL, 
	SUBSTR(obter_nome_estabelecimento(a.CD_ESTABELECIMENTO), 1, 100) DS_ESTABELECIMENTO, 
	a.NR_SEQ_DIALISADOR, 
	null DS_DIALISADOR, 
	null DS_MODELO, 
	null DS_MAQUINA_DIALISE, 
	null DS_PONTO_ACESSO, 
	null NM_PF_MONTAGEM, 
	SUBSTR(obter_nome_pf(a.CD_PF_RETIRADA),1,200) NM_PF_RETIRADA, 
	a.DT_RETIRADA, 
	null DS_MOTIVO_SUB_MAQ, 
	a.DS_MOTIVO_SUBST, 
	SUBSTR(obter_nome_usuario(a.NM_USUARIO_NREC),1,200) NM_USUARIO_NREC, 
	a.DT_ATUALIZACAO_NREC, 
	'FD' IE_OPCAO 
FROM	HD_DIALISE_DIALISADOR a 

UNION
 
SELECT	a.NR_SEQUENCIA, 
	a.NR_SEQ_DIALISE, 
	a.DT_MONTAGEM, 
	a.IE_TROCA_EMERGENCIA, 
	a.QT_REUSO_ATUAL, 
	SUBSTR(obter_nome_estabelecimento(a.CD_ESTABELECIMENTO), 1, 100) DS_ESTABELECIMENTO, 
	a.NR_SEQ_DIALISADOR, 
	(SUBSTR(obter_descricao_padrao('HD_DIALIZADOR','NR_DIALIZADOR',a.NR_SEQ_DIALISADOR),1,80))::numeric  DS_DIALISADOR, 
	null DS_MODELO, 
	null DS_MAQUINA_DIALISE, 
	null DS_PONTO_ACESSO, 
	null NM_PF_MONTAGEM, 
	SUBSTR(obter_nome_pf(a.CD_PF_RETIRADA),1,200) NM_PF_RETIRADA, 
	a.DT_RETIRADA, 
	null DS_MOTIVO_SUB_MAQ, 
	a.DS_MOTIVO_SUBST, 
	SUBSTR(obter_nome_usuario(a.NM_USUARIO_NREC),1,200) NM_USUARIO_NREC, 
	a.DT_ATUALIZACAO_NREC, 
	'C' IE_OPCAO 
FROM	HD_DIALISE_DIALISADOR a 

UNION
 
SELECT	a.NR_SEQUENCIA, 
	a.NR_SEQ_DIALISE, 
	a.DT_MONTAGEM, 
	a.IE_TROCA_EMERGENCIA, 
	a.QT_REUSO_ATUAL, 
	SUBSTR(obter_nome_estabelecimento(a.CD_ESTABELECIMENTO), 1, 100) DS_ESTABELECIMENTO, 
	a.NR_SEQ_DIALISADOR,	 
	(SUBSTR(obter_descricao_padrao('HD_DIALIZADOR','NR_DIALIZADOR',a.NR_SEQ_DIALISADOR),1,80))::numeric  DS_DIALISADOR, 
	SUBSTR(hd_obter_modelo_dialisador(a.nr_seq_dialisador),1,80) DS_MODELO, 
	SUBSTR(hd_obter_dados_maquina(a.nr_seq_maquina,'C')||' - '||hd_obter_dados_maquina(a.nr_seq_maquina,'D'),1,80) DS_MAQUINA_DIALISE, 
	SUBSTR(obter_descricao_padrao('HD_PONTO_ACESSO','DS_PONTO_ACESSO',NR_SEQ_PONTO_ACESSO),1,80) DS_PONTO_ACESSO, 
	SUBSTR(obter_nome_pf(a.CD_PF_MONTAGEM),1,200) NM_PF_MONTAGEM, 
	null NM_PF_RETIRADA, 
	null DT_RETIRADA, 
	null DS_MOTIVO_SUB_MAQ, 
	null DS_MOTIVO_SUBST, 
	SUBSTR(obter_nome_usuario(a.NM_USUARIO_NREC),1,200) NM_USUARIO_NREC, 
	a.DT_ATUALIZACAO_NREC, 
	'GM' IE_OPCAO 
FROM	HD_DIALISE_DIALISADOR a;

