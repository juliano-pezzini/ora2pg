-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_valor_fluxo_caixa ( cd_empresa_p fluxo_caixa.cd_empresa%type, cd_estabelecimento_p fluxo_caixa.cd_estabelecimento%type, dt_referencia_p fluxo_caixa.dt_referencia%type, cd_conta_financ_p fluxo_caixa.cd_conta_financ%type, ie_classif_fluxo_p fluxo_caixa.ie_classif_fluxo%type, ie_periodo_p fluxo_caixa.ie_periodo%type, ie_integracao_p fluxo_caixa.ie_integracao%type, vl_fluxo_p fluxo_caixa.vl_fluxo%type) AS $body$
BEGIN
update	fluxo_caixa
set	vl_fluxo = vl_fluxo_p
where	cd_empresa = cd_empresa_p
and	cd_estabelecimento = cd_estabelecimento_p
and	dt_referencia = dt_referencia_p
and	cd_conta_financ = cd_conta_financ_p
and	ie_classif_fluxo = ie_classif_fluxo_p
and	ie_periodo = ie_periodo_p
and	ie_integracao = ie_integracao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_valor_fluxo_caixa ( cd_empresa_p fluxo_caixa.cd_empresa%type, cd_estabelecimento_p fluxo_caixa.cd_estabelecimento%type, dt_referencia_p fluxo_caixa.dt_referencia%type, cd_conta_financ_p fluxo_caixa.cd_conta_financ%type, ie_classif_fluxo_p fluxo_caixa.ie_classif_fluxo%type, ie_periodo_p fluxo_caixa.ie_periodo%type, ie_integracao_p fluxo_caixa.ie_integracao%type, vl_fluxo_p fluxo_caixa.vl_fluxo%type) FROM PUBLIC;

