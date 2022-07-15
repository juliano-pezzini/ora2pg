-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_liberacao_noms ( nr_sequencia_p bigint, nm_tabela_p text) AS $body$
BEGIN

	if (upper(nm_tabela_p) = 'GUIA_MORTE_FETAL_NOMS') then
	
		update 	GUIA_MORTE_FETAL_NOMS
		set		dt_liberacao  = NULL,
				nm_usuario_lib  = NULL
		where 	nr_sequencia = nr_sequencia_p;

	elsif (upper(nm_tabela_p)	= 'GUIA_MORTE_NOMS') then
		
		update 	GUIA_MORTE_NOMS
		set		dt_liberacao  = NULL,
				nm_usuario_lib  = NULL
		where 	nr_sequencia = nr_sequencia_p;
		
	elsif (upper(nm_tabela_p)	= 'NOM_NASCIMENTO') then
		
		update 	NOM_NASCIMENTO
		set		dt_liberacao  = NULL,
				nm_usuario_lib  = NULL
		where 	nr_sequencia = nr_sequencia_p;
		
	end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_liberacao_noms ( nr_sequencia_p bigint, nm_tabela_p text) FROM PUBLIC;

