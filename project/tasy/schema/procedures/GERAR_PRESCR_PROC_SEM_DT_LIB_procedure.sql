-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_prescr_proc_sem_dt_lib ( nr_prescricao_p bigint, nr_seq_item_p bigint, cd_perfil_p bigint, ie_liberacao_p text, nm_usuario_p text, ie_tipo_item_p text DEFAULT NULL) AS $body$
DECLARE


    ds_horarios_w                 varchar(2000);
    ds_horarios_padr_w            varchar(2000);
    ds_hora_w                     varchar(2000);
    dt_liberacao_w                timestamp;
    dt_horario_w                  timestamp;
    k                             integer;
    y                             integer;
    nr_sequencia_w                bigint;
    nr_seq_prescr_w               integer;
    qt_dose_w                     double precision;
    qt_total_dispensar_w          double precision;
    cd_material_w                 integer;
    dt_primeiro_horario_w         timestamp;
    ie_agrupador_w                smallint;
    cd_intervalo_w                varchar(7);
    ie_prescricao_dieta_w         varchar(1);
    nr_ocorrencia_w               double precision;
    ie_esquema_alternado_w        varchar(1);
    nr_seq_solucao_w              integer;
    ie_agrupador_dil_w            smallint;
    nr_sequencia_dil_w            bigint;
    qt_dose_dil_w                 double precision;
    qt_total_disp_dil_w           double precision;
    nr_ocorrencia_dil_w           double precision;
    cd_material_dil_w             integer;
    hr_prim_horario_w             varchar(5);
    ie_urgente_w                  varchar(1);
    qt_conversao_w                double precision;
    qt_dose_especial_w            double precision;
    hr_dose_especial_w            varchar(5);
    nr_seq_procedimento_w         integer;
    cd_procedimento_w             bigint;
    ie_origem_proced_w            bigint;
    nr_seq_proc_interno_w         bigint;
    nr_ocor_proc_w                double precision;
    ie_proc_urgente_w             varchar(1);
    dt_prev_execucao_w            timestamp;
    ds_hora_proc_w                varchar(2000);
    dt_horario_proc_w             timestamp;
    ds_horarios_proc_w            varchar(2000);
    ds_horarios_padrao_proc_w     varchar(2000);
    cd_material_exame_w           varchar(20);
    nr_seq_recomendacao_w         integer;
    cd_recomendacao_w             bigint;
    ds_hora_rec_w                 varchar(2000);
    dt_horario_rec_w              timestamp;
    nr_seq_classif_rec_w          bigint;
    ds_horarios_rec_w             varchar(2000);
    ds_horarios_padrao_rec_w      varchar(2000);
    ie_se_necessario_w            varchar(1);
    ie_acm_w                      varchar(1);
    ie_horario_especial_w         varchar(1) := 'N';
    qt_dieta_w                    bigint;
    cd_setor_atendimento_w        integer;
    cd_estabelecimento_w          smallint;
    dt_prescricao_w               timestamp;
    dt_prescricao_ww              timestamp;
    qt_dia_adic_w                 bigint := 0;
    qt_registro_w                 bigint;
    dt_inicio_prescr_w            timestamp;
    nr_seq_procedimento_novo_w    integer;
    nr_seq_exame_w                bigint;
    ie_status_atend_w             smallint;
    ie_status_execucao_w          varchar(3);
    cd_setor_atendimento_proc_w   integer;
    cd_setor_coleta_w             integer;
    cd_setor_entrega_w            integer;
    cd_setor_exec_fim_w           integer;
    cd_setor_exec_inic_w          integer;
    nr_seq_lab_w                  varchar(20);
    ie_gerar_proc_intervalo_w     varchar(1);
    ie_suspenso_w                 varchar(1);
    ds_observacao_w               varchar(2000);
    ds_dado_clinico_w             varchar(2000);
    ds_material_especial_w        varchar(255);
    ie_controlado_w               varchar(1);
    nr_seq_prescr_hor_w           integer;
    dt_horario_proc_prev_w        timestamp;
    ie_proc_atual_w               varchar(1);
    qt_min_agora_w                bigint;
    qt_min_especial_w             bigint;
    ie_classif_urgente_w          varchar(3);
    dt_limite_agora_w             timestamp;
    dt_limite_especial_w          timestamp;
    nr_seq_classif_w              bigint;
    dt_liberacao_farmacia_w       timestamp;
    ie_amostra_w                  varchar(1);
    nr_seq_derivado_w             bigint;
    ie_util_hemocomponente_w      varchar(15);
    ie_tipo_proced_w              varchar(15);
    qt_vol_hemocomp_w             bigint;
    qt_procedimento_w             double precision;
    ie_lib_individual_w           varchar(1);
    dt_suspensao_progr_w          timestamp;
    nr_seq_etapa_w                bigint;
    dt_prev_execucao_ww           timestamp;
    nr_horas_validade_w           integer;
    dt_validade_prescr_w          timestamp;
    nr_seq_horario_w              bigint;
    ie_estendido_w                varchar(1);
    ie_add_dia_w                  varchar(1) := 'S';
    dt_resultado_w                timestamp;
    nr_seq_proc_cpoe_w            prescr_procedimento.nr_seq_proc_cpoe%TYPE;
    ie_considera_data_prevista_w  varchar(1);
    ie_tipo_proced_ww             prescr_procedimento.ie_tipo_proced%TYPE;
    nr_seq_prot_glic_w            prescr_procedimento.nr_seq_prot_glic%TYPE;

