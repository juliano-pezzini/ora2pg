-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ctb_classif_centro_v (cd_estabelecimento, cd_classificacao, ds_classificacao, ds_classif_codigo, ds_codigo_classif, ie_situacao) AS select	cd_estabelecimento,
	cd_classificacao,
	min(ds_centro_custo) ds_classificacao,
	substr(min(ds_centro_custo) || ' ' || cd_classificacao,1,80) ds_classif_codigo,
	substr(cd_classificacao || ' '  || min(ds_centro_custo),1,80) ds_codigo_classif,
	a.ie_situacao
FROM	centro_custo a
where	cd_classificacao is not null
group by cd_estabelecimento,
	cd_classificacao,
	a.ie_situacao;
