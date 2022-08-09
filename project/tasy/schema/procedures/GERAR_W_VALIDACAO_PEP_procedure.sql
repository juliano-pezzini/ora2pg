-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_validacao_pep (ds_mensagem_p text, ie_tipo_mensagem_p text, nm_usuario_p text) AS $body$
DECLARE

nr_sequencia_w integer;

BEGIN

	SELECT nextval('w_validacao_pep_seq')
	INTO STRICT nr_sequencia_w
	;
	
	INSERT INTO w_validacao_pep(
		nr_sequencia,
		ds_mensagem,
		ie_tipo_mensagem,
		nm_usuario,
		dt_atualizacao)
	VALUES (
		nr_sequencia_w,
		ds_mensagem_p,
		ie_tipo_mensagem_p,
		nm_usuario_p,
		clock_timestamp());
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_validacao_pep (ds_mensagem_p text, ie_tipo_mensagem_p text, nm_usuario_p text) FROM PUBLIC;
