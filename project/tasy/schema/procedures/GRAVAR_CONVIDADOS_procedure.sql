-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_convidados (nr_seq_agenda_p bigint, nm_usuario_convidado_p text, cd_pessoa_convidado_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w	bigint;


BEGIN

select	nextval('agenda_tasy_convite_seq')
into STRICT	nr_sequencia_w
;

insert into agenda_tasy_convite(
	nr_sequencia,
	nr_seq_agenda,
	nm_usuario_convidado,
	dt_atualizacao,
	nm_usuario,
	cd_pessoa_convidado,
	dt_atualizacao_nrec,
	nm_usuario_nrec)
values (nr_sequencia_w,
	nr_seq_agenda_p,
	nm_usuario_convidado_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_pessoa_convidado_p,
	clock_timestamp(),
	nm_usuario_p);


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_convidados (nr_seq_agenda_p bigint, nm_usuario_convidado_p text, cd_pessoa_convidado_p text, nm_usuario_p text) FROM PUBLIC;

