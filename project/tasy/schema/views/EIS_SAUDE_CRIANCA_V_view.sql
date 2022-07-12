-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_saude_crianca_v (nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, cd_pessoa_fisica, nr_seq_area, nr_seq_microarea, nr_atendimento, ie_nasc_vivo, qt_peso_nasc, dt_nascimento, dt_referencia, qt_vacina, ds_area, qt_vacina_dia, qt_vacina_menor_1, qt_menor_2, qt_peso_menor_2, qt_peso_abaixo_2500, qt_nasc_vivo, qt_atendimento, qt_crianca) AS select	a.NR_SEQUENCIA,a.DT_ATUALIZACAO,a.NM_USUARIO,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.CD_PESSOA_FISICA,a.NR_SEQ_AREA,a.NR_SEQ_MICROAREA,a.NR_ATENDIMENTO,a.IE_NASC_VIVO,a.QT_PESO_NASC,a.DT_NASCIMENTO,a.DT_REFERENCIA,a.QT_VACINA,
			substr(obter_desc_area_domicilio(nr_seq_area),1,255) ds_area,
			(select count(*) FROM eis_saude_crianca x where x.qt_vacina = 0) qt_vacina_dia,
			(select count(*) from eis_saude_crianca x where x.qt_vacina = 0 and obter_idade(dt_nascimento,LOCALTIMESTAMP, 'M') <= 12 and x.nr_seq_area = a.nr_seq_area) qt_vacina_menor_1,
			(select count(*) from eis_saude_crianca x where obter_idade(x.dt_nascimento,LOCALTIMESTAMP, 'M') <= 24) qt_menor_2,
			(select count(*) from eis_saude_crianca x where obter_idade(x.dt_nascimento,LOCALTIMESTAMP, 'M') <= 24 and qt_peso_nasc is not null and x.nr_seq_area = a.nr_seq_area) qt_peso_menor_2,
			(select count(*) from eis_saude_crianca x where qt_peso_nasc < 2500 and x.nr_seq_area = a.nr_seq_area) qt_peso_abaixo_2500,
			(select count(*) from eis_saude_crianca x where ie_nasc_vivo = 'S') qt_nasc_vivo,
			(select count(*) from eis_saude_crianca x where Obter_Idade(x.dt_nascimento,LOCALTIMESTAMP,'A') <= 2 and x.nr_seq_area = a.nr_seq_area) qt_atendimento,
			(select count(distinct cd_pessoa_fisica) from eis_saude_crianca x where Obter_Idade(x.dt_nascimento,LOCALTIMESTAMP,'A') <= 2) qt_crianca
	from	eis_saude_crianca a;

