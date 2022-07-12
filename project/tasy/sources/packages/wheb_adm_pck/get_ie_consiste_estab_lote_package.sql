-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION wheb_adm_pck.get_ie_consiste_estab_lote () RETURNS varchar AS $body$
BEGIN
	if (current_setting('wheb_adm_pck.ie_consiste_estab_lote_w')::coalesce(varchar(1)::text, '') = '') then
		CALL wheb_adm_pck.set_ie_consiste_estab_lote(current_setting('wheb_adm_pck.cd_estabelecimento_w')::smallint);
	end if;

	return current_setting('wheb_adm_pck.ie_consiste_estab_lote_w')::varchar(1);
	end;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION wheb_adm_pck.get_ie_consiste_estab_lote () FROM PUBLIC;
