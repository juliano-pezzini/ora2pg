-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW bft_allergy_v (patient_id, allergy_sequence_id, allergy_code, mnemonic_description, allergy_severity, allergy_reaction, food_allergy_identifier, drug_allergy_identifier, latex_allergy_identifier, identification_date, record_date, allergy_description) AS select	a.cd_pessoa_fisica patient_id,
	a.nr_sequencia allergy_sequence_id,
	a.nr_seq_tipo allergy_code,
	b.ds_tipo_alergia mnemonic_description,
	CASE WHEN a.nr_seq_nivel_seg=1 THEN 'MI' WHEN a.nr_seq_nivel_seg=2 THEN 'MO' WHEN a.nr_seq_nivel_seg=3 THEN 'SV'  ELSE 'U' END  allergy_severity,
	substr(obter_desc_reacao_alergica(a.nr_seq_reacao),1,100) allergy_reaction,
	b.ie_alimento food_allergy_identifier,
	b.ie_cadastro drug_allergy_identifier,
	b.ie_latex latex_allergy_identifier,
	a.dt_inicio identification_date,
	a.dt_registro record_date,
	coalesce(obter_desc_alergia(a.nr_sequencia),b.ds_tipo_alergia) allergy_description
FROM paciente_alergia a
LEFT OUTER JOIN tipo_alergia b ON (a.nr_seq_tipo = b.nr_sequencia)
WHERE ((a.dt_fim is null) or (LOCALTIMESTAMP between coalesce(a.dt_inicio,LOCALTIMESTAMP - interval '1 days') and a.dt_fim)) and a.dt_inativacao is null and a.dt_liberacao is not null;

