-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_exclui_impedimentos_doacao ( nr_seq_doacao_p bigint) AS $body$
BEGIN

delete	from san_doacao_impedimento a
where	a.nr_seq_impedimento in (SELECT	b.nr_sequencia
	from	san_impedimento b
	where	b.ie_questionario	= 'S')
and	a.nr_seq_doacao = nr_seq_doacao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_exclui_impedimentos_doacao ( nr_seq_doacao_p bigint) FROM PUBLIC;
