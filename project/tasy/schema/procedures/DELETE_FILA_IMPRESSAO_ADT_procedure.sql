-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE delete_fila_impressao_adt (nr_sequencia_p fila_impressao_adt.nr_sequencia%type ) AS $body$
BEGIN

	delete from fila_impressao_adt
	where nr_sequencia = nr_sequencia_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE delete_fila_impressao_adt (nr_sequencia_p fila_impressao_adt.nr_sequencia%type ) FROM PUBLIC;

