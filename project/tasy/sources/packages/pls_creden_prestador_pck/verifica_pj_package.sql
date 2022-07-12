-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_creden_prestador_pck.verifica_pj ( cd_cgc_p pessoa_juridica.cd_cgc%type, show_modal_p INOUT bigint) AS $body$
DECLARE

qt_pj_w	integer;

BEGIN
select	count(cd_cgc)
into STRICT	qt_pj_w
from	pessoa_juridica
where	cd_cgc = cd_cgc_p;

if (qt_pj_w > 0) then
	show_modal_p := 1;
else
	show_modal_p := 0;
end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_creden_prestador_pck.verifica_pj ( cd_cgc_p pessoa_juridica.cd_cgc%type, show_modal_p INOUT bigint) FROM PUBLIC;