--Parametros obter_setor_exame_lab
    cd_setor_atual_usuario_w      integer;
    cd_setor_atend_w              varchar(255);
    cd_setor_col_w                varchar(255);
    cd_setor_entrega_lab_w        varchar(255) := NULL;
    qt_dia_entrega_w              numeric(20);
    ie_emite_mapa_w               varchar(255);
    ds_hora_fixa_w                varchar(255);
    ie_data_resultado_w           varchar(255);
    qt_min_entrega_w              bigint;
    ie_atualizar_recoleta_w       varchar(255);
    ie_agora_w                    varchar(1);
    ie_dia_semana_final_w         bigint;
    ie_forma_atual_dt_result_w    exame_lab_regra_setor.ie_atul_data_result%TYPE;
    qt_min_atraso_w               bigint;
    cd_funcao_origem_w            prescr_medica.cd_funcao_origem%TYPE;
    nr_atendimento_w              prescr_medica.nr_atendimento%TYPE;
    cd_pessoa_fisica_w            prescr_medica.cd_pessoa_fisica%TYPE;
    sql_w                         varchar(200);
    c13 CURSOR FOR
    SELECT
        nr_sequencia,
        cd_procedimento,
        ie_origem_proced,
        nr_seq_proc_interno,
        nr_ocorrencia,
        coalesce(ie_urgencia, 'N'),
        coalesce(dt_prev_execucao, a.dt_inicio_prescr),
        substr(ds_horarios, 1, 2000),
        substr(padroniza_horario_prescr(b.ds_horarios, CASE WHEN to_char(b.dt_prev_execucao, 'hh24:mi')='00:00' THEN  to_char(b.dt_prev_execucao,        'dd/mm/yyyy hh24:mi:ss')  ELSE to_char(b.dt_prev_execucao, 'dd/mm/yyyy hh24:mi')                                                                                                                                         ||                                                                                                                                         ':00' END ),
               1,
               2000),
        coalesce(ie_se_necessario, 'N'),
        coalesce(ie_acm, 'N'),
        cd_material_exame,
        nr_seq_exame,
        b.ie_status_atend,
        b.ie_status_execucao,
        b.cd_setor_atendimento,
        b.cd_setor_coleta,
        b.cd_setor_entrega,
        b.cd_setor_exec_fim,
        b.cd_setor_exec_inic,
        b.nr_seq_lab,
        b.ie_suspenso,
        b.ds_observacao,
        b.ds_dado_clinico,
        b.ds_material_especial,
        b.ie_amostra,
        b.nr_seq_derivado,
        b.ie_util_hemocomponente,
        b.qt_vol_hemocomp,
        b.qt_procedimento,
        b.dt_suspensao_progr,
        obter_se_exibe_proced(b.nr_prescricao, b.nr_sequencia, b.ie_tipo_proced, 'BSST'),
        b.cd_intervalo,
        nr_seq_proc_cpoe,
        b.ie_tipo_proced,
        a.cd_funcao_origem,
        a.nr_atendimento,
        a.cd_pessoa_fisica,
        b.nr_seq_prot_glic
    FROM
        prescr_procedimento  b,
        prescr_medica        a 
    WHERE
            a.nr_prescricao = b.nr_prescricao
        AND a.nr_prescricao = nr_prescricao_p
        AND ( ( b.nr_sequencia = nr_seq_item_p )
              OR ( coalesce(nr_seq_item_p, 0) = 0 ) )
        AND coalesce(b.nr_seq_origem::text, '') = ''
        AND coalesce(b.ie_suspenso, 'N') <> 'S'
        AND ( ( ( ie_tipo_item_p = 'P' )
                AND ( coalesce(b.nr_seq_exame::text, '') = '' )
                AND ( coalesce(b.nr_seq_prot_glic::text, '') = '' ) )
              OR ( ie_tipo_item_p = 'E'  AND b.nr_seq_exame IS NOT NULL AND b.nr_seq_exame::text <> '')
              OR ( ie_tipo_item_p = 'G'  AND b.nr_seq_prot_glic IS NOT NULL AND b.nr_seq_prot_glic::text <> '')
              OR ( coalesce(ie_tipo_item_p::text, '') = '' ) )
        AND coalesce(a.dt_suspensao::text, '') = ''
        AND NOT EXISTS (
            SELECT
                1
            FROM
                prescr_proc_hor x
            WHERE
                    x.nr_prescricao = b.nr_prescricao
                AND x.nr_seq_procedimento = b.nr_sequencia
                AND (x.dt_lib_horario IS NOT NULL AND x.dt_lib_horario::text <> '')
        );

    c15 CURSOR FOR
    SELECT
        b.dt_horario,
        b.nr_sequencia,
        coalesce(c.dt_resultado, '')
    FROM
        prescr_proc_hor      b,
        prescr_medica        a,
        prescr_procedimento  c
    WHERE
            a.nr_prescricao = nr_prescricao_p
        AND a.nr_prescricao = b.nr_prescricao
        AND c.nr_prescricao = a.nr_prescricao
        AND c.nr_sequencia = b.nr_seq_procedimento
        AND b.nr_seq_procedimento = nr_seq_procedimento_w
        AND ( ( ie_gerar_proc_intervalo_w = 'S' )
              OR ( ( ie_gerar_proc_intervalo_w = 'D' )
                   AND ( verifica_se_proc_regra_interv(a.nr_prescricao, b.nr_seq_procedimento) = 'S' ) ) )
        AND ie_lib_individual_w = 'S'
        AND ie_liberacao_p = 'S'
        AND coalesce(c.ie_tipo_proced, 'X') NOT IN ( 'AP', 'APH', 'APC' )
    ORDER BY
        b.dt_horario ASC;


