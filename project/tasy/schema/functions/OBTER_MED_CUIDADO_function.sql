-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_med_cuidado (nr_seq_Cuidado_p bigint) RETURNS varchar AS $body$
DECLARE



ds_cuidado_w		varchar(80);


BEGIN

select	ds_cuidado
into STRICT	ds_cuidado_w
from	med_cuidado
where	nr_sequencia	= nr_seq_Cuidado_p;


return	ds_cuidado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_med_cuidado (nr_seq_Cuidado_p bigint) FROM PUBLIC;

