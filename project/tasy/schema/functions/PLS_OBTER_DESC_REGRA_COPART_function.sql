-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_desc_regra_copart ( nr_seq_regra_p bigint) RETURNS varchar AS $body$
DECLARE


ds_regra_w	pls_regra_copart_controle.ds_regra%type;
ds_retorno_w	varchar(255);


BEGIN

select	max(ds_regra)
into STRICT	ds_regra_w
from	pls_regra_copart_controle
where	nr_sequencia	= nr_seq_regra_p;

ds_retorno_w	:= substr(ds_regra_w,1,255);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_desc_regra_copart ( nr_seq_regra_p bigint) FROM PUBLIC;

