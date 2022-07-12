-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_data_doacao (nr_seq_doacao_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_doacao_w timestamp;


BEGIN

if (nr_seq_doacao_p IS NOT NULL AND nr_seq_doacao_p::text <> '') then
	select max(a.dt_doacao)
	into STRICT dt_doacao_w
	from san_doacao a
	where a.nr_sequencia = nr_seq_doacao_p;
end if;

return dt_doacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_data_doacao (nr_seq_doacao_p bigint) FROM PUBLIC;
