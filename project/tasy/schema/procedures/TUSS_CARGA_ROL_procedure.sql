-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tuss_carga_rol ( cd_proc_tuss_p bigint, ds_proc_rol_p text, nm_usuario_p text) AS $body$
BEGIN

insert 	into TUSS_ROL(nr_sequencia,
		cd_procedimento,
		ie_origem_proced,
		ds_procedimento_rol,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec)
	values (nextval('tuss_rol_seq'),
		cd_proc_tuss_p,
		8,
		ds_proc_rol_p,
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp());

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tuss_carga_rol ( cd_proc_tuss_p bigint, ds_proc_rol_p text, nm_usuario_p text) FROM PUBLIC;

