-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_vincula_atend_daily (nr_atendimento_p bigint, nr_sequencia_p bigint, ie_tipo_agenda_p bigint, nm_usuario_p text, ie_exec_regra_p text DEFAULT 'N') AS $body$
DECLARE


nr_sequencia_w			agenda_integrada_item.nr_sequencia%TYPE;
nr_seq_item_princ_w		agenda_integrada_item.nr_seq_item_princ%TYPE;				
nr_atendimento_w		agenda_consulta.nr_atendimento%TYPE;
ie_executa_evento_w		varchar(1);
ie_agend_selec_w		varchar(1);
cd_convenio_w			atend_categoria_convenio.cd_convenio%TYPE;
ie_tipo_agenda_w 		varchar(2) := '';

c01 CURSOR FOR
	SELECT
        nr_seq_agenda_cons
    FROM
        agenda_integrada_item
    WHERE
        nr_sequencia = nr_sequencia_w

UNION

    SELECT
        nr_seq_agenda_cons
    FROM
        agenda_integrada_item
    WHERE
        nr_seq_item_princ = nr_sequencia_w
    
UNION

    SELECT
        nr_seq_agenda_cons
    FROM
        agenda_integrada_item
    WHERE
        nr_seq_item_princ = nr_seq_item_princ_w
        AND nr_sequencia <> nr_sequencia_w
    
UNION

    SELECT
        nr_seq_agenda_cons
    FROM
        agenda_integrada_item
    WHERE
        nr_sequencia = nr_seq_item_princ_w;
		
BEGIN

ie_agend_selec_w := obter_valor_param_usuario(869, 425, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo);

IF ( coalesce(nr_sequencia_p, 0) > 0 ) THEN
        IF ( coalesce(nr_atendimento_p, 0) = 0 ) THEN
		SELECT
            MAX(nr_atendimento)
        INTO STRICT nr_atendimento_w
        FROM
            agenda_consulta
        WHERE
            nr_sequencia = nr_sequencia_p;
	ELSE
		nr_atendimento_w := nr_atendimento_p;
	END IF;

	SELECT
        MAX(cd_convenio)
    INTO STRICT cd_convenio_w
    FROM
        atend_categoria_convenio a
    WHERE
        a.nr_atendimento = nr_atendimento_p
        AND NOT EXISTS (
            SELECT
                b.nr_prioridade
            FROM
                atend_categoria_convenio b
            WHERE
                b.nr_atendimento = nr_atendimento_p
                AND a.nr_prioridade > b.nr_prioridade
        );
	
 	IF ( ( ie_tipo_agenda_p = 3 ) OR ( ie_tipo_agenda_p = 5 ) ) THEN
        UPDATE agenda_consulta
        SET
            nr_atendimento = nr_atendimento_w,
            dt_atualizacao = clock_timestamp(),
            nm_usuario = coalesce(nm_usuario_p, obter_usuario_ativo),
            cd_convenio = coalesce(cd_convenio_w, cd_convenio)
        WHERE
            nr_sequencia = nr_sequencia_p
            AND coalesce(nr_atendimento::text, '') = '';

    ELSE
        UPDATE agenda_paciente
        SET
            nr_atendimento = nr_atendimento_w,
            dt_atualizacao = clock_timestamp(),
            nm_usuario = coalesce(nm_usuario_p, obter_usuario_ativo),
            cd_convenio = coalesce(cd_convenio_w, cd_convenio)
        WHERE
            nr_sequencia = nr_sequencia_p
            AND coalesce(nr_atendimento::text, '') = '';

    END IF;
	
	IF ( ie_tipo_agenda_p = 3 AND ( coalesce(ie_agend_selec_w, 'S') = 'S' ) ) THEN
            SELECT
                coalesce(MAX(nr_sequencia), 0),
                coalesce(MAX(nr_seq_item_princ), 0)
            INTO STRICT
                nr_sequencia_w,
                nr_seq_item_princ_w
            FROM
                agenda_integrada_item
            WHERE
                nr_seq_agenda_cons = nr_sequencia_p;

            FOR r_c01 IN c01 LOOP BEGIN
                IF ( coalesce(r_c01.nr_seq_agenda_cons, 0) > 0 ) THEN
                    UPDATE agenda_consulta
                    SET
                        nr_atendimento = nr_atendimento_w,
                        dt_atualizacao = clock_timestamp(),
                        nm_usuario = coalesce(nm_usuario_p, obter_usuario_ativo),
                        cd_convenio = coalesce(cd_convenio_w, cd_convenio)
                    WHERE
                        nr_sequencia = r_c01.nr_seq_agenda_cons
                        AND coalesce(nr_atendimento::text, '') = '';

                END IF;

            END;
            END LOOP;

        END IF;
	
END IF;


IF ( ie_exec_regra_p = 'S' ) THEN
        SELECT
            MAX(obter_se_existe_evento_agenda(wheb_usuario_pck.get_cd_estabelecimento, 'VA', ie_tipo_agenda_p))
        INTO STRICT ie_executa_evento_w
;

		IF ( ie_tipo_agenda_p = 1 ) THEN
            ie_tipo_agenda_w := 'CI';

        ELSIF ( ie_tipo_agenda_p = 2 ) THEN
            ie_tipo_agenda_w := 'E';

        ELSIF ( ie_tipo_agenda_p = 3 ) THEN
            ie_tipo_agenda_w := 'C';

        ELSIF ( ie_tipo_agenda_p = 5 ) THEN
            ie_tipo_agenda_w := 'S';

        END IF;

	IF (ie_executa_evento_w = 'S') THEN
		CALL executar_evento_agenda('VA', ie_tipo_agenda_w, nr_sequencia_p, wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario, NULL, NULL);
	END IF;
	
END IF;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_vincula_atend_daily (nr_atendimento_p bigint, nr_sequencia_p bigint, ie_tipo_agenda_p bigint, nm_usuario_p text, ie_exec_regra_p text DEFAULT 'N') FROM PUBLIC;

