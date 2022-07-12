-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_tipo_estab (nr_seq_tipo_estab_p bigint) RETURNS varchar AS $body$
DECLARE


ds_tipo_estab_w	varchar(255);


BEGIN

select	ds_tipo_estab
into STRICT	ds_tipo_estab_w
from	tipo_estab_contrato
where	nr_sequencia = nr_seq_tipo_estab_p;

return	ds_tipo_estab_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_tipo_estab (nr_seq_tipo_estab_p bigint) FROM PUBLIC;

