-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW apae_item_pendente_pep_v (nr_sequencia, ds_item, nr_seq_apres, nm_usuario, nr_atendimento, dt_liberacao, dt_assinatura, cd_pessoa_fisica, nr_projeto, ds_tipo_fk, ie_processo_assinado) AS SELECT a.nr_sequencia,
	   obter_desc_expressao(315158) ds_item,
	   1 NR_SEQ_APRES,
	   b.nm_usuario,
	   b.nr_atendimento,
	   a.dt_liberacao dt_liberacao,
	   obter_data_assinatura_digital(a.nr_seq_assinatura) dt_assinatura,
	   c.cd_pessoa_fisica,
	   52510 nr_projeto,
       'nr_sequencia' ds_tipo_fk,
       'APAE' ie_processo_assinado
FROM pessoa_fisica c, aval_pre_anestesica a, pep_item_pendente b
LEFT OUTER JOIN atendimento_paciente d ON (b.nr_atendimento = d.nr_atendimento)
WHERE 1 = 1 AND a.nr_sequencia		  		 			= b.nr_seq_registro AND b.cd_pessoa_fisica						= c.cd_pessoa_fisica  AND a.dt_liberacao			IS NOT NULL AND obter_data_assinatura_digital(a.nr_seq_assinatura)	IS NULL AND coalesce(b.ie_pendente_assinat_usuario,'N')			= 'N' AND coalesce(OBTER_PENDENCIA_ASSINATURA(a.nm_usuario, a.nr_sequencia, 'APAE'), 'N') = 'S'

union

SELECT a.nr_sequencia,
       obter_desc_expressao(299216) ds_item,
       2 NR_SEQ_APRES,
       b.nm_usuario,
       b.nr_atendimento,
       a.dt_liberacao dt_liberacao,
       obter_data_assinatura_digital(a.nr_seq_assinatura) dt_assinatura,
       c.cd_pessoa_fisica,
       52789 nr_projeto,
       'nr_sequencia' ds_tipo_fk,
        'TAPAE' ie_processo_assinado
FROM pessoa_fisica c, ehr_registro a, pep_item_pendente b
LEFT OUTER JOIN atendimento_paciente d ON (b.nr_atendimento = d.nr_atendimento)
WHERE 1 = 1 AND a.nr_sequencia = b.nr_seq_ehr_reg AND b.cd_pessoa_fisica = c.cd_pessoa_fisica  AND a.dt_liberacao IS NOT NULL AND obter_data_assinatura_digital(a.nr_seq_assinatura) IS NULL AND coalesce(b.ie_pendente_assinat_usuario,'N') = 'N' AND coalesce(OBTER_PENDENCIA_ASSINATURA(a.nm_usuario, a.nr_sequencia, 'ER'), 'N') = 'S' order by
		NR_SEQ_APRES,
		ds_item;
