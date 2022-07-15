-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE movto_trans_financ_del_reg_js ( nr_seq_cheque_p bigint) AS $body$
BEGIN
if (nr_seq_cheque_p IS NOT NULL AND nr_seq_cheque_p::text <> '') then
	begin
	delete from cheque_cr
	where nr_seq_cheque = nr_seq_cheque_p;
	commit;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE movto_trans_financ_del_reg_js ( nr_seq_cheque_p bigint) FROM PUBLIC;