BEGIN
    DELETE FROM prescr_proc_hor
    WHERE
            nr_prescricao = nr_prescricao_p
        AND ( ( nr_seq_procedimento = nr_seq_item_p )
              OR ( coalesce(nr_seq_item_p, 0) = 0 ) )
        AND coalesce(dt_lib_horario::text, '') = '';

    qt_registro_w := 0;
/*select	count(*)
into	qt_registro_w
from	prescr_proc_hor
where	nr_prescricao = nr_prescricao_p
and	((nr_seq_procedimento = nr_seq_item_p) or
	 (nvl(nr_seq_item_p,0) = 0));*/
    ie_lib_individual_w := obter_param_usuario(924, 530, cd_perfil_p, nm_usuario_p, 0, ie_lib_individual_w);

    
    
    IF ( qt_registro_w = 0 ) THEN
    
    
    
        SELECT
            coalesce(dt_liberacao, dt_liberacao_medico),
            dt_primeiro_horario,
            cd_setor_atendimento,
            coalesce(cd_estabelecimento, 1),
            trunc(dt_prescricao, 'mi'),
            dt_inicio_prescr,
            dt_liberacao_farmacia,
            nr_horas_validade,
            dt_validade_prescr
        INTO STRICT
            dt_liberacao_w,
            dt_primeiro_horario_w,
            cd_setor_atendimento_w,
            cd_estabelecimento_w,
            dt_prescricao_w,
            dt_inicio_prescr_w,
            dt_liberacao_farmacia_w,
            nr_horas_validade_w,
            dt_validade_prescr_w
        FROM
            prescr_medica
        WHERE
            nr_prescricao = nr_prescricao_p;

        SELECT
            MAX(coalesce(ie_cons_dt_prev_regra, 'N'))
        INTO STRICT ie_considera_data_prevista_w
        FROM
            lab_parametro
        WHERE
            cd_estabelecimento = cd_estabelecimento_w;

        cd_setor_atual_usuario_w := obter_setor_usuario(nm_usuario_p);
        ie_gerar_proc_intervalo_w := obter_param_usuario(924, 192, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_gerar_proc_intervalo_w);
        IF ( coalesce(dt_primeiro_horario_w::text, '') = '' ) THEN
            dt_primeiro_horario_w := dt_prescricao_w;
        END IF;
        qt_dia_adic_w := 0;
        OPEN c13;
        LOOP
            FETCH c13 INTO
                nr_seq_procedimento_w,
                cd_procedimento_w,
                ie_origem_proced_w,
                nr_seq_proc_interno_w,
                nr_ocor_proc_w,
                ie_proc_urgente_w,
                dt_prev_execucao_w,
                ds_horarios_proc_w,
                ds_horarios_padrao_proc_w,
                ie_se_necessario_w,
                ie_acm_w,
                cd_material_exame_w,
                nr_seq_exame_w,
                ie_status_atend_w,
                ie_status_execucao_w,
                cd_setor_atendimento_proc_w,
                cd_setor_coleta_w,
                cd_setor_entrega_w,
                cd_setor_exec_fim_w,
                cd_setor_exec_inic_w,
                nr_seq_lab_w,
                ie_suspenso_w,
                ds_observacao_w,
                ds_dado_clinico_w,
                ds_material_especial_w,
                ie_amostra_w,
                nr_seq_derivado_w,
                ie_util_hemocomponente_w,
                qt_vol_hemocomp_w,
                qt_procedimento_w,
                dt_suspensao_progr_w,
                ie_tipo_proced_w,
                cd_intervalo_w,
                nr_seq_proc_cpoe_w,
                ie_tipo_proced_ww,
                cd_funcao_origem_w,
                nr_atendimento_w,
                cd_pessoa_fisica_w,
                nr_seq_prot_glic_w;

            EXIT WHEN NOT FOUND; /* apply on c13 */
            BEGIN
                qt_dia_adic_w := 0;
                IF (ds_horarios_padrao_proc_w IS NOT NULL AND ds_horarios_padrao_proc_w::text <> '') THEN
                    BEGIN
                        nr_seq_etapa_w := 0;
                        WHILE (ds_horarios_padrao_proc_w IS NOT NULL AND ds_horarios_padrao_proc_w::text <> '') LOOP
                            BEGIN
                                SELECT
                                    position(' ' in ds_horarios_padrao_proc_w)
                                INTO STRICT k
