-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cus_pronto_socorro_v (cd_estabelecimento, dt_referencia, cd_centro_controle, qt_distribuicao) AS select	a.cd_estabelecimento,
	a.dt_referencia, 
	s.cd_centro_custo cd_centro_controle, 
	sum(nr_pacientes) qt_distribuicao 
FROM 	eis_pronto_socorro_v a, 
	setor_atendimento s 
where 	a.cd_setor_atendimento = s.cd_setor_atendimento 
group by	a.cd_estabelecimento, 
	a.dt_referencia, 
	s.cd_centro_custo;
