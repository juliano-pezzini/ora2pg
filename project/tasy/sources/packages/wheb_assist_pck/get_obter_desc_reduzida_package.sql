-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION wheb_assist_pck.get_obter_desc_reduzida () RETURNS varchar AS $body$
BEGIN
		return wheb_assist_pck.obterparametrofuncao(924,374);
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION wheb_assist_pck.get_obter_desc_reduzida () FROM PUBLIC;
