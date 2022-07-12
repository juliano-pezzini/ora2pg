-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW matrix_pedido_ws_v7_v (identificacao_paciente, nr_prescricao, nr_atendimento, dt_mestruacao, altura, peso, usuario, codigo_convenio, nome_convenio, cd_plano_convenio, nome_plano, matricula, validade_carteirinha, guia, senha, cd_clinica, ds_clinica, ds_medicamentos, cd_setor_atendimento, ds_setor_atendimento, cd_setor_coleta, ds_setor_coleta, cd_setor_entrega, ds_setor_entrega, cd_setor_externo, ds_setor_externo, ds_leito, ie_metodo, ds_estabelecimento, cd_estabelecimento, dados_clinicos, ds_observacao, empresaconvenio, prioridade, dados_tecnicos, dt_entrega, dt_prescricao, nm_usuario_original) AS SELECT	a.cd_pessoa_fisica identificacao_paciente,
		    b.nr_prescricao,
        b.nr_atendimento,
        coalesce(to_char(b.dt_mestruacao,'dd/mm/yyyy hh24:mi:ss'), '01/01/1900 00:00:00') dt_mestruacao,
        CASE WHEN coalesce((select UPPER(IE_MATRIX_CONVERTE_VIRG_PONTO)                    FROM   lab_parametro                    where  cd_estabelecimento = a.cd_estabelecimento), 'N')='S' THEN  TO_CHAR(b.qt_altura_cm / 100) WHEN coalesce((select UPPER(IE_MATRIX_CONVERTE_VIRG_PONTO)                    FROM   lab_parametro                    where  cd_estabelecimento = a.cd_estabelecimento), 'N')='N' THEN (replace(b.qt_altura_cm / 100, '.',','))  END  altura,
        CASE WHEN coalesce((select UPPER(IE_MATRIX_CONVERTE_VIRG_PONTO)                    from   lab_parametro                    where  cd_estabelecimento = a.cd_estabelecimento), 'N')='S' THEN  TO_CHAR(b.qt_peso) WHEN coalesce((select UPPER(IE_MATRIX_CONVERTE_VIRG_PONTO)                    from   lab_parametro                    where  cd_estabelecimento = a.cd_estabelecimento), 'N')='N' THEN  replace(b.qt_peso, '.',',')  END  peso,
		    b.nm_usuario usuario,
		    d.cd_integracao codigo_Convenio,
		    SUBSTR(d.ds_convenio,1,50) nome_Convenio,
        c.cd_plano_convenio,
		    substr(obter_desc_plano(d.cd_convenio, c.cd_plano_convenio),1,255) nome_plano,
        c.cd_usuario_convenio matricula,
        to_char(c.dt_validade_carteira, 'dd/mm/rrrr hh24:mi:ss') validade_Carteirinha,
        SUBSTR(c.nr_doc_convenio,1,20) guia,
        SUBSTR(c.cd_senha,1,20) senha,
        coalesce(obter_conv_meio_ext_int('PRESCR_MEDICA', 'CD_SETOR_ATENDIMENTO', E.CD_SETOR_ATENDIMENTO, 'MX'), B.CD_SETOR_ATENDIMENTO) cd_clinica,
        SUBSTR(e.ds_setor_atendimento,1,255) ds_clinica,
        SUBSTR(obter_medic_hist_saude_atend(a.nr_atendimento),1,255) ds_medicamentos,
        coalesce(obter_conv_meio_ext_int('PRESCR_MEDICA', 'CD_SETOR_ATENDIMENTO', F.CD_SETOR_ATENDIMENTO, 'MX'), F.CD_SETOR_ATENDIMENTO) cd_setor_atendimento,
        SUBSTR(obter_nome_setor(f.cd_setor_atendimento),1,30) ds_setor_atendimento,
        coalesce(obter_conv_meio_ext_int('PRESCR_MEDICA', 'CD_SETOR_ATENDIMENTO', F.CD_SETOR_ATENDIMENTO, 'MX'), F.CD_SETOR_ATENDIMENTO) cd_setor_coleta,
        SUBSTR(obter_nome_setor(f.cd_setor_atendimento),1,30) ds_setor_coleta,
        coalesce(obter_conv_meio_ext_int('PRESCR_MEDICA', 'CD_SETOR_ATENDIMENTO', B.CD_SETOR_ENTREGA, 'MX'), B.CD_SETOR_ENTREGA) cd_setor_entrega,
        SUBSTR(obter_nome_setor(b.cd_setor_entrega),1,30) ds_setor_entrega,
        coalesce(obter_conv_meio_ext_int('PRESCR_MEDICA', 'CD_SETOR_ATENDIMENTO', E.CD_SETOR_ATENDIMENTO, 'MX'), B.CD_SETOR_ATENDIMENTO) cd_setor_externo,
        SUBSTR(obter_nome_setor(e.cd_setor_atendimento),1,30) ds_setor_externo,
        SUBSTR(f.cd_unidade_basica||' '||f.cd_unidade_compl,1,20) ds_leito,
        'RecebePedido' ie_metodo,
        obter_nome_estab( e.cd_estabelecimento) ds_estabelecimento,
        e.cd_estabelecimento,
        substr(Obter_select_concatenado_bv('select ds_dado_clinico from prescr_procedimento pp where pp.nr_seq_exame is not null and pp.nr_prescricao = :nr_prescricao','nr_prescricao='||b.nr_prescricao,','),1,255) dados_clinicos,
        substr(a.ds_observacao,1,255) ds_observacao,
        obter_dados_pf_pj(null, d.cd_cgc,'N') EmpresaConvenio,
        (SELECT CASE WHEN count(*)=0 THEN 'R'  ELSE 'U' END  cont FROM PRESCR_PROCEDIMENTO where ie_urgencia = 'S' and nr_prescricao = b.nr_prescricao) prioridade,
        substr(b.ds_obs_enfermagem,1,255) dados_tecnicos,
        to_char(b.dt_entrega, 'dd/mm/rrrr hh24:mi:ss') dt_entrega,
        to_char(b.dt_prescricao, 'dd/mm/rrrr hh24:mi:ss') dt_prescricao,
        b.nm_usuario_original
FROM atend_paciente_unidade f, convenio d, atend_categoria_convenio c, atendimento_paciente a, prescr_medica b
LEFT OUTER JOIN setor_atendimento e ON (b.cd_setor_atendimento = e.cd_setor_atendimento)
WHERE a.nr_atendimento = b.nr_atendimento AND a.nr_atendimento = c.nr_atendimento AND c.cd_convenio = d.cd_convenio and a.nr_atendimento = f.nr_atendimento and f.nr_seq_interno = Obter_Atepacu_paciente(a.nr_atendimento, 'A')  and coalesce(obter_conv_meio_ext_int('PRESCR_MEDICA', 'CD_SETOR_ATENDIMENTO', E.CD_SETOR_ATENDIMENTO, 'MX'), B.CD_SETOR_ATENDIMENTO) is not null AND c.nr_seq_interno =  (SELECT MAX(x.nr_seq_interno)
                             FROM    atend_categoria_convenio x
                             WHERE   x.nr_atendimento = c.nr_atendimento);

