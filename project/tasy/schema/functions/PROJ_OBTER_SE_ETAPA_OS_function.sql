-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_se_etapa_os ( nr_seq_etapa_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(01);


BEGIN

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ds_retorno_w
from	man_ordem_servico
where	nr_seq_proj_cron_etapa = nr_seq_etapa_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_obter_se_etapa_os ( nr_seq_etapa_p bigint) FROM PUBLIC;

