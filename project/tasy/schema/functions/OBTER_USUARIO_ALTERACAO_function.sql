-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_usuario_alteracao ( nm_usuario_p text) RETURNS varchar AS $body$
DECLARE
				
 
nm_usuario_alteracao_w	varchar(255);
				

BEGIN 
 
select	substr(obter_nome_usuario(nm_usuario_p), 1,255) 
into STRICT	nm_usuario_alteracao_w
;
 
 
if (coalesce(nm_usuario_alteracao_w::text, '') = '') then 
	begin 
		select	substr(pls_obter_dados_segurado((nm_usuario_p)::numeric , 'N'), 1,255) 
		into STRICT	nm_usuario_alteracao_w 
		;	
	exception 
	when others then 
		nm_usuario_alteracao_w := nm_usuario_p;
	end;
end if;
 
if (coalesce(nm_usuario_alteracao_w::text, '') = '') then 
	nm_usuario_alteracao_w := nm_usuario_p;
end if;
 
return	nm_usuario_alteracao_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_usuario_alteracao ( nm_usuario_p text) FROM PUBLIC;

