-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION sus_parametros_aih_pck.get_cd_medico_autorizador () RETURNS SUS_PARAMETROS_AIH.CD_MEDICO_AUTORIZADOR%TYPE AS $body$
BEGIN
	return current_setting('sus_parametros_aih_pck.cd_medico_autorizador')::sus_parametros_aih.cd_medico_autorizador%type;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_parametros_aih_pck.get_cd_medico_autorizador () FROM PUBLIC;
