-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tws_pls_requisicao_diag_v (nr_sequencia, cd_doenca, dt_atualizacao, ie_indicacao_acidente, ie_tipo_doenca, nr_seq_requisicao, ie_classificacao, ie_unidade_tempo, qt_tempo) AS SELECT 	nr_sequencia,
		cd_doenca,
		dt_atualizacao,
		ie_indicacao_acidente,
		ie_tipo_doenca,
		nr_seq_requisicao,
		ie_classificacao,
		ie_unidade_tempo,
		qt_tempo
FROM pls_requisicao_diagnostico;
