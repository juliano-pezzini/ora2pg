-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_qr_objeto (nr_Seq_objeto_p bigint) RETURNS varchar AS $body$
DECLARE


ds_objeto_w	varchar(255);

BEGIN

select	max(ds_objeto)
into STRICT	ds_objeto_w
from	qr_objeto_schematic
where	nr_sequencia	= nr_seq_objeto_p;

return	ds_objeto_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_qr_objeto (nr_Seq_objeto_p bigint) FROM PUBLIC;
