-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_usuario_upper ( nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


nm_completo_w	varchar(100);



BEGIN

select	ds_usuario
into STRICT	nm_completo_w
from	usuario
where	upper(nm_usuario)	= upper(nm_usuario_p);

return	nm_completo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_usuario_upper ( nm_usuario_p text) FROM PUBLIC;

