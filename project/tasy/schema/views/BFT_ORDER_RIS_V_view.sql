-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW bft_order_ris_v (prescription_number, prescription_item_sequence, procedure_code, internal_procedure_code, exam_procedure_name, ordering_provider_id_number, ordering_provider_given_name, ordering_provider_last_name, ordering_provider_middle_name, released_user_provider_num, nm_medico_solicitante, diagnostic_service_section_id, priority, requested_date_time, start_date_time, internal_prescription_code, relevant_clinical_data, relevant_clinical_information, entity_identifier, notes, side_for_exam, exam_department_code, is_suspended, suspended_time, image_exam_status, nr_prescricao, nr_seq_interno, date_acknowledged, user_acknowledged, interface_id, procedure_type_id, actual_date, exam_procedure_code, nr_seq_proc_hor) AS select	a.nr_prescricao prescription_number,
	a.nr_sequencia prescription_item_sequence,
	a.cd_procedimento procedure_code,
	a.nr_seq_proc_interno internal_procedure_code,
	elimina_acentuacao(c.ds_proc_exame) exam_procedure_name,
	b.cd_medico ordering_provider_id_number,
	obter_dados_pf(b.cd_medico,'PNG') ordering_provider_given_name,
	obter_dados_pf(b.cd_medico,'PNL') ordering_provider_last_name,
	obter_dados_pf(b.cd_medico,'PNM') ordering_provider_middle_name,
	get_provider_details(b.cd_medico, b.cd_estabelecimento, null) released_user_provider_num,
	substr(obter_nome_pf(a.cd_medico_exec),1,80) nm_medico_solicitante,
	substr((select max(x.ds_modalidade) FROM regra_proc_interno_integra x where x.nr_seq_proc_interno = a.nr_seq_proc_interno),1,10) diagnostic_service_section_id,
	a.ie_urgencia priority,
	b.dt_liberacao requested_date_time,
        coalesce(d.dt_horario,a.dt_prev_execucao) start_date_time,
	a.nr_seq_interno internal_prescription_code,
	a.ds_dado_clinico relevant_clinical_data,
	elimina_acentuacao(c.ds_proc_exame) || CASE WHEN a.ds_dado_clinico IS NULL THEN ''  ELSE '. ' ||elimina_acentuacao(a.ds_dado_clinico) END  relevant_clinical_information,
	a.nr_acesso_dicom entity_identifier ,
	substr(a.ds_observacao,1,4000) notes,
	a.ie_lado side_for_exam,
	a.cd_setor_atendimento exam_department_code,
	a.ie_suspenso is_suspended,
	a.dt_suspensao suspended_time,
	a.ie_status_execucao image_exam_status,
	b.nr_prescricao,
	a.nr_seq_interno,
   	(select max(dt_atualizacao_nrec)
	from laudo_paciente_ciente lpc
	where lpc.nr_sequencia = (select  max(x.nr_sequencia)
				from laudo_paciente_ciente x
				where x.nr_prescricao = a.nr_prescricao
				and x.nr_seq_prescricao = a.nr_sequencia
				and x.ie_tipo_acao = 'M'))  date_acknowledged,
	substr(get_user_report_ack(a.nr_prescricao,a.nr_sequencia),1,20) user_acknowledged,
	(select max(DS_INTERFACE_IDENTIFIER) from proc_interno_integracao y where y.nr_seq_proc_interno = a.nr_seq_proc_interno) interface_id,
	Obter_tipo_procedimento(a.cd_procedimento,a.ie_origem_proced,'C') procedure_type_id,
	LOCALTIMESTAMP actual_date,
	c.CD_INTEGRACAO exam_procedure_code,
        d.nr_sequencia nr_seq_proc_hor
from 	prescr_procedimento a,
	prescr_medica b,
	proc_interno c,
  prescr_proc_hor d 
where	a.nr_prescricao        = b.nr_prescricao
and  	a.nr_seq_proc_interno  = c.nr_sequencia
and   a.nr_prescricao         = d.nr_prescricao 
and   a.nr_sequencia       = d.nr_seq_procedimento 
and  	a.NR_SEQ_EXAME IS NULL;

