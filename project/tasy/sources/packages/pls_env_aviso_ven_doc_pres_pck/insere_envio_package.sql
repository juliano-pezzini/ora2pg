-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_env_aviso_ven_doc_pres_pck.insere_envio ( nr_seq_prestador_pp pls_regra_com_prest_dest.nr_seq_prestador%type, ds_assunto_pp text, ds_cabecalho_pp text, ds_email_origem_pp usuario.ds_email%type, ds_email_pp usuario.ds_email%type, tb_mensagem_pp dbms_sql.varchar2_table, qt_tamanho_pag_pp integer, nm_usuario_pp usuario.nm_usuario%type) AS $body$
DECLARE

			
ie_gerar_w	varchar(1) := 'S';

BEGIN
	for i in 1..qt_lista_w loop
		if (coalesce(REGEXP_INSTR(coalesce(ds_email_pp,' '),'^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$'), 0) = 0) then
			-- Se for encontrado um destinatario do mesmo e-mail ou um e-mail invalido, nao adiciona a lista
			ie_gerar_w	:= 'N';
		end if;
	end loop;
	
	if (ie_gerar_w = 'S') then
		qt_lista_w := qt_lista_w + 1;
		lista_email[qt_lista_w].nr_seq_prestador  := nr_seq_prestador_pp;
		lista_email[qt_lista_w].ds_assunto        := ds_assunto_pp;
		lista_email[qt_lista_w].ds_cabecalho      := ds_cabecalho_pp;
		lista_email[qt_lista_w].ds_email_origem   := ds_email_origem_pp;
		lista_email[qt_lista_w].ds_email          := ds_email_pp;
		lista_email[qt_lista_w].tb_mensagem       := tb_mensagem_pp;
		lista_email[qt_lista_w].qt_tamanho_pag    := qt_tamanho_pag_pp;
		lista_email[qt_lista_w].nm_usuario        := nm_usuario_pp;
	end if;
end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_env_aviso_ven_doc_pres_pck.insere_envio ( nr_seq_prestador_pp pls_regra_com_prest_dest.nr_seq_prestador%type, ds_assunto_pp text, ds_cabecalho_pp text, ds_email_origem_pp usuario.ds_email%type, ds_email_pp usuario.ds_email%type, tb_mensagem_pp dbms_sql.varchar2_table, qt_tamanho_pag_pp integer, nm_usuario_pp usuario.nm_usuario%type) FROM PUBLIC;