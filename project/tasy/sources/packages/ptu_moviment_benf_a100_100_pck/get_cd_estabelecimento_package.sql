-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ptu_moviment_benf_a100_100_pck.get_cd_estabelecimento () RETURNS bigint AS $body$
BEGIN
		return current_setting('ptu_moviment_benf_a100_100_pck.cd_estabelecimento_w')::bigint;
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_moviment_benf_a100_100_pck.get_cd_estabelecimento () FROM PUBLIC;
