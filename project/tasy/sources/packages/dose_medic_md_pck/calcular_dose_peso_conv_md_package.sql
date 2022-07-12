-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION dose_medic_md_pck.calcular_dose_peso_conv_md (qt_casas_retorno_p bigint, qt_dose_unid_cons_p bigint, qt_conversao_p bigint, qt_peso_p bigint) RETURNS bigint AS $body$
DECLARE


    qt_dose_w bigint;


BEGIN
    if (qt_casas_retorno_p > 0) then
      qt_dose_w := round(coalesce(qt_dose_unid_cons_p, 0) * coalesce(qt_conversao_p, 0) * coalesce(qt_peso_p, 0),
                         qt_casas_retorno_p);
    else
      qt_dose_w := coalesce(qt_dose_unid_cons_p, 0) * coalesce(qt_conversao_p, 0) * coalesce(qt_peso_p, 0);
    end if;

    return qt_dose_w;
  end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION dose_medic_md_pck.calcular_dose_peso_conv_md (qt_casas_retorno_p bigint, qt_dose_unid_cons_p bigint, qt_conversao_p bigint, qt_peso_p bigint) FROM PUBLIC;
