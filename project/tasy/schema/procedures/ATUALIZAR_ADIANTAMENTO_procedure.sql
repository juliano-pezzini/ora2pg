-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_adiantamento ( nr_seq_caixa_rec_p bigint, nr_adiantamento_p bigint) AS $body$
BEGIN
if (nr_seq_caixa_rec_p IS NOT NULL AND nr_seq_caixa_rec_p::text <> '') and (nr_adiantamento_p IS NOT NULL AND nr_adiantamento_p::text <> '') then
	begin
	update   adiantamento
	set         nr_seq_caixa_rec = 	nr_seq_caixa_rec_p
	where    nr_adiantamento  = 	nr_adiantamento_p;
	commit;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_adiantamento ( nr_seq_caixa_rec_p bigint, nr_adiantamento_p bigint) FROM PUBLIC;

