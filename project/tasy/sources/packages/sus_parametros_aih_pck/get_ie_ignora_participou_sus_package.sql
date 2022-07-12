-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION sus_parametros_aih_pck.get_ie_ignora_participou_sus () RETURNS SUS_PARAMETROS_AIH.IE_IGNORA_PARTICIPOU_SUS%TYPE AS $body$
BEGIN
	return current_setting('sus_parametros_aih_pck.ie_ignora_participou_sus')::sus_parametros_aih.ie_ignora_participou_sus%type;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_parametros_aih_pck.get_ie_ignora_participou_sus () FROM PUBLIC;
