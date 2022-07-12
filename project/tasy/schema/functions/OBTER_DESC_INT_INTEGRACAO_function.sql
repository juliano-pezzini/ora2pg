-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_int_integracao (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_titulo_w	varchar(255);


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	select	substr(obter_desc_expressao(cd_exp_titulo, ds_titulo),1,255)
	into STRICT 	ds_titulo_w
	from	int_integracao
	where	nr_sequencia = nr_sequencia_p;

end if;

return	ds_titulo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_int_integracao (nr_sequencia_p bigint) FROM PUBLIC;

