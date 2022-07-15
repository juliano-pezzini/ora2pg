-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_cheque_neg ( nr_seq_caixa_rec_p bigint, nr_seq_cheque_p bigint) AS $body$
BEGIN
if (nr_seq_caixa_rec_p IS NOT NULL AND nr_seq_caixa_rec_p::text <> '') and (nr_seq_cheque_p IS NOT NULL AND nr_seq_cheque_p::text <> '') then
	begin
	update   cheque_cr
        	set      nr_seq_caixa_rec = nr_seq_caixa_rec_p
        	where    nr_seq_cheque = nr_seq_cheque_p;
	commit;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_cheque_neg ( nr_seq_caixa_rec_p bigint, nr_seq_cheque_p bigint) FROM PUBLIC;

