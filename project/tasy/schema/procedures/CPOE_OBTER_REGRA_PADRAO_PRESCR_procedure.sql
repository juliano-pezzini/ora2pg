-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_obter_regra_padrao_prescr ( cd_material_p bigint, cd_perfil_p bigint, nm_usuario_p text, ie_via_aplicacao_p text, ie_se_necessario_p text, cd_estabelecimento_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p text DEFAULT NULL, cd_intervalo_p text DEFAULT NULL, qt_dose_medic_p bigint DEFAULT NULL, cd_unidade_medida_dose_p text DEFAULT NULL, ie_retorno_campo_p bigint DEFAULT NULL, ie_retorno_info_p INOUT bigint DEFAULT NULL, nr_ordenacao_p INOUT bigint  DEFAULT NULL) AS $body$
DECLARE


    nr_ordenacao_w               smallint;
    cd_unidade_basica_w          varchar(30);
    ds_lista_restricao_w         varchar(255);
    qt_hora_min_aplicacao_w      double precision;
    qt_dose_ml_item_w            double precision;
    qt_conversao_w               double precision;
    qt_idade_gestacional_w       double precision;
    qt_idade_w                   double precision;
    nr_seq_restricao_w           material_diluicao.nr_seq_restricao%TYPE;
    cd_pessoa_fisica_w           pessoa_fisica.cd_pessoa_fisica%TYPE;
    qt_peso_w                    prescr_medica.qt_peso%TYPE;
    cd_setor_atend_prescr_w      setor_atendimento.cd_setor_atendimento%TYPE;
    nr_seq_agrupamento_w         setor_atendimento.nr_seq_agrupamento%TYPE;
    ie_proporcao_w               material_diluicao.ie_proporcao%TYPE;
    sql_w                        varchar(200);
    qt_retorno_w                 double precision;
    qt_hora_min_aplicacao_aux_w  double precision;


 /* 	Prioridade da busca das informacoes no cursor C01 :
 * 1 Cadastro de Material/Farmacia/Doses Padroes
 * 2 Cadastro de Material/Farmacia/Diluicao 		
 * 3 Cadastro de Material/Farmacia/Prescr
 */
 
 /*  
 * ie_retorno_campo_p 
 * 1 = qt_min_aplicacao
 */
    c01 CURSOR FOR
    SELECT
        coalesce(a.qt_hora_aplicacao, 00) * 60 + coalesce(a.qt_minuto_aplicacao, 00)                  qt_hora_min_aplicacao,
        1                                                                               ordernacao,
        NULL                                                                            ie_proporcao
    FROM
        material_prescr a
    WHERE
            a.cd_material = cd_material_p
        AND a.ie_tipo = '1'
        AND coalesce(a.cd_setor_atendimento, coalesce(cd_setor_atend_prescr_w, 0)) = coalesce(cd_setor_atend_prescr_w, 0)
        AND ( ( coalesce(a.cd_unidade_basica::text, '') = '' )
              OR ( a.cd_unidade_basica = cd_unidade_basica_w ) )
        AND ( ( coalesce(a.ie_via_aplicacao::text, '') = '' )
              OR ( a.ie_via_aplicacao = ie_via_aplicacao_p ) )
        AND coalesce(qt_peso_w, 1) BETWEEN coalesce(a.qt_peso_min, 0) AND coalesce(a.qt_peso_max, 999999)
        AND ( ( coalesce(nr_seq_agrupamento::text, '') = '' )
              OR ( nr_seq_agrupamento = nr_seq_agrupamento_w ) )
        AND ( ( ( coalesce(qt_ig_min::text, '') = '' )
                AND ( coalesce(qt_ig_max::text, '') = '' ) )
              OR ( ( qt_idade_gestacional_w BETWEEN coalesce(qt_ig_min, 0) AND coalesce(qt_ig_max, 9999999) )
                   AND ( qt_idade_gestacional_w < 41 ) ) )
        AND coalesce(trunc(qt_idade_w), 1) BETWEEN coalesce(obter_idade_param_prescr2(coalesce(a.qt_idade_min, 0), coalesce(a.qt_idade_min_mes, 0), coalesce(
        a.qt_idade_min_dia, 0), coalesce(a.qt_idade_max, 0), coalesce(a.qt_idade_max_mes, 0),
                                                                            coalesce(a.qt_idade_max_dia, 0),
                                                                            'MIN'),
                                                  0) AND coalesce(obter_idade_param_prescr2(coalesce(a.qt_idade_min, 0), coalesce(a.qt_idade_min_mes,
                                                  0), coalesce(a.qt_idade_min_dia, 0), coalesce(a.qt_idade_max, 0), coalesce(a.qt_idade_max_mes,
                                                  0),
                                                                                       coalesce(a.qt_idade_max_dia, 0),
                                                                                       'MAX'),
                                                             9999999)
        AND NOT EXISTS (
            SELECT
                1
            FROM
                regra_setor_mat_prescr b
            WHERE
                    a.nr_sequencia = b.nr_seq_mat_prescr
                AND b.cd_setor_excluir = cd_setor_atend_prescr_w
        )
        AND ( ( coalesce(a.ie_somente_sn, 'N') = 'N' )
              OR ( ie_se_necessario_p = 'S' ) )
        AND ( ( coalesce(a.cd_estabelecimento::text, '') = '' )
              OR ( a.cd_estabelecimento = cd_estabelecimento_p ) )
        AND ( ( coalesce(a.cd_intervalo_filtro::text, '') = '' )
              OR ( a.cd_intervalo_filtro = cd_intervalo_p ) )
        AND ( ( coalesce(cd_doenca_cid::text, '') = '' )
              OR ( obter_se_cid_atendimento(nr_atendimento_p, cd_doenca_cid) = 'S' ) )

