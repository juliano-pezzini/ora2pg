-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_duplicar_agendamento ( nr_seq_ageint_p bigint) AS $body$
DECLARE


nr_seq_ageint_w		bigint;
nm_usuario_w		varchar(25);


BEGIN

nm_usuario_w := obter_usuario_ativo;

select	nextval('agenda_integrada_seq')
into STRICT	nr_seq_ageint_w
;

insert into agenda_integrada(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_agenda_externa,
	cd_categoria,
	cd_chave_regulacao_sus,
	cd_convenio,
	cd_empresa,
	cd_estabelecimento,
	cd_medico_solicitante,
	cd_pessoa_fisica,
	cd_plano,
	cd_procedencia,
	cd_profissional,
	cd_regulacao_sus,
	cd_tipo_acomodacao,
	cd_usuario_convenio,
	cnpj_solicitante,
	crm_medico_externo,
	ds_indicacao,
	ds_obs_final,
	ds_observacao,
	dt_fim_agendamento,
	dt_inicio_agendamento,
	dt_nascimento,
	dt_prevista,
	dt_ultima_menstruacao,
	dt_validade_carteira,
	ie_agend_coletivo,
	ie_api_integracao,
	ie_bloqueio_checklist,
	ie_cod_usuario_mae_resp,
	ie_externo,
	ie_forma_agendamento,
	ie_sexo,
	ie_tipo_acomod,
	ie_tipo_atendimento,
	ie_turno,
	nm_contato,
	nm_familia,
	nm_medico_externo,
	nm_paciente,
	nr_controle_sus,
	nr_doc_convenio,
	nr_seq_classificacao,
	nr_seq_cobertura,
	nr_seq_forma_indicacao,
	nr_seq_forma_laudo,
	nr_seq_mot_cancel,
	nr_seq_status,
	nr_seq_tipo_classif_pac,
	nr_telefone,
	qt_altura_cm,
	qt_idade_gestacional,
	qt_idade_pac,
	qt_ig_dia,
	qt_ig_semana,
	qt_peso)
SELECT	nr_seq_ageint_w,
	clock_timestamp(),
	nm_usuario_w,
	clock_timestamp(),
	nm_usuario_w,
	cd_agenda_externa,
	cd_categoria,
	cd_chave_regulacao_sus,
	cd_convenio,
	cd_empresa,
	cd_estabelecimento,
	cd_medico_solicitante,
	cd_pessoa_fisica,
	cd_plano,
	cd_procedencia,
	cd_profissional,
	cd_regulacao_sus,
	cd_tipo_acomodacao,
	cd_usuario_convenio,
	cnpj_solicitante,
	crm_medico_externo,
	ds_indicacao,
	ds_obs_final,
	ds_observacao,
	dt_fim_agendamento,
	dt_inicio_agendamento,
	dt_nascimento,
	dt_prevista,
	dt_ultima_menstruacao,
	dt_validade_carteira,
	ie_agend_coletivo,
	ie_api_integracao,
	ie_bloqueio_checklist,
	ie_cod_usuario_mae_resp,
	ie_externo,
	ie_forma_agendamento,
	ie_sexo,
	ie_tipo_acomod,
	ie_tipo_atendimento,
	ie_turno,
	nm_contato,
	nm_familia,
	nm_medico_externo,
	nm_paciente,
	nr_controle_sus,
	nr_doc_convenio,
	nr_seq_classificacao,
	nr_seq_cobertura,
	nr_seq_forma_indicacao,
	nr_seq_forma_laudo,
	nr_seq_mot_cancel,
	nr_seq_status,
	nr_seq_tipo_classif_pac,
	nr_telefone,
	qt_altura_cm,
	qt_idade_gestacional,
	qt_idade_pac,
	qt_ig_dia,
	qt_ig_semana,
	qt_peso
from	agenda_integrada
where	nr_sequencia	= nr_seq_ageint_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_duplicar_agendamento ( nr_seq_ageint_p bigint) FROM PUBLIC;

