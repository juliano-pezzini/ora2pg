-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_convenio_cobertura (nr_seq_cobertura_p bigint) RETURNS bigint AS $body$
DECLARE


cd_convenio_w	integer;


BEGIN

select 	coalesce(max(cd_convenio),0)
into STRICT	cd_convenio_w
from 	convenio_cobertura
where	nr_sequencia = nr_seq_cobertura_p;

return	cd_convenio_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_convenio_cobertura (nr_seq_cobertura_p bigint) FROM PUBLIC;
