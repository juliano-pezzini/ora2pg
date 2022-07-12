-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_outro_tasy_aberto (nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(64);
nm_maquina_w	varchar(64);
osuser_w	varchar(30);


BEGIN

select	machine,
	osuser
into STRICT	nm_maquina_w,
	osuser_w
from	v$session
where	audsid = userenv('sessionid');

select	max(machine)
into STRICT	ds_retorno_w
from	v$session
where	audsid <> userenv('sessionid')
and	( (machine <> nm_maquina_w) or (machine = nm_maquina_w and osuser <> osuser_w) )
and	upper(client_info) like 'USER='||Upper(nm_usuario_p)||';%';

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_outro_tasy_aberto (nm_usuario_p text) FROM PUBLIC;

