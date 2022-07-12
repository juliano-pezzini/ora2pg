-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_vacina_rn ( nr_seq_result_p bigint) RETURNS varchar AS $body$
DECLARE


ds_resultado_w		varchar(255);


BEGIN

if (nr_seq_result_p IS NOT NULL AND nr_seq_result_p::text <> '') then
	begin
	select	substr(ds_resultado,1,255)
	into STRICT	ds_resultado_w
	from	result_vacina_teste_rn
	where	nr_sequencia  = nr_seq_result_p;
	end;
end if;
return ds_resultado_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_vacina_rn ( nr_seq_result_p bigint) FROM PUBLIC;

