-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_perf_html ( nm_usuario_p text, dt_selecionada_p timestamp, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

 
/* 
TEMPO_PREVISTO_PROJ 	- TEMPO DE OS's VINCULADAS A PROJETO PREVISTAS 
TEMPO_EXEC_ENTENDIMENTO - ENTENDIMENTO E VALIDACAO 
TEMPO_EXEC_SET_UP 		- TEMPO SET UP AMBIENTE 
TEMPO_EXEC_V_V 			- TEMPO DE PROGRAMAÇÃO GASTO NAS OSS'S DO VeV 
TEMPO_EXEC_DEV_LEAD 	- TEMPO EXECUTADO EM OS'S DE ATIVIDADES DEV LEAD 
TEMPO_ATIV_EXTRAS 		- TEMPO GASTO COM ATIVIDADES EXTRAS 
TEMPO_TOTAL_EXEC_DIA 	- TEMPO EXECUTADO EM TODAS OS + OUTRAS ATIVIDADES DUARANTE O DIA 
TEMPO_PERMANENCIA 		- TEMPO DE PERMANENCIA NA COMPANIA NO DIA 
*/
 
 
qt_retorno_w	double precision;


BEGIN 
 
--TEMPO PREVISTO DE OS'S VINCULADAS A PROJETO 
IF (ie_opcao_p = 'TEMPO_PREVISTO_PROJ') THEN 
	select 	coalesce(SUM(y.QT_MIN_PREV*(PR_ATIVIDADE/100)),0) QT_PREVISTO 
	INTO STRICT 	qt_retorno_w 
	from	MAN_ORDEM_ATIV_PREV y, 
			MAN_ORDEM_SERVICO a 
	where	a.nr_sequencia = y.NR_SEQ_ORDEM_SERV 
	AND 	nr_seq_proj_cron_etapa IN (	SELECT 	nr_sequencia 
										FROM	proj_cron_etapa 
										WHERE 	nr_seq_cronograma in (	SELECT	nr_sequencia 
																		FROM 	proj_cronograma 
																		WHERE 	(dt_aprovacao IS NOT NULL AND dt_aprovacao::text <> '') 
																		AND 	nr_seq_proj in (select nr_seq_proj from proj_projeto where NR_SEQ_GERENCIA = 86))) 
	AND 	y.nm_usuario_prev = nm_usuario_p 
	AND 	(y.DT_PREVISTA IS NOT NULL AND y.DT_PREVISTA::text <> '') 
	AND 	trunc(y.DT_PREVISTA) = trunc(dt_selecionada_p) 
	AND 	(y.NR_SEQ_ATIV_EXEC IS NOT NULL AND y.NR_SEQ_ATIV_EXEC::text <> '') 
	AND 	(y.QT_MIN_PREV IS NOT NULL AND y.QT_MIN_PREV::text <> '') 
	AND 	(y.IE_PRIORIDADE_DESEN IS NOT NULL AND y.IE_PRIORIDADE_DESEN::text <> '') 
	AND 	a.ds_dano_breve NOT LIKE '%Smoke Test%' 
	AND 	a.ds_dano_breve NOT LIKE '%Present Function to Programmer Team%'
 
	AND 	a.ds_dano_breve NOT LIKE '%Define Project Team%' 
	AND 	a.ds_dano_breve NOT LIKE '%Distribute Service Orders for Programmers%' 
	AND 	a.ds_dano_breve NOT LIKE '%Documentation - Create Script for Help Video (F1)%' 
	AND 	a.ds_dano_breve NOT LIKE '%Initial Development Completed (Ready to Test and development Clear%' 
	AND 	a.ds_dano_breve NOT LIKE '%Test Clearance%' 
	AND 	a.ds_dano_breve NOT LIKE '%Function Flow Review and Corrections%'
 
	AND 	a.nr_seq_equipamento <> 7100 
	AND 	a.cd_pessoa_solicitante <> '442';
	 
-- TEMPO EXECUTADO COM OS'S DO TIPO: ENTENDIMENTO E VALIDAÇÃO 
ELSIF (ie_opcao_p = 'TEMPO_EXEC_ENTENDIMENTO') THEN 
	SELECT	SUM(b.qt_minuto) QT_ENTENDIMENTO 
	INTO STRICT 	qt_retorno_w 
	FROM 	MAN_ORDEM_SERVICO a, 
			man_ordem_serv_ativ b 
	WHERE 	a.nr_sequencia = b.nr_seq_ordem_serv 
	AND		a.nr_seq_tipo_ordem = 206 
	AND 	b.nm_usuario_exec = nm_usuario_p 
	AND 	trunc(b.DT_ATIVIDADE) = trunc(dt_selecionada_p);
 
-- TEMPO EXECUTADO COM OS'S DO TIPO: SET-UP DE AMBIENTE	 
ELSIF (ie_opcao_p = 'TEMPO_EXEC_SET_UP') THEN 
	SELECT	SUM(b.qt_minuto) QT_SET_UP 
	INTO STRICT 	qt_retorno_w 
	FROM 	MAN_ORDEM_SERVICO a, 
			man_ordem_serv_ativ b 
	WHERE 	a.nr_sequencia = b.nr_seq_ordem_serv 
	AND		a.nr_seq_tipo_ordem = 205 
	AND 	b.nm_usuario_exec = nm_usuario_p 
	AND 	trunc(b.DT_ATIVIDADE) = trunc(dt_selecionada_p);
 
-- TEMPO EXECUTADO COM OS'S DO TIPO: VeV 
ELSIF (ie_opcao_p = 'TEMPO_EXEC_V_V') THEN 
	SELECT	SUM(b.qt_minuto) QT_V_V 
	INTO STRICT 	qt_retorno_w 
	FROM 	man_ordem_servico_v a, 
			man_ordem_serv_ativ b 
	WHERE 	a.nr_sequencia = b.nr_seq_ordem_serv 
	AND 	a.ds_dano_breve NOT LIKE '%Smoke Test%' 
	AND 	a.ds_dano_breve NOT LIKE '%Present Function to Programmer Team%'
 
	AND 	a.ds_dano_breve NOT LIKE '%Define Project Team%' 
	AND 	a.ds_dano_breve NOT LIKE '%Distribute Service Orders for Programmers%' 
	AND 	a.ds_dano_breve NOT LIKE '%Documentation - Create Script for Help Video (F1)%' 
	AND 	a.ds_dano_breve NOT LIKE '%Initial Development Completed (Ready to Test and development Clear%' 
	AND 	a.ds_dano_breve NOT LIKE '%Test Clearance%' 
	AND 	a.ds_dano_breve NOT LIKE '%Function Flow Review and Corrections%'
 
	AND (a.nr_seq_equipamento = 7100 OR a.cd_pessoa_solicitante = '442') 
	AND 	b.nm_usuario_exec = nm_usuario_p 
	AND 	trunc(b.DT_ATIVIDADE) = trunc(dt_selecionada_p);
 
-- TEMPO EXECUTADO COM OS'S DO TIPO: DEV_LEAD 
ELSIF (ie_opcao_p = 'TEMPO_EXEC_DEV_LEAD') THEN 
	SELECT	SUM(b.qt_minuto) QT_DEV_LEAD 
	INTO STRICT 	qt_retorno_w 
	FROM 	man_ordem_servico_v a, 
			man_ordem_serv_ativ b 
	WHERE 	a.nr_sequencia = b.nr_seq_ordem_serv 
	AND		a.nr_seq_tipo_ordem = 204 
	AND 	b.nm_usuario_exec = nm_usuario_p 
	AND 	trunc(b.DT_ATIVIDADE) = trunc(dt_selecionada_p);
 
-- TEMPO EXECUTADO EM OUTRAS ATIVIDADES (USUARIO CONTROLE) 
ELSIF (ie_opcao_p = 'TEMPO_ATIV_EXTRAS') THEN 
 
	select	SUM(QT_MINUTO) QT_OUTRAS_ATIVIDADES 
	INTO STRICT 	qt_retorno_w 
	from	USUARIO_ATIVIDADE z 
	where 	trunc(z.DT_ATIVIDADE) = trunc(dt_selecionada_p) 
	and 	z.NM_USUARIO = nm_usuario_p;
	 
-- TEMPO TOTAL EXECUTADO DURANTE O DIA 
ELSIF (ie_opcao_p = 'TEMPO_TOTAL_EXEC_DIA') THEN 
 
	select sum(qt_minuto) qt_minuto_total 
	INTO STRICT 	qt_retorno_w 	from ( 
								SELECT 	sum(b.qt_minuto) qt_minuto	 
								from	man_ordem_serv_ativ b	 
								where 	b.nm_usuario_exec = nm_usuario_p 
								and 	trunc(b.DT_ATIVIDADE) = trunc(dt_selecionada_p) 
								
union
 
								SELECT 	sum(coalesce(z.qt_minuto,0)) qt_minuto 							 
								from	USUARIO_ATIVIDADE z 							 
								where  trunc(z.DT_ATIVIDADE) = trunc(dt_selecionada_p) 							 
								and		z.nm_usuario = nm_usuario_p ) alias9;
 
-- TEMPO TOTAL PERMANENCIA NO DIA								 
ELSIF (ie_opcao_p = 'TEMPO_PERMANENCIA') THEN 
 
	select (QT_MIN_TOTAL - QT_MIN_LANCHE - QT_MIN_LANCHE) QT_MIN_TOTAL 
	INTO STRICT 	qt_retorno_w 
	from 	usuario_controle 
	where 	nm_usuario = nm_usuario_p 
	and 	trunc(dt_entrada) = trunc(dt_selecionada_p);
	 
END IF;
 
RETURN	qt_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_perf_html ( nm_usuario_p text, dt_selecionada_p timestamp, ie_opcao_p text) FROM PUBLIC;

