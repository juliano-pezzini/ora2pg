-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_familia (nr_seq_familia_p bigint) RETURNS varchar AS $body$
DECLARE




ds_familia_w			varchar(155);


BEGIN


select 	max(ds_familia)
into STRICT	ds_familia_w
from	psf_familia
where	ie_situacao	= 'A'
and	nr_sequencia 	= nr_seq_familia_p;


return	ds_familia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_familia (nr_seq_familia_p bigint) FROM PUBLIC;

