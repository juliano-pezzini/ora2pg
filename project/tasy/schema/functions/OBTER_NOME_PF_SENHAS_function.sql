-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_pf_senhas (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);				
ie_tipo_nome_w		varchar(1);
ie_nome_oculto_w	varchar(1);
cd_pessoa_fisica_w	pessoa_fisica.cd_pessoa_fisica%type;
nm_paciente_w		paciente_senha_fila.nm_paciente%type;
nm_social_paciente_w	pessoa_fisica.nm_social%type;
nm_pessoa_fisica_w	pessoa_fisica.nm_pessoa_fisica%type;
nm_usuario_w		usuario.nm_usuario%type;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
cd_perfil_w		perfil.cd_perfil%type;


BEGIN

nm_usuario_w 		:= wheb_usuario_pck.get_nm_usuario;
cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;
cd_perfil_w		:= obter_perfil_ativo;

if (coalesce(nr_sequencia_p,0) > 0) then

	ie_tipo_nome_w := Obter_param_Usuario(10021, 65, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_tipo_nome_w);
	ie_nome_oculto_w := obter_param_Usuario(10021, 130, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_nome_oculto_w);

	select	max(b.cd_pessoa_fisica),
		max(a.nm_paciente),
		max(b.nm_social),
		max(SUBSTR(OBTER_NOME_PF(b.CD_PESSOA_FISICA), 0, 60))
	into STRICT	cd_pessoa_fisica_w,
		nm_paciente_w,
		nm_social_paciente_w,
		nm_pessoa_fisica_w
	from	paciente_senha_fila a,
		pessoa_fisica b
	where	a.nr_sequencia = nr_sequencia_p
	and	b.cd_pessoa_fisica = a.cd_pessoa_fisica;
	
	if (coalesce(cd_pessoa_fisica_w::text, '') = '') then
		select	substr(nm_paciente,1,60)
		into STRICT	nm_pessoa_fisica_w
		from	paciente_senha_fila
		where	nr_sequencia = nr_sequencia_p;
	end if;

	nm_pessoa_fisica_w	:= SUBSTR(coalesce(nm_social_paciente_w,nm_pessoa_fisica_w), 0, 60);
	if (ie_nome_oculto_w = 'S') then
		ds_retorno_w := substr(obter_nome_pf_oculta(cd_pessoa_fisica_w, cd_perfil_w, nm_usuario_w, nm_pessoa_fisica_w), 1, 200);
	else
		ds_retorno_w := nm_pessoa_fisica_w;
	end if;
		
	if (ie_tipo_nome_w in ('3','4')) then
		ds_retorno_w := substr(coalesce(pls_gerar_nome_abreviado(ds_retorno_w), ds_retorno_w),1,250);
	elsif (ie_tipo_nome_w = '5') then
		ds_retorno_w := substr(OBTER_INICIAIS_NOME_SENHAS(null,ds_retorno_w),1,250);
	end if;

end if;		

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_pf_senhas (nr_sequencia_p bigint) FROM PUBLIC;

