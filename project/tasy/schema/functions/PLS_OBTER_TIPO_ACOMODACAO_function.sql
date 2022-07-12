-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_tipo_acomodacao (nr_seq_tipo_acomod_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(30);


BEGIN

select	max(cd_tiss)
into STRICT	ds_retorno_w
from	pls_tipo_acomodacao
where	nr_sequencia	= nr_seq_tipo_acomod_p;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_tipo_acomodacao (nr_seq_tipo_acomod_p bigint) FROM PUBLIC;

