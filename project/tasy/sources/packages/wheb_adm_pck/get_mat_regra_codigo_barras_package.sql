-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION wheb_adm_pck.get_mat_regra_codigo_barras () RETURNS bigint AS $body$
BEGIN
	if (current_setting('wheb_adm_pck.nr_seq_mat_regra_barra_w')::coalesce(bigint::text, '') = '') then
		CALL wheb_adm_pck.set_mat_regra_codigo_barras(current_setting('wheb_adm_pck.cd_estabelecimento_w')::smallint);
	end if;

	return current_setting('wheb_adm_pck.nr_seq_mat_regra_barra_w')::bigint;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION wheb_adm_pck.get_mat_regra_codigo_barras () FROM PUBLIC;