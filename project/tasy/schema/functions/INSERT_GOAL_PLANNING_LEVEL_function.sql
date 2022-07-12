-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION insert_goal_planning_level ( nr_sequencia_p bigint, nr_seq_measure_goal_p bigint, dt_evaluation_goal_p timestamp ) RETURNS varchar AS $body$
DECLARE

    cursor_measure CURSOR FOR
      SELECT
        NR_SEQUENCIA,
        DT_ATUALIZACAO,
        NM_USUARIO,
        DT_ATUALIZACAO_NREC,
        NM_USUARIO_NREC,
        NR_SEQ_PAT_CP_IND,
        DT_EVALUATION,
        NR_SEQ_MEASURE,
        NR_SCORE,
        IE_EVOLUTION,
        DS_NOTE,
        NR_SEQ_ASSINATURA,
        DT_LIBERACAO,
        NM_USUARIO_LIB,
        NR_SEQ_CP_INDICATOR,
        NR_SEQ_PRESCR 
    FROM
        patient_cp_indic_measure
    WHERE
        nr_sequencia = nr_sequencia_p;

    cp_measure		    cursor_measure%rowtype;
    nr_sequencia_w		patient_cp_indic_measure.nr_sequencia%type;

BEGIN
    FOR cp_measure IN cursor_measure LOOP BEGIN
      SELECT
          nextval('patient_cp_indic_plan_seq')
      INTO STRICT
          nr_sequencia_w
;

      INSERT into PATIENT_CP_INDIC_PLAN(
                  NR_SEQUENCIA,
                  DT_ATUALIZACAO,
                  NM_USUARIO,
                  DT_ATUALIZACAO_NREC,
                  NM_USUARIO_NREC,
                  NR_SEQ_PAT_CP_IND,
                  DT_EVALUATION,
                  NR_SEQ_MEASURE,
                  NR_SCORE,
                  IE_EVALUATION,
                  NM_USUARIO_LIB,
                  DS_NOTE,
                  NR_SEQ_ASSINATURA,
                  NR_SEQ_CP_INDICATOR,
                  NR_SEQ_PRESCR,
                  NR_SEQ_MEASURE_GOAL,
                  DT_EVALUATION_GOAL,
                  DT_LIBERACAO)
            values (
                  nr_sequencia_w,
                  cp_measure.DT_ATUALIZACAO_NREC,
                  cp_measure.NM_USUARIO_NREC,
                  cp_measure.DT_ATUALIZACAO_NREC,
                  cp_measure.NM_USUARIO_NREC,
                  cp_measure.NR_SEQ_PAT_CP_IND,
                  cp_measure.DT_EVALUATION,
                  cp_measure.NR_SEQ_MEASURE,
                  cp_measure.NR_SCORE,
                  cp_measure.IE_EVOLUTION,
                  cp_measure.NM_USUARIO_LIB,
                  cp_measure.DS_NOTE,
                  cp_measure.NR_SEQ_ASSINATURA,
                  cp_measure.NR_SEQ_CP_INDICATOR,
                  cp_measure.NR_SEQ_PRESCR,
                  nr_seq_measure_goal_p,
                  dt_evaluation_goal_p,
                  cp_measure.DT_LIBERACAO
                  );
    END; END LOOP;

    commit;

    RETURN nr_sequencia_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION insert_goal_planning_level ( nr_sequencia_p bigint, nr_seq_measure_goal_p bigint, dt_evaluation_goal_p timestamp ) FROM PUBLIC;

