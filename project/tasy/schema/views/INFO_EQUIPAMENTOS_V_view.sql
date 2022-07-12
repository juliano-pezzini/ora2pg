-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW info_equipamentos_v (cd_estabelecimento, ds_estabelecimento, qt_estoque, qt_manutencao, qt_emprestado, cd_medico, ds_medico_solic, qt_pac_em_uso, qt_tempo_uso, qt_aguard_disponibilidade, cd_equipamento, ds_equipamento, dt_agenda, qt_equipamento, ie_status_agenda) AS select	a.cd_estabelecimento cd_estabelecimento, -- info e dimensão
			obter_nome_estabelecimento(a.cd_estabelecimento) ds_estabelecimento,
			CASE WHEN obter_status_equipamento(b.nr_sequencia, a.cd_equipamento, 'S')='D' THEN a.qt_equipamento  ELSE 0 END  qt_estoque,
			obter_qt_equip_manutencao(a.cd_classificacao, a.cd_equipamento, b.dt_agenda) qt_manutencao,
			CASE WHEN obter_status_equipamento(b.nr_sequencia, a.cd_equipamento, 'S')='E' THEN a.qt_equipamento  ELSE 0 END  qt_emprestado,
			e.cd_medico cd_medico, -- info e dimensão
			obter_nome_medico(e.cd_medico, 'NC') ds_medico_solic,
			1 qt_pac_em_uso,
			obter_tempo_uso_equipamento(b.nr_sequencia,a.cd_classificacao) qt_tempo_uso,
			CASE WHEN obter_status_equipamento(b.nr_sequencia, a.cd_equipamento, 'S')='I' THEN a.qt_equipamento  ELSE 0 END  qt_aguard_disponibilidade,
			a.cd_equipamento cd_equipamento,-- info e dimensão
			a.ds_equipamento ds_equipamento,
			b.dt_agenda,
			0 qt_equipamento,
			b.ie_status_agenda
FROM	equipamento a,
		agenda_paciente b,
		agenda_pac_equip c,
		prescr_medica e,
		atendimento_paciente f
where 	a.cd_equipamento = c.cd_equipamento
and 	b.nr_sequencia = c.nr_seq_agenda
and     a.ie_situacao  = 'A'
and 	f.nr_atendimento = b.nr_atendimento
and 	f.nr_atendimento = e.nr_atendimento

union

select 		a.cd_estabelecimento cd_estabelecimento,
			obter_nome_estabelecimento(a.cd_estabelecimento) ds_estabelecimento,
			0 qt_estoque,
			0 qt_manutencao,
			0 qt_emprestado,
			null cd_medico,
			null ds_medico_solic,
			0 qt_pac_em_uso,
			0 qt_tempo_uso,
			0 qt_aguard_disponibilidade,
			a.cd_equipamento cd_equipamento,
			obter_desc_equipamento(a.cd_equipamento) ds_equipamento,
			a.dt_atualizacao_nrec dt_agenda,
			a.qt_equipamento qt_equipamento,
			null ie_status_agenda
from	equipamento a
where   a.ie_situacao  = 'A';