;
                --INICIO MD 
                                BEGIN
                                    sql_w := 'begin calc_hor_padr_sem_dt_lib_md (:1, :2, :3); end;';
                                    EXECUTE sql_w
                                        USING IN k, OUT ds_hora_proc_w, IN OUT ds_horarios_padrao_proc_w;
                                EXCEPTION
                                    WHEN OTHERS THEN
                                        ds_hora_proc_w := NULL;
                                        ds_horarios_padrao_proc_w := NULL;
                                END;

                --FIM MD
                /* Inicio MD1 */

                                BEGIN
                                    sql_w := 'begin calc_dia_hor_sem_dt_lib_md (:1, :2, :3); end;';
                                    EXECUTE sql_w
                                        USING IN ie_proc_urgente_w, IN OUT ds_hora_proc_w, IN OUT qt_dia_adic_w;
                                EXCEPTION
                                    WHEN OTHERS THEN
                                        ds_hora_proc_w := NULL;
                                        qt_dia_adic_w := NULL;
                                END;

                /* Fim MD1 */

		        /* Inicio MD2 */

                                BEGIN
                                    sql_w := 'begin calc_dt_prescr_sem_dt_lib_md (:1, :2, :3, :4); end;';
                                    EXECUTE sql_w
                                        USING IN ie_proc_urgente_w, IN dt_liberacao_w, IN dt_prescricao_w, IN OUT dt_prescricao_ww;
                                EXCEPTION
                                    WHEN OTHERS THEN
                                        dt_prescricao_ww := NULL;
                                END;

			    /* Fim MD2 */

                                SELECT
                                    coalesce(MAX('S'), 'N')
                                INTO STRICT ie_estendido_w
                                FROM
                                    prescr_procedimento  a,
                                    prescr_medica        b
                                WHERE
                                        a.nr_prescricao = b.nr_prescricao
                                    AND a.nr_prescricao = nr_prescricao_p
                                    AND a.nr_sequencia = nr_seq_procedimento_w
                                    AND coalesce(b.cd_funcao_origem, 924) = 950
                                    AND (a.nr_seq_anterior IS NOT NULL AND a.nr_seq_anterior::text <> '')
                                    AND (a.nr_prescricao_original IS NOT NULL AND a.nr_prescricao_original::text <> '');
				
				/* Inicio MD3 */

                                BEGIN
                                    sql_w := 'CALL calc_dt_hor_sem_dt_lib_md(:1, :2, :3, :4, :6, :6) INTO :dt_horario_proc_w';
                                    EXECUTE sql_w
                                        USING IN dt_prev_execucao_w, IN dt_prescricao_ww, IN ie_estendido_w, IN ds_hora_proc_w, IN
                                        qt_dia_adic_w, IN ie_proc_urgente_w, OUT dt_horario_proc_w;

                                EXCEPTION
                                    WHEN OTHERS THEN
                                        dt_horario_proc_w := NULL;
                                END;

                /* Fim MD3 */

                                IF ( dt_suspensao_progr_w > dt_horario_proc_w ) OR ( coalesce(dt_suspensao_progr_w::text, '') = '' ) THEN
                                    SELECT
                                        nextval('prescr_proc_hor_seq')
                                    INTO STRICT nr_sequencia_w
