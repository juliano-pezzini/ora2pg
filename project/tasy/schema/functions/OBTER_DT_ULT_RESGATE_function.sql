-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_ult_resgate (nr_seq_aplicacao_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_ult_resg_w		timestamp;


BEGIN

if (nr_seq_aplicacao_p IS NOT NULL AND nr_seq_aplicacao_p::text <> '') then
	select 	max(dt_resgate) dt_resgate
	into STRICT	dt_ult_resg_w
	from 	banco_resgate
	where 	nr_seq_aplicacao = nr_seq_aplicacao_p;
end if;

return dt_ult_resg_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_ult_resgate (nr_seq_aplicacao_p bigint) FROM PUBLIC;

