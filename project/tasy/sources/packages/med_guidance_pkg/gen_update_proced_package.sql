-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE med_guidance_pkg.gen_update_proced ( nr_seq_edition_p JPN_MEDICAL_GUIDANCE.NR_SEQ_EDITION%type, nm_usuario_p JPN_MEDICAL_GUIDANCE.NM_USUARIO%type ) AS $body$
DECLARE


    cd_area_proced_w                AREA_PROCEDIMENTO.CD_AREA_PROCEDIMENTO%type;
    cd_especialidade_w              ESPECIALIDADE_PROC.CD_ESPECIALIDADE%type;
    cd_grupo_proc_actual_w          GRUPO_PROC.CD_GRUPO_PROC%type;
    cd_procedimento_w               PROCEDIMENTO.CD_PROCEDIMENTO%type;
    nr_seq_proc_interno_w           PROC_INTERNO.NR_SEQUENCIA%type;
    ds_erro_w                       varchar(255);
    qt_registros_w                  integer;

    ie_origem_proced_s              VALOR_DOMINIO.VL_DOMINIO%type := 24;

    ie_situacao_s                   PROCEDIMENTO.IE_SITUACAO%type := 'A';
    ie_classificacao_s              PROCEDIMENTO.IE_CLASSIFICACAO%type := 1;
    ie_exige_autor_sus_s            PROCEDIMENTO.IE_EXIGE_AUTOR_SUS%type := 'N';
    qt_exec_barra_s                 PROCEDIMENTO.QT_EXEC_BARRA%type := 1;
    ie_ativ_prof_bpa_s              PROCEDIMENTO.IE_ATIV_PROF_BPA%type := 'N';
    ie_alta_complexidade_s          PROCEDIMENTO.IE_ALTA_COMPLEXIDADE%type := 'N';
    ie_ignora_origem_s              PROCEDIMENTO.IE_IGNORA_ORIGEM%type := 'N';
    ie_classif_custo_s              PROCEDIMENTO.IE_CLASSIF_CUSTO%type := 'B';
    ie_localizador_s                PROCEDIMENTO.IE_LOCALIZADOR%type := 'S';

    ie_orientacao_s                 PROC_INTERNO.IE_ORIENTACAO%type := 'I';
    ie_tipo_util_s                  PROC_INTERNO.IE_TIPO_UTIL%type := 'O';
    ie_exige_lado_s                 PROC_INTERNO.IE_EXIGE_LADO%type := 'O';
    ie_tipo_s                       PROC_INTERNO.IE_TIPO%type := 'MDF';

    dt_sysdate_s                    timestamp := clock_timestamp();
    ds_proced_s                     varchar(255) := 'Medical guidance fee';
    cd_original_s                   integer := 1;
    ds_procedimento_w		    varchar(255);

    C_MEDICAL_GUIDANCE CURSOR FOR
    SELECT  CD_MEDICAL_PRACTICE_CODE,
            DS_ABBREVIATED_KANA,
            DS_BASIC_KANJI_NAME,
            DT_UPDATE,
            DT_END_DATE
    FROM    JPN_MEDICAL_GUIDANCE
    WHERE   NR_SEQ_EDITION = nr_seq_edition_p;


