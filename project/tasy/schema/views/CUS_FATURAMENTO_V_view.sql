-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cus_faturamento_v (cd_estabelecimento, dt_referencia, cd_centro_controle, qt_distribuicao) AS select	a.cd_estabelecimento,
	a.dt_mesano_referencia dt_referencia, 
	b.cd_centro_custo cd_centro_controle, 
	count(distinct(a.nr_atendimento)) qt_distribuicao 
FROM	setor_atendimento b, 
	conta_paciente_status_v a 
where	a.cd_setor_atendimento	= b.cd_setor_atendimento 
and	a.qt_exclusao_conta	= 0 
and	a.nr_seq_protocolo is not null 
group by	a.cd_estabelecimento, 
	a.dt_mesano_referencia, 
	b.cd_centro_custo 
order by 1,2;

