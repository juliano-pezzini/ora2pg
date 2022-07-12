-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_equipamento (cd_equipamento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(50);


BEGIN

select coalesce(max(ds_equipamento),0)
into STRICT	ds_retorno_w
from equipamento_lab
where cd_equipamento = cd_equipamento_p;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_equipamento (cd_equipamento_p bigint) FROM PUBLIC;