BEGIN

        SELECT  MAX(CD_AREA_PROCEDIMENTO)
        INTO STRICT    cd_area_proced_w
        FROM    AREA_PROCEDIMENTO
        WHERE   IE_ORIGEM_PROCED = ie_origem_proced_s
        AND     CD_ORIGINAL = cd_original_s;

        IF coalesce(cd_area_proced_w::text, '') = '' THEN
            SELECT  MAX(CD_AREA_PROCEDIMENTO) + 1
            INTO STRICT    cd_area_proced_w
            FROM    AREA_PROCEDIMENTO;

            CALL MED_GUIDANCE_PKG.INSERT_AREA_PROCEDIMENTO(
                cd_area_proced_p            => cd_area_proced_w,
                ds_area_procedimento_p      => ds_proced_s,
                ie_origem_proced_p          => ie_origem_proced_s,
                cd_original_p               => cd_original_s,
                cd_sistema_ant_p            => null,
                nm_usuario_p                => nm_usuario_p,
                dt_sysdate_p                => dt_sysdate_s
            );
        END IF;

        SELECT  MAX(CD_ESPECIALIDADE)
        INTO STRICT    cd_especialidade_w
        FROM    ESPECIALIDADE_PROC
        WHERE   IE_ORIGEM_PROCED = ie_origem_proced_s
        AND     CD_ORIGINAL = cd_original_s;

        IF  coalesce(cd_especialidade_w::text, '') = '' THEN
            SELECT  MAX(CD_ESPECIALIDADE) + 1
            INTO STRICT    cd_especialidade_w
            FROM    ESPECIALIDADE_PROC;

            CALL MED_GUIDANCE_PKG.INSERT_ESPECIALIDADE_PROC(
                cd_especialidade_p          => cd_especialidade_w,
                ds_especialidade_p          => ds_proced_s,
                ie_origem_proced_p          => ie_origem_proced_s,
                cd_area_proced_p            => cd_area_proced_w,
                cd_original_p               => cd_original_s,
                cd_especialidade_medica_p   => null,
                cd_especialidade_loc_p      => null,
                cd_sistema_ant_p            => null,
                nm_usuario_p                => nm_usuario_p,
                dt_sysdate_p                => dt_sysdate_s
            );
        END IF;

        SELECT  MAX(CD_GRUPO_PROC)
        INTO STRICT    cd_grupo_proc_actual_w
        FROM    GRUPO_PROC
        WHERE   CD_ESPECIALIDADE = cd_especialidade_w
        AND     IE_ORIGEM_PROCED = ie_origem_proced_s
        AND     CD_ORIGINAL = cd_original_s;

        IF  coalesce(cd_grupo_proc_actual_w::text, '') = '' THEN
            SELECT  MAX(CD_GRUPO_PROC) + 1
            INTO STRICT    cd_grupo_proc_actual_w
            FROM    GRUPO_PROC;

            CALL MED_GUIDANCE_PKG.INSERT_GRUPO_PROC(
                cd_grupo_proc_p         => cd_grupo_proc_actual_w,
                ds_grupo_proc_p         => ds_proced_s,
                ie_origem_proced_p      => ie_origem_proced_s,
                cd_especialidade_p      => cd_especialidade_w,
                cd_original_p           => cd_original_s,
                ie_situacao_p           => ie_situacao_s,
                nm_usuario_p            => nm_usuario_p,
                dt_sysdate_p            => dt_sysdate_s
            );
        END IF;

        FOR med_guidance_row IN C_MEDICAL_GUIDANCE LOOP
            SELECT  MAX(CD_PROCEDIMENTO)
            INTO STRICT    cd_procedimento_w
            FROM    PROCEDIMENTO
            WHERE   CD_PROCEDIMENTO_LOC = med_guidance_row.CD_MEDICAL_PRACTICE_CODE
            AND     IE_ORIGEM_PROCED = ie_origem_proced_s;

            IF  coalesce(cd_procedimento_w::text, '') = '' THEN
                SELECT  nextval('procedimento_seq')
                INTO STRICT    cd_procedimento_w
