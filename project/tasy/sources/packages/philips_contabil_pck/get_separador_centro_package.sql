-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION philips_contabil_pck.get_separador_centro () RETURNS varchar AS $body$
BEGIN
		if (coalesce(current_setting('philips_contabil_pck.ie_sep_classif_centro_w')::empresa.ie_sep_classif_centro%type,'X') = 'X') then
			PERFORM set_config('philips_contabil_pck.ie_sep_classif_centro_w', '.', false);
		end if;

		return current_setting('philips_contabil_pck.ie_sep_classif_centro_w')::empresa.ie_sep_classif_centro%type;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION philips_contabil_pck.get_separador_centro () FROM PUBLIC;
