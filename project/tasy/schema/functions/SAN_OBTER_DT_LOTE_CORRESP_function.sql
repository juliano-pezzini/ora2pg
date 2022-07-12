-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_dt_lote_corresp (nr_sequencia_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_lote_w	timestamp;


BEGIN

select	max(dt_registro)
into STRICT	dt_lote_w
from	san_envio_correspondencia
where	nr_sequencia = nr_sequencia_p;

return	dt_lote_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_dt_lote_corresp (nr_sequencia_p bigint) FROM PUBLIC;

