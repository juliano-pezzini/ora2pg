-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW scs_treinamento_philips_v (ds_classif, ds_grupo, ds_tipo_funcao, qt_minuto, qt_horas, pr_classif, dt_atividade, nm_usuario_exec, nr_seq_funcao, cd_grupo, ds_usuario_exec, cd_cargo, ds_cargo, cd_setor_usuario, ds_setor_usuario, nr_sequencia, nr_seq_ordem_serv) AS SELECT 'Produtivas' ds_classif,
     c.ds_grupo, 
    SUBSTR(obter_desc_tipo_funcao(a.nr_seq_funcao),1,100) ds_tipo_funcao, 
    a.qt_minuto, 
    ((a.qt_minuto)/60) qt_horas, 
	round((obter_porc_trein('P'))::numeric,2) pr_classif, 
    a.dt_atividade, 
    obter_nome_usuario(a.nm_usuario_exec) nm_usuario_exec, 
    a.nr_seq_funcao, 
    c.nr_sequencia cd_grupo, 
    a.nm_usuario_exec, 
    SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_exec,'R'),1,255), 
    SUBSTR(obter_cargo_usuario(a.nm_usuario_exec),1,255), 
    SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_exec,'S'),1,255), 
    SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_exec,'DS'),1,255), 
    a.NR_SEQUENCIA, 
    a.NR_SEQ_ORDEM_SERV 
FROM  man_ordem_servico_v v, 
    man_ordem_serv_ativ a, 
    man_tipo_funcao b, 
    man_grupo_funcao c 
WHERE  v.nr_sequencia  = a.nr_seq_ordem_serv 
AND   a.nr_seq_funcao = b.nr_sequencia 
AND   b.nr_seq_grupo_funcao = c.nr_sequencia 
AND   c.nr_sequencia IN (2,4,6,11) 

UNION ALL
 
SELECT 'Apoio' ds_classif, 
     c.ds_grupo, 
    SUBSTR(obter_desc_tipo_funcao(a.nr_seq_funcao),1,100) ds_tipo_funcao, 
    a.qt_minuto, 
    ((a.qt_minuto)/60) qt_horas, 
	 round((obter_porc_trein('A'))::numeric,2) pr_classif, 
     a.dt_atividade, 
     obter_nome_usuario(a.nm_usuario_exec) nm_usuario_exec, 
     a.nr_seq_funcao, 
    c.nr_sequencia cd_grupo, 
    a.nm_usuario_exec, 
    SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_exec,'R'),1,255), 
    SUBSTR(obter_cargo_usuario(a.nm_usuario_exec),1,255), 
    SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_exec,'S'),1,255), 
    SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_exec,'DS'),1,255), 
    a.NR_SEQUENCIA, 
    a.NR_SEQ_ORDEM_SERV 
FROM man_ordem_servico_v v, 
   man_ordem_serv_ativ a, 
   man_tipo_funcao b, 
   man_grupo_funcao c 
WHERE v.nr_sequencia  = a.nr_seq_ordem_serv 
AND  a.nr_seq_funcao = b.nr_sequencia 
AND   b.nr_seq_grupo_funcao = c.nr_sequencia 
AND  c.nr_sequencia IN (7,8,9) 

UNION ALL
 
SELECT 'Treinamento - Capacitação do Instrutor' ds_classif, 
    c.ds_grupo, 
    SUBSTR(obter_desc_tipo_funcao(a.nr_seq_funcao),1,100) ds_tipo_funcao, 
    a.qt_minuto, 
    ((a.qt_minuto)/60) qt_horas, 
	round((obter_porc_trein('T'))::numeric,2) pr_classif, 
    a.dt_atividade, 
    obter_nome_usuario(a.nm_usuario_exec) nm_usuario_exec, 
    a.nr_seq_funcao, 
    c.nr_sequencia cd_grupo, 
    a.nm_usuario_exec, 
    SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_exec,'R'),1,255), 
    SUBSTR(obter_cargo_usuario(a.nm_usuario_exec),1,255), 
    SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_exec,'S'),1,255), 
    SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_exec,'DS'),1,255), 
    a.NR_SEQUENCIA, 
    a.NR_SEQ_ORDEM_SERV 
FROM man_ordem_servico_v v, 
   man_ordem_serv_ativ a, 
   man_tipo_funcao b, 
   man_grupo_funcao c 
WHERE v.nr_sequencia  = a.nr_seq_ordem_serv 
AND  a.nr_seq_funcao = b.nr_sequencia 
AND   b.nr_seq_grupo_funcao = c.nr_sequencia 
AND  c.nr_sequencia IN (10) 

UNION ALL
 
SELECT 'Administrativo' ds_classif, 
    c.ds_grupo, 
    SUBSTR(obter_desc_tipo_funcao(a.nr_seq_funcao),1,100) ds_tipo_funcao, 
    a.qt_minuto, 
    ((a.qt_minuto)/60) qt_horas, 
	round((obter_porc_trein('ADM'))::numeric,2) pr_classif, 
    a.dt_atividade, 
    obter_nome_usuario(a.nm_usuario_exec) nm_usuario_exec, 
    a.nr_seq_funcao, 
    c.nr_sequencia cd_grupo, 
    a.nm_usuario_exec, 
    SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_exec,'R'),1,255), 
    SUBSTR(obter_cargo_usuario(a.nm_usuario_exec),1,255), 
    SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_exec,'S'),1,255), 
    SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_exec,'DS'),1,255), 
    a.NR_SEQUENCIA, 
    a.NR_SEQ_ORDEM_SERV 
FROM man_ordem_servico_v v, 
   man_ordem_serv_ativ a, 
   man_tipo_funcao b, 
   man_grupo_funcao c 
WHERE v.nr_sequencia  = a.nr_seq_ordem_serv 
AND  a.nr_seq_funcao = b.nr_sequencia 
AND   b.nr_seq_grupo_funcao = c.nr_sequencia 
AND  c.nr_sequencia IN (5,13);

