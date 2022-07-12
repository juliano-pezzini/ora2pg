-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION sus_parametros_aih_pck.get_ie_transf_diag_interna_bpa () RETURNS SUS_PARAMETROS_AIH.IE_TRANSF_DIAG_INTERNA_BPA%TYPE AS $body$
BEGIN
	return current_setting('sus_parametros_aih_pck.ie_transf_diag_interna_bpa')::sus_parametros_aih.ie_transf_diag_interna_bpa%type;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_parametros_aih_pck.get_ie_transf_diag_interna_bpa () FROM PUBLIC;