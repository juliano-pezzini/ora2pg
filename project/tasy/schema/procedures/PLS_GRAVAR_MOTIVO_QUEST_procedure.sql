-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gravar_motivo_quest ( nr_seq_motivo_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into ptu_questionamento_item(nr_sequencia, nr_seq_motivo, dt_atualizacao,
	nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
	nr_seq_conta_proc, nr_seq_conta_mat)
values (nextval('ptu_questionamento_item_seq'), nr_seq_motivo_p, clock_timestamp(),
	nm_usuario_p, clock_timestamp(), nm_usuario_p,
	nr_seq_conta_proc_p, nr_seq_conta_mat_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gravar_motivo_quest ( nr_seq_motivo_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nm_usuario_p text) FROM PUBLIC;
