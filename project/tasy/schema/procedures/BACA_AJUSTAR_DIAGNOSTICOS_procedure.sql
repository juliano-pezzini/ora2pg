-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajustar_diagnosticos () AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_seq_cliente_w	bigint;
dt_atualizacao_w	timestamp;
ds_erro_w		varchar(2000);
qt_contador_w		bigint := 0;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_cliente,
		coalesce(dt_atualizacao, clock_timestamp())
	from	med_pac_diagnostico
	where	coalesce(dt_diagnostico::text, '') = '';


BEGIN

open	c01;
loop
fetch	c01 into
	nr_sequencia_w,
	nr_seq_cliente_w,
	dt_atualizacao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	qt_contador_w	:= qt_contador_w + 1;

	begin
	update	med_pac_diagnostico
	set	dt_diagnostico	= dt_atualizacao_w
	where	nr_sequencia	= nr_sequencia_w;
	exception
		when others then
			null;
	end;

	if (qt_contador_w = 500) then
		begin
		qt_contador_w	:= 0;
		commit;
		end;
	end if;

	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajustar_diagnosticos () FROM PUBLIC;

