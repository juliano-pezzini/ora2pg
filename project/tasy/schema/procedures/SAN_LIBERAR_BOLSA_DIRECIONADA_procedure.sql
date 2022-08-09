-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_liberar_bolsa_direcionada ( sql_item_p text, nm_usuario_p text) AS $body$
DECLARE


lista_producao_w		dbms_sql.varchar2_table;
nr_seq_producao_w		bigint;

BEGIN
lista_producao_w := obter_lista_string(sql_item_p, ',');

for	i in lista_producao_w.first..lista_producao_w.last loop
	nr_seq_producao_w := (lista_producao_w(i))::numeric;

	if (coalesce(nr_seq_producao_w, 0) > 0) then

		update	san_producao
		set	dt_liberacao_direc	= clock_timestamp(),
			nm_usuario_direc	= nm_usuario_p
		where	nr_sequencia		= nr_seq_producao_w;

	end if;

end loop;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_liberar_bolsa_direcionada ( sql_item_p text, nm_usuario_p text) FROM PUBLIC;
