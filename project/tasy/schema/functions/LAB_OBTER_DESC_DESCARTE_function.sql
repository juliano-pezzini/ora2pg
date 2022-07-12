-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_desc_descarte (nr_seq_descarte_p lab_soro_forma_descarte.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN

if (nr_seq_descarte_p IS NOT NULL AND nr_seq_descarte_p::text <> '') then
	select  ds_forma_descarte
	into STRICT	ds_retorno_w
	from    lab_soro_forma_descarte
	where   nr_sequencia = nr_seq_descarte_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_desc_descarte (nr_seq_descarte_p lab_soro_forma_descarte.nr_sequencia%type) FROM PUBLIC;
