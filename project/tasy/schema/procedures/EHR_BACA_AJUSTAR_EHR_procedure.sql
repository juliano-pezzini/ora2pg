-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ehr_baca_ajustar_ehr () AS $body$
DECLARE


ds_resultado_w	varchar(20);

c01 CURSOR FOR
	SELECT	ds_resultado
	from	ehr_reg_elemento
	where	nr_seq_elemento = 764;

BEGIN

open c01;
loop
fetch c01 into
	ds_resultado_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	update	ehr_reg_elemento
	set	dt_resultado = to_date(ds_resultado, 'dd/mm/yyyy hh24:mi:ss')
	where	nr_seq_elemento = 764;
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ehr_baca_ajustar_ehr () FROM PUBLIC;

