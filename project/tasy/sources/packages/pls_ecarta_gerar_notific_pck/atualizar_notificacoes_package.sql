-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ecarta_gerar_notific_pck.atualizar_notificacoes ( nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

	-- Estabelecimentos
	c01_w CURSOR FOR
	SELECT	cd_estabelecimento
	from	estabelecimento a
	where	a.ie_situacao = 'A'; -- Ativo
BEGIN
	-- Processa os estabelecimentos
	for r01_w in c01_w loop
		CALL pls_ecarta_gerar_notific_pck.atualizar_notificacoes(r01_w.cd_estabelecimento, nm_usuario_p);
	end loop;
	
	-- Confirma alterações da transação
	commit;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ecarta_gerar_notific_pck.atualizar_notificacoes ( nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;