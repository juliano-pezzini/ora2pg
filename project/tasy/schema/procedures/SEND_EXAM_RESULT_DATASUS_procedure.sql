-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE send_exam_result_datasus ( nr_prescricao_p prescr_procedimento.nr_prescricao%TYPE, nr_seq_exame_p prescr_procedimento.nr_seq_exame%TYPE, nr_sequencia_p prescr_procedimento.nr_sequencia%TYPE, ds_sigla_integra_p equipamento_lab.ds_sigla%TYPE ) AS $body$
DECLARE


    timezone_w varchar(6) := substr(TZ_OFFSET(SESSIONTIMEZONE),1,6);
    exams CURSOR FOR
    SELECT
        b.cd_pessoa_fisica,
        PKG_DATE_UTILS.get_ISOFormat(b.dt_prescricao)||timezone_w  dt_prescricao,
        PKG_DATE_UTILS.get_ISOFormat(elri.dt_coleta)||timezone_w  dt_coleta,
        lee.cd_exame_equip   nr_seq_exame,
        lee.cd_exame_equip,
        (
            SELECT
                lab_obter_resultado_exame(t.nr_seq_resultado, t.nr_sequencia)
            FROM
                exame_lab_result_item t
            WHERE
                t.nr_seq_resultado = elri.nr_seq_resultado
                AND t.nr_seq_prescr = elri.nr_seq_prescr
                AND trim(both lab_obter_resultado_exame(t.nr_seq_resultado, t.nr_sequencia)) IS NOT NULL
                AND (obter_equipamento_exame(t.nr_seq_exame, NULL, 'COVID19') IS NOT NULL AND (obter_equipamento_exame(t.nr_seq_exame, NULL, 'COVID19'))::text <> '')
        ) ds_resultado,
        coalesce(obter_metodo_exame_lab(elri.nr_seq_metodo, 2), obter_desc_expressao(965135)) ds_metodo,
        coalesce(substr(obter_valor_ref_exame(elri.nr_seq_resultado, elri.nr_sequencia), 1, 255), obter_desc_expressao(965135)) ds_referencia
        ,
        coalesce(elri.ds_observacao, obter_desc_expressao(965135)) ds_observacao,
        PKG_DATE_UTILS.get_ISOFormat(clock_timestamp())||timezone_w  dt_atual,
        coalesce(pf.nr_cartao_nac_sus, pf.nr_cpf, '0') nr_cartaosus,
        pj.cd_cnes           estabelecimento,
        coalesce(lab_obter_mat_exame_integr(elri.nr_seq_material, 'COVID19'), mel.cd_material_integracao, mel.cd_material_exame) cd_material
        ,
        PKG_DATE_UTILS.get_ISOFormat(coalesce(elri.dt_aprovacao, clock_timestamp()))||timezone_w dt_aprovacao
    FROM
        prescr_medica           b
        INNER JOIN exame_lab_resultado     elr ON elr.nr_prescricao = b.nr_prescricao
        INNER JOIN exame_lab_result_item   elri ON elri.nr_seq_resultado = elr.nr_seq_resultado
        INNER JOIN exame_laboratorio       elab ON elab.nr_seq_exame = elri.nr_seq_exame
        INNER JOIN lab_exame_equip         lee ON lee.nr_seq_exame = elab.nr_seq_exame
        INNER JOIN equipamento_lab         el ON el.cd_equipamento = lee.cd_equipamento
        INNER JOIN material_exame_lab      mel ON mel.nr_sequencia = elri.nr_seq_material
        INNER JOIN pessoa_fisica           pf ON pf.cd_pessoa_fisica = b.cd_pessoa_fisica
        INNER JOIN pessoa_fisica           pfmedico ON pfmedico.cd_pessoa_fisica = coalesce(elri.cd_medico_resp, b.cd_medico)
        INNER JOIN estabelecimento         est ON est.cd_estabelecimento = b.cd_estabelecimento
        INNER JOIN pessoa_juridica         pj ON pj.cd_cgc = est.cd_cgc
    WHERE
        b.nr_prescricao = nr_prescricao_p
        AND elri.nr_seq_prescr = nr_sequencia_p
        AND elri.nr_seq_exame = nr_seq_exame_p
        AND el.ds_sigla = ds_sigla_integra_p;

    json_exam                philips_json;
    ds_dados_bifrost         text;
    ds_param_integ_res_w     text;
    ie_resultado_w           varchar(1);
    id_rnds                  varchar(255);
    uuid_rnds                varchar(255);
    cns_medico               varchar(255);
    nr_seq_empresa_datasus   CONSTANT empresa_integr_dados.nr_seq_empresa_integr%TYPE := 116;
