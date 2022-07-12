-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION philips_param_pck.get_param_funcao_usuario (vl_index_p bigint) RETURNS varchar AS $body$
BEGIN
		return	substr(current_setting('philips_param_pck.ds_parametro_w')::varchar(32000),(vl_index_p * 4000)+1,4000);
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION philips_param_pck.get_param_funcao_usuario (vl_index_p bigint) FROM PUBLIC;