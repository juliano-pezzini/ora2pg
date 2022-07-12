-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cns_agendamento (cd_convenio_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(30);
ie_buscar_cns_sus_w	varchar(1);
cd_convenio_sus_w	integer;


BEGIN

select	coalesce(max(ie_buscar_cns_sus),'N')
into STRICT	ie_buscar_cns_sus_w
from	parametro_agenda
where	cd_estabelecimento = cd_estabelecimento_p;

if (ie_buscar_cns_sus_w = 'S') then
	select	max(cd_convenio_sus)
	into STRICT	cd_convenio_sus_w
	from	parametro_faturamento;

	if (cd_convenio_p = cd_convenio_sus_w) then
		select	max(nr_cartao_nac_sus)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cns_agendamento (cd_convenio_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
