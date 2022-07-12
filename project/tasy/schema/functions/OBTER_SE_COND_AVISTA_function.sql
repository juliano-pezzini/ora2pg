-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_cond_avista (nr_sequencia_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(80) := '';


BEGIN


select   CASE WHEN count(*)=0 THEN 'S' WHEN count(*)=1 THEN 'S'  ELSE 'N' END
into STRICT	 ds_retorno_w
from     nota_fiscal_venc
where    nr_sequencia = nr_sequencia_p;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_cond_avista (nr_sequencia_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

