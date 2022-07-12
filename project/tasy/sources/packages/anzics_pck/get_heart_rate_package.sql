-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION anzics_pck.get_heart_rate ( nr_atendimento_p bigint, nr_seq_atepacu_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

    qt_min_hr_w atendimento_sinal_vital.qt_freq_cardiaca%type;
    qt_max_hr_w atendimento_sinal_vital.qt_freq_cardiaca%type;

BEGIN
    CALL anzics_pck.set_icu_date(nr_seq_atepacu_p);
    SELECT MAX(a.qt_freq_cardiaca),
      MIN(a.qt_freq_cardiaca)
    INTO STRICT qt_max_hr_w,
      qt_min_hr_w
    FROM atendimento_sinal_vital a
    WHERE a.nr_atendimento = nr_atendimento_p
    AND a.dt_sinal_vital BETWEEN current_setting('anzics_pck.dt_inicio_w')::timestamp AND current_setting('anzics_pck.dt_fim_w')::timestamp
    AND (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
    AND coalesce(a.dt_inativacao::text, '') = '';
    IF (ie_opcao_p       = 'HRHI') THEN
      RETURN qt_max_hr_w;
    elsif (ie_opcao_p = 'HRLO') THEN
      RETURN qt_min_hr_w;
    END IF;
    RETURN NULL;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION anzics_pck.get_heart_rate ( nr_atendimento_p bigint, nr_seq_atepacu_p bigint, ie_opcao_p text) FROM PUBLIC;