;
                    /* Inicio MD4 */

                                    BEGIN
                                        sql_w := 'CALL calc_hor_esp_sem_dt_lib_md(:1, :2, :3, :4) INTO :ie_horario_especial_w';
                                        EXECUTE sql_w
                                            USING IN ie_se_necessario_w, IN ie_acm_w, IN dt_prev_execucao_ww, IN 1, OUT ie_horario_especial_w;

                                   EXCEPTION
                                        WHEN OTHERS THEN
                                            ie_horario_especial_w := NULL;
                                    END;

                    /* Fim MD4 */

					
                    --INICIO MD
                                    BEGIN
                                        sql_w := 'begin calc_nr_seq_etp_sem_dt_lib_md (:1, :2, :3); end;';
                                        EXECUTE sql_w
                                            USING IN nr_seq_derivado_w, IN ie_tipo_proced_ww, IN OUT nr_seq_etapa_w;
                                    EXCEPTION
                                        WHEN OTHERS THEN
                                            nr_seq_etapa_w := NULL;
                                    END;

					--FIM MD
                                    INSERT INTO prescr_proc_hor(
                                        nr_sequencia,
                                        dt_atualizacao,
                                        nm_usuario,
                                        dt_atualizacao_nrec,
                                        nm_usuario_nrec,
                                        nr_prescricao,
                                        nr_seq_procedimento,
                                        cd_procedimento,
                                        ie_origem_proced,
                                        nr_seq_proc_interno,
                                        ds_horario,
                                        dt_horario,
                                        nr_ocorrencia,
                                        ie_urgente,
                                        ie_horario_especial,
                                        cd_material_exame,
                                        ie_aprazado,
                                        nr_etapa
                                    ) VALUES (
                                        nr_sequencia_w,
                                        clock_timestamp(),
                                        nm_usuario_p,
                                        clock_timestamp(),
                                        nm_usuario_p,
                                        nr_prescricao_p,
                                        nr_seq_procedimento_w,
                                        cd_procedimento_w,
                                        ie_origem_proced_w,
                                        nr_seq_proc_interno_w,
                                        ds_hora_proc_w,
                                        dt_horario_proc_w,
                                        nr_ocor_proc_w,
                                        ie_proc_urgente_w,
                                        coalesce(ie_horario_especial_w, 'N'),
                                        cd_material_exame_w,
                                        'N',
                                        CASE WHEN nr_seq_etapa_w=0 THEN  NULL  ELSE nr_seq_etapa_w END 
                                    );

                                END IF;

                            END;
                        END LOOP;

                    END;

                ELSE	
			--INICIO MD
                    BEGIN
                        sql_w := 'begin obter_hor_proc_sem_dt_lib_md (:1, :2, :3, :4, :5); end;';
                        EXECUTE sql_w
                            USING IN hr_prim_horario_w, IN dt_primeiro_horario_w, IN dt_prev_execucao_w, OUT ds_hora_proc_w, OUT dt_horario_proc_w;

                    EXCEPTION
                        WHEN OTHERS THEN
                            nr_seq_etapa_w := NULL;
                    END;

                --FIM MD
                    IF ( dt_suspensao_progr_w > dt_horario_proc_w ) OR ( coalesce(dt_suspensao_progr_w::text, '') = '' ) THEN
                        SELECT
                            nextval('prescr_proc_hor_seq')
                        INTO STRICT nr_sequencia_w
