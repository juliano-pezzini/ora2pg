-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_locale_estabelecimento () RETURNS varchar AS $body$
DECLARE

ds_locale_w 	establishment_locale.ds_locale%type;

BEGIN

select	max(ds_locale)
into STRICT	ds_locale_w
from	establishment_locale
where	cd_estabelecimento = coalesce(wheb_usuario_pck.get_cd_estabelecimento, 1);

if (coalesce(ds_locale_w::text, '') = '') then
	ds_locale_w := PKG_I18N.get_estab_locale;
end if;


return ds_locale_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_locale_estabelecimento () FROM PUBLIC;