UNION

    SELECT
        coalesce(qt_minuto_aplicacao, 00)       qt_hora_min_aplicacao,
        2                                 ordernacao,
        ie_proporcao                      ie_proporcao
    FROM
        material_diluicao
    WHERE
            obter_se_regra_diluicao_setor(nr_seq_interno, cd_setor_atend_prescr_w) = 'S'
        AND coalesce(obter_conversao_unid_med_cons(cd_material_p, cd_unidade_medida_dose_p, qt_dose_medic_p), 0) BETWEEN coalesce(obter_conversao_unid_med_cons(
        cd_material_p, cd_unidade_medida, qt_dose_min), 0) AND coalesce(obter_conversao_unid_med_cons(cd_material_p, cd_unidade_medida,
        qt_dose_max), 9999999)
        AND coalesce(qt_idade_w, 1) BETWEEN obter_idade_diluicao(cd_material, nr_sequencia, 'MIN') AND obter_idade_diluicao(cd_material,
        nr_sequencia, 'MAX')
        AND coalesce(qt_peso_w, 0) BETWEEN coalesce(qt_peso_min, 0) AND coalesce(qt_peso_max, 999999)
        AND ( ( obter_se_contido(nr_seq_restricao, ds_lista_restricao_w) = 'S' )
              OR ( coalesce(nr_seq_restricao::text, '') = '' ) )
        AND ( ( cd_setor_excluir <> cd_setor_atend_prescr_w )
              OR ( coalesce(cd_setor_excluir::text, '') = '' ) )
        AND ( ( ie_via_excluir <> ie_via_aplicacao_p )
              OR ( coalesce(ie_via_excluir::text, '') = '' ) )
        AND ( ( nr_seq_agrupamento = nr_seq_agrupamento_w )
              OR ( coalesce(nr_seq_agrupamento::text, '') = '' ) )
        AND ( ( cd_setor_atendimento = cd_setor_atend_prescr_w )
              OR ( coalesce(cd_setor_atendimento::text, '') = '' ) )
        AND ( ( ie_via_aplicacao = ie_via_aplicacao_p )
              OR ( coalesce(ie_via_aplicacao::text, '') = '' ) )
        AND ( ( cd_unidade_medida = cd_unidade_medida_dose_p )
              OR ( coalesce(cd_unidade_medida::text, '') = '' ) )
        AND coalesce(cd_perfil, coalesce(obter_perfil_ativo, 0)) = coalesce(obter_perfil_ativo, 0)
        AND coalesce(cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p
        AND obter_se_material_ativo(cd_diluente) = 'A'
--and nvl(ie_proporcao, 'F') = 'ST'
        AND ie_reconstituicao = 'N'
        AND cd_material = cd_material_p
    
UNION

    SELECT
        coalesce(a.qt_min_aplicacao, 00)         qt_hora_min_aplicacao,
        3                                  ordernacao,
        NULL                               ie_proporcao
    FROM
        material a
    WHERE
            ie_situacao = 'A'
        AND cd_material = cd_material_p
    ORDER BY
        ordernacao;

    c03 CURSOR FOR
    SELECT
        nr_seq_restricao
    FROM
        paciente_rep_prescricao a
    WHERE
        (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
        AND coalesce(dt_inativacao::text, '') = ''
        AND ( ( coalesce(a.dt_fim::text, '') = '' )
              OR ( clock_timestamp() BETWEEN coalesce(a.dt_inicio, clock_timestamp() - interval '1 days') AND a.dt_fim + 86399 / 86400 ) )
        AND cd_pessoa_fisica = cd_pessoa_fisica_w;


BEGIN
    IF ( coalesce(cd_material_p, 0) = 0 ) THEN
        ie_retorno_info_p := 0;
    END IF;
    IF (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') THEN
        cd_pessoa_fisica_w := coalesce(cd_pessoa_fisica_p, obter_pessoa_atendimento(nr_atendimento_p, 'C'));
        cd_unidade_basica_w := obter_unidade_atendimento(nr_atendimento_p, 'A', 'UB');
        cd_setor_atend_prescr_w := cpoe_obter_setor_atend_prescr(nr_atendimento_p, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p);
        SELECT
            MAX(nr_seq_agrupamento)
        INTO STRICT nr_seq_agrupamento_w
        FROM
            setor_atendimento
        WHERE
            cd_setor_atendimento = cd_setor_atend_prescr_w;

        BEGIN
            qt_peso_w := obter_sinal_vital(nr_atendimento_p, 'Peso');
        EXCEPTION
            WHEN unique_violation  THEN
                qt_peso_w := NULL;
        END;

    ELSE
        cd_pessoa_fisica_w := cd_pessoa_fisica_p;
        qt_peso_w := obter_peso_pf(cd_pessoa_fisica_w);
    END IF;

    SELECT
        MAX(obter_idade(b.dt_nascimento, coalesce(b.dt_obito, clock_timestamp()), 'DIA')),
        coalesce(MAX(obter_semana_idade_igc(clock_timestamp(), b.dt_nascimento, b.dt_nascimento_ig, b.qt_dias_ig, b.qt_semanas_ig)), 0)
    INTO STRICT
        qt_idade_w,
        qt_idade_gestacional_w
    FROM
        pessoa_fisica b
    WHERE
        b.cd_pessoa_fisica = cd_pessoa_fisica_w;

    OPEN c03;
    LOOP
        FETCH c03 INTO nr_seq_restricao_w;
        EXIT WHEN NOT FOUND; /* apply on c03 */
        ds_lista_restricao_w := nr_seq_restricao_w
                                || ','
                                || ds_lista_restricao_w;
    END LOOP;

    CLOSE c03;

    OPEN c01;
    LOOP
        FETCH c01 INTO
            qt_hora_min_aplicacao_w,
            nr_ordenacao_w,
            ie_proporcao_w;
        EXIT WHEN NOT FOUND; /* apply on c01 */
        BEGIN
            IF ( ie_retorno_campo_p = 1 ) THEN
                IF ( qt_hora_min_aplicacao_w > 0 ) THEN
                    IF ( nr_ordenacao_w = 2 )
                        AND ( coalesce(ie_proporcao_w, 'XPTO') = 'ST' )
                    THEN

                --inicio md
                        BEGIN
                            qt_retorno_w := coalesce(obter_conversao_ml(cd_material_p, qt_dose_medic_p, cd_unidade_medida_dose_p), 0);
                            sql_w := 'CALL OBTER_dose_ml_item_MD(:1)INTO :qt_dose_ml_item_w';
                            EXECUTE sql_w
                                USING IN qt_retorno_w, OUT qt_dose_ml_item_w;
                        EXCEPTION
                            WHEN unique_violation  THEN
                                qt_dose_ml_item_w := NULL;
                        END;

                --fim md
                        SELECT
                            coalesce(MAX(qt_conversao), 1)
                        INTO STRICT qt_conversao_w
                        FROM
                            material_conversao_unidade
                        WHERE
                                cd_material = cd_material_p
                            AND upper(cd_unidade_medida) = upper(obter_unid_med_usua('ML'));			
                /* Inicio MD1 */

                        BEGIN
                            sql_w := 'CALL obter_hora_min_aplicacao_md(:1, :2, :3)INTO :qt_hora_min_aplicacao_aux_w';
                            EXECUTE sql_w
                                USING IN qt_dose_ml_item_w, IN qt_hora_min_aplicacao_w, IN qt_conversao_w, OUT qt_hora_min_aplicacao_aux_w;
                        EXCEPTION
                            WHEN unique_violation  THEN
                                qt_hora_min_aplicacao_aux_w := NULL;
                        END;

                        qt_hora_min_aplicacao_w := qt_hora_min_aplicacao_aux_w;
                /* Fim MD1 */

                    END IF;
                    ie_retorno_info_p := qt_hora_min_aplicacao_w;
					nr_ordenacao_p := nr_ordenacao_w;
                END IF;
            END IF;
        END;

    END LOOP;

    CLOSE c01;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_obter_regra_padrao_prescr ( cd_material_p bigint, cd_perfil_p bigint, nm_usuario_p text, ie_via_aplicacao_p text, ie_se_necessario_p text, cd_estabelecimento_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p text DEFAULT NULL, cd_intervalo_p text DEFAULT NULL, qt_dose_medic_p bigint DEFAULT NULL, cd_unidade_medida_dose_p text DEFAULT NULL, ie_retorno_campo_p bigint DEFAULT NULL, ie_retorno_info_p INOUT bigint DEFAULT NULL, nr_ordenacao_p INOUT bigint  DEFAULT NULL) FROM PUBLIC;
