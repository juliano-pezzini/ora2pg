-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_motivo_atraso_pac ( cd_motivo_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_motivo_atraso_w	varchar(255);
ds_retorno_w		varchar(255);


BEGIN
if (cd_motivo_p IS NOT NULL AND cd_motivo_p::text <> '') then
	select	max(substr(ds_motivo,1,255))
	into STRICT	ds_motivo_atraso_w
	from	agenda_motivo_Atraso
	where	nr_sequencia		= cd_motivo_p
	and	cd_estabelecimento	= cd_estabelecimento_p
	and	ie_situacao	= 'A';
end if;
	ds_retorno_w	:= ds_motivo_atraso_w;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_motivo_atraso_pac ( cd_motivo_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

