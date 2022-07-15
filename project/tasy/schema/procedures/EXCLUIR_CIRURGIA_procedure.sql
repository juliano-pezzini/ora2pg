-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_cirurgia (nr_cirurgia_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE

ds_erro_w			varchar(255);

BEGIN
	delete from cirurgia
	where nr_cirurgia = nr_cirurgia_p;
	commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_cirurgia (nr_cirurgia_p bigint, ds_erro_p INOUT text) FROM PUBLIC;

