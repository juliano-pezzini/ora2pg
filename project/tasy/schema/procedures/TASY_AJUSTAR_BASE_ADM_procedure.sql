-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_ajustar_base_adm ( nm_usuario_p text, nr_seq_log_erro_p bigint) AS $body$
DECLARE


qt_reg_w		bigint;


BEGIN

qt_reg_w	:= 0;

begin
	CALL tasy_ajustar_base_con(nm_usuario_p);
exception
when others then
	CALL GRAVAR_LOG_ATUALIZACAO_ERRO(nr_seq_log_erro_p,'tasy_ajustar_base_con',substr(SQLERRM(SQLSTATE),1,1800),'Matheus A. França');
end;

begin
	CALL tasy_ajustar_base_sup(nm_usuario_p);
exception
when others then
	CALL GRAVAR_LOG_ATUALIZACAO_ERRO(nr_seq_log_erro_p,'tasy_ajustar_base_sup',substr(SQLERRM(SQLSTATE),1,1800),'Fábio Campigotto');
end;

begin
	CALL tasy_ajustar_base_fatp(nm_usuario_p);
exception
when others then
	CALL GRAVAR_LOG_ATUALIZACAO_ERRO(nr_seq_log_erro_p,'tasy_ajustar_base_fatp',substr(SQLERRM(SQLSTATE),1,1800),'Anderson Vicenzi');
end;

begin
	CALL TASY_AJUSTAR_BASE_FIN(nm_usuario_p);
exception
when others then
	CALL GRAVAR_LOG_ATUALIZACAO_ERRO(nr_seq_log_erro_p,'tasy_ajustar_base_fin',substr(SQLERRM(SQLSTATE),1,1800),'Edgar Bork de Freitas');
end;

begin
	CALL tasy_ajustar_base_fiscal(nm_usuario_p);
exception
when others then
	CALL GRAVAR_LOG_ATUALIZACAO_ERRO(nr_seq_log_erro_p,'tasy_ajustar_base_fiscal',substr(SQLERRM(SQLSTATE),1,1800),'Bruno C. Gukowski');
end;

begin
	CALL tasy_ajustar_base_fat(nm_usuario_p);
exception
when others then
	CALL GRAVAR_LOG_ATUALIZACAO_ERRO(nr_seq_log_erro_p,'tasy_ajustar_base_fat',substr(SQLERRM(SQLSTATE),1,1800),'Fabrício J. Theiss');
end;

begin
	CALL tasy_ajustar_base_interno(nm_usuario_p);
exception
when others then
	CALL GRAVAR_LOG_ATUALIZACAO_ERRO(nr_seq_log_erro_p,'tasy_ajustar_base_interno',substr(SQLERRM(SQLSTATE),1,1800),'Elton Berns');
end;

begin
	CALL tasy_ajustar_base_nfe(nm_usuario_p);
exception
when others then
	CALL GRAVAR_LOG_ATUALIZACAO_ERRO(nr_seq_log_erro_p,'tasy_ajustar_base_nfe',substr(SQLERRM(SQLSTATE),1,1800),'Adriano F. Stringari');
end;

begin
	CALL tasy_ajustar_base_fatenv(nm_usuario_p);
exception
when others then
	CALL GRAVAR_LOG_ATUALIZACAO_ERRO(nr_seq_log_erro_p,'tasy_ajustar_base_fatenv',substr(SQLERRM(SQLSTATE),1,1800),'Luciano H. Alves');
end;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_ajustar_base_adm ( nm_usuario_p text, nr_seq_log_erro_p bigint) FROM PUBLIC;
