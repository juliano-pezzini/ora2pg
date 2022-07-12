-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cid_procedimento ( cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);
cd_doenca_cid_w	varchar(10);
cd_cid_secund_w	varchar(10);

/* ie_opcao_p
 - P - CID primário
 - S - CID secundário
*/
BEGIN

if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
	begin
	select	max(cd_doenca_cid),
		max(cd_cid_secundario)
	into STRICT	cd_doenca_cid_w,
		cd_cid_secund_w
	from	procedimento
	where	cd_procedimento 	= cd_procedimento_p
	and	ie_origem_proced	= ie_origem_proced_p;

	if (ie_opcao_p = 'P') then
		ds_retorno_w	:= cd_doenca_cid_w;
	elsif (ie_opcao_p = 'S') then
		ds_retorno_w	:= cd_cid_secund_w;
	end if;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cid_procedimento ( cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_opcao_p text) FROM PUBLIC;
