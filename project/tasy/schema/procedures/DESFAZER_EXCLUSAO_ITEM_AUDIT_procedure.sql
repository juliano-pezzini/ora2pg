-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_exclusao_item_audit ( nr_sequencia_p bigint, nr_seq_auditoria_p bigint, nr_interno_conta_p bigint, nr_seq_item_p bigint, ie_tipo_item_p text, nm_usuario_p text) AS $body$
BEGIN

if (ie_tipo_item_p	= 'P') then
	update	procedimento_paciente
	set	cd_motivo_exc_conta  = NULL,
		ds_compl_motivo_excon  = NULL,
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p,
		nr_interno_conta = nr_interno_conta_p
	where	nr_sequencia = nr_seq_item_p;

	update	auditoria_propaci
	set	ie_tipo_auditoria = 'E',
		nr_seq_motivo  = NULL,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_sequencia_p;
else
	update	material_atend_paciente
	set	cd_motivo_exc_conta  = NULL,
		ds_compl_motivo_excon  = NULL,
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p,
		nr_interno_conta = nr_interno_conta_p
	where	nr_sequencia = nr_seq_item_p;

	update	auditoria_matpaci
	set	ie_tipo_auditoria = 'E',
		nr_seq_motivo  = NULL,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_exclusao_item_audit ( nr_sequencia_p bigint, nr_seq_auditoria_p bigint, nr_interno_conta_p bigint, nr_seq_item_p bigint, ie_tipo_item_p text, nm_usuario_p text) FROM PUBLIC;
