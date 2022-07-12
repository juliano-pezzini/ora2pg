-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_ultm_hist ( nr_seq_projeto_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(100);


BEGIN
select	coalesce(max(a.ds_titulo),'')
into STRICT	ds_retorno_w
from	proj_cron_etapa_hist a
where	a.nr_seq_etapa_cron = nr_seq_projeto_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_obter_ultm_hist ( nr_seq_projeto_p bigint) FROM PUBLIC;