BEGIN
    json_exam := philips_json();
    BEGIN
        SELECT
            nr_identificador,
            nr_prescricao_p uuid_rnds,
            coalesce(cd_resp_informacao_int, '0') cns_medico
        INTO STRICT
            id_rnds,
            uuid_rnds,
            cns_medico
        FROM
            empresa_integr_dados
        WHERE
            nr_seq_empresa_integr = nr_seq_empresa_datasus
            AND ie_situacao = 'A';

    EXCEPTION
        WHEN too_many_rows OR no_data_found THEN
            id_rnds := NULL;
            uuid_rnds := NULL;
            cns_medico := '0';
    END;

    FOR itemexam IN exams LOOP BEGIN
        IF ( coalesce(itemexam.ds_resultado, '0') <> '0' ) THEN
            IF ( itemexam.ds_resultado NOT IN (
                '1',
                '2',
                '3'
            ) ) THEN
                BEGIN
                    IF ( upper(itemexam.ds_resultado) LIKE '%'
                                                           || obter_desc_expressao(347494)
                                                           || '%' ) THEN
                        ie_resultado_w := '1';
                    ELSIF ( upper(itemexam.ds_resultado) LIKE '%'
                                                              || obter_desc_expressao(347495)
                                                              || '%' ) THEN
                        ie_resultado_w := '2';
                    ELSE
                        ie_resultado_w := '3';
                    END IF;

                END;
            ELSE
                ie_resultado_w := itemexam.ds_resultado;
            END IF;
            json_exam.put('ds_idrnds', id_rnds);
            json_exam.put('ds_uuidrnds', uuid_rnds);
            json_exam.put('dt_atual', itemexam.dt_atual);
            json_exam.put('ds_cartaosus', itemexam.nr_cartaosus);
            json_exam.put('ds_pessoajuridica', itemexam.estabelecimento);
            json_exam.put('cd_cod_exame', itemexam.nr_seq_exame);
            json_exam.put('ds_observacao', itemexam.ds_observacao);
            json_exam.put('ds_metodo', itemexam.ds_metodo);
            json_exam.put('ds_resultado', ie_resultado_w);
            json_exam.put('ds_referencia', itemexam.ds_referencia);
            json_exam.put('dt_coleta', itemexam.dt_coleta);
            json_exam.put('cd_material', itemexam.cd_material);
            json_exam.put('cns_medico', cns_medico);
            json_exam.put('dt_aprovacao', itemexam.dt_aprovacao);
            json_exam.put('ds_access_token', get_valid_token_integ_lab('lab.datasus.tokenrequest', 'DataSus'));
            dbms_lob.createtemporary(lob_loc => ds_dados_bifrost, cache => true, dur => dbms_lob.call);

            json_exam.(ds_dados_bifrost);
            ds_param_integ_res_w := bifrost.send_integration_content('lab.datasus.sendexam', ds_dados_bifrost, wheb_usuario_pck.get_nm_usuario
            );
        END IF;

    END;
    END LOOP;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE send_exam_result_datasus ( nr_prescricao_p prescr_procedimento.nr_prescricao%TYPE, nr_seq_exame_p prescr_procedimento.nr_seq_exame%TYPE, nr_sequencia_p prescr_procedimento.nr_sequencia%TYPE, ds_sigla_integra_p equipamento_lab.ds_sigla%TYPE ) FROM PUBLIC;
