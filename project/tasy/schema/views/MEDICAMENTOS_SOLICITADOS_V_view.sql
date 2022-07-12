-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW medicamentos_solicitados_v (ds_unidade, ds_prof_solicitante, ds_medicamento, cd_quantidade, dt_periodo) AS select 	substr(obter_nome_estabelecimento(a.cd_estabelecimento), 1, 255) ds_unidade,
	substr(obter_nome_pf(a.cd_medico), 1, 255) ds_prof_solicitante,
	substr(obter_desc_material(b.cd_material), 1, 255) ds_medicamento,
	b.qt_material cd_quantidade,
	a.dt_inicio_prescr dt_periodo
FROM 	prescr_medica a,
	prescr_material b
where 	a.nr_prescricao = b.nr_prescricao;

