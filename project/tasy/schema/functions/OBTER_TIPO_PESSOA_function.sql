-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_pessoa ( cd_pessoa_fisica_p text) RETURNS bigint AS $body$
DECLARE


ie_tipo_pessoa_w			smallint	:= 0;
ie_funcionario_w			varchar(01);



BEGIN

select coalesce(max(1),0)
into STRICT 	ie_tipo_pessoa_w
from	Medico
where	cd_pessoa_fisica	= cd_pessoa_fisica_p;

if (ie_tipo_pessoa_w = 0) then
	begin
	select coalesce(ie_funcionario,'N'),
		 ie_tipo_pessoa
	into STRICT	ie_funcionario_w,
		ie_tipo_pessoa_w
	from 	pessoa_fisica
	where cd_pessoa_fisica	= cd_pessoa_fisica_p;
	if (ie_funcionario_w = 'S') or (ie_tipo_pessoa_w	= 3) then
		ie_tipo_pessoa_w	:= 3;
	end if;
	end;
end if;

RETURN ie_tipo_pessoa_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_pessoa ( cd_pessoa_fisica_p text) FROM PUBLIC;

