-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION anzics_pck.get_ventilation_hours ( nr_atendimento_p bigint, nr_seq_atepacu_p bigint, ie_type_ventilation text) RETURNS bigint AS $body$
DECLARE

    qt_vent_hours smallint := NULL;

BEGIN
    CALL anzics_pck.set_icu_date(nr_seq_atepacu_p);
    IF (ie_type_ventilation = 'INV') THEN
      SELECT obter_total_gas_hr_ventilation(nr_atendimento_p,current_setting('anzics_pck.dt_inicio_w')::timestamp,current_setting('anzics_pck.dt_fim_w')::timestamp,'INV','N')/60
      INTO STRICT qt_vent_hours
;
    ELSE
      SELECT obter_total_gas_hr_ventilation(nr_atendimento_p,current_setting('anzics_pck.dt_inicio_w')::timestamp,current_setting('anzics_pck.dt_fim_w')::timestamp,'NIV','N')/60
      INTO STRICT qt_vent_hours
;
    END IF;
    RETURN qt_vent_hours;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION anzics_pck.get_ventilation_hours ( nr_atendimento_p bigint, nr_seq_atepacu_p bigint, ie_type_ventilation text) FROM PUBLIC;
