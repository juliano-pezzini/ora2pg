-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_response_code_ihc ( nr_account_p bigint, cd_response_code_p bigint, cd_transaction_p text) AS $body$
DECLARE


nr_sequencia_w	ihc_claim.nr_sequencia%type;

BEGIN
	select 	max(nr_sequencia)
	into STRICT 	nr_sequencia_w
	from 	ihc_claim
	where 	nr_account = nr_account_p;

	update	ihc_claim
	set		cd_response_code 	= cd_response_code_p,
			cd_transaction		= cd_transaction_p
	where	nr_sequencia = nr_sequencia_w;

	commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_response_code_ihc ( nr_account_p bigint, cd_response_code_p bigint, cd_transaction_p text) FROM PUBLIC;
