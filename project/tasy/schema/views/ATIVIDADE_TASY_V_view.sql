-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW atividade_tasy_v (nr_sequencia, cd_atividade, dt_atualizacao, nm_usuario, dt_atividade, qt_minuto, nr_seq_ordem_serv, ds_observacao, dt_dia, dt_inicio_sem, dt_inicio_mes, nm_atividade, ds_titulo, nr_seq_projeto) AS select a.NR_SEQUENCIA,a.CD_ATIVIDADE,a.DT_ATUALIZACAO,a.NM_USUARIO,a.DT_ATIVIDADE,a.QT_MINUTO,a.NR_SEQ_ORDEM_SERV,a.DS_OBSERVACAO,
	trunc(a.dt_atividade, 'dd') dt_dia,
	trunc(a.dt_atividade, 'day') dt_inicio_sem,
	trunc(a.dt_atividade, 'month') dt_inicio_mes,
	b.ds_valor_dominio nm_atividade,
	c.ds_titulo,
	c.nr_seq_projeto
FROM	Ordem_servico_tasy c,
	Valor_dominio b,
	Atividade_tasy a
where a.nr_seq_ordem_serv 	= c.nr_sequencia
  and b.cd_dominio 		= 1029
  and b.vl_dominio		= a.cd_atividade;

