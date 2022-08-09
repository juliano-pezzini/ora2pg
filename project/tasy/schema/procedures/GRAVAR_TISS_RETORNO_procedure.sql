-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_tiss_retorno ( ie_cancelamento_p text, nr_sequencia_autor_p bigint, nr_seq_motivo_glosa_p bigint, ds_erro_retorno_p text, nr_seq_proc_autor_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert	into tiss_retorno_autorizacao(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	dt_evento,
	ie_cancelamento,
	nr_seq_autorizacao,
	nr_seq_motivo_glosa,
	ds_erro_retorno,
	nr_seq_proc_autor)
values (nextval('tiss_retorno_autorizacao_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	ie_cancelamento_p,
	nr_sequencia_autor_p,
	nr_seq_motivo_glosa_p,
	ds_erro_retorno_p,
	nr_seq_proc_autor_p);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_tiss_retorno ( ie_cancelamento_p text, nr_sequencia_autor_p bigint, nr_seq_motivo_glosa_p bigint, ds_erro_retorno_p text, nr_seq_proc_autor_p bigint, nm_usuario_p text) FROM PUBLIC;
