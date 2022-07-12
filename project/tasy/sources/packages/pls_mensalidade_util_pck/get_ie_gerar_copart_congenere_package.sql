-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_mensalidade_util_pck.get_ie_gerar_copart_congenere () RETURNS varchar AS $body$
BEGIN
	return current_setting('pls_mensalidade_util_pck.pls_parametros_w')::pls_parametros%rowtype.ie_gerar_copart_congenere;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_mensalidade_util_pck.get_ie_gerar_copart_congenere () FROM PUBLIC;
