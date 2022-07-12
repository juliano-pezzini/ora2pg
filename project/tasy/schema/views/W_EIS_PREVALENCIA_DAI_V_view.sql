-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW w_eis_prevalencia_dai_v (cd_setor, ds_setor_atendimento, dt_avaliacao, ds_sexo, ie_faixa_etaria, ds_fatores, na) AS select	distinct
	Obter_Setor_Atendimento(b.nr_atendimento) cd_setor, 
	substr(obter_nome_setor(Obter_Setor_Atendimento(b.nr_atendimento)),1,255) ds_Setor_Atendimento,	 
	b.dt_avaliacao, 
	substr(obter_sexo_pf(OBTER_PESSOA_ATENDIMENTO(b.nr_atendimento,'C'),'D'),1,20) ds_sexo, 
	substr(Obter_desc_ficha_DAI(null,'E',b.dt_avaliacao,obter_data_nascto_pf(OBTER_PESSOA_ATENDIMENTO(b.nr_atendimento,'C'))),1,20) ie_faixa_etaria, 
	substr(Obter_desc_ficha_DAI(c.nr_seq_item,'F'),1,255) ds_fatores, 
	b.nr_atendimento NA 
FROM atend_paciente_unidade f, eif_escala_item e, eif_escala d, escala_eif b
LEFT OUTER JOIN escala_eif_item c ON (b.nr_sequencia = c.nr_seq_escala)
WHERE d.nr_sequencia = b.nr_seq_escala and b.dt_inativacao is null and upper(d.ds_escala) like upper('%dermatite%')  and (c.ie_resultado = 'S') and ((e.qt_pontos_pos - e.qt_pontos_neg) <> 0) and c.nr_seq_item = e.nr_sequencia and obter_resultado_escala_eif(b.nr_sequencia,'R') = 'S' and f.nr_atendimento = b.nr_atendimento;
