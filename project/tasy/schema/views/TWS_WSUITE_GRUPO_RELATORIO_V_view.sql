-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tws_wsuite_grupo_relatorio_v (nr_sequencia, dt_atualizacao, cd_grupo, cd_exp_relatorio, cd_exp_descricao) AS SELECT  nr_sequencia,
	dt_atualizacao,
	cd_grupo,
	cd_exp_relatorio,
	cd_exp_descricao
FROM wsuite_grupo_relatorio;

