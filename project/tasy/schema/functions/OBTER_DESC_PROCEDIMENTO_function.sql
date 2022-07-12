-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_procedimento (cd_procedimento_p bigint, ie_origem_proced_p bigint) RETURNS varchar AS $body$
DECLARE


ds_procedimento_w		PROCEDIMENTO.DS_PROCEDIMENTO%type;


BEGIN

if (coalesce(cd_procedimento_p::text, '') = '') then
	ds_procedimento_w := null;
else
	begin
	select 	ds_procedimento
	into STRICT 	ds_procedimento_w
	from 	procedimento
	where 	cd_procedimento = cd_procedimento_p
	  and 	ie_origem_proced = coalesce(ie_origem_proced_p,ie_origem_proced)  LIMIT 1;
	exception
		when others then
			ds_procedimento_w := null;
	end;
end if;
RETURN ds_procedimento_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_procedimento (cd_procedimento_p bigint, ie_origem_proced_p bigint) FROM PUBLIC;
