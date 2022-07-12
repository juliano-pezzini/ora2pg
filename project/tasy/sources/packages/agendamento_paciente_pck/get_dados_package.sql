-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION agendamento_paciente_pck.get_dados (cd_paciente_p text, dt_referencia_p timestamp, cd_protocolo_p bigint, cd_convenio_p bigint, nr_reserva_pac_p text, ie_forma_apres_p text) RETURNS SETOF AGENDAMENTO_PACIENTE_TAB AS $body$
DECLARE

        agendamento_paciente_w agendamento_paciente_tab := agendamento_paciente_tab();
        index_w                bigint := 0;
        c_limit                bigint := 500;
        dt_inicio_w            timestamp := trunc(dt_referencia_p);
        dt_final_w             timestamp := dt_inicio_w + 180;

        c01 CURSOR FOR  -- Ao alterar este cursor alterar C11.
            SELECT CASE WHEN a.cd_tipo_agenda=1 THEN  obter_desc_expressao(486364)  ELSE obter_desc_expressao(289683) END  ds_tipo_agenda,
                   a.ds_agenda ds_agenda,
                   b.hr_inicio dt_ordenacao,
                   a.cd_tipo_agenda,
                   substr(obter_desc_prescr_proc(b.cd_procedimento, b.ie_origem_proced, b.nr_seq_proc_interno), 1, 255) ds_item,
                   --SUBSTR(obter_nome_convenio(b.cd_convenio),1,255) ds_convenio,
                   d.ds_convenio ds_convenio,
                   b.nr_minuto_duracao nr_minuto_duracao,
                   b.nr_atendimento nr_atendimento,
                   substr(obter_idade_pac_agenda(a.cd_tipo_agenda, b.nr_sequencia), 1, 30) ds_idade,
                   substr(b.nr_telefone, 1, 60) nr_telefone,
                   substr(obter_desc_plano(b.cd_convenio, b.cd_plano), 1, 255) ds_plano,
                   substr(obter_categoria_convenio(b.cd_convenio, b.cd_categoria), 1, 255) ds_categoria,
                   b.cd_usuario_convenio cd_usuario_convenio,
                   coalesce(b.nr_sequencia, 0) nr_seq_exame,
                   0 nr_seq_cons,
                   NULL nr_seq_radio,
                   NULL nr_seq_quimio,
                   --SUBSTR(obter_valor_dominio(83, b.ie_status_agenda),1,110) ds_status,
                   substr(obter_desc_expressao(c.cd_exp_valor_dominio), 1, 110) ds_status,
                   b.cd_convenio cd_convenio_exame,
                   NULL cd_convenio_consulta,
                   b.cd_pessoa_fisica cd_pessoa_fisica_exame,
                   '' cd_pessoa_fisica_consulta,
                   b.dt_agenda dt_agenda_exame,
                   to_date(NULL) dt_agenda_consulta,
                   b.ie_status_agenda ie_status_agenda_exame,
                   '' ie_status_agenda_consulta,
                   substr(ageint_obter_obs_final(b.nr_sequencia, NULL, NULL), 1, 255) ds_obs_final,
                   b.ie_encaixe,
                   e.nr_seq_agenda_int nr_seq_ageint,
                   a.cd_estabelecimento,
                   coalesce(b.nr_sequencia, 0) nr_seq_agenda,
                   0 nr_seq_item,
                   b.nr_reserva nr_reserva,
                   coalesce(e.ie_duplicado_estab, 'N') ie_duplicado_estab,
                   e.nr_sequencia nr_seq_ageint_item,
                   0 nr_seq_lab,
                   substr(b.ds_observacao, 1, 4000) ds_observacao,
                   b.nm_usuario_orig nm_usuario_origem,
                   e.dt_resultado dt_resultado,
                   e.dt_entrega_prevista dt_entrega_prevista,
                   coalesce(b.ie_transferido, 'N') ie_transferido,
                   0 nr_seq_mot_reagendamento,
                   substr(obter_desc_classif_agenda_pac(b.nr_seq_classif_agenda), 1, 255) ds_classificacao,
				   NULL nr_secao_consulta,
                   substr(obter_desc_espec_medica(a.cd_especialidade), 1, 255) ds_especialidade
              FROM valor_dominio_v c, agenda a, agenda_paciente b
