-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_escala_copd_md ( ie_cough_p bigint, ie_mucus_p bigint, ie_chest_p bigint, ie_breathless_p bigint, ie_limited_activity_p bigint, ie_confident_p bigint, ie_sleep_p bigint, ie_energy_p bigint ) RETURNS bigint AS $body$
DECLARE

  qt_score_w bigint;

BEGIN
  qt_score_w := coalesce(ie_cough_p, 0) +
    coalesce(ie_mucus_p, 0) +
    coalesce(ie_chest_p, 0) +
    coalesce(ie_breathless_p, 0) +
    coalesce(ie_limited_activity_p, 0) +
    coalesce(ie_confident_p, 0) +
    coalesce(ie_sleep_p, 0) +
    coalesce(ie_energy_p, 0);

  return qt_score_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_escala_copd_md ( ie_cough_p bigint, ie_mucus_p bigint, ie_chest_p bigint, ie_breathless_p bigint, ie_limited_activity_p bigint, ie_confident_p bigint, ie_sleep_p bigint, ie_energy_p bigint ) FROM PUBLIC;
