-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE delete_med_treatment_plan ( nr_seq_gestao_vaga_p gestao_vaga.nr_sequencia%TYPE, cd_pessoa_fisica_p gestao_vaga.cd_pessoa_fisica%TYPE, delete_status_p text ) AS $body$
DECLARE


    nr_sequencia_w med_treatment_plan.nr_sequencia%TYPE;
    c_treatment CURSOR(
        cd_person_p           gestao_vaga.cd_pessoa_fisica%TYPE
    ) FOR
    SELECT
        a.nr_sequencia
    FROM
        med_treatment_plan a
    WHERE
        a.nr_atendimento IN (
            SELECT
                ap.nr_atendimento
            FROM
                atendimento_paciente   ap
            WHERE ap.cd_pessoa_fisica = cd_person_p
        )
        AND coalesce(a.dt_liberacao::text, '') = '';


BEGIN	
	if (delete_status_p = 'N') THEN	
		UPDATE med_treatment_plan mtp
		SET
			mtp.nr_seq_ges_vag  = NULL		
		WHERE
		mtp.nr_seq_ges_vag = nr_seq_gestao_vaga_p;
		commit;
	ELSE
    OPEN c_treatment(cd_pessoa_fisica_p);
    LOOP
        FETCH c_treatment INTO nr_sequencia_w;
        EXIT WHEN NOT FOUND; /* apply on c_treatment */
        BEGIN
            DELETE FROM med_treatment_plan_conf
            WHERE
                nr_seq_med_treat_plan = nr_sequencia_w;

            DELETE FROM med_treatment_plan_team
            WHERE
                nr_seq_med_treat_plan = nr_sequencia_w;

            DELETE FROM med_treatment_plan_disease
            WHERE
                nr_seq_med_treat_plan = nr_sequencia_w;

            DELETE FROM med_treatment_plan mtp
            WHERE
                mtp.nr_sequencia = nr_sequencia_w
                AND coalesce(mtp.dt_liberacao::text, '') = '';

        END;

    END LOOP;

    CLOSE c_treatment;
	END IF;
    UPDATE med_treatment_plan mtp
    SET
        mtp.dt_inativacao = clock_timestamp()
    WHERE
        mtp.nr_atendimento IN (
            SELECT
                ap.nr_atendimento
            FROM
                atendimento_paciente   ap
            WHERE
                ap.cd_pessoa_fisica = cd_pessoa_fisica_p
        )
        AND (mtp.dt_liberacao IS NOT NULL AND mtp.dt_liberacao::text <> '');

    COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE delete_med_treatment_plan ( nr_seq_gestao_vaga_p gestao_vaga.nr_sequencia%TYPE, cd_pessoa_fisica_p gestao_vaga.cd_pessoa_fisica%TYPE, delete_status_p text ) FROM PUBLIC;
