-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_total_gas_hr_ventilation ( nr_atendimento_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_tipo_gasoterapia_p text, ie_whole_day_calculation text DEFAULT 'S') RETURNS bigint AS $body$
DECLARE

  /*
  Tipo de gasoterapia:
  INV = Invasive
  NIV = Non Invasive
  */
  ie_evento_w  varchar(15);
  ie_somar_w   varchar(1);
  qt_minutos_w bigint := 0;
  dt_evento_w  timestamp;
  dt_inicio_w  timestamp;
  c01 CURSOR FOR
    SELECT dt_evento,
      ie_evento
    FROM prescr_gasoterapia_evento a ,
      prescr_gasoterapia b,
      prescr_medica c
    WHERE b.nr_sequencia           = a.nr_seq_gasoterapia
    AND b.nr_prescricao            = c.nr_prescricao
    AND c.nr_atendimento           = nr_atendimento_p
    AND ((ie_whole_day_calculation ='S'
    AND dt_evento BETWEEN TRUNC(dt_inicial_p) AND fim_dia(dt_final_p))
    OR (ie_whole_day_calculation ='N'
    AND dt_evento BETWEEN dt_inicial_p AND dt_final_p))
    AND coalesce(a.ie_evento_valido,'S') = 'S'
    AND ((ie_tipo_gasoterapia_p     = 'INV'
    AND b.ie_respiracao            IN ('ESPONT','VMI','VMIFB'))
    OR (ie_tipo_gasoterapia_p       = 'NIV'
    AND b.ie_respiracao            IN ('BORB','VMNI')))
    ORDER BY dt_evento;

BEGIN
  IF ((nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') AND (dt_inicial_p IS NOT NULL AND dt_inicial_p::text <> '') AND (dt_final_p IS NOT NULL AND dt_final_p::text <> '')) THEN
    OPEN C01;
    LOOP
      FETCH C01 INTO dt_evento_w, ie_evento_w;
      EXIT WHEN NOT FOUND; /* apply on C01 */
      IF (ie_evento_w IN ('R','I')) THEN
        dt_inicio_w   := dt_evento_w;
        ie_somar_w    := 'S';
      elsif (ie_evento_w  IN ('IN','T','TE')) AND (ie_somar_w = 'S') THEN
        qt_minutos_w  := qt_minutos_w + obter_min_entre_datas(dt_inicio_w, dt_evento_w, 1);
        ie_somar_w    := 'N';
      END IF;
    END LOOP;
    CLOSE C01;
  END IF;
RETURN qt_minutos_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_total_gas_hr_ventilation ( nr_atendimento_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_tipo_gasoterapia_p text, ie_whole_day_calculation text DEFAULT 'S') FROM PUBLIC;

