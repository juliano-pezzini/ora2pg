-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atend_pac_before ON atend_pac_un_log_mot_temp CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atend_pac_before() RETURNS trigger AS $BODY$
DECLARE
    dt_inicio_w          cpoe_dieta.dt_inicio%TYPE;
    hr_prim_horario_w    cpoe_dieta.hr_prim_horario%TYPE;
    nr_sequencia_w       cpoe_dieta.nr_sequencia%TYPE;
    cd_pessoa_fisica_w   atendimento_paciente.cd_pessoa_fisica%TYPE;
    nm_usuario_w         varchar(15);
BEGIN
     IF ( wheb_usuario_pck.get_ie_executar_trigger = 'S' and 1 = 2 ) THEN
        IF ( TG_OP = 'INSERT' ) THEN
            NEW.nm_usuario := obter_usuario_ativo;
            NEW.dt_atualizacao := LOCALTIMESTAMP;

         IF (NEW.dt_movimentacao IS NOT NULL ) THEN
                dt_inicio_w := trunc(NEW.dt_movimentacao, 'hh24') + 1 / 24;
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
                    cd_pessoa_fisica,
                    dt_liberacao
                ) VALUES (
                    nr_sequencia_w,
                    NEW.nr_atendimento,
                    'J',
                    NEW.nr_categoria_refeicao_fim,
                    'N',
                    NULL,
                    NEW.dt_movimentacao,
                    NEW.dt_final_jejum,
                    'P',
                    'P',
                    dt_inicio_w,
                    obter_usuario_ativo,
                    LOCALTIMESTAMP,
                    cd_pessoa_fisica_w,
                    NEW.dt_movimentacao
                );

            END IF;

        END IF;


        IF ( TG_OP = 'UPDATE' ) THEN
                IF OLD.nr_sequencia_dieta IS NOT NULL THEN
                    UPDATE cpoe_dieta
                    SET
                        dt_suspensao = LOCALTIMESTAMP,
                        dt_lib_suspensao = LOCALTIMESTAMP
                    WHERE
                        nr_sequencia = OLD.nr_sequencia_dieta;

                END IF;

            END IF;


               UPDATE cpoe_dieta
                SET
                    dt_suspensao = LOCALTIMESTAMP,
                    dt_lib_suspensao = LOCALTIMESTAMP
                WHERE
                    nr_sequencia = OLD.nr_sequencia_dieta;

                IF ( NEW.dt_movimentacao IS NOT NULL AND OLD.nr_atendimento IS NOT NULL) THEN
                    dt_inicio_w := trunc(NEW.dt_movimentacao, 'hh24') + 1 / 24;
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
                        cd_pessoa_fisica,
                        dt_liberacao
                    ) VALUES (
                        nr_sequencia_w,
                        OLD.nr_atendimento,
                        'J',
                        NEW.nr_categoria_refeicao_fim,
                        'N',
                        NULL,
                        NEW.dt_movimentacao,
                        NEW.dt_final_jejum,
                        'P',
                        'P',
                        dt_inicio_w,
                        obter_usuario_ativo,
                        LOCALTIMESTAMP,
                        cd_pessoa_fisica_w,
                        NEW.dt_movimentacao
                    );

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
-- REVOKE ALL ON FUNCTION trigger_fct_atend_pac_before() FROM PUBLIC;

CREATE TRIGGER atend_pac_before
	BEFORE INSERT OR UPDATE OR DELETE ON atend_pac_un_log_mot_temp FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atend_pac_before();

