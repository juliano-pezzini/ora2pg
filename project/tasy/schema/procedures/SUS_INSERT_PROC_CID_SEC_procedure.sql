-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_insert_proc_cid_sec (cd_procedimento_p bigint, cd_doenca_cid_p text, nm_usuario_p text) AS $body$
BEGIN

insert 	into sus_procedimento_cid_sec(cd_procedimento,
	ie_origem_proced,
	cd_doenca_cid_sec,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_sequencia)
values (cd_procedimento_p,
	7,
	cd_doenca_cid_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nextval('sus_procedimento_cid_sec_seq'));

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_insert_proc_cid_sec (cd_procedimento_p bigint, cd_doenca_cid_p text, nm_usuario_p text) FROM PUBLIC;

