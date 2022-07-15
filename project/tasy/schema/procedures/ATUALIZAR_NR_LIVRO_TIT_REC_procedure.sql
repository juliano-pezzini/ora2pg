-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_nr_livro_tit_rec (nr_interno_conta_p bigint, nr_seq_protocolo_p bigint, nr_livro_p text, nm_usuario_p text) AS $body$
BEGIN

update	titulo_receber
set	nr_livro		= nr_livro_p,
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	coalesce(nr_livro::text, '') = ''
and (nr_interno_conta	= nr_interno_conta_p
	or nr_seq_protocolo	= nr_seq_protocolo_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_nr_livro_tit_rec (nr_interno_conta_p bigint, nr_seq_protocolo_p bigint, nr_livro_p text, nm_usuario_p text) FROM PUBLIC;

