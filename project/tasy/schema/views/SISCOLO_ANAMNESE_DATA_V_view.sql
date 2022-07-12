-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW siscolo_anamnese_data_v (nr_sequencia, dt_atualizacao, dt_atualizacao_nrec, nm_usuario, nm_usuario_nrec, sg_estado, cd_municipio_ibge, cd_cnes, ds_razao_social, nr_prontuario, ie_fez_papanicolau, dt_ultimo_exame_papanic, ie_usa_diu, ie_gravida, ie_usa_anticoncep, ie_usa_hormonio, ie_fez_radio, dt_ultima_mestrua, ie_sang_relacao, ie_sang_menopausa, ie_inspecao_colo, ie_sinal_dst, dt_coleta, dt_recebimento, nm_pessoa_coleta, ie_pessoa_coleta, nr_seq_siscolo, nr_prescricao) AS select  a.nr_sequencia,
        a.dt_atualizacao,
        a.dt_atualizacao_nrec,
        a.nm_usuario,
        a.nm_usuario_nrec,
        c.sg_estado,
        c.cd_municipio_ibge,
        c.cd_cnes,
        substr(elimina_aspas(c.ds_razao_social),1,40) ds_razao_social,
        g.nr_prontuario,
        d.ie_fez_papanicolau,
        d.dt_ultimo_exame_papanic,
        d.ie_usa_diu,
        d.ie_gravida,
        d.ie_usa_anticoncep,
        d.ie_usa_hormonio,
        d.ie_fez_radio,
        d.dt_ultima_mestrua,
        d.ie_sang_relacao,
        d.ie_sang_menopausa,
        d.ie_inspecao_colo,
        d.ie_sinal_dst,
        d.dt_coleta,
        obter_data_frasco_pato(e.nr_sequencia, 30) dt_recebimento,
        substr(elimina_aspas(g.nm_pessoa_fisica),1,40) nm_pessoa_coleta,
        CASE WHEN g.nm_pessoa_fisica IS NULL THEN  'N'  ELSE 'S' END  ie_pessoa_coleta,
        d.nr_seq_siscolo,
        a.nr_prescricao
FROM siscolo_cito_anamnese d, atendimento_paciente b
LEFT OUTER JOIN pessoa_juridica c ON (b.cd_cgc_indicacao = c.cd_cgc)
, frasco_pato_loc e
LEFT OUTER JOIN siscolo_atendimento a ON (e.nr_prescricao = a.nr_prescricao)
, prescr_procedimento f
LEFT OUTER JOIN pessoa_fisica g ON (f.cd_pessoa_coleta = g.cd_pessoa_fisica)
WHERE b.nr_atendimento = a.nr_atendimento  and f.nr_prescricao = a.nr_prescricao and d.nr_seq_siscolo = a.nr_sequencia;