LEFT OUTER JOIN agenda_integrada_item e ON (b.nr_sequencia = e.nr_seq_agenda_exame)
LEFT OUTER JOIN convenio d ON (b.cd_convenio = d.cd_convenio)
WHERE a.cd_agenda = b.cd_agenda AND a.cd_tipo_agenda = 2  AND c.cd_dominio = 83 AND c.vl_dominio = b.ie_status_agenda  ----------------------       
  AND b.cd_pessoa_fisica = cd_paciente_p AND b.dt_agenda BETWEEN dt_inicio_w AND dt_final_w AND (coalesce(cd_convenio_p::text, '') = '' OR b.cd_convenio = cd_convenio_p) AND (coalesce(nr_reserva_pac_p::text, '') = '' OR b.nr_reserva = nr_reserva_pac_p) AND (coalesce(cd_protocolo_p::text, '') = '' OR e.nr_seq_agenda_int = cd_protocolo_p) AND ((ie_forma_apres_p = '0') OR 
                   (ie_forma_apres_p = '1' AND ie_status_agenda <> 'C') OR
                   (ie_forma_apres_p = '2' AND ie_status_agenda = 'C') OR
                   (ie_forma_apres_p = '3' AND cd_tipo_agenda <> 20));
               -----------
        c11 CURSOR FOR  -- Ao alterar este cursor alterar C01.
            SELECT CASE WHEN a.cd_tipo_agenda=1 THEN  obter_desc_expressao(486364)  ELSE obter_desc_expressao(289683) END  ds_tipo_agenda,
                   a.ds_agenda ds_agenda,
                   b.hr_inicio dt_ordenacao,
                   a.cd_tipo_agenda,
                   substr(obter_desc_prescr_proc(b.cd_procedimento, b.ie_origem_proced, b.nr_seq_proc_interno), 1, 255) ds_item,
                   --SUBSTR(obter_nome_convenio(b.cd_convenio),1,255) ds_convenio,
                   d.ds_convenio ds_convenio,
                   b.nr_minuto_duracao nr_minuto_duracao,
                   b.nr_atendimento nr_atendimento,
                   substr(obter_idade_pac_agenda(a.cd_tipo_agenda, b.nr_sequencia), 1, 30) ds_idade,
                   substr(b.nr_telefone, 1, 60) nr_telefone,
                   substr(obter_desc_plano(b.cd_convenio, b.cd_plano), 1, 255) ds_plano,
                   substr(obter_categoria_convenio(b.cd_convenio, b.cd_categoria), 1, 255) ds_categoria,
                   b.cd_usuario_convenio cd_usuario_convenio,
                   coalesce(b.nr_sequencia, 0) nr_seq_exame,
                   0 nr_seq_cons,
                   NULL nr_seq_radio,
                   NULL nr_seq_quimio,
                   --SUBSTR(obter_valor_dominio(83, b.ie_status_agenda),1,110) ds_status,
                   substr(obter_desc_expressao(c.cd_exp_valor_dominio), 1, 110) ds_status,
                   b.cd_convenio cd_convenio_exame,
                   NULL cd_convenio_consulta,
                   b.cd_pessoa_fisica cd_pessoa_fisica_exame,
                   '' cd_pessoa_fisica_consulta,
                   b.dt_agenda dt_agenda_exame,
                   to_date(NULL) dt_agenda_consulta,
                   b.ie_status_agenda ie_status_agenda_exame,
                   '' ie_status_agenda_consulta,
                   substr(ageint_obter_obs_final(b.nr_sequencia, NULL, NULL), 1, 255) ds_obs_final,
                   b.ie_encaixe,
                   e.nr_seq_agenda_int nr_seq_ageint,
                   a.cd_estabelecimento,
                   coalesce(b.nr_sequencia, 0) nr_seq_agenda,
                   0 nr_seq_item,
                   b.nr_reserva nr_reserva,
                   coalesce(e.ie_duplicado_estab, 'N') ie_duplicado_estab,
                   e.nr_sequencia nr_seq_ageint_item,
                   0 nr_seq_lab,
                   substr(b.ds_observacao, 1, 4000) ds_observacao,
                   b.nm_usuario_orig nm_usuario_origem,
                   e.dt_resultado dt_resultado,
                   e.dt_entrega_prevista dt_entrega_prevista,
                   coalesce(b.ie_transferido, 'N') ie_transferido,
                   0 nr_seq_mot_reagendamento,
                   substr(obter_desc_classif_agenda_pac(b.nr_seq_classif_agenda), 1, 255) ds_classificacao,
				   NULL nr_secao_consulta,
                   substr(obter_desc_espec_medica(a.cd_especialidade), 1, 255) ds_especialidade
              FROM valor_dominio_v c, agenda a, agenda_paciente b
