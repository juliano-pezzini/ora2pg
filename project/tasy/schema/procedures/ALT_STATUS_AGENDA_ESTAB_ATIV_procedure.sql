-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alt_status_agenda_estab_ativ () AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	cd_estabelecimento
	from	estabelecimento
	where	ie_situacao = 'A';

BEGIN

for r_c01_w in C01 loop

	CALL alterar_status_agenda_regra(r_c01_w.cd_estabelecimento);

end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alt_status_agenda_estab_ativ () FROM PUBLIC;

