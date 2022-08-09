-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_alta_quimioterapia ( nr_seq_atendimento_p bigint, nm_usuario_p text) AS $body$
BEGIN

update 	paciente_atendimento
set 	dt_fim_adm		= clock_timestamp(),
	nm_usuario 		= nm_usuario_p ,
	nm_usuario_fim_adm	= nm_usuario_p
where 	nr_seq_atendimento 	= nr_seq_atendimento_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_alta_quimioterapia ( nr_seq_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;
