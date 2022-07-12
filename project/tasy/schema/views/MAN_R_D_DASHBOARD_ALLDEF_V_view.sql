-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW man_r_d_dashboard_alldef_v (nr_sequencia, ds_periodo_os, dt_ordem_servico, ds_estagio, ds_dano_breve, ds_localizacao, ds_grupo_des, nr_seq_estagio, nr_seq_gerencia, nr_seq_status, ie_tipo_sla, nr_atraso, ds_hr_rest_pr_resp, ds_hr_rest_solucao, nm_usuario_executor, ie_sla_leg) AS select
    os.NR_SEQUENCIA,
    os.DS_PERIODO_OS,
    os.DT_ORDEM_SERVICO,
    os.DS_ESTAGIO,
    os.DS_DANO_BREVE,
    os.DS_LOCALIZACAO,
    os.DS_GRUPO_DES,
    os.NR_SEQ_ESTAGIO,
    os.NR_SEQ_GERENCIA,
    os.NR_SEQ_STATUS,
    os.IE_TIPO_SLA,
    CASE WHEN substr(ds_periodo_os,1,1)='G' THEN  1 WHEN substr(ds_periodo_os,1,1)='W' THEN  2 WHEN substr(ds_periodo_os,1,1)='C' THEN  3 WHEN substr(ds_periodo_os,1,1)='B' THEN  4 END  nr_atraso,
    man_obter_tempo_sla_formatado(qt_min_rest_pr_resp) ds_hr_rest_pr_resp,
    man_obter_tempo_sla_formatado(qt_min_rest_solucao) ds_hr_rest_solucao,
    substr(obter_nome_usuario(man_obter_executor_ativo(os.nr_sequencia)), 1, 100) nm_usuario_executor,
    os.ie_sla_leg
FROM (   
            select  b.nr_sequencia,
                    b.dt_ordem_servico,
                    obter_desc_expressao_idioma(c.cd_exp_estagio,c.ds_estagio,5) ds_estagio,
                    substr(b.ds_dano_breve,1,255) ds_dano_breve,
                    substr(e.ds_localizacao,1,255) ds_localizacao,
                    substr(d.ds_grupo,1,100) ds_grupo_des,
                    b.nr_seq_estagio,
                    d.nr_seq_gerencia,
                    a.nr_seq_status,
                    coalesce(a.ie_tipo_sla, 998) ie_tipo_sla,
                    sla_dashboard_pck.obter_status_resp(b.nr_sequencia) ds_periodo_os,
                    sla_dashboard_pck.obter_min_resp_rest(b.nr_sequencia) qt_min_rest_pr_resp,
                    sla_dashboard_pck.obter_min_solucao(b.nr_sequencia) qt_min_rest_solucao,
                    CASE WHEN a.ie_tipo_sla=1 THEN  8665 WHEN a.ie_tipo_sla=2 THEN  8666 END  ie_sla_leg
            from    man_ordem_serv_sla a,
                    man_ordem_servico b,
                    man_estagio_processo c,
                    grupo_desenvolvimento d,
                    man_localizacao e
            where   a.nr_seq_ordem = b.nr_sequencia
            and     b.nr_seq_estagio = c.nr_sequencia
            and     b.nr_seq_grupo_des = d.nr_sequencia
            and     b.nr_seq_localizacao = e.nr_sequencia
            and     c.ie_situacao = 'A'
            and     d.ie_situacao = 'A'
            and     c.ie_situacao = 'A'
            and (c.ie_desenv = 'S' or c.ie_tecnologia = 'S')
            and     b.ie_status_ordem <> 3
            and     a.nr_seq_status > 0
            and     ie_tipo_sla = 3
            and     ie_tipo_sla_termino = 3
          ) os;

