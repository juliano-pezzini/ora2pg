-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS wocupacao_saida_temp_before ON wocupacao_saida_temporaria CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_wocupacao_saida_temp_before() RETURNS trigger AS $BODY$
DECLARE
    dt_inicio_w          cpoe_dieta.dt_inicio%TYPE;
    hr_prim_horario_w    cpoe_dieta.hr_prim_horario%TYPE;
    nr_sequencia_w       cpoe_dieta.nr_sequencia%TYPE;
    cd_pessoa_fisica_w   atendimento_paciente.cd_pessoa_fisica%TYPE;
    nm_usuario_w         varchar(15);
BEGIN
    IF ( wheb_usuario_pck.get_ie_executar_trigger = 'S' ) THEN
        IF ( TG_OP = 'INSERT' ) THEN
		if (NEW.dt_start_date > NEW.dt_end_date ) then
                CALL wheb_mensagem_pck.exibir_mensagem_abort(1127560, 'STARTDATE='|| obter_desc_expressao(286980) || ';ENDDATE=' || obter_desc_expressao(1067080));
        end if;
            NEW.nm_usuario := obter_usuario_ativo;
            NEW.dt_atualizacao := LOCALTIMESTAMP;
            IF NEW.nr_atendimento IS NOT NULL THEN
               UPDATE atend_paciente_unidade
                SET
                    dt_saida_temporaria = NEW.DT_START_DATE,
                    dt_retorno_saida_temporaria  = NULL,
                    nm_usuario = coalesce(obter_usuario_ativo, nm_usuario),
                    dt_atualizacao = LOCALTIMESTAMP
                WHERE
                    nr_atendimento = NEW.nr_atendimento;

            END IF;

            IF ( NEW.ie_sem_jejum = 'N' AND NEW.dt_inicio_jejum IS NOT NULL ) THEN
                dt_inicio_w := trunc(NEW.dt_inicio_jejum, 'hh24') + 1 / 24;
                hr_prim_horario_w := substr(cpoe_obter_primeiro_horario(NEW.nr_atendimento, NULL, NULL, NULL, NULL,
                            NULL, NULL), 1, 5);

                IF ( hr_prim_horario_w IS NOT NULL ) THEN
                    dt_inicio_w := to_date(to_char(dt_inicio_w, 'dd/mm/yyyy')
                                           || hr_prim_horario_w, 'dd/mm/yyyy hh24:mi');
                END IF;

                cd_pessoa_fisica_w := obter_cd_pes_fis_atend(NEW.nr_atendimento);
                SELECT
                    nextval('cpoe_dieta_seq')
                INTO STRICT nr_sequencia_w
;

                NEW.nr_sequencia_dieta := nr_sequencia_w;
                INSERT INTO cpoe_dieta(
                    nr_sequencia,
                    nr_atendimento,
                    ie_tipo_dieta,
                    nr_seq_tipo,
                    ie_se_necessario,
                    ds_observacao,
                    dt_inicio,
                    dt_fim,
                    ie_duracao,
                    ie_administracao,
                    dt_prim_horario,
                    nm_usuario,
                    dt_atualizacao,
                    cd_pessoa_fisica
                ) VALUES (
                    nr_sequencia_w,
                    NEW.nr_atendimento,
                    'J',
                    coalesce(NEW.nr_categoria_refeicao_inicio, NEW.nr_categoria_refeicao_fim),
                    'N',
                    NULL,
                    NEW.dt_inicio_jejum,
                    NEW.dt_final_jejum,
                    CASE WHEN NEW.dt_final_jejum IS NULL THEN 'C'  ELSE 'P' END ,
                    'P',
                    dt_inicio_w,
                    obter_usuario_ativo,
                    LOCALTIMESTAMP,
                    cd_pessoa_fisica_w
                );

            END IF;

        END IF;

        IF ( TG_OP = 'UPDATE' ) THEN
		if (NEW.dt_start_date > NEW.dt_end_date or NEW.dt_start_date > OLD.dt_end_date ) then
                CALL wheb_mensagem_pck.exibir_mensagem_abort(1127560, 'STARTDATE='|| obter_desc_expressao(286980) || ';ENDDATE=' || obter_desc_expressao(1067080));
        end if;
            IF NEW.DT_START_DATE <> OLD.DT_START_DATE THEN
                UPDATE atend_paciente_unidade
                SET
                    dt_saida_temporaria = NEW.DT_START_DATE,
                    dt_retorno_saida_temporaria  = NULL,
                    nm_usuario = coalesce(obter_usuario_ativo, nm_usuario),
                    dt_atualizacao = LOCALTIMESTAMP
                WHERE
                    nr_atendimento = NEW.nr_atendimento;

            END IF;

            IF ( OLD.dt_final_saida IS NULL AND NEW.dt_final_saida IS NOT NULL ) THEN
                IF OLD.nr_sequencia_dieta IS NOT NULL THEN
                    UPDATE cpoe_dieta
                    SET
                        dt_suspensao = LOCALTIMESTAMP,
                        dt_lib_suspensao = LOCALTIMESTAMP
                    WHERE
                        nr_sequencia = OLD.nr_sequencia_dieta;

                END IF;

            END IF;

            IF ( NEW.ie_sem_jejum = 'N' AND ( NEW.dt_inicio_jejum <> OLD.dt_inicio_jejum OR NEW.nr_categoria_refeicao_inicio
            <> OLD.nr_categoria_refeicao_inicio OR NEW.nr_categoria_refeicao_fim <> OLD.nr_categoria_refeicao_fim OR NEW.dt_final_jejum
            <> OLD.dt_final_jejum ) ) OR ( NEW.ie_sem_jejum = 'N' AND OLD.ie_sem_jejum = 'S' ) THEN
                UPDATE cpoe_dieta
                SET
                    dt_suspensao = LOCALTIMESTAMP,
                    dt_lib_suspensao = LOCALTIMESTAMP
                WHERE
                    nr_sequencia = OLD.nr_sequencia_dieta;

                IF ( NEW.ie_sem_jejum = 'N' AND NEW.dt_inicio_jejum IS NOT NULL ) THEN
                    dt_inicio_w := trunc(NEW.dt_inicio_jejum, 'hh24') + 1 / 24;
                    hr_prim_horario_w := substr(cpoe_obter_primeiro_horario(NEW.nr_atendimento, NULL, NULL, NULL, NULL,
                            NULL, NULL), 1, 5);

                    IF ( hr_prim_horario_w IS NOT NULL ) THEN
                        dt_inicio_w := to_date(to_char(dt_inicio_w, 'dd/mm/yyyy')
                                               || hr_prim_horario_w, 'dd/mm/yyyy hh24:mi');
                    END IF;

                    cd_pessoa_fisica_w := obter_cd_pes_fis_atend(NEW.nr_atendimento);
                    SELECT
                        nextval('cpoe_dieta_seq')
                    INTO STRICT nr_sequencia_w
