-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_schematic_tab (nr_seq_objeto_p bigint, nr_seq_obj_sch_param_p bigint, nm_usuario_p text, ie_opcao_p text) AS $body$
BEGIN

if (ie_opcao_p = 'V') then

	update	objeto_schematic_param
	set	nr_seq_obj_sch	= nr_seq_objeto_p,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_obj_sch_param_p;

elsif (ie_opcao_p = 'D') then

	update	objeto_schematic_param
	set	nr_seq_obj_sch	 = NULL,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_obj_sch_param_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_schematic_tab (nr_seq_objeto_p bigint, nr_seq_obj_sch_param_p bigint, nm_usuario_p text, ie_opcao_p text) FROM PUBLIC;

