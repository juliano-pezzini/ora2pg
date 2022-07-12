-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tws_pls_consulta_mprev_v (ie_indicacao, nr_seq_indicacao, ds_indicacao, nr_sequencia, nr_seq_captacao, dt_atualizacao) AS SELECT	'C' ie_indicacao,
	a.nr_seq_campanha nr_seq_indicacao,
	b.nm_campanha ds_indicacao,
	b.nr_sequencia,
	a.nr_seq_captacao,
	b.dt_atualizacao
FROM 	mprev_captacao_destino a,
	mprev_campanha b
WHERE 	a.nr_seq_campanha	= b.nr_sequencia

UNION

SELECT	'P' ie_indicacao,
	a.nr_seq_programa nr_seq_indicacao,
	b.nm_programa ds_indicacao,
	b.nr_sequencia,
	a.nr_seq_captacao,
	b.dt_atualizacao
FROM 	mprev_captacao_destino a,
	mprev_programa b
WHERE 	a.nr_seq_programa	= b.nr_sequencia

UNION

SELECT 'D' ie_indicacao,
	a.nr_seq_diagnostico_int nr_seq_indicacao,
	b.ds_diagnostico ds_indicacao,
	b.nr_sequencia,
	a.nr_seq_captacao,
	b.dt_atualizacao
FROM 	mprev_captacao_diagnostico a,
	diagnostico_interno b
WHERE 	a.nr_seq_diagnostico_int	= b.nr_sequencia;

