-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_cooperado ( cd_pessoa_fisica_p text, cd_cgc_p text) RETURNS varchar AS $body$
DECLARE


qt_registro_w		bigint	:= 0;
ie_retorno_w		varchar(1)	:= 'N';


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	select	count(*)
	into STRICT	qt_registro_w
	from	pls_cooperado a
	where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p
	and (a.dt_exclusao > clock_timestamp() or coalesce(a.dt_exclusao::text, '') = '');
elsif (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') then
	select	count(*)
	into STRICT	qt_registro_w
	from	pls_cooperado a
	where	a.cd_cgc	= cd_cgc_p
	and (a.dt_exclusao > clock_timestamp() or coalesce(a.dt_exclusao::text, '') = '');
end if;

if (qt_registro_w > 0) then
	ie_retorno_w	:= 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_cooperado ( cd_pessoa_fisica_p text, cd_cgc_p text) FROM PUBLIC;
