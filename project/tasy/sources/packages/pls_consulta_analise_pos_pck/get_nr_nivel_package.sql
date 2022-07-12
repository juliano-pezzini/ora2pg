-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_consulta_analise_pos_pck.get_nr_nivel () RETURNS bigint AS $body$
BEGIN
		return current_setting('pls_consulta_analise_pos_pck.nr_nivel_w')::bigint;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_consulta_analise_pos_pck.get_nr_nivel () FROM PUBLIC;
