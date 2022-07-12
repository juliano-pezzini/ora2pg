-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_problema_atend (nr_seq_problema_p bigint) RETURNS varchar AS $body$
DECLARE



ds_retorno_w		varchar(255) := '';


BEGIN


If (nr_seq_problema_p IS NOT NULL AND nr_seq_problema_p::text <> '') then

	Select  substr(ds_problema,1,255)
	into STRICT	ds_retorno_w
	from	lista_problema_pac
	where	nr_Sequencia = nr_seq_problema_p;


end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_problema_atend (nr_seq_problema_p bigint) FROM PUBLIC;

