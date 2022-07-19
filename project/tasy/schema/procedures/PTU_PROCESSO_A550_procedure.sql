-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_processo_a550 () AS $body$
DECLARE


nr_sequencia_w		ptu_camara_contestacao.nr_sequencia%type;
qt_sessoes		integer;
nm_id_sid_w		ptu_camara_contestacao.ds_sid_processo%type;
nm_id_serial_w		ptu_camara_contestacao.ds_serial_processo%type;
ds_status_w		varchar(255);

C01 CURSOR FOR
	SELECT	nr_sequencia,
		ds_sid_processo,
		ds_serial_processo
	from	ptu_camara_contestacao
	where	ie_status	= 'EI';


BEGIN

open C01;
loop
fetch C01 into
	nr_sequencia_w,
	nm_id_sid_w,
	nm_id_serial_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	coalesce(max(status), 'INACTIVE')
	into STRICT	ds_status_w
	from	v$session
	where	sid	= nm_id_sid_w
	and	serial#	= nm_id_serial_w;

	if (ds_status_w = 'INACTIVE') then
		CALL ptu_atualizar_status_imp_a550( nr_sequencia_w, 'IN', 'S');
	end if;

	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_processo_a550 () FROM PUBLIC;

