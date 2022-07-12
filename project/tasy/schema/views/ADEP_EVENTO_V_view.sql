-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW adep_evento_v (nr_seq_apresent, ie_tipo_item, nr_atendimento, nr_prescricao, nr_seq_item, cd_item, nr_seq_evento, ie_evento, ds_evento, cd_pessoa_evento, nm_pessoa_evento, dt_evento, dt_evento_real, ds_observacao, ds_justificativa, nr_seq_horario, dt_horario_original, ds_funcao_profissional, dt_assinatura) AS select	1 nr_seq_apresent,
	ie_tipo_item,
	nr_atendimento,
	nr_prescricao,
	null nr_seq_item,
	cd_item,
	nr_sequencia nr_seq_evento,
	ie_alteracao ie_evento,
	substr(obter_valor_dominio(1620,ie_alteracao),1,100) ds_evento,
	cd_pessoa_fisica cd_pessoa_evento,
	substr(obter_nome_pf(cd_pessoa_fisica),1,60) nm_pessoa_evento,
	dt_alteracao dt_evento,
	dt_atualizacao_nrec dt_evento_real,
	ds_observacao,
	ds_justificativa,
	nr_seq_horario_dieta nr_seq_horario,
	dt_horario_original,
	substr(Obter_funcao_usuario_orig(obter_usuario_pf(cd_pessoa_fisica)),1,240) ds_funcao_profissional,
	OBTER_DATA_ASSINATURA_DIGITAL(nr_seq_assinatura) dt_assinatura
FROM	prescr_mat_alteracao
where	ie_tipo_item = 'D'

union

select	2 nr_seq_apresent,
	ie_tipo_item,
	nr_atendimento,
	nr_prescricao,
	nr_seq_prescricao nr_seq_item,
	cd_item,
	nr_sequencia nr_seq_evento,
	ie_alteracao ie_evento,
	substr(obter_valor_dominio(1620,ie_alteracao),1,100) ds_evento,
	cd_pessoa_fisica cd_pessoa_evento,
	substr(obter_nome_pf(cd_pessoa_fisica),1,60) nm_pessoa_evento,
	dt_alteracao dt_evento,
	dt_atualizacao_nrec dt_evento_real,
	ds_observacao,
	ds_justificativa,
	nr_seq_horario nr_seq_horario,
	dt_horario_original,
	substr(Obter_funcao_usuario_orig(obter_usuario_pf(cd_pessoa_fisica)),1,240) ds_funcao_profissional,
	OBTER_DATA_ASSINATURA_DIGITAL(nr_seq_assinatura) dt_assinatura
from	prescr_mat_alteracao
where	ie_tipo_item = 'S'

union

select	3 nr_seq_apresent,
	ie_tipo_item,
	nr_atendimento,
	nr_prescricao,
	nr_seq_prescricao nr_seq_item,
	cd_item,
	nr_sequencia nr_seq_evento,
	ie_alteracao ie_evento,
	substr(obter_valor_dominio(1620,ie_alteracao),1,100) ds_evento,
	cd_pessoa_fisica cd_pessoa_evento,
	substr(obter_nome_pf(cd_pessoa_fisica),1,60) nm_pessoa_evento,
	dt_alteracao dt_evento,
	dt_atualizacao_nrec dt_evento_real,
	ds_observacao,
	ds_justificativa,
	nr_seq_horario nr_seq_horario,
	dt_horario_original,
	substr(Obter_funcao_usuario_orig(obter_usuario_pf(cd_pessoa_fisica)),1,240) ds_funcao_profissional,
	OBTER_DATA_ASSINATURA_DIGITAL(nr_seq_assinatura) dt_assinatura
from	prescr_mat_alteracao
where	ie_tipo_item = 'M'

union

select	4 nr_seq_apresent,
	ie_tipo_item,
	nr_atendimento,
	nr_prescricao,
	nr_seq_prescricao nr_seq_item,
	cd_item,
	nr_sequencia nr_seq_evento,
	ie_alteracao ie_evento,
	substr(obter_valor_dominio(1620,ie_alteracao),1,100) ds_evento,
	cd_pessoa_fisica cd_pessoa_evento,
	substr(obter_nome_pf(cd_pessoa_fisica),1,60) nm_pessoa_evento,
	dt_alteracao dt_evento,
	dt_atualizacao_nrec dt_evento_real,
	ds_observacao,
	ds_justificativa,
	nr_seq_horario nr_seq_horario,
	dt_horario_original,
	substr(Obter_funcao_usuario_orig(obter_usuario_pf(cd_pessoa_fisica)),1,240) ds_funcao_profissional,
	OBTER_DATA_ASSINATURA_DIGITAL(nr_seq_assinatura) dt_assinatura
from	prescr_mat_alteracao
where	ie_tipo_item = 'MAT'

union

