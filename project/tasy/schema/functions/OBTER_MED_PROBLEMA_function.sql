-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_med_problema (nr_seq_problema_p bigint) RETURNS varchar AS $body$
DECLARE



ds_problema_w		varchar(80);


BEGIN

select	ds_problema
into STRICT	ds_problema_w
from	med_problema
where	nr_sequencia	= nr_seq_problema_p;


return	ds_problema_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_med_problema (nr_seq_problema_p bigint) FROM PUBLIC;
