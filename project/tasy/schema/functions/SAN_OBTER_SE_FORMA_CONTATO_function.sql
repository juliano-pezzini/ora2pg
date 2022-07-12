-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_se_forma_contato (cd_pessoa_fisica_p text, nr_seq_forma_contato_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);


BEGIN

ds_retorno_w := 'N';

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ds_retorno_w
from	pessoa_fisica_contato
where	cd_pessoa_fisica = cd_pessoa_fisica_p
and	nr_seq_forma_cont = nr_seq_forma_contato_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_se_forma_contato (cd_pessoa_fisica_p text, nr_seq_forma_contato_p bigint) FROM PUBLIC;
