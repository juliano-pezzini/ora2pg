-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_se_grupo_perm ( nr_Seq_grupo_p bigint, cd_perfil_p bigint, cd_pessoa_Fisica_p text, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1)	:= 'N';
qt_perm_Regra_w	integer;
qt_regra_w	integer;


BEGIN

select	count(*)
into STRICT	qt_regra_w
from	ageint_regra_perm_grupo
where	nr_seq_grupo	= nr_seq_grupo_p
and	ie_situacao	= 'A'
and	coalesce(cd_estabelecimento, cd_estabelecimento_p)	= cd_estabelecimento_p;

if (qt_regra_w	> 0) then
	select	count(*)
	into STRICT	qt_perm_Regra_w
	from	ageint_regra_perm_grupo
	where	nr_seq_grupo	= nr_seq_grupo_p
	and	coalesce(cd_pessoa_Fisica,cd_pessoa_fisica_p)	  = cd_pessoa_fisica_p
	and	coalesce(cd_perfil, cd_perfil_p)			  = cd_perfil_p
	and	coalesce(cd_setor_atendimento, cd_setor_atendimento_p) = cd_setor_atendimento_p
	and	ie_situacao			= 'A'
	and	coalesce(ie_perm_visualizar, 'S')	= 'S'
	and	coalesce(cd_estabelecimento, cd_estabelecimento_p)	= cd_estabelecimento_p;

	if (qt_perm_Regra_w > 0) then
		ds_retorno_w	:= 'S';
	end if;
else
	ds_Retorno_w	:= 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_se_grupo_perm ( nr_Seq_grupo_p bigint, cd_perfil_p bigint, cd_pessoa_Fisica_p text, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

