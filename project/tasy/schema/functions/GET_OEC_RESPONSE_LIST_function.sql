-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_oec_response_list (auth_seq_p bigint) RETURNS varchar AS $body$
DECLARE

lv_result_value		varchar(5000);
  i RECORD;

BEGIN

for i in (	SELECT b.nr_sequencia
		from oec_claim a, oec_response b
		where ((b.nr_seq_authorization = auth_seq_p) or (a.nr_sequencia_autor = auth_seq_p)) 
		and a.cd_seq_transaction = b.nr_seq_transaction
	)
loop
	lv_result_value := lv_result_value || ',' || i.nr_sequencia;
end loop;

return ltrim(lv_result_value, ',');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_oec_response_list (auth_seq_p bigint) FROM PUBLIC;
