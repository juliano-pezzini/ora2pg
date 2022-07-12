-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION sus_obter_inco_ativa_pck.get_cd_inconsistencia () RETURNS SUS_INCONSISTENCIA.CD_INCONSISTENCIA%TYPE AS $body$
BEGIN
		return current_setting('sus_obter_inco_ativa_pck.cd_inconsistencia_w')::sus_inconsistencia.cd_inconsistencia%type;
	end;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_inco_ativa_pck.get_cd_inconsistencia () FROM PUBLIC;
