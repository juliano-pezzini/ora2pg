-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW bft_service_request_v (encounter_id, request_date, release_date, service_description, service_quantity, service_urgency, justification, clinical_data, icd_code, previous_exam, icd_description, request_desc) AS select	a.nr_atendimento encounter_id,
	a.dt_solicitacao request_date,
	a.dt_liberacao release_date,
	substr(obter_med_exame_externo(b.nr_sequencia),1,255) service_description,
	b.qt_exame service_quantity,
	b.ie_urgente service_urgency,
	coalesce(b.ds_justificativa,a.ds_justificativa) justification,
	a.ds_dados_clinicos clinical_data,
	a.cd_doenca icd_code,
	a.ds_exame_ant previous_exam,
	a.ds_cid icd_description,
	a.ds_solicitacao request_desc
FROM	pedido_exame_externo a,
	pedido_exame_externo_item b
where	a.nr_sequencia			= b.nr_seq_pedido
and	a.dt_liberacao is not null
and	a.dt_inativacao is null;

