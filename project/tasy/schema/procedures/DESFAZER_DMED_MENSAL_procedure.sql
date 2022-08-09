-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_dmed_mensal (nr_seq_dmed_mensal_p bigint) AS $body$
BEGIN

delete 	from dmed_titulos_mensal
where	nr_seq_dmed_mensal = nr_seq_dmed_mensal_p;

commit;

update dmed_mensal set dt_geracao  = NULL
where nr_sequencia = nr_seq_dmed_mensal_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_dmed_mensal (nr_seq_dmed_mensal_p bigint) FROM PUBLIC;
