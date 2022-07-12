-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_dieta ( cd_dieta_p bigint, ie_opcao_p text, cd_perfil_p bigint, cd_setor_P bigint, nm_usuario_p text, cd_convenio_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w	varchar(4000);
cont_w			bigint;

-- I  - Descricao indicacao 
-- N  - Nome dieta 
-- T  - Tipo dieta 
-- J  - Jejum 
-- O  - Obriga quantidade 
-- NC - Nome Curto 
-- SIT - Situacao dieta 
-- OJ Obriga justificativa 
 

BEGIN 
 
if (ie_opcao_p = 'I') then 
	select	ds_indicacao 
	into STRICT	ds_retorno_w 
	from 	dieta 
	where	cd_dieta	= cd_dieta_p;	
elsif (ie_opcao_p = 'N') then 
	select	nm_dieta 
	into STRICT	ds_retorno_w 
	from 	dieta 
	where	cd_dieta	= cd_dieta_p;
elsif (ie_opcao_p = 'T') then 
	select	ie_tipo_dieta 
	into STRICT	ds_retorno_w 
	from	dieta 
	where	cd_dieta	= cd_dieta_p;
elsif (ie_opcao_p = 'J') then 
	select	ie_jejum 
	into STRICT	ds_retorno_w 
	from	dieta 
	where	cd_dieta	= cd_dieta_p;
elsif (ie_opcao_p = 'O') then 
	select	ie_obriga_qt 
	into STRICT	ds_retorno_w 
	from	dieta 
	where	cd_dieta	= cd_dieta_p;
elsif (ie_opcao_p = 'NC') then 
	select	max(nm_curto) 
	into STRICT	ds_retorno_w 
	from	dieta 
	where	cd_dieta	= cd_dieta_p;
elsif (ie_opcao_p = 'SIT') then 
	select	ie_situacao 
	into STRICT	ds_retorno_w 
	from	dieta 
	where	cd_dieta	= cd_dieta_p;
elsif (ie_opcao_p = 'OJ') then 
	 
	select 	count(nr_sequencia) 
	into STRICT	cont_w 
	from	dieta_perfil 
	where	cd_dieta = cd_dieta_p;
	 
	select	ie_obriga_justif 
	into STRICT	ds_retorno_w 
	from	dieta 
	where	cd_dieta	= cd_dieta_p;
	 
	if (cont_w > 0) then 
		ds_retorno_w := obter_se_dieta_perfil(cd_perfil_p,cd_setor_P,cd_dieta_p,nm_usuario_p,cd_convenio_p,'J',ds_retorno_w);
	end if;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_dieta ( cd_dieta_p bigint, ie_opcao_p text, cd_perfil_p bigint, cd_setor_P bigint, nm_usuario_p text, cd_convenio_p bigint) FROM PUBLIC;
