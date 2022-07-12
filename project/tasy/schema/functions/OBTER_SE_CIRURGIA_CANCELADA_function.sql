-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_cirurgia_cancelada (nr_seq_cirurgia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1);
ie_cirurgia_cancelada_w		varchar(1);


BEGIN

ds_retorno_w	:= 'N';

select	coalesce(max(CASE WHEN coalesce(dt_cancelamento::text, '') = '' THEN 'N'  ELSE 'S' END ),'N')
into STRICT	ds_retorno_w
from	cirurgia
where	nr_cirurgia = nr_seq_cirurgia_p;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_cirurgia_cancelada (nr_seq_cirurgia_p bigint) FROM PUBLIC;
