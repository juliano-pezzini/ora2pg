-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION anzics_pck.get_result_lab ( nr_atendimento_p bigint, nr_seq_atepacu_p bigint, nr_seq_exame_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

    qt_result_max_w        double precision;
    qt_result_min_w        double precision;
    ie_formato_resultado_w varchar(3);
    pr_resultado_max_w     double precision;
    pr_resultado_min_w     double precision;

BEGIN
    CALL anzics_pck.set_icu_date(nr_seq_atepacu_p);
    SELECT MAX(b.qt_resultado),
      MAX(b.pr_resultado),
      MIN(b.qt_resultado),
      MIN(b.pr_resultado),
      MAX(y.ie_formato_resultado)
    INTO STRICT qt_result_max_w,
      pr_resultado_max_w,
      qt_result_min_w,
      pr_resultado_min_w,
      ie_formato_resultado_w
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
    AND a.dt_resultado BETWEEN current_setting('anzics_pck.dt_inicio_w')::timestamp AND current_setting('anzics_pck.dt_fim_w')::timestamp;
    IF (upper(ie_opcao_p)        = 'MIN') THEN
      IF (ie_formato_resultado_w = 'P') THEN
        RETURN pr_resultado_min_w;
      ELSE
        RETURN qt_result_min_w;
      END IF;
    elsif (upper(ie_opcao_p)     = 'MAX') THEN
      IF (ie_formato_resultado_w = 'P') THEN
        RETURN pr_resultado_max_w;
      ELSE
        RETURN qt_result_max_w;
      END IF;
    END IF;
    RETURN NULL;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION anzics_pck.get_result_lab ( nr_atendimento_p bigint, nr_seq_atepacu_p bigint, nr_seq_exame_p bigint, ie_opcao_p text) FROM PUBLIC;
