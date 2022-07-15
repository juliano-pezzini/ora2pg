-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE aghos_reg_solic_internacao_ws ( dt_integracao_p timestamp, nm_usuario_p text, nr_internacao_p bigint, ie_prioridade_p bigint, nr_seq_laudo_p bigint, nr_atendimento_p bigint, ds_nome_paciente_p text, ie_autorizacao_automatica_p text, cd_pessoa_fisica_p text ) AS $body$
DECLARE



nr_seq_solicitacao_w bigint;


BEGIN
	select nextval('solicitacao_tasy_aghos_seq')
	into STRICT 	nr_seq_solicitacao_w
	;

insert 	into solicitacao_tasy_aghos(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_internacao,
		ie_urgencia,
		nr_seq_laudo,
		nr_atend_original,
		ie_situacao ,
		ie_motivo_rejeicao,
		nr_atendimento,
		ds_motivo_situacao,
		cd_cgc,
		nm_paciente,
		ie_autorizacao_automatica,
		cd_pessoa_fisica)
	values (nr_seq_solicitacao_w,
		coalesce(dt_integracao_p, clock_timestamp()),
		nm_usuario_p,
		coalesce(dt_integracao_p, clock_timestamp()),
		nm_usuario_p,
		nr_internacao_p,
		ie_prioridade_p,
		nr_seq_laudo_p,
		nr_atendimento_p,
		'A',
		null,
		null,
		'Solicitação enviada ao Aghos',
		null,
		ds_nome_paciente_p,
		ie_autorizacao_automatica_p,
		cd_pessoa_fisica_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aghos_reg_solic_internacao_ws ( dt_integracao_p timestamp, nm_usuario_p text, nr_internacao_p bigint, ie_prioridade_p bigint, nr_seq_laudo_p bigint, nr_atendimento_p bigint, ds_nome_paciente_p text, ie_autorizacao_automatica_p text, cd_pessoa_fisica_p text ) FROM PUBLIC;

