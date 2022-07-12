-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW conta_contabil_localizador_v (cd_conta_contabil, ds_conta_contabil, ie_situacao, ie_tipo, cd_classificacao, cd_classif, cd_grupo, cd_empresa, cd_classif_superior, ds_conta_apres, ie_nivel, ie_classif_superior, cd_classif_sup, ds_localizador) AS select	a.cd_conta_contabil,
	a.ds_conta_contabil,
	a.ie_situacao,
	a.ie_tipo,
	a.cd_classificacao_atual cd_classificacao,
	a.cd_classificacao_atual cd_classif,
	a.cd_grupo,
	a.cd_empresa,
	a.cd_classif_superior,
	substr(lpad('  ', 5 *(substr(obter_classif_ctb(a.cd_classificacao_atual,'NIVEL'),1,3) -1))||ds_conta_contabil,1,254) ds_conta_apres,
	substr(obter_classif_ctb(a.cd_classificacao_atual,'NIVEL'),1,3) ie_nivel,
	substr(obter_classif_ctb(a.cd_classificacao_atual,'SUPERIOR'),1,120) ie_classif_superior,
	a.cd_classif_superior_atual cd_classif_sup,
	cd_classificacao_atual || ' - ' || a.cd_conta_contabil || ' - ' || ds_conta_contabil ds_localizador
FROM	conta_contabil a
where	a.ie_situacao = 'A';
