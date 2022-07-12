-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ativ_prev_ordem ( nr_seq_ordem_p bigint) RETURNS timestamp AS $body$
DECLARE




ds_retorno_w		timestamp;


BEGIN

select	max(DT_PREVISTA)
into STRICT	ds_retorno_w
from	man_ordem_ativ_prev
where	nr_seq_ordem_serv = nr_seq_ordem_p
and	nr_seq_ativ_exec in (49,48,31,35,37,36,105,38,116,41,50,46,24,87,85,83,88,82,9,11,10,40,17,16,15,98);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ativ_prev_ordem ( nr_seq_ordem_p bigint) FROM PUBLIC;

