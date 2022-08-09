-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE separar_fatura ( nr_seq_proc_mat_p bigint, ie_tipo_p text, nr_interno_conta_dest_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_interno_conta_dest_p IS NOT NULL AND nr_interno_conta_dest_p::text <> '') and (nr_seq_proc_mat_p IS NOT NULL AND nr_seq_proc_mat_p::text <> '') and (ie_tipo_p IS NOT NULL AND ie_tipo_p::text <> '') then

	if (ie_tipo_p = 'P') then
		update	procedimento_paciente
		set	nr_interno_conta = nr_interno_conta_dest_p,
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		where	nr_sequencia = nr_seq_proc_mat_p;
	elsif (ie_tipo_p = 'M') then
		update	material_atend_paciente
		set	nr_interno_conta = nr_interno_conta_dest_p,
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		where	nr_sequencia = nr_seq_proc_mat_p;
	end if;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE separar_fatura ( nr_seq_proc_mat_p bigint, ie_tipo_p text, nr_interno_conta_dest_p bigint, nm_usuario_p text) FROM PUBLIC;
