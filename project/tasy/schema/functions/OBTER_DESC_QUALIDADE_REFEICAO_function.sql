-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_qualidade_refeicao (nr_seq_qualidade_p bigint) RETURNS varchar AS $body$
DECLARE


ds_qualidade_w	varchar(60);

BEGIN
if (nr_seq_qualidade_p IS NOT NULL AND nr_seq_qualidade_p::text <> '') then
	select	ds_qualidade
	into STRICT	ds_qualidade_w
	from	adep_qualidade_refeicao
	where	nr_sequencia = nr_seq_qualidade_p;
end if;

return ds_qualidade_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_qualidade_refeicao (nr_seq_qualidade_p bigint) FROM PUBLIC;
