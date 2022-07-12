-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION gerar_int_dankia_pck.get_ie_local_dankia (cd_local_estoque_p bigint) RETURNS varchar AS $body$
BEGIN
		
		select	coalesce(max(ie_tipo_local),'0')
		into STRICT	current_setting('gerar_int_dankia_pck.ie_tipo_local_w')::local_estoque.ie_tipo_local%type
		from 	local_estoque
		where 	cd_local_estoque = cd_local_estoque_p;
		
		if (current_setting('gerar_int_dankia_pck.ie_tipo_local_w')::local_estoque.ie_tipo_local%type = '11') then
			PERFORM set_config('gerar_int_dankia_pck.ie_local_dankia', 'S', false);
		else
			PERFORM set_config('gerar_int_dankia_pck.ie_local_dankia', 'N', false);
		end if;

		return current_setting('gerar_int_dankia_pck.ie_local_dankia')::varchar(1);
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gerar_int_dankia_pck.get_ie_local_dankia (cd_local_estoque_p bigint) FROM PUBLIC;
