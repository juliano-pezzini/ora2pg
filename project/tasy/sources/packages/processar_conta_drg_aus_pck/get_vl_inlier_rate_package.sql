-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION processar_conta_drg_aus_pck.get_vl_inlier_rate () RETURNS bigint AS $body$
BEGIN
		return current_setting('processar_conta_drg_aus_pck.vl_inlier_rate_w')::drg_procedimento.vl_inlier_rate%type;
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION processar_conta_drg_aus_pck.get_vl_inlier_rate () FROM PUBLIC;
