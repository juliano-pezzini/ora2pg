-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_motivo_canc_agecons ( cd_motivo_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_motivo_w	varchar(255);
ds_retorno_w	varchar(255);


BEGIN
if (cd_motivo_p IS NOT NULL AND cd_motivo_p::text <> '') then
	select	max(ds_motivo)
	into STRICT	ds_motivo_w
	from	agenda_motivo_cancelamento
	where	cd_motivo	=	cd_motivo_p
	and	ie_agenda in ('C','T');
end if;

if (ie_opcao_p = 'D') then
	ds_retorno_w	:= ds_motivo_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_motivo_canc_agecons ( cd_motivo_p text, ie_opcao_p text) FROM PUBLIC;