;

                CALL MED_GUIDANCE_PKG.INSERT_PROCEDIMENTO(
                    cd_procedimento_p       => cd_procedimento_w,
                    ds_procedimento_p       => MED_GUIDANCE_PKG.CUSTOM_SUBSTR(med_guidance_row.DS_BASIC_KANJI_NAME, 'DS_PROCEDIMENTO', 'PROCEDIMENTO'),
                    ie_situacao_p           => ie_situacao_s,
                    cd_grupo_proc_p         => cd_grupo_proc_actual_w,
                    ie_classificacao_p      => ie_classificacao_s,
                    ie_origem_proced_p      => ie_origem_proced_s,
                    ie_exige_autor_sus_p    => ie_exige_autor_sus_s,
                    qt_exec_barra_p         => qt_exec_barra_s,
                    ie_ativ_prof_bpa_p      => ie_ativ_prof_bpa_s,
                    ie_alta_complexidade_p  => ie_alta_complexidade_s,
                    ie_ignora_origem_p      => ie_ignora_origem_s,
                    ie_classif_custo_p      => ie_classif_custo_s,
                    ie_localizador_p        => ie_localizador_s,
                    cd_procedimento_loc_p   => med_guidance_row.CD_MEDICAL_PRACTICE_CODE,
                    nm_usuario_p            => nm_usuario_p,
                    dt_sysdate_p            => dt_sysdate_s
                );

                SELECT  COUNT(*)
                INTO STRICT    qt_registros_w
                FROM    PROCEDIMENTO_VERSAO
                WHERE   CD_PROCEDIMENTO = cd_procedimento_w
                AND     IE_ORIGEM_PROCED = ie_origem_proced_s
                AND     DT_VIGENCIA_INICIAL = med_guidance_row.DT_UPDATE
                AND     coalesce(DT_VIGENCIA_FINAL, clock_timestamp()) = coalesce(med_guidance_row.DT_END_DATE, clock_timestamp());

                IF qt_registros_w = 0 THEN
                    CALL MED_GUIDANCE_PKG.INSERT_PROCEDIMENTO_VERSAO(
                        cd_procedimento_p       => cd_procedimento_w,
                        cd_proc_previous_p      => null,
                        cd_versao_p             => null,
                        dt_versao_p             => null,
                        dt_vigencia_final_p     => med_guidance_row.DT_END_DATE,
                        dt_vigencia_inicial_p   => med_guidance_row.DT_UPDATE,
                        ie_origem_proced_p      => ie_origem_proced_s,
                        nm_usuario_p            => nm_usuario_p,
                        dt_sysdate_p            => dt_sysdate_s
                    );
                END IF;

                SELECT  COUNT(*)
                INTO STRICT    qt_registros_w
                FROM    PROC_INTERNO
                WHERE   CD_PROCEDIMENTO = cd_procedimento_w;

                CALL MED_GUIDANCE_PKG.UPSERT_PROC_INTERNO(
                    ds_proc_exame_p         => MED_GUIDANCE_PKG.CUSTOM_SUBSTR(med_guidance_row.DS_BASIC_KANJI_NAME, 'DS_PROC_EXAME', 'PROC_INTERNO'),
                    ds_exame_curto_p        => MED_GUIDANCE_PKG.CUSTOM_SUBSTR(med_guidance_row.DS_ABBREVIATED_KANA, 'DS_EXAME_CURTO', 'PROC_INTERNO'),
                    ds_laudo_p              => MED_GUIDANCE_PKG.CUSTOM_SUBSTR(med_guidance_row.DS_BASIC_KANJI_NAME, 'DS_LAUDO', 'PROC_INTERNO'),
                    cd_procedimento_p       => cd_procedimento_w,
                    cd_procedimento_loc_p   => med_guidance_row.CD_MEDICAL_PRACTICE_CODE,
                    ie_orientacao_p         => ie_orientacao_s,
                    ie_tipo_util_p          => ie_tipo_util_s,
                    ie_exige_lado_p         => ie_exige_lado_s,
                    ie_tipo_p               => ie_tipo_s,
                    ie_situacao_p           => ie_situacao_s,
                    ie_origem_proced_p      => ie_origem_proced_s,
                    nm_usuario_p            => nm_usuario_p,
                    nr_seq_edition_p        => nr_seq_edition_p,
                    qt_records_p            => qt_registros_w,
                    dt_sysdate_p            => dt_sysdate_s,
		    dt_end_date_p	    => med_guidance_row.DT_END_DATE
                );
	    ELSE
		BEGIN
		ds_procedimento_w := MED_GUIDANCE_PKG.CUSTOM_SUBSTR(med_guidance_row.DS_BASIC_KANJI_NAME, 'DS_PROCEDIMENTO', 'PROCEDIMENTO');
		
		UPDATE	PROCEDIMENTO
		SET	DS_PROCEDIMENTO = ds_procedimento_w
		WHERE	CD_PROCEDIMENTO = cd_procedimento_w
		and	IE_ORIGEM_PROCED = ie_origem_proced_s;
		EXCEPTION WHEN OTHERS THEN
			ROLLBACK;
			CALL WHEB_MENSAGEM_PCK.EXIBIR_MENSAGEM_ABORT(799570, 'DS_ERRO_W=UPDATE_PROCEDIMENTO'|| chr(10) ||SQLERRM);
		END;
		
		SELECT  COUNT(*)
                INTO STRICT    qt_registros_w
                FROM    PROC_INTERNO
                WHERE   CD_PROCEDIMENTO = cd_procedimento_w
		AND     IE_ORIGEM_PROCED = ie_origem_proced_s;

		IF (qt_registros_w > 0) THEN
			CALL MED_GUIDANCE_PKG.UPSERT_PROC_INTERNO(
			    ds_proc_exame_p         => MED_GUIDANCE_PKG.CUSTOM_SUBSTR(med_guidance_row.DS_BASIC_KANJI_NAME, 'DS_PROC_EXAME', 'PROC_INTERNO'),
			    ds_exame_curto_p        => MED_GUIDANCE_PKG.CUSTOM_SUBSTR(med_guidance_row.DS_ABBREVIATED_KANA, 'DS_EXAME_CURTO', 'PROC_INTERNO'),
			    ds_laudo_p              => MED_GUIDANCE_PKG.CUSTOM_SUBSTR(med_guidance_row.DS_BASIC_KANJI_NAME, 'DS_LAUDO', 'PROC_INTERNO'),
			    cd_procedimento_p       => cd_procedimento_w,
			    cd_procedimento_loc_p   => med_guidance_row.CD_MEDICAL_PRACTICE_CODE,
			    ie_orientacao_p         => ie_orientacao_s,
			    ie_tipo_util_p          => ie_tipo_util_s,
			    ie_exige_lado_p         => ie_exige_lado_s,
			    ie_tipo_p               => ie_tipo_s,
			    ie_situacao_p           => ie_situacao_s,
			    ie_origem_proced_p      => ie_origem_proced_s,
			    nm_usuario_p            => nm_usuario_p,
			    nr_seq_edition_p        => nr_seq_edition_p,
			    qt_records_p            => qt_registros_w,
			    dt_sysdate_p            => dt_sysdate_s,
			    dt_end_date_p	    => med_guidance_row.DT_END_DATE
			);		
		END IF;
            END IF;
        END LOOP;

        UPDATE  JPN_MED_GUIDANCE_EDITION
        SET     DT_ATUALIZACAO = dt_sysdate_s,
                DT_PROCEDURE_UPDATE = dt_sysdate_s,
                NM_USUARIO = nm_usuario_p
        WHERE   NR_SEQUENCIA = nr_seq_edition_p;

        COMMIT;
    END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_guidance_pkg.gen_update_proced ( nr_seq_edition_p JPN_MEDICAL_GUIDANCE.NR_SEQ_EDITION%type, nm_usuario_p JPN_MEDICAL_GUIDANCE.NM_USUARIO%type ) FROM PUBLIC;
