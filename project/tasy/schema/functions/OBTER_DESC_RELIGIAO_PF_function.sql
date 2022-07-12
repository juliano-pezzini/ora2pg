-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_religiao_pf ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


cd_religiao_w	bigint;
ds_religiao_w	varchar(40) := '';

BEGIN
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	begin
	select	cd_religiao
	into STRICT	cd_religiao_w
	from	pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;

	if (cd_religiao_w IS NOT NULL AND cd_religiao_w::text <> '') then
		begin
		select	ds_religiao
		into STRICT	ds_religiao_w
		from	religiao
		where	cd_religiao = cd_religiao_w;
		end;
	end if;
	end;
end if;
return ds_religiao_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_religiao_pf ( cd_pessoa_fisica_p text) FROM PUBLIC;

