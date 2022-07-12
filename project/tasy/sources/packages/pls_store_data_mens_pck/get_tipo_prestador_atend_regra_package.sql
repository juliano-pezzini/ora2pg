-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_store_data_mens_pck.get_tipo_prestador_atend_regra () RETURNS varchar AS $body$
BEGIN
		return current_setting('pls_store_data_mens_pck.ie_tipo_prestador_atend_regr_w')::pls_mensalidade_grupo.ie_tipo_prestador_atend%type;
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_store_data_mens_pck.get_tipo_prestador_atend_regra () FROM PUBLIC;
