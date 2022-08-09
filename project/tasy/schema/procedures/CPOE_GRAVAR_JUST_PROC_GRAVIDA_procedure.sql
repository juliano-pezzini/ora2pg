-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gravar_just_proc_gravida ( nr_seq_proc_cpoe_p cpoe_procedimento.nr_sequencia%type, ds_justificativa_p cpoe_justif_proc_grav.ds_justificativa%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

	insert into	CPOE_JUSTIF_PROC_GRAV(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ds_justificativa,
			nr_seq_proc_cpoe
	)	values (
			nextval('cpoe_justif_proc_grav_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			ds_justificativa_p,
			nr_seq_proc_cpoe_p
	);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gravar_just_proc_gravida ( nr_seq_proc_cpoe_p cpoe_procedimento.nr_sequencia%type, ds_justificativa_p cpoe_justif_proc_grav.ds_justificativa%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
