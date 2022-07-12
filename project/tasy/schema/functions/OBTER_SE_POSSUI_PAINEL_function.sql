-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_possui_painel ( nr_seq_indicador_p bigint, nm_usuario_p text, cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE


qt_registro_w	integer;


BEGIN

if	(cd_perfil_p IS NOT NULL AND cd_perfil_p::text <> '' AND cd_perfil_p <> 0 AND nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '' AND nm_usuario_p = 'x') then
	select	count(*)
	into STRICT	qt_registro_w
	from	indicador_gestao_usuario
	where	nr_seq_indicador	=	nr_seq_indicador_p
	and	cd_perfil		= 	cd_perfil_p;
else
	select	count(*)
	into STRICT	qt_registro_w
	from	indicador_gestao_usuario
	where	nr_seq_indicador	=	nr_seq_indicador_p
	and	nm_usuario		=	nm_usuario_p;
end if;

if (qt_registro_w > 0) then
	return 'S';
else
	return 'N';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_possui_painel ( nr_seq_indicador_p bigint, nm_usuario_p text, cd_perfil_p bigint) FROM PUBLIC;

