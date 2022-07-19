-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_liberar_estornar_aval ( nr_sequencia_p bigint, ie_tipo_p text, nm_usuario_p text ) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and ( ie_tipo_p 	in ('DL', 'A') ) then
	
	if ( ie_tipo_p = 'DL' ) then
		update 	proj_projeto_aval
		set 	dt_liberacao 	 = NULL,
			nm_usuario_lib 	 = NULL,
			dt_atualizacao 	= clock_timestamp(),
			nm_usuario 	= nm_usuario_p
		where 	nr_sequencia = nr_sequencia_p;
	else
		update 	proj_projeto_aval
		set 	ie_situacao 	= 'A',
			dt_aprovacao 	= clock_timestamp(),
			nm_usuario_aprov 	= nm_usuario_p,
			dt_atualizacao 	= clock_timestamp(),
			nm_usuario 	= nm_usuario_p
		where 	nr_sequencia = nr_sequencia_p;
	end if;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_liberar_estornar_aval ( nr_sequencia_p bigint, ie_tipo_p text, nm_usuario_p text ) FROM PUBLIC;

