-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_tempo_aplicacao_md (ie_tipo_material text, ie_change_vol text, qt_minutos_aplicacao_p INOUT bigint, qt_hr_min_aplicacao_p text, qt_hr_aplicacao_p INOUT bigint, qt_min_aplicacao_p INOUT bigint) AS $body$
DECLARE

  qt_hr_min_aplicacao_w varchar(500);
  hr_aux_w              bigint := 601;


BEGIN

  if (('MA' = ie_tipo_material and (qt_hr_min_aplicacao_p IS NOT NULL AND qt_hr_min_aplicacao_p::text <> '')) or
     'S' = ie_change_vol) then
    if (1 >= qt_minutos_aplicacao_p) then
      qt_hr_min_aplicacao_w := null;

      if (qt_hr_min_aplicacao_p IS NOT NULL AND qt_hr_min_aplicacao_p::text <> '') then
        qt_hr_aplicacao_p  := substr(qt_hr_min_aplicacao_p, 1, 2);
        qt_min_aplicacao_p := substr(qt_hr_min_aplicacao_p, 4, 5);
      else
        qt_hr_aplicacao_p  := 1;
        qt_min_aplicacao_p := 1;
      end if;

    elsif (qt_minutos_aplicacao_p >= 1) then
      if (qt_minutos_aplicacao_p < hr_aux_w) then
        qt_min_aplicacao_p := qt_minutos_aplicacao_p;
      elsif (qt_minutos_aplicacao_p = hr_aux_w) then
        qt_hr_aplicacao_p  := 11;
        qt_min_aplicacao_p := 1;
      else
        qt_hr_aplicacao_p  := round(dividir_sem_round_md(qt_minutos_aplicacao_p, 60));
        qt_min_aplicacao_p := (coalesce(qt_minutos_aplicacao_p, 0) -
                              (coalesce(qt_hr_aplicacao_p, 0) * coalesce(hr_aux_w, 0)));
      end if;
    end if;
  else
    if ((qt_hr_min_aplicacao_p IS NOT NULL AND qt_hr_min_aplicacao_p::text <> '') and
       length(qt_hr_min_aplicacao_p) > 1 and
       substr(qt_hr_min_aplicacao_p, 1, 2) not like '%:%') then
      qt_hr_aplicacao_p := substr(qt_hr_min_aplicacao_p, 1, 2);

      if (length(qt_hr_min_aplicacao_p) > 4) then
        qt_min_aplicacao_p := substr(qt_hr_min_aplicacao_p, 4, 5);
      else
        qt_min_aplicacao_p := 1;
      end if;

    else
      qt_hr_aplicacao_p  := 1;
      qt_min_aplicacao_p := 1;
    end if;
  end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_tempo_aplicacao_md (ie_tipo_material text, ie_change_vol text, qt_minutos_aplicacao_p INOUT bigint, qt_hr_min_aplicacao_p text, qt_hr_aplicacao_p INOUT bigint, qt_min_aplicacao_p INOUT bigint) FROM PUBLIC;
