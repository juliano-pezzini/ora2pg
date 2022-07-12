-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_store_data_mens_pck.get_ie_geracao_valores () RETURNS varchar AS $body$
BEGIN
		return current_setting('pls_store_data_mens_pck.contrato_w')::pls_contrato%rowtype.ie_geracao_valores;
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_store_data_mens_pck.get_ie_geracao_valores () FROM PUBLIC;
