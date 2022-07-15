-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE altera_tributo_tit_pag ( nr_titulo_p bigint, nm_usuario_p text, cd_tributo_p bigint) AS $body$
BEGIN

if (cd_tributo_p IS NOT NULL AND cd_tributo_p::text <> '') then
	update	titulo_pagar
	set	cd_tributo = cd_tributo_p,
		nm_usuario = nm_usuario_p
	where	nr_titulo = nr_titulo_p;
	commit;
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE altera_tributo_tit_pag ( nr_titulo_p bigint, nm_usuario_p text, cd_tributo_p bigint) FROM PUBLIC;

