-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_titulo_transacao ( nr_titulo_p bigint, nr_sequencia_p bigint) AS $body$
BEGIN
if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	update  movto_trans_financ
	set 	nr_seq_titulo_receber = nr_titulo_p
	where   nr_sequencia = nr_sequencia_p;
	commit;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_titulo_transacao ( nr_titulo_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

