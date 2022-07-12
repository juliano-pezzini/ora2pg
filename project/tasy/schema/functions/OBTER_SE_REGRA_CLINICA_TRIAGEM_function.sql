-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_regra_clinica_triagem ( ie_clinica_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 		varchar(1) := 'S';
cd_perfil_usuario_w		integer;
qt_reg_w			bigint;
cd_setor_usuario_w		integer;


BEGIN

cd_perfil_usuario_w	:= Obter_perfil_Ativo;
cd_setor_usuario_w	:= wheb_usuario_pck.get_cd_setor_atendimento;

select	count(*)
into STRICT	qt_reg_w
from	clinica_regra_triagem
where	ie_clinica = ie_clinica_p;

if (qt_reg_w	> 0) then
	select	count(*)
	into STRICT	qt_reg_w
	from	clinica_regra_triagem
	where	ie_clinica = ie_clinica_p
	and	coalesce(cd_perfil,cd_perfil_usuario_w)	= cd_perfil_usuario_w
	and	coalesce(cd_setor_atendimento,cd_setor_usuario_w)	= cd_setor_usuario_w;

	if (qt_reg_w	= 0) then
		ds_retorno_w	:= 'N';
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_regra_clinica_triagem ( ie_clinica_p bigint) FROM PUBLIC;
