-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_insert_procedimento_leito (cd_procedimento_p bigint, cd_espec_leito_p bigint, cd_tipo_leito_p bigint, nr_seq_espec_leito_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert 	into sus_procedimento_leito(cd_procedimento,
	ie_origem_proced,
	cd_espec_leito,
	cd_tipo_leito,
	nr_seq_espec_leito,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_sequencia )
values (cd_procedimento_p,
	7,
	cd_espec_leito_p,
	cd_tipo_leito_p,
	nr_seq_espec_leito_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nextval('sus_procedimento_leito_seq'));

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_insert_procedimento_leito (cd_procedimento_p bigint, cd_espec_leito_p bigint, cd_tipo_leito_p bigint, nr_seq_espec_leito_p bigint, nm_usuario_p text) FROM PUBLIC;