;

                        SELECT
                            MAX(dt_prev_execucao)
                        INTO STRICT dt_prev_execucao_ww
                        FROM
                            prescr_procedimento
                        WHERE
                                nr_prescricao = nr_prescricao_p
                            AND nr_sequencia = nr_seq_procedimento_w;

                        ie_horario_especial_w := 'N';

                 --INICIO MD                       
                        BEGIN
                            sql_w := 'CALL calc_hor_esp_sem_dt_lib_md(:1, :2, :3, :4) INTO :ie_horario_especial_w';
                            EXECUTE sql_w
                                USING IN ie_se_necessario_w, IN ie_acm_w, IN dt_prev_execucao_ww, IN 2, OUT ie_horario_especial_w;

                        EXCEPTION
                            WHEN OTHERS THEN
                                ie_horario_especial_w := NULL;
                        END;
                --FIM MD
                        INSERT INTO prescr_proc_hor(
                            nr_sequencia,
                            dt_atualizacao,
                            nm_usuario,
                            dt_atualizacao_nrec,
                            nm_usuario_nrec,
                            nr_prescricao,
                            nr_seq_procedimento,
                            cd_procedimento,
                            ie_origem_proced,
                            nr_seq_proc_interno,
                            ds_horario,
                            dt_horario,
                            nr_ocorrencia,
                            ie_urgente,
                            ie_horario_especial,
                            cd_material_exame,
                            ie_aprazado,
                            nr_etapa
                        ) VALUES (
                            nr_sequencia_w,
                            clock_timestamp(),
                            nm_usuario_p,
                            clock_timestamp(),
                            nm_usuario_p,
                            nr_prescricao_p,
                            nr_seq_procedimento_w,
                            cd_procedimento_w,
                            ie_origem_proced_w,
                            nr_seq_proc_interno_w,
                            ds_hora_proc_w,
                            dt_horario_proc_w,
                            nr_ocor_proc_w,
                            ie_proc_urgente_w,
                            ie_horario_especial_w,
                            cd_material_exame_w,
                            'N',
                            CASE WHEN ie_horario_especial_w='S' THEN  NULL  ELSE 1 END
                        );

                        if (nr_horas_validade_w > 24 and cd_funcao_origem_w <> 2314) then

                            SELECT
                                nextval('prescr_proc_hor_seq')
                            INTO STRICT nr_seq_horario_w
