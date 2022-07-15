-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_senha_monitor ( nr_sequencia_p bigint, ie_tipo_acao_p text) AS $body$
BEGIN
/*
ie_tipo_acao_p

I	-	Inserir data
L	-	Limpar data

*/
if (ie_tipo_acao_p = 'I') then

	update 	paciente_senha_fila
	set		dt_visualizacao_monitor = clock_timestamp()
	where	nr_sequencia = nr_sequencia_p;

end if;

if (ie_tipo_acao_p = 'L') then

	update 	paciente_senha_fila
	set		dt_visualizacao_monitor  = NULL
	where	nr_sequencia = nr_sequencia_p;

end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_senha_monitor ( nr_sequencia_p bigint, ie_tipo_acao_p text) FROM PUBLIC;

