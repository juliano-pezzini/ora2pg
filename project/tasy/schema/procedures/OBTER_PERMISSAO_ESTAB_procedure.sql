-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_permissao_estab (nm_usuario_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint, cd_empresa_p INOUT bigint, ds_erro_p INOUT text) AS $body$
DECLARE


/* Cuidado ao alterar esta procedure, ela é usada no componente paciente */

cont_w		integer;
ds_erro_w	varchar(254);
cd_empresa_w	integer;


BEGIN
cd_empresa_w	:= null;
ds_erro_w	:= '';

select	count(*)
into STRICT	cont_w
from (
	SELECT	1
	from	usuario_estabelecimento
	where	nm_usuario_param	= nm_usuario_p
	and	cd_estabelecimento	= cd_estabelecimento_p
	
union

	SELECT	1
	from	usuario
	where	nm_usuario	= nm_usuario_p
	and	cd_estabelecimento	= cd_estabelecimento_p) alias1;

if (cont_w > 0) then
	select	count(*)
	into STRICT	cont_w
	from	perfil
	where	cd_perfil		= cd_perfil_p
	and	coalesce(cd_estabelecimento, cd_estabelecimento_p)	= cd_estabelecimento_p;
	if (cont_w > 0) then
		select	max(cd_empresa)
		into STRICT	cd_empresa_w
		from	Usuario_estabelecimento_v
		where	nm_usuario 		= nm_usuario_p
		and	cd_estabelecimento	= cd_estabelecimento_p;
	else
		ds_erro_w	:= WHEB_MENSAGEM_PCK.get_texto(279415,null);
	end if;
else
	ds_erro_w	:= WHEB_MENSAGEM_PCK.get_texto(279418,null);
end if;

cd_empresa_p	:= cd_empresa_w;
ds_erro_p	:= ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_permissao_estab (nm_usuario_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint, cd_empresa_p INOUT bigint, ds_erro_p INOUT text) FROM PUBLIC;
