-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_pepo_retroativo () AS $body$
DECLARE

 
nr_cirurgia_w	bigint;

C01 CURSOR FOR 
	SELECT	distinct 
		nr_cirurgia 
	from	cirurgia 
	where	dt_termino < clock_timestamp() - interval '1 days' 
	and	coalesce(dt_liberacao::text, '') = '' 
	order by	nr_cirurgia;


BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nr_cirurgia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	CALL liberar_pepo(nr_cirurgia_w,'L','Tasy');
	end;
end loop;
close C01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_pepo_retroativo () FROM PUBLIC;
