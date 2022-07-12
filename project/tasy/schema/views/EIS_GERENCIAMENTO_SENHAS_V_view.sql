-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_gerenciamento_senhas_v (fila, nr_seq_atend, cd_senha_gerada, qt_tempo_espera, qt_min_dif, qt_min_atend, dt_inutilizacao, ie_esta_meta, nr_seq_fila, dt_inicio_atendimento, dt_fim_atendimento, dt_geracao_senha, dt_entrada_fila, qt_tempo_medio_esp_atual, nm_usuario, nm_usuario_inicio, dt_primeira_chamada, nr_sequencia, nr_seq_fila_espera, qt_tempo_maximo, ds_fila, nm_fila, nm_usuario_fim, ds_local, ds_maquina_chamada, nr_senha_atend, dt_fim_atend_atends_senha, nr_seq_fila_espera_atend, dt_saida_fila) AS select	b.nr_sequencia fila,
	d.nr_sequencia nr_seq_atend,
	SUBSTR(obter_letra_verifacao_senha(coalesce(a.nr_seq_fila_senha_origem, a.nr_seq_fila_senha)), 1, 10) || a.cd_senha_gerada cd_senha_gerada,
	SUBSTR(coalesce(OBTER_MIN_ENTRE_DATAS(A.DT_ENTRADA_FILA, DT_PRIMEIRA_CHAMADA, 1), 0), 1, 10) qt_tempo_espera,
	SUBSTR(coalesce(obter_min_entre_datas(a.dt_entrada_fila, LOCALTIMESTAMP, 1), 0), 1, 30) qt_min_dif,
	SUBSTR(coalesce(obter_min_entre_datas(a.dt_primeira_chamada, a.dt_fim_atendimento, 1), 0), 1, 30) qt_min_atend,
	a.dt_inutilizacao,
	obter_dentro_meta(obter_min_entre_datas(a.dt_inicio_atendimento, a.dt_fim_Atendimento, 1), b.qt_tempo_maximo) ie_esta_meta,
	a.nr_seq_fila_senha nr_seq_fila,
	a.dt_inicio_atendimento,
	a.dt_fim_atendimento,
	a.dt_geracao_senha,
	a.dt_entrada_fila,
	obter_min_entre_datas(a.dt_entrada_fila, LOCALTIMESTAMP,1) qt_tempo_medio_esp_atual,
	a.nm_usuario,
	d.nm_usuario_inicio,
	a.dt_primeira_chamada,
	a.nr_sequencia,
	b.nr_sequencia nr_seq_fila_espera,
	b.qt_tempo_maximo,
	b.ds_fila,
	OBTER_DESC_FILA(b.nr_sequencia) nm_fila,
	d.nm_usuario_fim nm_usuario_fim,
	obter_desc_local_senha(d.NR_SEQ_LOCAL_CHAMADA) ds_local,
	a.ds_maquina_chamada,
	a.nr_sequencia nr_senha_atend,
	d.dt_fim_atendimento dt_fim_atend_atends_senha,
	d.NR_SEQ_FILA_ESPERA nr_seq_fila_espera_atend,
	(select max(coalesce(dt_saida, LOCALTIMESTAMP))
	FROM 	MOVIMENTACAO_SENHA_FILA C
	where 	C.nr_seq_fila_espera = b.nr_sequencia
	AND	C.NR_SEQ_PAC_SENHA_FILA = a.nr_sequencia
	and C.nr_sequencia = (select max(x.nr_sequencia) from MOVIMENTACAO_SENHA_FILA x where x.nr_seq_fila_espera = b.nr_sequencia and x.NR_SEQ_PAC_SENHA_FILA = a.nr_sequencia)) dt_saida_fila
FROM fila_espera_senha b, paciente_senha_fila a
LEFT OUTER JOIN atendimentos_senha d ON (a.nr_sequencia = d.nr_seq_pac_senha_fila);

