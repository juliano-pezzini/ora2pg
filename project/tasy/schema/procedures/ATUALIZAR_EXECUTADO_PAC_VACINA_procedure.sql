-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_executado_pac_vacina ( nr_sequencia_p bigint, cd_tipo_baixa_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
	CALL inserir_mat_med_proc( 
		nr_sequencia_p, 
		cd_tipo_baixa_p, 
		cd_estabelecimento_p, 
		nm_usuario_p);
 
	update 	paciente_vacina 
	set  	ie_executado 	= 'S', 
		dt_atualizacao	= clock_timestamp(), 
		nm_usuario	= nm_usuario_p 
	where 	nr_sequencia 	= nr_sequencia_p;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_executado_pac_vacina ( nr_sequencia_p bigint, cd_tipo_baixa_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

