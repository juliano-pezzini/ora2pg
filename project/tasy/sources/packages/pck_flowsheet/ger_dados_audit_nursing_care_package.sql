-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pck_flowsheet.ger_dados_audit_nursing_care (cd_relatorio_p bigint, ie_dados_p text, dt_inicial_p timestamp, dt_final_p timestamp, cd_pessoa_fisica_p bigint) AS $body$
DECLARE


    c1 CURSOR FOR
      SELECT distinct nr_atendimento
        from w_rel_val_flowsheet t
       where t.nm_usuario = wheb_usuario_pck.get_nm_usuario
         and t.nr_relatorio = cd_relatorio_p;
    r1 c1%rowtype;

    c_cur_ferida_i CURSOR FOR
      SELECT a1.dt_inicio_ferida,
             a1.dt_inativacao,
             a1.ds_justificativa,
             a1.nm_usuario_inativacao,
             lf.ds_localizacao
        from cur_ferida a1,
             localizacao_ferida lf
       where a1.dt_inicio_ferida between dt_inicial_p and dt_final_p
         and a1.nr_atendimento = r1.nr_atendimento
         and a1.ie_situacao = 'I'
         and lf.nr_sequencia = a1.nr_seq_localizacao;
    r_cur_ferida_i c_cur_ferida_i%rowtype;

    c_cur_curativo_i CURSOR FOR
      SELECT a2.dt_curativo,
             a2.dt_inativacao,
             a2.ds_justificativa,
             a2.nm_usuario_inativacao,
             obter_valor_dominio(1097, a2.ie_borda) ie_borda,
             obter_valor_dominio(1101, a2.ie_tipo_exsudato) ie_tipo_exsudato,
             obter_valor_dominio(1095, a2.ie_tamanho) ie_tamanho,
             a2.nr_horas_validade
        from cur_curativo a2
       where a2.dt_curativo between dt_inicial_p and dt_final_p
         and a2.nr_atendimento = r1.nr_atendimento
         and a2.ie_situacao = 'I';
    r_cur_curativo_i c_cur_curativo_i%rowtype;

    c_monit_resp_i CURSOR FOR
      SELECT a4.dt_monitorizacao,
             a4.dt_inativacao,
             a4.ds_justificativa,
             a4.nm_usuario_inativacao,
             obter_valor_dominio(2816, a4.ie_canula_traqueo) ie_canula_traqueo,
             a4.nr_protese,
             a4.qt_rima_labial,
             a4.qt_fio2
        from atendimento_monit_resp a4
       where a4.dt_monitorizacao between dt_inicial_p and dt_final_p
         and a4.nr_atendimento = r1.nr_atendimento
         and a4.ie_situacao = 'I';
    r_monit_resp_i c_monit_resp_i%rowtype;

    c_informacao_leito_i CURSOR FOR
      SELECT a5.dt_liberacao,
             a5.dt_inativacao,
             a5.ds_justificativa,
             a5.nm_usuario_inativacao,
             obter_valor_dominio(9270, a5.ie_bedposition) ie_bedposition,
             obter_valor_dominio(9271, a5.ie_headrailsposition) ie_headrailsposition,
             obter_valor_dominio(9282, a5.ie_hobalarminfo) ie_hobalarminfo
        from atend_informacao_leito a5
       where a5.dt_liberacao between dt_inicial_p and dt_final_p
         and a5.nr_atendimento = r1.nr_atendimento
         and a5.ie_situacao = 'I';
    r_informacao_leito_i c_informacao_leito_i%rowtype;

    c_atend_precaucao_i CURSOR FOR
      SELECT a6.dt_registro dt_liberacao,
             a6.dt_inativacao,
             a6.ds_justificativa,
             a6.nm_usuario_inativacao,
             c6.ds_precaucao
        from atendimento_precaucao a6,
             cih_precaucao c6
       where a6.dt_registro between dt_inicial_p and dt_final_p
         and a6.nr_atendimento = r1.nr_atendimento
         and a6.ie_situacao = 'I'
         and c6.nr_sequencia = a6.nr_seq_precaucao;
    r_atend_precaucao_i c_atend_precaucao_i%rowtype;

    c_paciente_rep_prescricao_i CURSOR FOR
      SELECT a7.dt_liberacao,
             a7.dt_inativacao,
             a7.ds_justificativa,
             a7.nm_usuario_inativacao,
             b7.ds_restricao,
             a7.ds_observacao,
             'Inactive' ie_situacao,
             c7.ds_nivel
        from paciente_rep_prescricao a7,
             rep_restricao b7,
             nivel_seguranca_alerta c7,
             atendimento_paciente d7
       where a7.dt_liberacao between dt_inicial_p and dt_final_p
         and a7.ie_situacao = 'I'
         and b7.nr_sequencia = a7.nr_seq_restricao
         and c7.nr_sequencia = a7.nr_seq_nivel_seg
         and a7.cd_pessoa_fisica = d7.cd_pessoa_fisica
         and d7.nr_atendimento = r1.nr_atendimento;
    r_paciente_rep_prescricao_i c_paciente_rep_prescricao_i%rowtype;

    c_nutricao CURSOR FOR
      SELECT b8.ds_avaliacao,
             a8.dt_avaliacao,
             a8.dt_inativacao,
             a8.ds_justificativa,
             a8.nm_usuario_inativacao
        from atend_aval_nut_enf a8,
             tipo_aval_nut_enf b8
       where a8.nr_seq_tipo_aval = b8.nr_sequencia
         and a8.ie_situacao = 'I'
         and a8.nr_atendimento = r1.nr_atendimento
         and a8.dt_avaliacao between dt_inicial_p and dt_final_p;
    r_nutricao c_nutricao%rowtype;

    c_enferm CURSOR(ie_sae_rel_p cp_intervention.ie_interv_sae_rel%type) FOR
      SELECT e.ds_resultado,
             b.dt_suspensao,
             b.ds_justificativa,
             c.dt_atualizacao,
             b.nm_usuario_susp
        from pe_prescricao a,
             pe_prescr_proc b,
             pe_item_result_proc c,
             cp_intervention d,
             pe_item_resultado e
        where b.nr_seq_prescr = a.nr_sequencia
          and b.nr_seq_result = c.nr_seq_result
          and c.nr_seq_proc = d.nr_seq_pe_procedimento
          and d.ie_interv_sae_rel = ie_sae_rel_p
          and (b.dt_suspensao IS NOT NULL AND b.dt_suspensao::text <> '')
          and a.nr_atendimento = r1.nr_atendimento
          and c.dt_atualizacao between dt_inicial_p and dt_final_p
          and e.nr_sequencia = c.nr_seq_result;
    r_enferm c_enferm%rowtype;

    w_audit_flowsheet_w w_rel_audit_flowsheet%rowtype;


