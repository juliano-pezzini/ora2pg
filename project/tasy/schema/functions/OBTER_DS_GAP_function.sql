-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ds_gap (nr_seq_gap bigint) RETURNS varchar AS $body$
DECLARE


ds_gap_w	varchar(255);

BEGIN

if (nr_seq_gap IS NOT NULL AND nr_seq_gap::text <> '')then

select	ds_gap
into STRICT	ds_gap_w
from	latam_gap
where	nr_sequencia = nr_seq_gap;

end if;


return	ds_gap_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ds_gap (nr_seq_gap bigint) FROM PUBLIC;
