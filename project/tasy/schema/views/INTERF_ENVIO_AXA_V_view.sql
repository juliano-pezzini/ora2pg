-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW interf_envio_axa_v (nr_ordem, nr_interno_conta, ie_tipo_registro, cd_chave_hospital, cd_chave_aseguradora, cd_chave_paciente, nm_paciente, dt_nascimento, ie_sexo, nr_quarto, dt_entrada_hospital, hr_entrada_hospital, cd_medico_resp, dt_saida, hr_saida, vl_total_cobrar, cd_icd, cd_cpd, ie_tipo_validacao, vl_perc_coparticipacao, vl_deduzido, vl_topo_coparticipacao, cd_codigo_produto, vl_perc_desc, qt_quantidade, vl_preco_unitario, ds_descricao, ds_grupo, dt_servico, ds_area) AS SELECT  1 nr_ordem,
	a.nr_interno_conta,
        'E' ie_tipo_registro,
        lpad(coalesce(nullif(obter_codigo_interno_conv(a.cd_estabelecimento, a.cd_convenio_parametro),'0'),'16'), 6, ' ') cd_chave_hospital,
        lpad('9', 6, ' ') cd_chave_aseguradora,
        a.nr_atendimento cd_chave_paciente,
        c.nm_pessoa_fisica nm_paciente,
        to_char(c.dt_nascimento, 'DD/MM/YYYY') dt_nascimento,
        c.ie_sexo,
        substr(obter_unidade_atendimento(a.nr_atendimento, 'A', 'U'),1,30) nr_quarto,
        to_char(b.dt_entrada, 'DD/MM/YYYY') dt_entrada_hospital,
        to_char(b.dt_entrada, 'HH24:MI') hr_entrada_hospital,
        substr(obter_nome_pf(b.cd_medico_resp),1,30)cd_medico_resp,
        to_char(b.dt_alta, 'DD/MM/YYYY') dt_saida,
        to_char(b.dt_alta, 'HH24:MI') hr_saida,
        lpad(campo_mascara_virgula(obter_valor_conta(a.nr_interno_conta, 0) + a.vl_desconto), 16, ' ') vl_total_cobrar,
        '' cd_icd,
        '' cd_cpd,
        CASE WHEN obter_se_atendimento_alta(a.nr_atendimento)='S' THEN 'V'  ELSE 'C' END  ie_tipo_validacao,
        lpad(campo_mascara_virgula(a.pr_coseguro_hosp), 6, ' ') vl_perc_coparticipacao,
        lpad(campo_mascara_virgula(a.vl_deduzido), 16, ' ') vl_deduzido,
        '' vl_topo_coparticipacao,
        0 cd_codigo_produto,
        '' vl_perc_desc,
        '' qt_quantidade,
        '' vl_preco_unitario,
        '' ds_descricao,
        '' ds_grupo,
        '' dt_servico,
        '' ds_area
FROM    conta_paciente a,
        atendimento_paciente b,
        pessoa_fisica c
WHERE   a.nr_atendimento = b.nr_atendimento
AND     b.cd_pessoa_fisica = c.cd_pessoa_fisica

UNION ALL

SELECT  2 nr_ordem,
	a.nr_interno_conta,
        'D' ie_tipo_registro,
        '' cd_chave_hospital,
        '' cd_chave_aseguradora,
        0 cd_chave_paciente,
        '' nm_paciente,
        '' dt_nascimento,
        '' ie_sexo,
        '' nr_quarto,
        '' dt_entrada_hospital,
        '' hr_entrada_hospital,
        '' cd_medico_resp,
        '' dt_saida,
        '' hr_saida,
        '' vl_total_cobrar,
        '' cd_icd,
        '' cd_cpd,
        '' ie_tipo_validacao,
        '' vl_perc_coparticipacao,
        '' vl_deduzido,
        '' vl_topo_coparticipacao,
        a.cd_item cd_codigo_produto,
        substr(GNP_OBTER_PR_DESC_PROCMAT(a.nr_sequencia,a.ie_proc_mat),1,10) vl_perc_desc,
	lpad(campo_mascara_virgula(a.qt_item), 7, ' ') qt_quantidade,
        lpad(campo_mascara_virgula(round((a.vl_unitario)::numeric,2)), 16, ' ') vl_preco_unitario,
        a.ds_item ds_descricao,
        substr(obter_desc_local_estoque(a.cd_local_estoque),1,100) ds_grupo,
        to_char(a.dt_item, 'YYYY/MM/DD HH24:MI:SS') dt_servico,
        '' ds_area
FROM conta_paciente_v a;

