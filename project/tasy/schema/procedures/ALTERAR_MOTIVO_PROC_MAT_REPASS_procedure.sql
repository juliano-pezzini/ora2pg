-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_motivo_proc_mat_repass ( ie_proc_mat_p bigint, nr_seq_p bigint, nr_repasse_terceiro_p bigint, nr_seq_motivo_des_p bigint, cd_medico_p text, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (ie_proc_mat_p = 0) then

	update	procedimento_repasse
	set	nr_repasse_terceiro	 = NULL,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp(),
		nr_seq_motivo_des	= nr_seq_motivo_des_p
	where	nr_seq_procedimento	= nr_seq_p
	and	nr_repasse_terceiro	= nr_repasse_terceiro_p
	and	nr_sequencia		= nr_sequencia_p;

elsif (ie_proc_mat_p = 1) then

	update	material_repasse
	set	nr_repasse_terceiro	 = NULL,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp(),
		nr_seq_motivo_des	= nr_seq_motivo_des_p
	where	nr_seq_material		= nr_seq_p
	and	nr_repasse_terceiro	= nr_repasse_terceiro_p
	and	nr_sequencia		= nr_sequencia_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_motivo_proc_mat_repass ( ie_proc_mat_p bigint, nr_seq_p bigint, nr_repasse_terceiro_p bigint, nr_seq_motivo_des_p bigint, cd_medico_p text, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
