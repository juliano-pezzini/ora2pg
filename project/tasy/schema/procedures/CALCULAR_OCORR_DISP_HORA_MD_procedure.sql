-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_ocorr_disp_hora_md ( ie_param_controll_p bigint, qt_unitaria_dil_p bigint, ie_agrupador_dil_p bigint, nr_ocorrencia_p bigint, qt_unitaria_p bigint, qt_dispensar_hor_p INOUT bigint, nr_ocorrencia_dil_p INOUT bigint ) AS $body$
BEGIN
  if (ie_param_controll_p = 0) then
    qt_dispensar_hor_p := ceil(qt_unitaria_dil_p);
    if (ie_agrupador_dil_p = 9) then
      nr_ocorrencia_dil_p := nr_ocorrencia_p;
      qt_dispensar_hor_p := qt_unitaria_dil_p * ceil(qt_unitaria_p);
    end if;
  end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_ocorr_disp_hora_md ( ie_param_controll_p bigint, qt_unitaria_dil_p bigint, ie_agrupador_dil_p bigint, nr_ocorrencia_p bigint, qt_unitaria_p bigint, qt_dispensar_hor_p INOUT bigint, nr_ocorrencia_dil_p INOUT bigint ) FROM PUBLIC;

