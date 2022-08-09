-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_ajustar_base_assis ( nm_usuario_p text, nr_seq_log_erro_p bigint) AS $body$
BEGIN

/*AJUSTES DE BASE DA GERÊNCIA ASSISTENCIAL*/

begin
	Tasy_Ajustar_Base_Pac(nm_usuario_p); /* Paciente: Bruna Gieland */
exception
when others then
	CALL GRAVAR_LOG_ATUALIZACAO_ERRO(nr_seq_log_erro_p,'Tasy_Ajustar_Base_Pac',substr(SQLERRM(SQLSTATE),1,1800),'Bruna Gieland');
end;

begin
	CALL Tasy_Ajustar_Base_REP(nm_usuario_p); /*REP: Rafael Caldas*/
exception
when others then
	CALL GRAVAR_LOG_ATUALIZACAO_ERRO(nr_seq_log_erro_p,'Tasy_Ajustar_Base_REP',substr(SQLERRM(SQLSTATE),1,1800),'Rafael Caldas');
end;


begin
	CALL Tasy_Ajustar_Base_PEP(nm_usuario_p); /*PEP: Felipe Martini*/
exception
when others then
	CALL GRAVAR_LOG_ATUALIZACAO_ERRO(nr_seq_log_erro_p,'Tasy_Ajustar_Base_PEP',substr(SQLERRM(SQLSTATE),1,1800),'Felipe Martini');
end;


begin
	CALL Tasy_Ajustar_Base_Clinico(nm_usuario_p); /*Clinico: Daniel Dalcastagne*/
exception
when others then
	CALL GRAVAR_LOG_ATUALIZACAO_ERRO(nr_seq_log_erro_p,'Tasy_Ajustar_Base_Clinico',substr(SQLERRM(SQLSTATE),1,1800),'Daniel Dalcastagne');
end;


begin
	CALL Tasy_Ajustar_Base_Java_Assis(nm_usuario_p); /*Java: Rafael Patricio*/
exception
when others then
	CALL GRAVAR_LOG_ATUALIZACAO_ERRO(nr_seq_log_erro_p,'Tasy_Ajustar_Base_Java_Assis',substr(SQLERRM(SQLSTATE),1,1800),'Rafael Patrício');
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_ajustar_base_assis ( nm_usuario_p text, nr_seq_log_erro_p bigint) FROM PUBLIC;
