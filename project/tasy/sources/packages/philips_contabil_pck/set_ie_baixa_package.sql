-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE philips_contabil_pck.set_ie_baixa (ie_baixa_p titulo_receber_liq.ie_lib_caixa%type) AS $body$
BEGIN
        	PERFORM set_config('philips_contabil_pck.ie_baixa_w', ie_baixa_p, false);
        END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE philips_contabil_pck.set_ie_baixa (ie_baixa_p titulo_receber_liq.ie_lib_caixa%type) FROM PUBLIC;
