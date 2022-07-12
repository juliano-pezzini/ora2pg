-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cfps_municipio ( cd_estabelecimento_p bigint, cd_cgc_p text, cd_pessoa_fisica_p text, ds_municipio_p text, ie_tipo_nota_p text default '', cd_cgc_emitente_p text default '') RETURNS varchar AS $body$
DECLARE


qt_registro_w		bigint;
retorno_w		varchar(4);
ds_municipio_w		varchar(40);
sg_estado_w		pessoa_juridica.sg_estado%type;
cd_internacional_w	pessoa_juridica.cd_internacional%type;
cd_cgc_w		pessoa_juridica.cd_cgc%type;
cd_cgc_emitente_w	nota_fiscal.cd_cgc_emitente%type;
ie_tipo_nota_w		nota_fiscal.ie_tipo_nota%type;


BEGIN

select	count(*)
into STRICT	qt_registro_w
from	pessoa_juridica
where	cd_cgc = cd_cgc_p;

select	coalesce(ie_tipo_nota_p,'SE')
into STRICT	ie_tipo_nota_w
;

select	coalesce(cd_cgc_emitente_p,'0')
into STRICT	cd_cgc_emitente_w
;

if (qt_registro_w > 0) then

	if (upper(Elimina_Acentuacao(ds_municipio_p)) = 'FLORIANOPOLIS') then

		if (ie_tipo_nota_w in ('EN','EF','EP')) and (cd_cgc_emitente_w <> '0') then
			begin

			select	ds_municipio,
				coalesce(sg_estado,'X'),
				coalesce(cd_cgc,'0'),
				coalesce(cd_internacional,'0')
			into STRICT	ds_municipio_w,
				sg_estado_w,
				cd_cgc_w,
				cd_internacional_w
			from	pessoa_juridica
			where	cd_cgc = cd_cgc_emitente_w;

			if (sg_estado_w = 'X') then
				retorno_w:= '0000';
			elsif (sg_estado_w = 'SC')  then
				retorno_w:= '9302';
				if (upper(Elimina_Acentuacao(ds_municipio_w)) = 'FLORIANOPOLIS') then
					retorno_w:= '9301';
				end if;
			else
				retorno_w:= '9303';
			end if;

			if (cd_cgc_w = '0') and (cd_internacional_w <> '0') then
				begin
				retorno_w:= '9304';
				end;
			end if;

			end;
		else
			begin

			select	ds_municipio,
				coalesce(sg_estado,'X')
			into STRICT	ds_municipio_w,
				sg_estado_w
			from	pessoa_juridica
			where	cd_cgc = cd_cgc_p;

			if (sg_estado_w = 'X') then
				retorno_w:= '0000';
			elsif (sg_estado_w = 'IN')  then
				retorno_w:= '9204';
			elsif (sg_estado_w = 'SC')  then
				retorno_w:= '9202';

			if (upper(Elimina_Acentuacao(ds_municipio_w)) = 'FLORIANOPOLIS') then
				retorno_w:= '9201';
			end if;
			else
				retorno_w:= '9203';
			end if;

			end;
		end if;

	end if;

end if;

select	count(*)
into STRICT	qt_registro_w
from	pessoa_fisica a,
	compl_pessoa_fisica b
where	a.cd_pessoa_fisica = b.cd_pessoa_fisica
and	ie_tipo_complemento = 1
and	a.cd_pessoa_fisica = cd_pessoa_fisica_p;

if (qt_registro_w > 0) then

	if (upper(Elimina_Acentuacao(ds_municipio_p)) = 'FLORIANOPOLIS') then

		select	ds_municipio,
			coalesce(sg_estado,'X')
		into STRICT	ds_municipio_w,
			sg_estado_w
		from	pessoa_fisica a,
			compl_pessoa_fisica b
		where	a.cd_pessoa_fisica = b.cd_pessoa_fisica
		and	ie_tipo_complemento = 1
		and	a.cd_pessoa_fisica = cd_pessoa_fisica_p;

		if (sg_estado_w = 'X') then
			retorno_w:= '0000';
		elsif (sg_estado_w = 'IN')  then
			retorno_w:= '9204';
		elsif (sg_estado_w = 'SC')  then
			retorno_w:= '9202';
			if (upper(Elimina_Acentuacao(ds_municipio_w)) = 'FLORIANOPOLIS') then
				retorno_w:= '9201';
			end if;
		else
			retorno_w:= '9203';
		end if;

	end if;

end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cfps_municipio ( cd_estabelecimento_p bigint, cd_cgc_p text, cd_pessoa_fisica_p text, ds_municipio_p text, ie_tipo_nota_p text default '', cd_cgc_emitente_p text default '') FROM PUBLIC;
