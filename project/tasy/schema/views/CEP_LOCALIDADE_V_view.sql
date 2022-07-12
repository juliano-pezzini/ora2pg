-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cep_localidade_v (nr_localidade, nm_localidade, cd_cep, ds_uf, nm_localidade_sem_acento) AS select	a.nr_sequencia nr_localidade,
	a.nm_localidade,
	a.cd_cep,
	a.ds_uf,
	Elimina_Acentuacao(a.nm_localidade) nm_localidade_sem_acento
FROM	cep_loc a,
	funcao_parametro b
where	b.cd_funcao	= 0
and	b.nr_sequencia	= 25
and	coalesce(b.vl_parametro, b.vl_parametro_padrao) = 'S'

union

select	a.nr_localidade,
	a.nm_localidade,
	a.cd_localidade,
	a.cd_unidade_federacao,
	Elimina_Acentuacao(a.nm_localidade) nm_localidade_sem_acento
from	cep_localidade a,
	funcao_parametro b
where	b.cd_funcao	= 0
and	b.nr_sequencia	= 25
and	coalesce(b.vl_parametro, b.vl_parametro_padrao) = 'N';
