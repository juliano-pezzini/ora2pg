-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_envia_sms_ata (nm_usuario_p text) RETURNS varchar AS $body$
DECLARE

				 
ie_enviar_sms_w		varchar(1);


BEGIN 
 
select 	coalesce(max('S'),'N') 
into STRICT	ie_enviar_sms_w 
from ( SELECT obter_cargo_usuario(nm_usuario) cargo 
		from 	usuario 
		where	nm_usuario = nm_usuario_p) alias3 
where (upper(cargo) like('%COORDENADOR%') 
or 		upper(cargo) like('%GERENTE%') 
or 		upper(cargo) like('%DIRETOR%'));
 
 
return	ie_enviar_sms_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_envia_sms_ata (nm_usuario_p text) FROM PUBLIC;
