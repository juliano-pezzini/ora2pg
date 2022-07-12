-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE dpc_pkg.update_status_questionnaire (NR_SEQ_DPC_QUEST_P bigint, SI_TYPE_P text, NM_USUARIO_P text) AS $body$
BEGIN
if (SI_TYPE_P=1)then
	update	patient_dpc_questionnaire
	set	SI_STATUS = '1',
		nm_usuario_medico = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_dpc_quest_p;

elsif (SI_TYPE_P=2)then
	update	patient_dpc_questionnaire
	set	SI_STATUS = '2',
		nm_usuario_medico = nm_usuario_p,
		dt_liberacao_medico = clock_timestamp(),
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_dpc_quest_p;
	
elsif (SI_TYPE_P=3)then
	update	patient_dpc_questionnaire
	set	SI_STATUS = '3',
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_dpc_quest_p;

elsif (SI_TYPE_P=4)then
	update	patient_dpc_questionnaire
	set	SI_STATUS = '4',
		nm_usuario_liberacao = nm_usuario_p,
		dt_liberacao = clock_timestamp(),
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_dpc_quest_p;

elsif (SI_TYPE_P=5)then	
	update	patient_dpc_questionnaire
	set	SI_STATUS = '5',
		nm_usuario_inativacao = nm_usuario_p,
		dt_inativacao    = clock_timestamp(),
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_dpc_quest_p;
    commit;
end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dpc_pkg.update_status_questionnaire (NR_SEQ_DPC_QUEST_P bigint, SI_TYPE_P text, NM_USUARIO_P text) FROM PUBLIC;