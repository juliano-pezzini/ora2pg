-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_iniciar_triagem ( nr_seq_doacao_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_doacao_p IS NOT NULL AND nr_seq_doacao_p::text <> '') then

	if (ie_opcao_p = 'F') then
		update 	san_doacao
		set	dt_inicio_triagem_fisica 	= clock_timestamp(),
			nm_usuario_ini_tri_fisica 	= nm_usuario_p
		where	nr_sequencia			= nr_seq_doacao_p;
	else
		update 	san_doacao
		set	dt_inicio_triagem 	= clock_timestamp(),
			nm_usuario_ini_triagem 	= nm_usuario_p
		where	nr_sequencia		= nr_seq_doacao_p;
	end if;

end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_iniciar_triagem ( nr_seq_doacao_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;

