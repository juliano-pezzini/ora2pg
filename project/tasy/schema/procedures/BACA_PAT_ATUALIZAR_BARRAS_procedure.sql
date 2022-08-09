-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_pat_atualizar_barras () AS $body$
DECLARE


qt_registro_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_registro_w
from	pat_inventario_bem
where	coalesce(ie_barras::text, '') = '';

if (qt_registro_w > 0) then
	update	pat_inventario_bem
	set	ie_barras	= 'S'
	where	coalesce(ie_barras::text, '') = '';

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_pat_atualizar_barras () FROM PUBLIC;
