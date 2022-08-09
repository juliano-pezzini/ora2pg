-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_disease_data ( nr_seq_med_p bigint, cd_doenca_p text, nr_atendimento_p bigint ) AS $body$
DECLARE

    dt_diagnostico_w    med_treatment_plan_disease.dt_diagnostico%TYPE;

BEGIN
    SELECT
        MAX(dt_diagnostico)
    INTO STRICT dt_diagnostico_w
    FROM
        diagnostico_doenca
    WHERE
        nr_atendimento = nr_atendimento_p
        AND cd_doenca = cd_doenca_p;

    
IF (dt_diagnostico_w IS NOT NULL AND dt_diagnostico_w::text <> '') THEN
    INSERT INTO med_treatment_plan_disease(
        nr_sequencia,
        dt_atualizacao,
        dt_atualizacao_nrec,
        nm_usuario,
        nm_usuario_nrec,
        nr_seq_med_treat_plan,
        cd_doenca,
        nr_atendimento,
        dt_diagnostico
    ) VALUES (
        nextval('med_treatment_plan_disease_seq'),
        clock_timestamp(),
        clock_timestamp(),
        wheb_usuario_pck.get_nm_usuario,
        wheb_usuario_pck.get_nm_usuario,
        nr_seq_med_p,
        cd_doenca_p,
        nr_atendimento_p,
        dt_diagnostico_w
    );

END IF;

commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_disease_data ( nr_seq_med_p bigint, cd_doenca_p text, nr_atendimento_p bigint ) FROM PUBLIC;
