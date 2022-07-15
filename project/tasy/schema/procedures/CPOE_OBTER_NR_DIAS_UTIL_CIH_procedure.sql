-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_obter_nr_dias_util_cih ( nr_sequencia_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p text, cd_material_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, dt_fim_cih_p timestamp, dt_suspensao_p timestamp, dt_lib_suspensao_p timestamp, nr_seq_cpoe_anterior_p bigint, nr_dia_util_p INOUT bigint, ie_tratamento_vig_p INOUT text, qt_total_dias_lib_p INOUT bigint ) AS $body$
DECLARE


    qt_dia_util_w              cpoe_material.nr_dia_util%TYPE;
    ie_dias_util_medic_w       material.ie_dias_util_medic%TYPE;
    qt_dias_sem_antibiotico_w  parametro_medico.qt_dias_antibiotico%TYPE;
    ie_atb_pessoa_w            varchar(1);
    dt_fim_w                   timestamp;
    sql_w                      varchar(200);
    cd_estabelecimento_w       estabelecimento.cd_estabelecimento%TYPE;
    qt_hors_copia_w            bigint;
    ds_parametros_w            varchar(4000);
    ds_erro_w                  varchar(4000);
    c01 CURSOR FOR
    SELECT
        nr_dia_util,
        dt_inicio,
        dt_fim,
        dt_fim_cih,
        dt_suspensao,
        dt_lib_suspensao,
        nr_sequencia,
        qt_dias_liberado
    FROM
        cpoe_material
    WHERE
        ( ( coalesce(ie_atb_pessoa_w, 'N') = 'S'
            AND cd_pessoa_fisica = cd_pessoa_fisica_p )
          OR ( coalesce(ie_atb_pessoa_w, 'N') = 'N'
               AND nr_atendimento = nr_atendimento_p ) )
        AND cd_material = cd_material_p
        AND ie_antibiotico = 'S'
        AND ( ( coalesce(dt_liberacao::text, '') = ''
                AND nr_sequencia <> coalesce(nr_sequencia_p, 0) )
              OR (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') )
        AND dt_inicio < ( clock_timestamp() + ( ( qt_hors_copia_w + 1 ) / 24 ) );

BEGIN
    ie_tratamento_vig_p := 'S';
    cd_estabelecimento_w := coalesce(wheb_usuario_pck.get_cd_estabelecimento, 0);
    qt_hors_copia_w := get_qt_hours_after_copy_cpoe(obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, cd_estabelecimento_w);
    BEGIN
        sql_w := 'CALL obter_dt_fim_med_md (:1, :2, :3, :4) INTO :dt_fim_w';
        EXECUTE sql_w
            USING IN dt_fim_p, IN dt_fim_cih_p, IN dt_suspensao_p, IN dt_lib_suspensao_p, OUT dt_fim_w;

    EXCEPTION
        WHEN OTHERS THEN
            ds_erro_w := sqlerrm;
            ds_parametros_w := ( 'nr_sequencia_p: '
                                 || nr_sequencia_p
                                 || '-'
                                 || 'nr_atendimento_p: '
                                 || nr_atendimento_p
                                 || '-'
                                 || 'cd_pessoa_fisica_p: '
                                 || cd_pessoa_fisica_p
                                 || '-'
                                 || 'dt_fim_p: '
                                 || dt_fim_p
                                 || '-'
                                 || 'dt_fim_cih_p: '
                                 || dt_fim_cih_p
                                 || '-'
                                 || 'dt_suspensao_p: '
                                 || dt_suspensao_p
                                 || '-'
                                 || 'dt_lib_suspensao_p: '
                                 || dt_lib_suspensao_p
                                 || '-'
                                 || 'dt_fim_w: '
                                 || dt_fim_w );

            CALL gravar_log_medical_device('cpoe_obter_nr_dias_util_cih', 'obter_dt_fim_med_md',
                                     ds_parametros_w,
                                     substr(ds_erro_w, 4000),
                                     wheb_usuario_pck.get_nm_usuario,
                                     'S');

            dt_fim_w := NULL;
    END;

--dt_fim_w := obter_menor_data_w(dt_fim_p, dt_fim_cih_p, dt_suspensao_p, dt_lib_suspensao_p);
    SELECT
        coalesce(MAX(ie_atb_pessoa), 'N'),
        coalesce(MAX(qt_dias_antibiotico), 1)
    INTO STRICT
        ie_atb_pessoa_w,
        qt_dias_sem_antibiotico_w
    FROM
        parametro_medico
    WHERE
        cd_estabelecimento = cd_estabelecimento_w;

    SELECT
        coalesce(MAX(ie_dias_util_medic), 'N')
    INTO STRICT ie_dias_util_medic_w
    FROM
        material
    WHERE
        cd_material = cd_material_p;

    BEGIN
        sql_w := 'CALL OBTER_QT_DIA_UTIL_CIH_MD(:1) INTO :qt_dia_util_w';
        EXECUTE sql_w
            USING IN ie_dias_util_medic_w, OUT qt_dia_util_w;
    EXCEPTION
        WHEN OTHERS THEN
            ds_erro_w := sqlerrm;
            ds_parametros_w := ( 'nr_sequencia_p: '
                                 || nr_sequencia_p
                                 || '-'
                                 || 'nr_atendimento_p: '
                                 || nr_atendimento_p
                                 || '-'
                                 || 'cd_pessoa_fisica_p: '
                                 || cd_pessoa_fisica_p
                                 || '-'
                                 || 'ie_dias_util_medic_w: '
                                 || ie_dias_util_medic_w
                                 || '-'
                                 || 'qt_dia_util_w: '
                                 || qt_dia_util_w );

            CALL gravar_log_medical_device('cpoe_obter_nr_dias_util_cih',
                                     'OBTER_QT_DIA_UTIL_CIH_MD',
                                     ds_parametros_w,
                                     substr(ds_erro_w, 4000),
                                     wheb_usuario_pck.get_nm_usuario,
                                     'S');

            qt_dia_util_w := NULL;
    END;

    IF (
        (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '')
        AND (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '')
        AND (cd_material_p IS NOT NULL AND cd_material_p::text <> '')
    ) THEN
        FOR cpoe_mat_w IN c01 LOOP
            BEGIN
                sql_w := 'begin CALCULA_TOTAL_DIA_LIB_CIH_MD(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13); end;';
                EXECUTE sql_w
                    USING IN nr_seq_cpoe_anterior_p, IN cpoe_mat_w.nr_sequencia, IN cpoe_mat_w.dt_fim_cih, IN cpoe_mat_w.dt_fim, IN
                    cpoe_mat_w.dt_suspensao, IN cpoe_mat_w.dt_lib_suspensao, IN qt_dias_sem_antibiotico_w, IN cpoe_mat_w.dt_inicio,
                    IN cpoe_mat_w.nr_dia_util, IN cpoe_mat_w.qt_dias_liberado, IN OUT qt_total_dias_lib_p, IN OUT nr_dia_util_p,
					IN dt_inicio_p;

            EXCEPTION
                WHEN OTHERS THEN
                    ds_erro_w := sqlerrm;
                    ds_parametros_w := ( 'nr_sequencia_p: '
                                         || nr_sequencia_p
                                         || '-'
                                         || 'nr_atendimento_p: '
                                         || nr_atendimento_p
                                         || '-'
                                         || 'cd_pessoa_fisica_p: '
                                         || cd_pessoa_fisica_p
                                         || '-'
                                         || 'nr_seq_cpoe_anterior_p: '
                                         || nr_seq_cpoe_anterior_p
                                         || '-'
                                         || 'cpoe_mat_w.nr_sequencia: '
                                         || cpoe_mat_w.nr_sequencia
                                         || '-'
                                         || 'cpoe_mat_w.dt_fim_cih: '
                                         || cpoe_mat_w.dt_fim_cih
                                         || '-'
                                         || 'cpoe_mat_w.dt_fim: '
                                         || cpoe_mat_w.dt_fim
                                         || '-'
                                         || 'cpoe_mat_w.dt_suspensao: '
                                         || cpoe_mat_w.dt_suspensao
                                         || '-'
                                         || 'cpoe_mat_w.dt_lib_suspensao: '
                                         || cpoe_mat_w.dt_lib_suspensao
                                         || '-'
                                         || 'qt_dias_sem_antibiotico_w: '
                                         || qt_dias_sem_antibiotico_w
                                         || '-'
                                         || 'cpoe_mat_w.dt_inicio: '
                                         || cpoe_mat_w.dt_inicio
                                         || '-'
                                         || 'cpoe_mat_w.nr_dia_util: '
                                         || cpoe_mat_w.nr_dia_util
                                         || '-'
                                         || 'cpoe_mat_w.qt_dias_liberado: '
                                         || cpoe_mat_w.qt_dias_liberado
                                         || '-'
                                         || 'qt_total_dias_lib_p: '
                                         || qt_total_dias_lib_p
                                         || '-'
                                         || 'nr_dia_util_p: '
                                         || nr_dia_util_p
										 || '-'
                                         || 'dt_inicio_p: '
                                         || dt_inicio_p );

                    CALL gravar_log_medical_device('cpoe_obter_nr_dias_util_cih',
                                             'CALCULA_TOTAL_DIA_LIB_CIH_MD',
                                             ds_parametros_w,
                                             substr(ds_erro_w, 4000),
                                             wheb_usuario_pck.get_nm_usuario,
                                             'S');

                    qt_total_dias_lib_p := NULL;
                    nr_dia_util_p := NULL;
            END;
        END LOOP;
    END IF;


    BEGIN
        sql_w := 'begin OBTER_NR_DIAS_UTIL_CIH_MD(:1, :2, :3, :4, :5); end;';
        EXECUTE sql_w
            USING IN qt_dia_util_w, IN dt_inicio_p, IN OUT ie_tratamento_vig_p, IN OUT qt_total_dias_lib_p, IN OUT nr_dia_util_p;

    EXCEPTION
        WHEN OTHERS THEN
            ds_erro_w := sqlerrm;
            ds_parametros_w := ( 'nr_sequencia_p: '
                                 || nr_sequencia_p
                                 || '-'
                                 || 'nr_atendimento_p: '
                                 || nr_atendimento_p
                                 || '-'
                                 || 'cd_pessoa_fisica_p: '
                                 || cd_pessoa_fisica_p
                                 || '-'
                                 || 'qt_dia_util_w: '
                                 || qt_dia_util_w
                                 || '-'
                                 || 'dt_inicio_p: '
                                 || dt_inicio_p
                                 || '-'
                                 || 'ie_tratamento_vig_p: '
                                 || ie_tratamento_vig_p
                                 || '-'
                                 || 'qt_total_dias_lib_p: '
                                 || qt_total_dias_lib_p
                                 || '-'
                                 || 'nr_dia_util_p: '
                                 || nr_dia_util_p );

            CALL gravar_log_medical_device('cpoe_obter_nr_dias_util_cih',
                                     'OBTER_NR_DIAS_UTIL_CIH_MD',
                                     ds_parametros_w,
                                     substr(ds_erro_w, 4000),
                                     wheb_usuario_pck.get_nm_usuario,
                                     'S');

            ie_tratamento_vig_p := NULL;
            qt_total_dias_lib_p := NULL;
            nr_dia_util_p := NULL;
    END;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_obter_nr_dias_util_cih ( nr_sequencia_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p text, cd_material_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, dt_fim_cih_p timestamp, dt_suspensao_p timestamp, dt_lib_suspensao_p timestamp, nr_seq_cpoe_anterior_p bigint, nr_dia_util_p INOUT bigint, ie_tratamento_vig_p INOUT text, qt_total_dias_lib_p INOUT bigint ) FROM PUBLIC;

