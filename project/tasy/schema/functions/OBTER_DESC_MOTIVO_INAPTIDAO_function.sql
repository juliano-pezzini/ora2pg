-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_motivo_inaptidao (cd_motivo_inaptidao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_motivo_w		varchar(80);


BEGIN

if (cd_motivo_inaptidao_p IS NOT NULL AND cd_motivo_inaptidao_p::text <> '') then
	begin

	select	ds_motivo_inaptidao
	into STRICT	ds_motivo_w
	from	san_motivo_inaptidao
	where	nr_sequencia	= cd_motivo_inaptidao_p
	and	ie_situacao 	= 'A';

	end;
end if;

return	ds_motivo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_motivo_inaptidao (cd_motivo_inaptidao_p bigint) FROM PUBLIC;

