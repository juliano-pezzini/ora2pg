-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_curriculo_inf ( nr_seq_inf_p bigint) RETURNS varchar AS $body$
DECLARE


ds_informacao_w		varchar(255);


BEGIN

select	ds_informacao
into STRICT	ds_informacao_w
from	pf_curriculo_inf
where	nr_sequencia	= nr_seq_inf_p;

return	ds_informacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_curriculo_inf ( nr_seq_inf_p bigint) FROM PUBLIC;
