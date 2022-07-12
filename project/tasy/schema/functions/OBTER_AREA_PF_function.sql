-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_area_pf ( cd_pessoa_fisica_p bigint) RETURNS bigint AS $body$
DECLARE


nr_retorno_w		bigint;


BEGIN
select	max(a.nr_seq_area)
into STRICT	nr_retorno_w
from	domicilio_familia a
where	a.cd_pessoa_fisica = cd_pessoa_fisica_p;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_area_pf ( cd_pessoa_fisica_p bigint) FROM PUBLIC;
