-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_tipo_dado (nr_seq_tipo_dado_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(80);


BEGIN

if (nr_seq_tipo_dado_p IS NOT NULL AND nr_seq_tipo_dado_p::text <> '') then

	select	a.ds_tipo_dado
	into STRICT	ds_retorno_w
	from	proj_tipo_dado a
	where	a.nr_sequencia = nr_seq_tipo_dado_p;
end if;

RETURN	ds_retorno_w;

END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_tipo_dado (nr_seq_tipo_dado_p bigint) FROM PUBLIC;

