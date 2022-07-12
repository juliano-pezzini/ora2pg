-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_fora_linha_simpro (cd_simpro_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_fora_linha_w         timestamp;


BEGIN

select  max(dt_fora_linha)
into STRICT    dt_fora_linha_w
from    simpro_cadastro
where   cd_simpro       = cd_simpro_p;

return  dt_fora_linha_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_fora_linha_simpro (cd_simpro_p bigint) FROM PUBLIC;
