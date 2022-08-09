-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_fase_objeto_offline () AS $body$
DECLARE


ds_script_w text;

C0100 CURSOR FOR
	SELECT	ds_comando
	from	objeto_versao_offline_w
	where	upper(ds_comando) not like '%TASY_CONSISTIR_TASY_VERSAO%'
    and length(ds_comando) != 0
	order by nr_Sequencia;


BEGIN

open C0100;
loop
fetch C0100 into	
	ds_script_w;
EXIT WHEN NOT FOUND; /* apply on C0100 */
	begin
		CALL tasy_versao_executa_objeto('Atualizacao',ds_script_w);
	end;
end loop;
close C0100;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_fase_objeto_offline () FROM PUBLIC;
