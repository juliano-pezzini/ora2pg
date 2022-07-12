-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION anzics_pck.obter_apache_exam_result ( nr_atendimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, nr_seq_exame_p bigint, nr_seq_resultado_p bigint) RETURNS bigint AS $body$
DECLARE

    nr_apache_result_w double precision;

BEGIN
    SELECT CASE WHEN y.ie_formato_resultado='V' THEN qt_resultado WHEN y.ie_formato_resultado='P' THEN pr_resultado END  qt_result
    INTO STRICT nr_apache_result_w
    FROM exame_lab_result_item b,
      exame_lab_resultado a,
      prescr_procedimento x,
      exame_laboratorio y,
      prescr_medica c
    WHERE a.nr_seq_resultado = b.nr_seq_resultado
    AND a.nr_prescricao      = c.nr_prescricao
    AND x.nr_sequencia       = b.nr_seq_prescr
    AND x.nr_prescricao      = c.nr_prescricao
    AND c.nr_atendimento     = nr_atendimento_p
    AND b.nr_seq_exame       = nr_seq_exame_p
    AND b.nr_seq_exame       = y.nr_seq_exame
    AND x.ie_status_atend   >= 35
    AND a.nr_seq_resultado   = nr_seq_resultado_p
    AND a.dt_resultado BETWEEN dt_inicio_p AND dt_fim_p;
    RETURN nr_apache_result_w;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION anzics_pck.obter_apache_exam_result ( nr_atendimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, nr_seq_exame_p bigint, nr_seq_resultado_p bigint) FROM PUBLIC;