LEFT OUTER JOIN agenda_integrada_item e ON (b.nr_sequencia = e.nr_seq_agenda_exame)
LEFT OUTER JOIN convenio d ON (b.cd_convenio = d.cd_convenio)
WHERE a.cd_agenda = b.cd_agenda AND a.cd_tipo_agenda = 2  AND c.cd_dominio = 83 AND c.vl_dominio = b.ie_status_agenda  ----------------------
  AND b.dt_agenda BETWEEN dt_inicio_w AND dt_final_w AND (coalesce(cd_convenio_p::text, '') = '' OR b.cd_convenio = cd_convenio_p) AND (coalesce(nr_reserva_pac_p::text, '') = '' OR b.nr_reserva = nr_reserva_pac_p) AND e.nr_seq_agenda_int = cd_protocolo_p AND ((ie_forma_apres_p = '0') OR 
                   (ie_forma_apres_p = '1' AND ie_status_agenda <> 'C') OR
                   (ie_forma_apres_p = '2' AND ie_status_agenda = 'C') OR
                   (ie_forma_apres_p = '3' AND cd_tipo_agenda <> 20));
               -----------
        c02 CURSOR FOR   -- Ao alterar este cursor alterar C22.
            SELECT CASE WHEN a.cd_tipo_agenda=5 THEN  obter_desc_expressao(298345)  ELSE obter_desc_expressao(285916) END  ds_tipo_agenda,
                   coalesce(substr(obter_nome_pf(a.cd_pessoa_fisica), 1, 60),
                       substr(coalesce(obter_desc_espec_medica(a.cd_especialidade), a.ds_agenda), 1, 255)) ds_agenda,
                   c.dt_agenda dt_ordenacao,
                   a.cd_tipo_agenda,
                   coalesce(substr(obter_nome_pf(a.cd_pessoa_fisica), 1, 60),
                       substr(obter_desc_espec_medica(a.cd_especialidade), 1, 255)) ds_item,
                   --SUBSTR(obter_nome_convenio(c.cd_convenio),1,255) ds_convenio,
                   d.ds_convenio ds_convenio,
                   c.nr_minuto_duracao nr_minuto_duracao,
                   c.nr_atendimento nr_atendimento,
                   substr(obter_idade_pac_agenda(a.cd_tipo_agenda, c.nr_sequencia), 1, 30) ds_idade,
                   substr(c.nr_telefone, 1, 60) nr_telefone,
                   substr(obter_desc_plano(c.cd_convenio, c.cd_plano), 1, 255) ds_plano,
                   substr(obter_categoria_convenio(c.cd_convenio, c.cd_categoria), 1, 255) ds_categoria,
                   c.cd_usuario_convenio cd_usuario_convenio,
                   0 nr_seq_exame,
                   coalesce(c.nr_sequencia, 0) nr_seq_cons,
                   NULL nr_seq_radio,
                   NULL nr_seq_quimio,
                   --SUBSTR(obter_valor_dominio(83, c.ie_status_agenda),1,110) ds_status,
                   substr(obter_desc_expressao(b.cd_exp_valor_dominio), 1, 110) ds_status,
                   NULL cd_convenio_exame,
                   c.cd_convenio cd_convenio_consulta,
                   '' cd_pessoa_fisica_exame,
                   c.cd_pessoa_fisica cd_pessoa_fisica_consulta,
                   NULL dt_agenda_exame,
                   c.dt_agenda dt_agenda_consulta,
                   NULL ie_status_agenda_exame,
                   c.ie_status_agenda ie_status_agenda_consulta,
                   substr(ageint_obter_obs_final(NULL, c.nr_sequencia, NULL), 1, 255) ds_obs_final,
                   c.ie_encaixe,
                   e.nr_seq_agenda_int nr_seq_ageint,
                   a.cd_estabelecimento,
                   coalesce(c.nr_sequencia, 0) nr_seq_agenda,
                   0 nr_seq_item,
                   c.nr_reserva nr_reserva,
                   coalesce(e.ie_duplicado_estab, 'N') ie_duplicado_estab,
                   e.nr_sequencia nr_seq_ageint_item,
                   0 nr_seq_lab,
                   substr(c.ds_observacao, 1, 2000) ds_observacao,
                   c.nm_usuario_origem nm_usuario_origem,
                   e.dt_resultado dt_resultado,
                   e.dt_entrega_prevista dt_entrega_prevista,
                   coalesce(c.ie_transferido, 'N') ie_transferido,
                   0 nr_seq_mot_reagendamento,
                   substr(obter_classif_agenda_consulta(c.ie_classif_agenda), 1, 255) ds_classificacao,
				   c.nr_secao nr_secao_consulta,
                   substr(obter_desc_espec_medica(a.cd_especialidade), 1, 255) ds_especialidade
              FROM valor_dominio_v b, agenda a, agenda_consulta c
