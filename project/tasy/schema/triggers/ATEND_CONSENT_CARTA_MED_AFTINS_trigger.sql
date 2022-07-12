-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atend_consent_carta_med_aftins ON atend_consent_carta_med CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atend_consent_carta_med_aftins() RETURNS trigger AS $BODY$
DECLARE
    nr_sequencia_recipient_w laudo_paciente_recipient.nr_sequencia%TYPE;
    old_nr_sequencia_recipient_w laudo_paciente_recipient.nr_sequencia%TYPE;
    cod_expression_w integer;

    c01 CURSOR FOR
    SELECT
        lau.nm_usuario     nm_usuario,
        lau.nr_sequencia   nr_seq_laudo
    FROM
        laudo_paciente lau
    WHERE
        lau.nr_atendimento = NEW.nr_atendimento;

BEGIN
    IF ( coalesce(wheb_usuario_pck.get_ie_executar_trigger, 'S') = 'S' ) THEN

        SELECT MAX(nr_sequencia)
        INTO STRICT old_nr_sequencia_recipient_w
        FROM laudo_paciente_recipient
        WHERE cd_medico = OLD.cd_medico
                AND ie_situacao = 'A'
                AND dt_liberacao IS NOT NULL
                AND dt_inativacao IS NULL;

        IF (TG_OP = 'INSERT') THEN
                FOR c01_w IN c01 LOOP
                SELECT nextval('laudo_paciente_recipient_seq')
                INTO STRICT nr_sequencia_recipient_w
;
                INSERT INTO laudo_paciente_recipient(
                        nr_sequencia,
                        dt_atualizacao,
                        nm_usuario,
                        dt_atualizacao_nrec,
                        nm_usuario_nrec,
                        ie_situacao,
                        nr_atendimento,
                        nr_seq_laudo,
                        cd_medico,
                        ie_main_recipient,
                        dt_liberacao,
                        nm_usuario_lib
                ) VALUES (
                        nr_sequencia_recipient_w,
                        LOCALTIMESTAMP,
                        OBTER_USUARIO_ATIVO,
                        LOCALTIMESTAMP,
                        OBTER_USUARIO_ATIVO,
                        'A',
                        NEW.nr_atendimento,
                        c01_w.nr_seq_laudo,
                        NEW.cd_medico,
                        'N',
                        LOCALTIMESTAMP,
                        OBTER_USUARIO_ATIVO
                );

                END LOOP;
        END IF;

        IF((TG_OP = 'UPDATE' OR TG_OP = 'DELETE') AND old_nr_sequencia_recipient_w > 0) THEN

                IF (TG_OP = 'UPDATE') THEN
                        cod_expression_w := 1059075;
                ELSE
                        cod_expression_w := 1059077;
                END IF;

                UPDATE laudo_paciente_recipient
                SET ie_situacao = 'I',
                        ds_justificativa = obter_desc_expressao(cod_expression_w),
                        dt_inativacao = LOCALTIMESTAMP,
                        nm_usuario_inativacao = OBTER_USUARIO_ATIVO
                WHERE nr_sequencia = old_nr_sequencia_recipient_w;

                IF (TG_OP = 'UPDATE') THEN
                        SELECT nextval('laudo_paciente_recipient_seq')
                        INTO STRICT nr_sequencia_recipient_w
;
                        INSERT INTO laudo_paciente_recipient(
                                nr_sequencia,
                                dt_atualizacao,
                                nm_usuario,
                                dt_atualizacao_nrec,
                                nm_usuario_nrec,
                                ie_situacao,
                                nr_atendimento,
                                nr_seq_laudo,
                                cd_medico,
                                ie_main_recipient,
                                dt_liberacao,
                                nm_usuario_lib
                        )
                        SELECT
                                nr_sequencia_recipient_w,
                                LOCALTIMESTAMP,
                                OBTER_USUARIO_ATIVO,
                                LOCALTIMESTAMP,
                                OBTER_USUARIO_ATIVO,
                                'A',
                                lapare.nr_atendimento,
                                lapare.nr_seq_laudo,
                                NEW.cd_medico,
                                lapare.ie_main_recipient,
                                LOCALTIMESTAMP,
                                OBTER_USUARIO_ATIVO
                        FROM laudo_paciente_recipient lapare
                        WHERE lapare.nr_sequencia = old_nr_sequencia_recipient_w;
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
-- REVOKE ALL ON FUNCTION trigger_fct_atend_consent_carta_med_aftins() FROM PUBLIC;

CREATE TRIGGER atend_consent_carta_med_aftins
	AFTER INSERT OR UPDATE OR DELETE ON atend_consent_carta_med FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atend_consent_carta_med_aftins();