select	5 nr_seq_apresent,
	ie_tipo_item,
	nr_atendimento,
	nr_prescricao,
	nr_seq_procedimento nr_seq_item,
	cd_item,
	nr_sequencia nr_seq_evento,
	ie_alteracao ie_evento,
	substr(obter_valor_dominio(1620,ie_alteracao),1,100) ds_evento,
	cd_pessoa_fisica cd_pessoa_evento,
	substr(obter_nome_pf(cd_pessoa_fisica),1,60) nm_pessoa_evento,
	dt_alteracao dt_evento,
	dt_atualizacao_nrec dt_evento_real,
	ds_observacao,
	ds_justificativa,
	nr_seq_horario_proc nr_seq_horario,
	dt_horario_original,
	substr(Obter_funcao_usuario_orig(obter_usuario_pf(cd_pessoa_fisica)),1,240) ds_funcao_profissional,
	OBTER_DATA_ASSINATURA_DIGITAL(nr_seq_assinatura) dt_assinatura
from	prescr_mat_alteracao
where	ie_tipo_item in ('P', 'G')

union

select	6 nr_seq_apresent,
	ie_tipo_item,
	nr_atendimento,
	nr_prescricao,
	nr_seq_recomendacao nr_seq_item,
	cd_item,
	nr_sequencia nr_seq_evento,
	ie_alteracao ie_evento,
	substr(obter_valor_dominio(1620,ie_alteracao),1,100) ds_evento,
	cd_pessoa_fisica cd_pessoa_evento,
	substr(obter_nome_pf(cd_pessoa_fisica),1,60) nm_pessoa_evento,
	dt_alteracao dt_evento,
	dt_atualizacao_nrec dt_evento_real,
	ds_observacao,
	ds_justificativa,
	nr_seq_horario_rec nr_seq_horario,
	dt_horario_original,
	substr(Obter_funcao_usuario_orig(obter_usuario_pf(cd_pessoa_fisica)),1,240) ds_funcao_profissional,
	OBTER_DATA_ASSINATURA_DIGITAL(nr_seq_assinatura) dt_assinatura
from	prescr_mat_alteracao
where	ie_tipo_item = 'R'

union

select	7 nr_seq_apresent,
	ie_tipo_item,
	nr_atendimento,
	nr_prescricao,
	nr_seq_item_sae nr_seq_item,
	cd_item,
	nr_sequencia nr_seq_evento,
	ie_alteracao ie_evento,
	substr(obter_valor_dominio(1620,ie_alteracao),1,100) ds_evento,
	cd_pessoa_fisica cd_pessoa_evento,
	substr(obter_nome_pf(cd_pessoa_fisica),1,60) nm_pessoa_evento,
	dt_alteracao dt_evento,
	dt_atualizacao_nrec dt_evento_real,
	ds_observacao,
	ds_justificativa,
	nr_seq_horario_sae nr_seq_horario,
	dt_horario_original,
	substr(Obter_funcao_usuario_orig(obter_usuario_pf(cd_pessoa_fisica)),1,240) ds_funcao_profissional,
	OBTER_DATA_ASSINATURA_DIGITAL(nr_seq_assinatura) dt_assinatura
from	prescr_mat_alteracao
where	ie_tipo_item = 'E'

union

select	3 nr_seq_apresent,
	ie_tipo_item,
	nr_atendimento,
	nr_prescricao,
	nr_seq_prescricao nr_seq_item,
	cd_item,
	nr_sequencia nr_seq_evento,
	ie_alteracao ie_evento,
	substr(obter_valor_dominio(1620,ie_alteracao),1,100) ds_evento,
	cd_pessoa_fisica cd_pessoa_evento,
	substr(obter_nome_pf(cd_pessoa_fisica),1,60) nm_pessoa_evento,
	dt_alteracao dt_evento,
	dt_atualizacao_nrec dt_evento_real,
	ds_observacao,
	ds_justificativa,
	nr_seq_horario nr_seq_horario,
	dt_horario_original,
	substr(Obter_funcao_usuario_orig(obter_usuario_pf(cd_pessoa_fisica)),1,240) ds_funcao_profissional,
	OBTER_DATA_ASSINATURA_DIGITAL(nr_seq_assinatura) dt_assinatura
from	prescr_mat_alteracao
where	ie_tipo_item = 'IC'

union

select	9 nr_seq_apresent,
	ie_tipo_item,
	nr_atendimento,
	nr_prescricao,
	nr_seq_prescricao nr_seq_item,
	cd_item,
	nr_sequencia nr_seq_evento,
	ie_alteracao ie_evento,
	substr(obter_valor_dominio(1620,ie_alteracao),1,100) ds_evento,
	cd_pessoa_fisica cd_pessoa_evento,
	substr(obter_nome_pf(cd_pessoa_fisica),1,60) nm_pessoa_evento,
	dt_alteracao dt_evento,
	dt_atualizacao_nrec dt_evento_real,
	ds_observacao,
	ds_justificativa,
	nr_seq_horario nr_seq_horario,
	dt_horario_original,
	substr(Obter_funcao_usuario_orig(obter_usuario_pf(cd_pessoa_fisica)),1,240) ds_funcao_profissional,
	OBTER_DATA_ASSINATURA_DIGITAL(nr_seq_assinatura) dt_assinatura
from	prescr_mat_alteracao
where	ie_tipo_item = 'IA';
