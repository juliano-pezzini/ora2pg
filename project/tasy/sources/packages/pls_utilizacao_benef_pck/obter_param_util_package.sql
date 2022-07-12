-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_utilizacao_benef_pck.obter_param_util ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS PARAM_UTILIZACAO_BENEF AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Retorna os parametros da utilizacao configuraveis pela operadora
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atencao:
Alteracoes:
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_param_ret_w	param_utilizacao_benef;

BEGIN

select	max(a.nr_sequencia),
        max(a.dt_inicio_apresent),
        max(a.dt_fim_apresent),
        max(a.qt_dias_limite),
        max(coalesce(a.ie_reembolso, 'S')),
        max(coalesce(a.ie_acesso_titular,'1')),
	max(coalesce(a.ie_desconto_copartic, 'S')),
	max(coalesce(a.ie_apres_item_glosado, 'S')),
	max(coalesce(a.ie_tipo_prest_apres, 'P')),
	max((	select	count(1) contador
		from	pls_param_util_benef_glosa	x
		where	x.nr_seq_regra			= a.nr_sequencia ))
into STRICT	ds_param_ret_w.nr_sequencia,
	ds_param_ret_w.dt_inicio_apresent,
	ds_param_ret_w.dt_fim_apresent,
	ds_param_ret_w.qt_dias_limite,
	ds_param_ret_w.ie_reembolso,
	ds_param_ret_w.ie_acesso_titular,
	ds_param_ret_w.ie_desconto_copartic,
	ds_param_ret_w.ie_apres_item_glosado,
	ds_param_ret_w.ie_tipo_prest_apres,
	ds_param_ret_w.qt_glosas_cadastradas	
from	pls_param_util_benef	a
where	a.cd_estabelecimento = cd_estabelecimento_p;

return ds_param_ret_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_utilizacao_benef_pck.obter_param_util ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;