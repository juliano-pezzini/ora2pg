-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duv_liberar_mensagem (nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, ie_opcao_p text, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/*
ie_opcao_p
	L - Liberar
	D - Desfazer liberação
*/
BEGIN

update	duv_mensagem
set		dt_liberacao	= CASE WHEN ie_opcao_p='L' THEN  clock_timestamp()  ELSE null END ,
		nm_usuario		= nm_usuario_p
where	nr_sequencia	= nr_seq_mensagem_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duv_liberar_mensagem (nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, ie_opcao_p text, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

