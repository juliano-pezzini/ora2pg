-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_municipio_pj ( cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_municipio_w	varchar(40);


BEGIN

select	max(ds_municipio)
into STRICT	ds_municipio_w
from	pessoa_juridica b,
	estabelecimento a
where	cd_estabelecimento = cd_estabelecimento_p
and	a.cd_cgc = b.cd_cgc;

return	ds_municipio_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_municipio_pj ( cd_estabelecimento_p bigint) FROM PUBLIC;
