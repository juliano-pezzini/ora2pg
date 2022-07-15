-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_acertar_pessoa_pesquisa () AS $body$
DECLARE


/* Estrutura cliente */

trigger_name_w		varchar(255);
cont_w			bigint;
sql_erro_w		varchar(4000);


c02 CURSOR FOR
SELECT	trigger_name
from	user_triggers
where	table_name = 'PESSOA_FISICA'

union all

select	trigger_name
from	user_triggers
where	table_name = 'COMPL_PESSOA_FISICA'
order by
	1;

c03 CURSOR FOR
SELECT	trigger_name
from	user_triggers
where	status = 'DISABLED'
order by
	1;


BEGIN

open c02;
loop
fetch c02 into
	trigger_name_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin
	CALL exec_sql_dinamico('OS110058_PF', 'alter trigger ' || trigger_name_w || ' disable');
	end;
end loop;
close c02;

begin

select	count(*)
into STRICT	cont_w
from	pessoa_fisica
where	coalesce(nm_pessoa_pesquisa, 'X')		<> padronizar_nome(nm_pessoa_fisica);

while	cont_w > 0 loop

	update	pessoa_fisica a
	set	nm_pessoa_pesquisa		= padronizar_nome(nm_pessoa_fisica)
	where	coalesce(nm_pessoa_pesquisa, 'X')	<> padronizar_nome(nm_pessoa_fisica)  LIMIT 2000;

	commit;

	cont_w	:= cont_w - 1999;

end loop;

exception
	when others then

	open c03;
	loop
	fetch c03 into
		trigger_name_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin
		CALL exec_sql_dinamico('OS110058_PF', 'alter trigger ' || trigger_name_w || ' enable');
		end;
	end loop;
	close c03;
	sql_erro_w := sqlerrm;
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(278856, 'SQL_ERRO_P=' || sql_erro_w);
end;

open c03;
loop
fetch c03 into
	trigger_name_w;
EXIT WHEN NOT FOUND; /* apply on c03 */
	begin
	CALL exec_sql_dinamico('OS110058_PF', 'alter trigger ' || trigger_name_w || ' enable');
	end;
end loop;
close c03;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_acertar_pessoa_pesquisa () FROM PUBLIC;

