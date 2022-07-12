-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_mensalidade_util_pck.get_ie_mes_reaj_faixa_etaria (ie_regulamentacao_p pls_plano.ie_regulamentacao%type) RETURNS varchar AS $body$
BEGIN
if (ie_regulamentacao_p = 'R') then
	return pls_mensalidade_util_pck.get_ie_mes_cobranca_reaj();
else
	return pls_mensalidade_util_pck.get_ie_mes_cobranca_reaj_reg();
end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_mensalidade_util_pck.get_ie_mes_reaj_faixa_etaria (ie_regulamentacao_p pls_plano.ie_regulamentacao%type) FROM PUBLIC;