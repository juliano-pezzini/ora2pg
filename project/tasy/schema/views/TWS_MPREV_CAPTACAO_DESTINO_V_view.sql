-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tws_mprev_captacao_destino_v (nr_sequencia, dt_atualizacao, nr_seq_captacao, nr_seq_programa, nr_seq_campanha) AS select	nr_sequencia,
	dt_atualizacao,
	nr_seq_captacao,
	nr_seq_programa,
	nr_seq_campanha
FROM 	mprev_captacao_destino;

