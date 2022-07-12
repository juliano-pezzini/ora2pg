-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW medicamentos_pend_entrega_v (ds_material, ds_unidade, ds_prof_solicitante, ds_tempo_dia, dt_atualizacao_nrec, dt_liberacao, dt_lib_material, dt_lib_farmacia, dt_lib_enfermagem) AS select 	ds_material,
	ds_unidade,
	ds_prof_solicitante,
	ds_tempo_dia,
	dt_atualizacao_nrec,
	dt_liberacao,
	dt_lib_material,
	dt_lib_farmacia,
	dt_lib_enfermagem
FROM (select 	substr(c.ds_material,1,255) ds_material,
		substr(obter_nome_estabelecimento(a.cd_estabelecimento), 1, 255) ds_unidade,
		substr(obter_nome_pf(a.cd_medico), 1, 255) ds_prof_solicitante,
		cast((coalesce(b.dt_liberacao, coalesce(b.dt_lib_material, coalesce(b.dt_lib_farmacia, b.dt_lib_enfermagem))) - b.dt_atualizacao_nrec) as number(10,2)) ds_tempo_dia,
		b.dt_atualizacao_nrec dt_atualizacao_nrec,
		b.dt_liberacao dt_liberacao,
		b.dt_lib_material dt_lib_material,
		b.dt_lib_farmacia dt_lib_farmacia,
		b.dt_lib_enfermagem dt_lib_enfermagem
	from   	prescr_medica a,
	       	prescr_material b,
	       	material c
	where  	a.nr_prescricao = b.nr_prescricao
	and 	b.cd_material = c.cd_material) alias11;
