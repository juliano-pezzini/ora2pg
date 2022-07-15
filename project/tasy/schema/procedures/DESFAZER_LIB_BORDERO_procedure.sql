-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_lib_bordero ( nr_bordero_p bigint) AS $body$
BEGIN

update	bordero_pagamento
set 	dt_liberacao	 = NULL,
	nm_usuario_lib	 = NULL
where 	nr_bordero		= nr_bordero_p;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_lib_bordero ( nr_bordero_p bigint) FROM PUBLIC;