LEFT OUTER JOIN agenda_integrada_item e ON (c.nr_sequencia = e.nr_seq_agenda_cons)
LEFT OUTER JOIN convenio d ON (c.cd_convenio = d.cd_convenio)
WHERE a.cd_agenda = c.cd_agenda  AND a.cd_tipo_agenda IN (3, 4, 5) AND b.cd_dominio = 83 AND b.vl_dominio = c.ie_status_agenda  ----------------------       
  AND c.cd_pessoa_fisica = cd_paciente_p AND c.dt_agenda BETWEEN dt_inicio_w AND dt_final_w AND (coalesce(cd_convenio_p::text, '') = '' OR c.cd_convenio = cd_convenio_p) AND (coalesce(nr_reserva_pac_p::text, '') = '' OR c.nr_reserva = nr_reserva_pac_p) AND (coalesce(cd_protocolo_p::text, '') = '' OR e.nr_seq_agenda_int = cd_protocolo_p) AND ((ie_forma_apres_p = '0') OR 
                   (ie_forma_apres_p = '1' AND ie_status_agenda <> 'C') OR
                   (ie_forma_apres_p = '2' AND ie_status_agenda = 'C') OR
                   (ie_forma_apres_p = '3' AND cd_tipo_agenda <> 20));
               -----------  
        c22 CURSOR FOR  -- Ao alterar este cursor alterar C02.
        
            SELECT CASE WHEN a.cd_tipo_agenda=5 THEN  obter_desc_expressao(298345)  ELSE obter_desc_expressao(285916) END  ds_tipo_agenda,
                   coalesce(substr(obter_nome_pf(a.cd_pessoa_fisica), 1, 60),
                       substr(coalesce(obter_desc_espec_medica(a.cd_especialidade), a.ds_agenda), 1, 255)) ds_agenda,
                   c.dt_agenda dt_ordenacao,
                   a.cd_tipo_agenda,
                   coalesce(substr(obter_nome_pf(a.cd_pessoa_fisica), 1, 60),
                       substr(obter_desc_espec_medica(a.cd_especialidade), 1, 255)) ds_item,
                   --SUBSTR(obter_nome_convenio(c.cd_convenio),1,255) ds_convenio,
                   d.ds_convenio ds_convenio,
                   c.nr_minuto_duracao nr_minuto_duracao,
                   c.nr_atendimento nr_atendimento,
                   substr(obter_idade_pac_agenda(a.cd_tipo_agenda, c.nr_sequencia), 1, 30) ds_idade,
                   substr(c.nr_telefone, 1, 60) nr_telefone,
                   substr(obter_desc_plano(c.cd_convenio, c.cd_plano), 1, 255) ds_plano,
                   substr(obter_categoria_convenio(c.cd_convenio, c.cd_categoria), 1, 255) ds_categoria,
                   c.cd_usuario_convenio cd_usuario_convenio,
                   0 nr_seq_exame,
                   coalesce(c.nr_sequencia, 0) nr_seq_cons,
                   NULL nr_seq_radio,
                   NULL nr_seq_quimio,
                   --SUBSTR(obter_valor_dominio(83, c.ie_status_agenda),1,110) ds_status,
                   substr(obter_desc_expressao(b.cd_exp_valor_dominio), 1, 110) ds_status,
                   NULL cd_convenio_exame,
                   c.cd_convenio cd_convenio_consulta,
                   '' cd_pessoa_fisica_exame,
                   c.cd_pessoa_fisica cd_pessoa_fisica_consulta,
                   NULL dt_agenda_exame,
                   c.dt_agenda dt_agenda_consulta,
                   NULL ie_status_agenda_exame,
                   c.ie_status_agenda ie_status_agenda_consulta,
                   substr(ageint_obter_obs_final(NULL, c.nr_sequencia, NULL), 1, 255) ds_obs_final,
                   c.ie_encaixe,
                   e.nr_seq_agenda_int nr_seq_ageint,
                   a.cd_estabelecimento,
                   coalesce(c.nr_sequencia, 0) nr_seq_agenda,
                   0 nr_seq_item,
                   c.nr_reserva nr_reserva,
                   coalesce(e.ie_duplicado_estab, 'N') ie_duplicado_estab,
                   e.nr_sequencia nr_seq_ageint_item,
                   0 nr_seq_lab,
                   substr(c.ds_observacao, 1, 2000) ds_observacao,
                   c.nm_usuario_origem nm_usuario_origem,
                   e.dt_resultado dt_resultado,
                   e.dt_entrega_prevista dt_entrega_prevista,
                   coalesce(c.ie_transferido, 'N') ie_transferido,
                   0 nr_seq_mot_reagendamento,
                   substr(obter_classif_agenda_consulta(c.ie_classif_agenda), 1, 255) ds_classificacao,
				   c.nr_secao nr_secao_consulta,
                   substr(obter_desc_espec_medica(a.cd_especialidade), 1, 255) ds_especialidade
              FROM valor_dominio_v b, agenda a, agenda_consulta c
