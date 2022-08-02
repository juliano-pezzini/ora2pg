-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tre_apr_des_treinamento (nm_usuario_p text, nr_sequencia_p bigint, cd_pessoa_aprov_p text, ie_opcao_p text) AS $body$
DECLARE

/*
   ie_opcao_p	'A' - Aprovar treinamento
		'D' - Desfazer aprovação treinamento
*/
BEGIN

if (ie_opcao_p = 'A') then
	begin
	update 	tre_curso set
		dt_aprovacao 	= clock_timestamp(),
		cd_pessoa_aprov = cd_pessoa_aprov_p,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao 	= clock_timestamp()
	where 	nr_sequencia 	= nr_sequencia_p;
	end;
elsif (ie_opcao_p = 'D') then
	begin
	update 	tre_curso set
		dt_aprovacao 	 = NULL,
		cd_pessoa_aprov  = NULL,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao 	= clock_timestamp()
	where 	nr_sequencia 	= nr_sequencia_p;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tre_apr_des_treinamento (nm_usuario_p text, nr_sequencia_p bigint, cd_pessoa_aprov_p text, ie_opcao_p text) FROM PUBLIC;

