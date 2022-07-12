-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW funcao_gerencia_nhmcg_v (nr_seq_gerencia, ds_gerencia, cd_gerente, nr_seq_grupo_desenv, ds_grupo_desenv, cd_funcao, ds_funcao, ie_situacao_funcao) AS select	g.nr_sequencia nr_seq_gerencia,
	g.ds_gerencia,
	g.cd_responsavel cd_gerente,
	gd.nr_sequencia nr_seq_grupo_desenv,
	gd.ds_grupo ds_grupo_desenv,
	fg.cd_funcao,
	f.ds_funcao,
	f.ie_situacao ie_situacao_funcao
FROM 	funcao f,
	funcao_grupo_des fg,
	grupo_desenvolvimento gd,
	gerencia_wheb g
where 	f.cd_funcao = fg.cd_funcao
and 	fg.nr_seq_grupo = gd.nr_sequencia
and 	gd.nr_seq_gerencia = g.nr_sequencia
and	g.nr_sequencia in (3,11)
and	((f.IE_SITUACAO_SWING <> 'I') or (f.cd_funcao in (8055,9901,9902)))
and	f.IE_SITUACAO <> 'I'
and	f.ds_aplicacao not in ('TasyRel','TasyGer')
and 	not exists (select 1 from PROJ_CRON_ETAPA  a
		   where NR_SEQ_CRONOGRAMA in (3842, 3838)
		   and cd_funcao is not null
		   and ie_etapa_exec_desenv = 'F'
		   and upper(a.cd_funcao) = (f.cd_funcao));

