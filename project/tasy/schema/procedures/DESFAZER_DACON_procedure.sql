-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_dacon ( nr_sequencia_p bigint) AS $body$
BEGIN

delete 	from dacon_nota_fiscal
where	nr_seq_dacon = nr_sequencia_p;

commit;

update dacon set dt_geracao  = NULL
where nr_sequencia = nr_sequencia_p;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_dacon ( nr_sequencia_p bigint) FROM PUBLIC;

