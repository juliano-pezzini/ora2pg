-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW man_estagio_processo_v (nr_sequencia, ds_estagio, nr_seq_grupo_trab, nr_seq_grupo_planej, ie_situacao_os, ie_situacao, ie_acao, ie_nivel_solucao_cliente) AS select	a.nr_sequencia,
	substr(obter_desc_expressao(a.cd_exp_estagio,a.ds_estagio),1,40) ds_estagio,
	a.nr_seq_grupo_trab,
	a.nr_seq_grupo_planej,
	a.ie_situacao_os,
	a.ie_situacao,
	a.ie_acao,
	a.ie_nivel_solucao_cliente
FROM	man_estagio_processo a
where	not exists (	select 1
			from   man_grupo_planej_estagio x
			where  x.nr_seq_estagio = a.nr_sequencia)

union all

select	b.nr_seq_estagio,
	substr(obter_desc_expressao(a.cd_exp_estagio,a.ds_estagio),1,40) ds_estagio,
	a.nr_seq_grupo_trab,
	b.nr_seq_grupo_planej,
	a.ie_situacao_os,
	a.ie_situacao,
	a.ie_acao,
	a.ie_nivel_solucao_cliente
from	man_grupo_planej_estagio b,
	man_estagio_processo a
where	a.nr_sequencia = b.nr_seq_estagio
order by 2;

