-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION is_user_exists ( nm_usuario_p text) RETURNS varchar AS $body$
DECLARE

				
nm_usuario_w		varchar(2);


BEGIN
	if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
		select (CASE WHEN (max(nm_usuario) IS NOT NULL AND (max(nm_usuario))::text <> '') THEN 'S' ELSE 'N' END)
		into STRICT   nm_usuario_w
		from   usuario
		where  nm_usuario = nm_usuario_p;	
	end if;

	return nm_usuario_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION is_user_exists ( nm_usuario_p text) FROM PUBLIC;