LEFT OUTER JOIN agenda_integrada_item e ON (c.nr_sequencia = e.nr_seq_agenda_cons)
LEFT OUTER JOIN convenio d ON (c.cd_convenio = d.cd_convenio)
WHERE a.cd_agenda = c.cd_agenda  AND a.cd_tipo_agenda IN (3, 4, 5) AND b.cd_dominio = 83 AND b.vl_dominio = c.ie_status_agenda  ----------------------
  AND c.dt_agenda BETWEEN dt_inicio_w AND dt_final_w AND (coalesce(cd_convenio_p::text, '') = '' OR c.cd_convenio = cd_convenio_p) AND (coalesce(nr_reserva_pac_p::text, '') = '' OR c.nr_reserva = nr_reserva_pac_p) AND e.nr_seq_agenda_int = cd_protocolo_p AND ((ie_forma_apres_p = '0') OR 
                   (ie_forma_apres_p = '1' AND ie_status_agenda <> 'C') OR
                   (ie_forma_apres_p = '2' AND ie_status_agenda = 'C') OR
                   (ie_forma_apres_p = '3' AND cd_tipo_agenda <> 20));
               -----------               
        c03 CURSOR FOR
            SELECT obter_desc_expressao(297224) ds_tipo_agenda,
                   substr(rxt_obter_desc_equipamento(b.nr_seq_equipamento), 1, 250) ds_agenda,
                   b.dt_agenda dt_ordenacao,
                   10 cd_tipo_agenda,
                   substr(rxt_obter_desc_trat_agenda(b.nr_seq_tratamento), 1, 240) ds_item,
                   substr(obter_dados_atendimento(b.nr_atendimento, 'NC'), 1, 255) ds_convenio,
                   b.nr_minuto_duracao,
                   b.nr_atendimento,
                   substr(obter_idade_pf(b.cd_pessoa_fisica, b.dt_agenda, 'A'), 1, 30) ds_idade,
                   substr(obter_compl_pf(b.cd_pessoa_fisica, 1, 'T'), 1, 60) nr_telefone,
                   substr(obter_dados_categ_conv(b.nr_atendimento, 'DP'), 1, 255) ds_plano,
                   substr(obter_dados_categ_conv(b.nr_atendimento, 'DC'), 1, 255) ds_categoria,
                   substr(obter_dados_categ_conv(b.nr_atendimento, 'U'), 1, 110) cd_usuario_convenio,
                   NULL nr_seq_exame,
                   NULL nr_seq_cons,
                   b.nr_sequencia nr_seq_radio,
                   NULL nr_seq_quimio,
                   substr(obter_valor_dominio(2217, b.ie_status_agenda), 1, 110) ds_status,
                   (obter_dados_atendimento(b.nr_atendimento, 'CC'))::numeric  cd_convenio_exame,
                   NULL cd_convenio_consulta,
                   b.cd_pessoa_fisica cd_pessoa_fisica_exame,
                   NULL cd_pessoa_fisica_consulta,
                   b.dt_agenda dt_agenda_exame,
                   NULL dt_agenda_consulta,
                   b.ie_status_agenda ie_status_agenda_exame,
                   NULL ie_status_agenda_consulta,
                   '' ds_obs_final,
                   '' ie_encaixe,
                   NULL nr_seq_ageint,
                   NULL cd_estabelecimento,
                   0 nr_seq_agenda,
                   0 nr_seq_item,
                   NULL nr_reserva,
                   'N' ie_duplicado_estab,
                   0 nr_seq_ageint_item,
                   0 nr_seq_lab,
                   NULL ds_observacao,
                   NULL nm_usuario_origem,
                   NULL dt_resultado,
                   NULL dt_entrega_prevista,
                   NULL ie_transferido,
                   0 nr_seq_mot_reagendamento,
                   substr(rxt_obter_desc_classif_agenda(b.ie_classif_agenda), 1, 255) ds_classificacao,
				   NULL nr_secao_consulta,
                   NULL ds_especialidade
              FROM rxt_agenda b
             WHERE
             ----------------------       
                 b.cd_pessoa_fisica = cd_paciente_p
             AND b.dt_agenda BETWEEN dt_inicio_w AND dt_final_w
            
             AND (coalesce(cd_convenio_p::text, '') = '' OR (obter_dados_atendimento(b.nr_atendimento, 'CC'))::numeric  = cd_convenio_p)
             AND (coalesce(nr_reserva_pac_p::text, '') = '')
             AND (coalesce(cd_protocolo_p::text, '') = '')
            
             AND ((ie_forma_apres_p = '0') OR 
                 (ie_forma_apres_p = '1' AND ie_status_agenda <> 'C') OR
                 (ie_forma_apres_p = '2' AND ie_status_agenda = 'C'));
             -----------
        c04 CURSOR FOR
            SELECT obter_desc_expressao(701396) ds_tipo_agenda,
                   substr(obter_descricao_padrao('QT_LOCAL', 'DS_LOCAL', c.nr_seq_local), 1, 60) ds_agenda,
                   c.dt_agenda dt_ordenacao,
                   11 cd_tipo_agenda,
                   substr(obter_desc_prot_medic(e.nr_seq_paciente), 1, 255) ds_item,
                   substr(obter_nome_convenio(f.cd_convenio), 1, 255) ds_convenio,
                   c.nr_minuto_duracao,
                   c.nr_atendimento,
                   substr(obter_idade_pf(c.cd_pessoa_fisica, c.dt_agenda, 'A'), 1, 30) ds_idade,
                   substr(obter_compl_pf(c.cd_pessoa_fisica, 1, 'T'), 1, 60) nr_telefone,
                   substr(obter_desc_plano_conv(f.cd_convenio, f.cd_plano), 1, 255) ds_plano,
                   substr(obter_categoria_convenio(f.cd_convenio, f.cd_categoria), 1, 255) ds_categoria,
                   f.cd_usuario_convenio cd_usuario_convenio,
                   NULL nr_seq_exame,
                   NULL nr_seq_cons,
                   NULL nr_seq_radio,
                   c.nr_sequencia nr_seq_quimio,
                   substr(obter_valor_dominio(3192, c.ie_status_agenda), 1, 110) ds_status,
                   f.cd_convenio cd_convenio_exame,
                   NULL cd_convenio_consulta,
                   c.cd_pessoa_fisica cd_pessoa_fisica_exame,
                   NULL cd_pessoa_fisica_consulta,
                   c.dt_agenda dt_agenda_exame,
                   NULL dt_agenda_consulta,
                   c.ie_status_agenda ie_status_agenda_exame,
                   NULL ie_status_agenda_consulta,
                   '' ds_obs_final,
                   c.ie_encaixe,
                   NULL nr_seq_ageint,
                   e.cd_estabelecimento,
                   0 nr_seq_agenda,
                   0 nr_seq_item,
                   NULL nr_reserva,
                   'N' ie_duplicado_estab,
                   0 nr_seq_ageint_item,
                   0 nr_seq_lab,
                   NULL ds_observacao,
                   NULL nm_usuario_origem,
                   NULL dt_resultado,
                   NULL dt_entrega_prevista,
                   NULL ie_transferido,
                   c.nr_seq_mot_reagendamento nr_seq_mot_reagendamento,
                   '' ds_classificacao,
				   NULL nr_secao_consulta,
                   NULL ds_especialidade
              FROM paciente_atendimento d, agenda_quimio c, paciente_setor e