;

                    NEW.nr_sequencia_dieta := nr_sequencia_w;
                    INSERT INTO cpoe_dieta(
                        nr_sequencia,
                        nr_atendimento,
                        ie_tipo_dieta,
                        nr_seq_tipo,
                        ie_se_necessario,
                        ds_observacao,
                        dt_inicio,
                        dt_fim,
                        ie_duracao,
                        ie_administracao,
                        dt_prim_horario,
                        nm_usuario,
                        dt_atualizacao,
                        cd_pessoa_fisica
                    ) VALUES (
                        nr_sequencia_w,
                        OLD.nr_atendimento,
                        'J',
                        coalesce(NEW.nr_categoria_refeicao_inicio, NEW.nr_categoria_refeicao_fim),
                        'N',
                        NULL,
                        NEW.dt_inicio_jejum,
                        NEW.dt_final_jejum,
                        CASE WHEN NEW.dt_final_jejum IS NULL THEN 'C'  ELSE 'P' END ,
                        'P',
                        dt_inicio_w,
                        obter_usuario_ativo,
                        LOCALTIMESTAMP,
                        cd_pessoa_fisica_w
                    );

                END IF;
				
				

            END IF;

            IF NEW.ie_sem_jejum = 'S' THEN
                IF OLD.nr_sequencia_dieta IS NOT NULL THEN
                    UPDATE cpoe_dieta
                    SET
                        dt_suspensao = LOCALTIMESTAMP,
                        dt_lib_suspensao = LOCALTIMESTAMP
                    WHERE
                        nr_sequencia = OLD.nr_sequencia_dieta;

                    NEW.nr_sequencia_dieta := NULL;
                END IF;
            END IF;
		    IF (NEW.ie_sem_jejum = 'N' AND NEW.ie_sem_jejum = OLD.ie_sem_jejum and NEW.dt_final_jejum is not null and NEW.dt_final_jejum <>  coalesce(OLD.dt_final_jejum ,TO_DATE('30/12/2999','dd/mm/yyyy'))) THEN

				update cpoe_dieta 
				set dt_fim=NEW.dt_final_jejum ,
				dt_atualizacao=LOCALTIMESTAMP,
				nm_usuario = coalesce(obter_usuario_ativo, nm_usuario)
				where  nr_atendimento = NEW.nr_atendimento and  nr_sequencia = OLD.nr_sequencia_dieta;

            END IF;

        END IF;

        IF ( TG_OP = 'DELETE' ) THEN
            UPDATE atend_paciente_unidade
            SET
                dt_saida_temporaria  = NULL,
                dt_retorno_saida_temporaria  = NULL,
                nm_usuario = coalesce(obter_usuario_ativo, nm_usuario),
                dt_atualizacao = LOCALTIMESTAMP
            WHERE
                nr_atendimento = OLD.nr_atendimento;

            IF OLD.nr_sequencia_dieta IS NOT NULL THEN
                UPDATE cpoe_dieta
                SET
                    dt_suspensao = LOCALTIMESTAMP,
                    dt_lib_suspensao = LOCALTIMESTAMP
                WHERE
                    nr_sequencia = OLD.nr_sequencia_dieta;

            END IF;

        END IF;

    END IF;
IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_wocupacao_saida_temp_before() FROM PUBLIC;

CREATE TRIGGER wocupacao_saida_temp_before
	BEFORE INSERT OR UPDATE OR DELETE ON wocupacao_saida_temporaria FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_wocupacao_saida_temp_before();

