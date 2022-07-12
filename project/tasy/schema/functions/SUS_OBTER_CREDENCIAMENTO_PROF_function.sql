-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_credenciamento_prof ( cd_profissional_p text, cd_convenio_p bigint, cd_cbo_p text) RETURNS varchar AS $body$
DECLARE


ie_credenciamento_w	varchar(3)	:= '0';
cd_estabelecimento_w	smallint 	:= coalesce(wheb_usuario_pck.get_cd_estabelecimento,0);


BEGIN

select	coalesce(max(ie_credenciamento),'0')
into STRICT	ie_credenciamento_w
from	sus_medico_credenciamento
where	cd_medico		= cd_profissional_p
and	coalesce(cd_cbo,coalesce(cd_cbo_p,'X'))	= coalesce(cd_cbo_p,'X')
and	coalesce(ie_situacao,'A') = 'A'
and	coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w;

if (ie_credenciamento_w	= '0') then
	begin
	select	coalesce(max(ie_tipo_servico_sus),'0')
	into STRICT	ie_credenciamento_w
	from	medico_convenio
	where	cd_pessoa_fisica	= cd_profissional_p
	and	cd_convenio	= cd_convenio_p;
	end;
end if;

return	ie_credenciamento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_credenciamento_prof ( cd_profissional_p text, cd_convenio_p bigint, cd_cbo_p text) FROM PUBLIC;