LEFT OUTER JOIN paciente_setor_convenio f ON (e.nr_seq_paciente = f.nr_seq_paciente)
WHERE c.nr_seq_atendimento = d.nr_seq_atendimento AND d.nr_seq_paciente = e.nr_seq_paciente  ----------------------       
  AND c.cd_pessoa_fisica = cd_paciente_p AND c.dt_agenda BETWEEN dt_inicio_w AND dt_final_w AND (coalesce(cd_convenio_p::text, '') = '' OR f.cd_convenio = cd_convenio_p) AND (coalesce(nr_reserva_pac_p::text, '') = '') AND (coalesce(cd_protocolo_p::text, '') = '') AND ((ie_forma_apres_p = '0') OR
                   (ie_forma_apres_p = '1' AND ie_status_agenda <> 'C') OR
                   (ie_forma_apres_p = '2' AND ie_status_agenda = 'C'));
               -----------     
        c05 CURSOR FOR
            SELECT obter_desc_expressao(701396) ds_tipo_agenda,
                   substr(obter_descricao_padrao('QT_LOCAL', 'DS_LOCAL', c.nr_seq_local), 1, 60) ds_agenda,
                   c.dt_agenda dt_ordenacao,
                   11 cd_tipo_agenda,
                   substr(qt_obter_desc_tipo_agenda(b.ie_tipo_pend_agenda), 1, 255) ds_item,
                   substr(obter_nome_convenio(a.cd_convenio), 1, 255) ds_convenio,
                   c.nr_minuto_duracao,
                   c.nr_atendimento,
                   substr(obter_idade_pf(c.cd_pessoa_fisica, c.dt_agenda, 'A'), 1, 30) ds_idade,
                   substr(obter_compl_pf(c.cd_pessoa_fisica, 1, 'T'), 1, 60) nr_telefone,
                   substr(obter_desc_plano_conv(a.cd_convenio, a.cd_plano), 1, 255) ds_plano,
                   substr(obter_categoria_convenio(a.cd_convenio, a.cd_categoria), 1, 255) ds_categoria,
                   a.cd_usuario_convenio cd_usuario_convenio,
                   NULL nr_seq_exame,
                   NULL nr_seq_cons,
                   NULL nr_seq_radio,
                   c.nr_sequencia nr_seq_quimio,
                   substr(obter_valor_dominio(3192, c.ie_status_agenda), 1, 110) ds_status,
                   a.cd_convenio cd_convenio_exame,
                   NULL cd_convenio_consulta,
                   c.cd_pessoa_fisica cd_pessoa_fisica_exame,
                   NULL cd_pessoa_fisica_consulta,
                   c.dt_agenda dt_agenda_exame,
                   NULL dt_agenda_consulta,
                   c.ie_status_agenda ie_status_agenda_exame,
                   NULL ie_status_agenda_consulta,
                   '' ds_obs_final,
                   c.ie_encaixe,
                   NULL nr_seq_ageint,
                   a.cd_estabelecimento,
                   0 nr_seq_agenda,
                   b.nr_sequencia nr_seq_item,
                   NULL nr_reserva,
                   coalesce(b.ie_duplicado_estab, 'N') ie_duplicado_estab,
                   b.nr_sequencia nr_seq_ageint_item,
                   0 nr_seq_lab,
                   NULL ds_observacao,
                   NULL nm_usuario_origem,
                   NULL dt_resultado,
                   NULL dt_entrega_prevista,
                   NULL ie_transferido,
                   c.nr_seq_mot_reagendamento nr_seq_mot_reagendamento,
                   '' ds_classificacao,
				   NULL nr_secao_consulta,
                   NULL ds_especialidade
              FROM agenda_quimio         c,
                   agenda_integrada_item b,
                   agenda_integrada      a
             WHERE c.nr_seq_ageint_item = b.nr_sequencia
               AND b.nr_seq_agenda_int = a.nr_sequencia
               ----------------------       
               AND c.cd_pessoa_fisica = cd_paciente_p
               AND c.dt_agenda BETWEEN dt_inicio_w AND dt_final_w
                  
               AND (coalesce(cd_convenio_p::text, '') = '' OR a.cd_convenio = cd_convenio_p)
               AND (coalesce(nr_reserva_pac_p::text, '') = '')
               AND (coalesce(cd_protocolo_p::text, '') = '' OR b.nr_seq_agenda_int = cd_protocolo_p)
                  
               AND ((ie_forma_apres_p = '0') OR 
                   (ie_forma_apres_p = '1' AND ie_status_agenda <> 'C') OR
                   (ie_forma_apres_p = '2' AND ie_status_agenda = 'C'));
                -----------   
         C06 CURSOR FOR
         SELECT obter_desc_expressao(289736) ds_tipo_agenda,
                NULL ds_agenda,
                b.dt_prevista dt_ordenacao,
                20 cd_tipo_agenda,
                substr(coalesce(obter_desc_proc_interno(b.nr_seq_proc_interno), obter_desc_exame(b.nr_seq_exame)), 1, 255) ds_item,
                substr(ageint_obter_conv_item_lab(b.nr_sequencia), 1, 255) ds_convenio,
                0 nr_minuto_duracao,
                0 nr_atendimento,
                substr(obter_idade_pf(a.cd_pessoa_fisica, b.dt_prevista, 'A'), 1, 30) ds_idade,
                substr(obter_compl_pf(a.cd_pessoa_fisica, 1, 'T'), 1, 60) nr_telefone,
                substr(obter_desc_plano(a.cd_convenio, a.cd_plano), 1, 255) ds_plano,
                substr(obter_categoria_convenio(a.cd_convenio, a.cd_categoria), 1, 255) ds_categoria,
                a.cd_usuario_convenio cd_usuario_convenio,
                0 nr_seq_exame,
                NULL nr_seq_cons,
                NULL nr_seq_radio,
                NULL nr_seq_quimio,
                substr(CASE WHEN coalesce(b.dt_cancelamento::text, '') = '' THEN  obter_desc_status_ageint(a.nr_seq_status)  ELSE obter_desc_expressao(322155) END ,
                       1,
                       80) ds_status,
                NULL cd_convenio_exame,
                a.cd_convenio cd_convenio_consulta,
                '' cd_pessoa_fisica_exame,
                a.cd_pessoa_fisica cd_pessoa_fisica_consulta,
                NULL dt_agenda_exame,
                b.dt_prevista dt_agenda_consulta,
                NULL ie_status_agenda_exame,
                NULL ie_status_agenda_consulta,
                substr(a.ds_obs_final, 1, 255) ds_obs_final,
                'N' ie_encaixe,
                b.nr_seq_ageint nr_seq_ageint,
                a.cd_estabelecimento,
                0 nr_seq_agenda,
                0 nr_seq_item,
                '' nr_reserva,
                'N' ie_duplicado_estab,
                0 nr_seq_ageint_item,
                b.nr_sequencia,
                NULL ds_observacao,
                NULL nm_usuario_origem,
                NULL dt_resultado,
                NULL dt_entrega_prevista,
                NULL ie_transferido,
                0 nr_seq_mot_reagendamento,
                '',
				NULL nr_secao_consulta,
                NULL ds_especialidade
           FROM ageint_exame_lab b,
                agenda_integrada a
          WHERE b.nr_seq_ageint = a.nr_sequencia
            AND (b.dt_prevista IS NOT NULL AND b.dt_prevista::text <> '')
            ----------------------       
            AND a.cd_pessoa_fisica = cd_paciente_p
            AND b.dt_prevista BETWEEN dt_inicio_w AND dt_final_w
                  
            AND (coalesce(cd_convenio_p::text, '') = '' OR a.cd_convenio = cd_convenio_p)
            AND (coalesce(nr_reserva_pac_p::text, '') = '' )
            AND (coalesce(cd_protocolo_p::text, '') = '' )
                  
            AND ((ie_forma_apres_p = '0')
                --OR                ((ie_forma_apres_p = '1') AND (ie_status_agenda <> 'C')) 
                --OR                ((ie_forma_apres_p = '2') AND (ie_status_agenda = 'C')) 
                --OR                ((ie_forma_apres_p = '3') AND (cd_tipo_agenda <> 20))
                );
            -----------            
          
    
 
    
    
