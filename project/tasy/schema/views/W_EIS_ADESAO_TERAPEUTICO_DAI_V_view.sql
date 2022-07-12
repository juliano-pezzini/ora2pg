-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW w_eis_adesao_terapeutico_dai_v (cd_setor, ds_setor_atendimento, dt_evento, ds_unidade, ie_sexo, ds_sexo, ie_faixa_etaria, ie_prescrito, na) AS select	distinct
	b.cd_setor_atendimento cd_setor, 
	SUBSTR(obter_nome_setor(b.cd_setor_atendimento),1,255) ds_Setor_Atendimento,	 
	b.dt_evento, 
	obter_unidade_atendimento(b.nr_atendimento,'A','U') ds_unidade, 
	obter_sexo_pf(b.cd_pessoa_fisica,'C') ie_sexo, 
	obter_sexo_pf(b.cd_pessoa_fisica,'D') ds_sexo, 
	SUBSTR(Obter_desc_ficha_DAI(null,'E',b.dt_Evento,obter_data_nascto_pf(b.cd_pessoa_fisica)),1,80) ie_faixa_etaria, 
	SUBSTR(Obter_desc_ficha_DAI(b.nr_atendimento,'PT',b.dt_evento),1,10) ie_prescrito,	 
	b.nr_atendimento NA 
FROM	qua_evento_paciente b, 
	qua_tipo_evento d, 
	qua_evento f, 
	qua_evento_dermatite a 
where	b.dt_inativacao is null 
and	a.nr_seq_evento = b.nr_sequencia 
and	d.ie_tipo_evento = 'DAI' 
and	d.nr_sequencia = f.nr_Seq_tipo 
and	b.nr_Seq_evento = f.nr_sequencia 
and	a.ie_origem_dermatite = 'U';
