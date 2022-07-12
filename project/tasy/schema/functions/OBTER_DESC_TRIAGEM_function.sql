-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_triagem ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_classificacao_w	varchar(60);


BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	select	ds_classificacao
	into STRICT	ds_classificacao_w
	from	triagem_classif_risco
	where	nr_sequencia	= nr_sequencia_p;

end if;

return ds_classificacao_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_triagem ( nr_sequencia_p bigint) FROM PUBLIC;

