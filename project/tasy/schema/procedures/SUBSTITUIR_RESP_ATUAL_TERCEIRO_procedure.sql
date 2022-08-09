-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE substituir_resp_atual_terceiro ( nr_seq_terceiro_p bigint) AS $body$
BEGIN

if (nr_seq_terceiro_p IS NOT NULL AND nr_seq_terceiro_p::text <> '') then
	begin
	update	terceiro_pessoa_fisica
	set	ie_resp_terceiro = 'N'
	where	nr_seq_terceiro = nr_seq_terceiro_p;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE substituir_resp_atual_terceiro ( nr_seq_terceiro_p bigint) FROM PUBLIC;