BEGIN
    
        if (cd_paciente_p IS NOT NULL AND cd_paciente_p::text <> '') then

          OPEN c01;
          LOOP
              FETCH c01 BULK COLLECT
                  INTO agendamento_paciente_w LIMIT c_limit;

              EXIT WHEN agendamento_paciente_w.count = 0;
              FOR i IN agendamento_paciente_w.first .. agendamento_paciente_w.last LOOP

                  RETURN NEXT agendamento_paciente_w(i);
              END LOOP;
          END LOOP;
          CLOSE c01;

          OPEN c02;
          LOOP
              FETCH c02 BULK COLLECT
                  INTO agendamento_paciente_w LIMIT c_limit;

              EXIT WHEN agendamento_paciente_w.count = 0;
              FOR i IN agendamento_paciente_w.first .. agendamento_paciente_w.last LOOP

                  RETURN NEXT agendamento_paciente_w(i);
              END LOOP;
          END LOOP;
          CLOSE c02;

        else
          OPEN c11;
          LOOP
              FETCH c11 BULK COLLECT
                  INTO agendamento_paciente_w LIMIT c_limit;

              EXIT WHEN agendamento_paciente_w.count = 0;
              FOR i IN agendamento_paciente_w.first .. agendamento_paciente_w.last LOOP

                  RETURN NEXT agendamento_paciente_w(i);
              END LOOP;
          END LOOP;
          CLOSE c11;

          OPEN c22;
          LOOP
              FETCH c22 BULK COLLECT
                  INTO agendamento_paciente_w LIMIT c_limit;

              EXIT WHEN agendamento_paciente_w.count = 0;
              FOR i IN agendamento_paciente_w.first .. agendamento_paciente_w.last LOOP

                  RETURN NEXT agendamento_paciente_w(i);
              END LOOP;
          END LOOP;
          CLOSE c22;
        end if;

        OPEN c03;
        LOOP
            FETCH c03 BULK COLLECT
                INTO agendamento_paciente_w LIMIT c_limit;

            EXIT WHEN agendamento_paciente_w.count = 0;
            FOR i IN agendamento_paciente_w.first .. agendamento_paciente_w.last LOOP

                RETURN NEXT agendamento_paciente_w(i);
            END LOOP;
        END LOOP;
    	  CLOSE c03;

        OPEN c04;
        LOOP
            FETCH c04 BULK COLLECT
                INTO agendamento_paciente_w LIMIT c_limit;

            EXIT WHEN agendamento_paciente_w.count = 0;
            FOR i IN agendamento_paciente_w.first .. agendamento_paciente_w.last LOOP

                RETURN NEXT agendamento_paciente_w(i);
            END LOOP;
        END LOOP;
        CLOSE c04;

        OPEN c05;
        LOOP
            FETCH c05 BULK COLLECT
                INTO agendamento_paciente_w LIMIT c_limit;

            EXIT WHEN agendamento_paciente_w.count = 0;
            FOR i IN agendamento_paciente_w.first .. agendamento_paciente_w.last LOOP

                RETURN NEXT agendamento_paciente_w(i);
            END LOOP;
        END LOOP;
        CLOSE c05;

        OPEN c06;
        LOOP
            FETCH c06 BULK COLLECT
                INTO agendamento_paciente_w LIMIT c_limit;

            EXIT WHEN agendamento_paciente_w.count = 0;
            FOR i IN agendamento_paciente_w.first .. agendamento_paciente_w.last LOOP

                RETURN NEXT agendamento_paciente_w(i);
            END LOOP;
        END LOOP;
        CLOSE c06;


    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION agendamento_paciente_pck.get_dados (cd_paciente_p text, dt_referencia_p timestamp, cd_protocolo_p bigint, cd_convenio_p bigint, nr_reserva_pac_p text, ie_forma_apres_p text) FROM PUBLIC;