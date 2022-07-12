-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION adep_obter_se_setor_proc_user (nm_usuario_p text, cd_setor_proced_p bigint) RETURNS varchar AS $body$
DECLARE


ie_setor_user_w	varchar(1) := 'S';


BEGIN

if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (cd_setor_proced_p IS NOT NULL AND cd_setor_proced_p::text <> '') then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_setor_user_w
	from	usuario_setor_v
	where	nm_usuario		= nm_usuario_p
	and	cd_setor_atendimento	= cd_setor_proced_p;

end if;

return ie_setor_user_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION adep_obter_se_setor_proc_user (nm_usuario_p text, cd_setor_proced_p bigint) FROM PUBLIC;