BEGIN

    w_audit_flowsheet_w.nr_ordem := 1;
    w_audit_flowsheet_w.nr_relatorio := cd_relatorio_p;
    w_audit_flowsheet_w.cd_pessoa_fisica := cd_pessoa_fisica_p;

    open c1;
    loop
      fetch c1 into r1;
      EXIT WHEN NOT FOUND; /* apply on c1 */

        w_audit_flowsheet_w.nr_atendimento := r1.nr_atendimento;

        open c_cur_ferida_i;
        loop
          fetch c_cur_ferida_i into r_cur_ferida_i;
          EXIT WHEN NOT FOUND; /* apply on c_cur_ferida_i */

            w_audit_flowsheet_w.dt_evento := to_char(r_cur_ferida_i.dt_inicio_ferida, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.dt_inativacao := to_char(r_cur_ferida_i.dt_inativacao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.ds_motivo := r_cur_ferida_i.ds_justificativa;
            w_audit_flowsheet_w.ds_autor := r_cur_ferida_i.nm_usuario_inativacao;

            CALL pck_flowsheet.verify_and_insert_audit('Site/Assessment', r_cur_ferida_i.ds_localizacao, w_audit_flowsheet_w);

        end loop;
        close c_cur_ferida_i;

        open c_cur_curativo_i;
        loop
          fetch c_cur_curativo_i
            into r_cur_curativo_i;
          EXIT WHEN NOT FOUND; /* apply on c_cur_curativo_i */

            w_audit_flowsheet_w.dt_evento := to_char(r_cur_curativo_i.dt_curativo, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.dt_inativacao := to_char(r_cur_curativo_i.dt_inativacao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.ds_motivo := r_cur_curativo_i.ds_justificativa;
            w_audit_flowsheet_w.ds_autor := r_cur_curativo_i.nm_usuario_inativacao;

            CALL pck_flowsheet.verify_and_insert_audit('Margins', r_cur_curativo_i.ie_borda, w_audit_flowsheet_w);
            CALL pck_flowsheet.verify_and_insert_audit('Drainage', r_cur_curativo_i.ie_tipo_exsudato, w_audit_flowsheet_w);
            CALL pck_flowsheet.verify_and_insert_audit('Dressing', r_cur_curativo_i.ie_tamanho, w_audit_flowsheet_w);
            CALL pck_flowsheet.verify_and_insert_audit('Care', r_cur_curativo_i.nr_horas_validade, w_audit_flowsheet_w);

        end loop;
        close c_cur_curativo_i;

        open c_monit_resp_i;
        loop
          fetch c_monit_resp_i
            into r_monit_resp_i;
          EXIT WHEN NOT FOUND; /* apply on c_monit_resp_i */

            w_audit_flowsheet_w.dt_evento := to_char(r_monit_resp_i.dt_monitorizacao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.dt_inativacao := to_char(r_monit_resp_i.dt_inativacao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.ds_motivo := r_monit_resp_i.ds_justificativa;
            w_audit_flowsheet_w.ds_autor := r_monit_resp_i.nm_usuario_inativacao;

            CALL pck_flowsheet.verify_and_insert_audit('Airway Type', r_monit_resp_i.ie_canula_traqueo, w_audit_flowsheet_w);
            CALL pck_flowsheet.verify_and_insert_audit('Airway Size', r_monit_resp_i.nr_protese, w_audit_flowsheet_w);
            CALL pck_flowsheet.verify_and_insert_audit('Airway Position', r_monit_resp_i.qt_rima_labial, w_audit_flowsheet_w);

        end loop;
        close c_monit_resp_i;


        open c_informacao_leito_i;
        loop
          fetch c_informacao_leito_i
            into r_informacao_leito_i;
          EXIT WHEN NOT FOUND; /* apply on c_informacao_leito_i */

            w_audit_flowsheet_w.dt_evento := to_char(r_informacao_leito_i.dt_liberacao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.dt_inativacao := to_char(r_informacao_leito_i.dt_inativacao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.ds_motivo := r_informacao_leito_i.ds_justificativa;
            w_audit_flowsheet_w.ds_autor := r_informacao_leito_i.nm_usuario_inativacao;

            CALL pck_flowsheet.verify_and_insert_audit('Bed Position', r_informacao_leito_i.ie_bedposition, w_audit_flowsheet_w);
            CALL pck_flowsheet.verify_and_insert_audit('Side Rails', r_informacao_leito_i.ie_headrailsposition, w_audit_flowsheet_w);
            CALL pck_flowsheet.verify_and_insert_audit('Safety Check', r_informacao_leito_i.ie_hobalarminfo, w_audit_flowsheet_w);

        end loop;
        close c_informacao_leito_i;

        open c_atend_precaucao_i;
        loop
          fetch c_atend_precaucao_i
            into r_atend_precaucao_i;
          EXIT WHEN NOT FOUND; /* apply on c_atend_precaucao_i */

            w_audit_flowsheet_w.dt_evento := to_char(r_atend_precaucao_i.dt_liberacao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.dt_inativacao := to_char(r_atend_precaucao_i.dt_inativacao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.ds_motivo := r_atend_precaucao_i.ds_justificativa;
            w_audit_flowsheet_w.ds_autor := r_atend_precaucao_i.nm_usuario_inativacao;

            CALL pck_flowsheet.verify_and_insert_audit('Isolation Precautions', r_atend_precaucao_i.ds_precaucao, w_audit_flowsheet_w);

        end loop;
        close c_atend_precaucao_i;

        open c_paciente_rep_prescricao_i;
        loop
          fetch c_paciente_rep_prescricao_i
            into r_paciente_rep_prescricao_i;
          EXIT WHEN NOT FOUND; /* apply on c_paciente_rep_prescricao_i */

            w_audit_flowsheet_w.dt_evento := to_char(r_paciente_rep_prescricao_i.dt_liberacao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.dt_inativacao := to_char(r_paciente_rep_prescricao_i.dt_inativacao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.ds_motivo := r_paciente_rep_prescricao_i.ds_justificativa;
            w_audit_flowsheet_w.ds_autor := r_paciente_rep_prescricao_i.nm_usuario_inativacao;

            CALL pck_flowsheet.verify_and_insert_audit('Restraints', r_paciente_rep_prescricao_i.ds_restricao, w_audit_flowsheet_w);
            CALL pck_flowsheet.verify_and_insert_audit('Reason for Restraint', r_paciente_rep_prescricao_i.ds_observacao, w_audit_flowsheet_w);
            CALL pck_flowsheet.verify_and_insert_audit('Restraint Status', r_paciente_rep_prescricao_i.ie_situacao, w_audit_flowsheet_w);
            CALL pck_flowsheet.verify_and_insert_audit('Restraint Type', r_paciente_rep_prescricao_i.ds_nivel, w_audit_flowsheet_w);

        end loop;
        close c_paciente_rep_prescricao_i;

        open c_nutricao;
        loop
          fetch c_nutricao
            into r_nutricao;
          EXIT WHEN NOT FOUND; /* apply on c_nutricao */

            w_audit_flowsheet_w.dt_evento := to_char(r_nutricao.dt_avaliacao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.dt_inativacao := to_char(r_nutricao.dt_inativacao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.ds_motivo := r_nutricao.ds_justificativa;
            w_audit_flowsheet_w.ds_autor := r_nutricao.nm_usuario_inativacao;

            CALL pck_flowsheet.verify_and_insert_audit('Nutrition', r_nutricao.ds_avaliacao, w_audit_flowsheet_w);

        end loop;
        close c_nutricao;

        open c_enferm(2);
        loop
          fetch c_enferm
            into r_enferm;
          EXIT WHEN NOT FOUND; /* apply on c_enferm */

            w_audit_flowsheet_w.dt_evento := to_char(r_enferm.dt_atualizacao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.dt_inativacao := to_char(r_enferm.dt_suspensao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.ds_motivo := r_enferm.ds_justificativa;
            w_audit_flowsheet_w.ds_autor := r_enferm.nm_usuario_susp;

            CALL pck_flowsheet.verify_and_insert_audit('Activity', r_enferm.ds_resultado, w_audit_flowsheet_w);

        end loop;
        close c_enferm;

        open c_enferm(3);
        loop
          fetch c_enferm
            into r_enferm;
          EXIT WHEN NOT FOUND; /* apply on c_enferm */

            w_audit_flowsheet_w.dt_evento := to_char(r_enferm.dt_atualizacao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.dt_inativacao := to_char(r_enferm.dt_suspensao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.ds_motivo := r_enferm.ds_justificativa;
            w_audit_flowsheet_w.ds_autor := r_enferm.nm_usuario_susp;

            CALL pck_flowsheet.verify_and_insert_audit('Hygiene/ADLs', r_enferm.ds_resultado, w_audit_flowsheet_w);

        end loop;
        close c_enferm;

        open c_enferm(4);
        loop
          fetch c_enferm
            into r_enferm;
          EXIT WHEN NOT FOUND; /* apply on c_enferm */

            w_audit_flowsheet_w.dt_evento := to_char(r_enferm.dt_atualizacao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.dt_inativacao := to_char(r_enferm.dt_suspensao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.ds_motivo := r_enferm.ds_justificativa;
            w_audit_flowsheet_w.ds_autor := r_enferm.nm_usuario_susp;

            CALL pck_flowsheet.verify_and_insert_audit('Treatments', r_enferm.ds_resultado, w_audit_flowsheet_w);

        end loop;
        close c_enferm;

        open c_enferm(5);
        loop
          fetch c_enferm
            into r_enferm;
          EXIT WHEN NOT FOUND; /* apply on c_enferm */

            w_audit_flowsheet_w.dt_evento := to_char(r_enferm.dt_atualizacao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.dt_inativacao := to_char(r_enferm.dt_suspensao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.ds_motivo := r_enferm.ds_justificativa;
            w_audit_flowsheet_w.ds_autor := r_enferm.nm_usuario_susp;

            CALL pck_flowsheet.verify_and_insert_audit('Incision/Woundcare', r_enferm.ds_resultado, w_audit_flowsheet_w);

        end loop;
        close c_enferm;

        open c_enferm(6);
        loop
          fetch c_enferm
            into r_enferm;
          EXIT WHEN NOT FOUND; /* apply on c_enferm */

            w_audit_flowsheet_w.dt_evento := to_char(r_enferm.dt_atualizacao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.dt_inativacao := to_char(r_enferm.dt_suspensao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.ds_motivo := r_enferm.ds_justificativa;
            w_audit_flowsheet_w.ds_autor := r_enferm.nm_usuario_susp;

            CALL pck_flowsheet.verify_and_insert_audit('Safety Assessment', r_enferm.ds_resultado, w_audit_flowsheet_w);

        end loop;
        close c_enferm;

        open c_enferm(7);
        loop
          fetch c_enferm
            into r_enferm;
          EXIT WHEN NOT FOUND; /* apply on c_enferm */

            w_audit_flowsheet_w.dt_evento := to_char(r_enferm.dt_atualizacao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.dt_inativacao := to_char(r_enferm.dt_suspensao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.ds_motivo := r_enferm.ds_justificativa;
            w_audit_flowsheet_w.ds_autor := r_enferm.nm_usuario_susp;

            CALL pck_flowsheet.verify_and_insert_audit('Precautions', r_enferm.ds_resultado, w_audit_flowsheet_w);

        end loop;
        close c_enferm;

        open c_enferm(8);
        loop
          fetch c_enferm
            into r_enferm;
          EXIT WHEN NOT FOUND; /* apply on c_enferm */

            w_audit_flowsheet_w.dt_evento := to_char(r_enferm.dt_atualizacao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.dt_inativacao := to_char(r_enferm.dt_suspensao, 'MM/DD/YYYY HH24:MI:SS');
            w_audit_flowsheet_w.ds_motivo := r_enferm.ds_justificativa;
            w_audit_flowsheet_w.ds_autor := r_enferm.nm_usuario_susp;

            CALL pck_flowsheet.verify_and_insert_audit('Equipment', r_enferm.ds_resultado, w_audit_flowsheet_w);

        end loop;
        close c_enferm;
                                                        
        commit;

    end loop;
    close c1;

    commit;

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pck_flowsheet.ger_dados_audit_nursing_care (cd_relatorio_p bigint, ie_dados_p text, dt_inicial_p timestamp, dt_final_p timestamp, cd_pessoa_fisica_p bigint) FROM PUBLIC;