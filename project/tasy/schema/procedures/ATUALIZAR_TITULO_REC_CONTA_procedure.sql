-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_titulo_rec_conta ( nr_seq_conta_banco_p bigint, nr_titulo_p bigint) AS $body$
BEGIN

if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then
update	titulo_receber
set	nr_seq_conta_banco = nr_seq_conta_banco_p
where	nr_titulo = nr_titulo_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_titulo_rec_conta ( nr_seq_conta_banco_p bigint, nr_titulo_p bigint) FROM PUBLIC;
