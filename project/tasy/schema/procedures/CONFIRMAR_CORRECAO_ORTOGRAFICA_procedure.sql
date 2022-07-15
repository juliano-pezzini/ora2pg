-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE confirmar_correcao_ortografica ( nr_seq_lote_p bigint, ie_acao_p text, nm_usuario_p text) AS $body$
DECLARE


/*

ie_acao_p

C	Confirmar correção ortográfica
D	Desfazer confirmação da correção

*/
BEGIN

update	analise_ortografica_lote
set	dt_confirmacao	= CASE WHEN coalesce(ie_acao_p,'C')='C' THEN clock_timestamp()  ELSE null END ,
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_lote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE confirmar_correcao_ortografica ( nr_seq_lote_p bigint, ie_acao_p text, nm_usuario_p text) FROM PUBLIC;

