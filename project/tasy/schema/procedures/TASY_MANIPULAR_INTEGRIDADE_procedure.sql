-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_manipular_integridade ( nm_tabela_p text, ds_acao_p text) AS $body$
DECLARE



nm_tabela_w			varchar(50);
nm_integridade_w		varchar(50);
ds_comando_w			varchar(2000);

c01 CURSOR FOR
	SELECT nm_tabela, nm_integridade_referencial
	from integridade_referencial
	where nm_tabela_referencia	= nm_tabela_p;



BEGIN


OPEN C01;
LOOP
FETCH C01 into
	nm_tabela_w,
	nm_integridade_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	ds_comando_w	:= 'Alter table ' || nm_tabela_W || ' ' || ds_acao_p ||
			' constraint ' || nm_integridade_w;
	CALL Exec_Sql_Dinamico(nm_integridade_w, ds_comando_w);
	end;
END LOOP;
CLOSE c01;


END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_manipular_integridade ( nm_tabela_p text, ds_acao_p text) FROM PUBLIC;