;

                            IF ( dt_horario_proc_w BETWEEN( dt_validade_prescr_w - 1 ) AND dt_validade_prescr_w ) THEN
                                INSERT INTO prescr_proc_hor(
                                    nr_sequencia,
                                    dt_atualizacao,
                                    nm_usuario,
                                    dt_atualizacao_nrec,
                                    nm_usuario_nrec,
                                    nr_prescricao,
                                    nr_seq_procedimento,
                                    cd_procedimento,
                                    ie_origem_proced,
                                    nr_seq_proc_interno,
                                    ds_horario,
                                    dt_horario,
                                    nr_ocorrencia,
                                    ie_urgente,
                                    ie_horario_especial,
                                    cd_material_exame,
                                    ie_aprazado
                                ) VALUES (
                                    nr_seq_horario_w,
                                    clock_timestamp(),
                                    nm_usuario_p,
                                    clock_timestamp(),
                                    nm_usuario_p,
                                    nr_prescricao_p,
                                    nr_seq_procedimento_w,
                                    cd_procedimento_w,
                                    ie_origem_proced_w,
                                    nr_seq_proc_interno_w,
                                    substr(to_char(dt_inicio_prescr_w, 'dd/mm/yyyy hh24:mi:ss'), 12, 5),
                                    dt_inicio_prescr_w,
                                    nr_ocor_proc_w,
                                    ie_proc_urgente_w,
                                    'S',
                                    cd_material_exame_w,
                                    'N'
                                );

                            ELSE
                                INSERT INTO prescr_proc_hor(
                                    nr_sequencia,
                                    dt_atualizacao,
                                    nm_usuario,
                                    dt_atualizacao_nrec,
                                    nm_usuario_nrec,
                                    nr_prescricao,
                                    nr_seq_procedimento,
                                    cd_procedimento,
                                    ie_origem_proced,
                                    nr_seq_proc_interno,
                                    ds_horario,
                                    dt_horario,
                                    nr_ocorrencia,
                                    ie_urgente,
                                    ie_horario_especial,
                                    cd_material_exame,
                                    ie_aprazado
                                ) VALUES (
                                    nr_seq_horario_w,
                                    clock_timestamp(),
                                    nm_usuario_p,
                                    clock_timestamp(),
                                    nm_usuario_p,
                                    nr_prescricao_p,
                                    nr_seq_procedimento_w,
                                    cd_procedimento_w,
                                    ie_origem_proced_w,
                                    nr_seq_proc_interno_w,
                                    substr(to_char(dt_validade_prescr_w, 'dd/mm/yyyy hh24:mi:ss'), 12, 5),
                                    dt_validade_prescr_w,
                                    nr_ocor_proc_w,
                                    ie_proc_urgente_w,
                                    'S',
                                    cd_material_exame_w,
                                    'N'
                                );

                            END IF;

                        END IF;

                    END IF;

                END IF;

            END;

            ie_proc_atual_w := 'S';
            OPEN c15;
            LOOP
                FETCH c15 INTO
                    dt_horario_proc_prev_w,
                    nr_seq_horario_w,
                    dt_resultado_w;
                EXIT WHEN NOT FOUND; /* apply on c15 */
                IF ( ie_proc_atual_w = 'N' ) THEN
                    SELECT
                        coalesce(MAX(nr_sequencia), 0) + 1
                    INTO STRICT nr_seq_procedimento_novo_w
                    FROM
                        prescr_procedimento
                    WHERE
                        nr_prescricao = nr_prescricao_p;

                    dt_horario_proc_prev_w := atualiza_dt_realizacao_exame(nr_seq_exame_w, nr_prescricao_p, dt_horario_proc_prev_w, dt_horario_proc_prev_w);
                    SELECT * FROM obter_setor_exame_lab(nr_prescricao_p, nr_seq_exame_w, cd_setor_atual_usuario_w, cd_material_exame_w, NULL, 'S', cd_setor_atend_w, cd_setor_col_w, cd_setor_entrega_lab_w, qt_dia_entrega_w, ie_emite_mapa_w, ds_hora_fixa_w, ie_data_resultado_w, qt_min_entrega_w, ie_atualizar_recoleta_w, coalesce(ie_agora_w, 'N'), ie_dia_semana_final_w, ie_forma_atual_dt_result_w, qt_min_atraso_w, dt_horario_proc_prev_w) INTO STRICT cd_setor_atend_w, cd_setor_col_w, cd_setor_entrega_lab_w, qt_dia_entrega_w, ie_emite_mapa_w, ds_hora_fixa_w, ie_data_resultado_w, qt_min_entrega_w, ie_atualizar_recoleta_w, ie_dia_semana_final_w, ie_forma_atual_dt_result_w, qt_min_atraso_w;

                    SELECT
                        CASE WHEN ie_considera_data_prevista_w='S' THEN  coalesce(dt_horario_proc_prev_w, coalesce(dt_entrada_unidade, dt_prescricao))  ELSE coalesce(dt_entrada_unidade, dt_prescricao) END
                    INTO STRICT dt_resultado_w
                    FROM
                        prescr_medica
                    WHERE
                        nr_prescricao = nr_prescricao_p;					

                /* Inicio MD7 */

                  BEGIN
                        sql_w := 'begin calc_dt_resul_sem_dt_lib_md (:1, :2, :3, :4); end;';
                        EXECUTE sql_w
                            USING IN ds_hora_fixa_w, IN qt_dia_entrega_w, IN qt_min_entrega_w, IN OUT dt_resultado_w;

                   EXCEPTION
                        WHEN OTHERS THEN
                            dt_resultado_w := NULL;
                    END;
                /* Fim MD7 */

                    INSERT INTO prescr_procedimento(
                        nr_prescricao,
                        nr_sequencia,
                        nr_seq_origem,
                        dt_prev_execucao,
                        qt_procedimento,
                        nm_usuario,
                        dt_atualizacao,
                        cd_procedimento,
                        ie_origem_proced,
                        nr_seq_proc_interno,
                        ie_urgencia,
                        nr_seq_exame,
                        ie_status_atend,
                        ie_status_execucao,
                        cd_setor_atendimento,
                        cd_setor_coleta,
                        cd_setor_entrega,
                        cd_setor_exec_fim,
                        cd_setor_exec_inic,
					--nr_seq_lab,
                        ie_origem_inf,
                        cd_motivo_baixa,
                        ie_suspenso,
                        ds_observacao,
                        ds_dado_clinico,
                        ds_material_especial,
                        ie_amostra,
                        cd_material_exame,
                        nr_seq_derivado,
                        ie_util_hemocomponente,
                        qt_vol_hemocomp,
                        cd_intervalo,
                        dt_resultado,
                        nr_seq_proc_cpoe,
                        nr_seq_prot_glic
                    ) VALUES (
                        nr_prescricao_p,
                        nr_seq_procedimento_novo_w,
                        nr_seq_procedimento_w,
                        dt_horario_proc_prev_w,
                        qt_procedimento_w,
                        nm_usuario_p,
                        clock_timestamp(),
                        cd_procedimento_w,
                        ie_origem_proced_w,
                        nr_seq_proc_interno_w,
                        ie_proc_urgente_w,
                        nr_seq_exame_w,
                        ie_status_atend_w,
                        ie_status_execucao_w,
                        cd_setor_atendimento_proc_w,
                        cd_setor_coleta_w,
                        cd_setor_entrega_w,
                        cd_setor_exec_fim_w,
                        cd_setor_exec_inic_w,
					--nr_seq_lab_w,
                        1,
                        0,
                        ie_suspenso_w,
                        ds_observacao_w,
                        ds_dado_clinico_w,
                        ds_material_especial_w,
                        ie_amostra_w,
                        cd_material_exame_w,
                        nr_seq_derivado_w,
                        ie_util_hemocomponente_w,
                        qt_vol_hemocomp_w,
                        cd_intervalo_w,
                        dt_resultado_w,
                        nr_seq_proc_cpoe_w,
                        nr_seq_prot_glic_w
                    );

                    UPDATE prescr_proc_hor
                    SET
                        nr_seq_proc_origem = nr_seq_procedimento_novo_w
                    WHERE
                        nr_sequencia = nr_seq_horario_w;

                    BEGIN
                        IF (
                            ( cd_funcao_origem_w = 2314 )
                            AND (nr_seq_proc_cpoe_w IS NOT NULL AND nr_seq_proc_cpoe_w::text <> '')
                            AND (nr_seq_prot_glic_w IS NOT NULL AND nr_seq_prot_glic_w::text <> '')
                        ) THEN
                            CALL cpoe_gerar_proc_glic_reg(nr_prescricao_p, nr_atendimento_w, nr_seq_proc_cpoe_w, nr_seq_prot_glic_w,
                                                    nr_seq_procedimento_novo_w,
                                                    nm_usuario_p,
                                                    cd_pessoa_fisica_w);
                        END IF;
                    EXCEPTION
                        WHEN OTHERS THEN
                            CALL gravar_log_cpoe(substr('GERAR_PRESCR_PROC_SEM_DT_LIB EXCEPTION CPOE_GERAR_PROC_GLIC_REG: '
                                                   || substr(to_char(sqlerrm), 1, 2000)
                                                   || ' -nr_seq_proc_cpoe_w:'
                                                   || nr_seq_proc_cpoe_w
                                                   || ' -nr_prescricao_p :'
                                                   || nr_prescricao_p
                                                   || ' -nr_sequencia_w:'
                                                   || nr_seq_procedimento_novo_w,
                                                  1,
                                                  2000),
                                           nr_atendimento_w,
                                           'P',
                                           nr_seq_proc_cpoe_w);
                    END;

                END IF;

                ie_proc_atual_w := 'N';
            END LOOP;

            CLOSE c15;
        END LOOP;

        CLOSE c13;
    END IF;

    IF ( coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S' ) THEN
        COMMIT;
    END IF;

    IF ( ie_lib_individual_w = 'S' )
        AND ( ie_liberacao_p = 'S' )
    THEN
        UPDATE prescr_proc_hor
        SET
            dt_lib_horario = clock_timestamp()
        WHERE
                nr_prescricao = nr_prescricao_p
            AND coalesce(dt_lib_horario::text, '') = ''
            AND ( ( nr_seq_procedimento = nr_seq_item_p )
                  OR ( coalesce(nr_seq_item_p, 0) = 0 ) );

        CALL atualizar_seq_hor_glicemia(nr_prescricao_p);
    END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_prescr_proc_sem_dt_lib ( nr_prescricao_p bigint, nr_seq_item_p bigint, cd_perfil_p bigint, ie_liberacao_p text, nm_usuario_p text, ie_tipo_item_p text DEFAULT NULL) FROM PUBLIC;
