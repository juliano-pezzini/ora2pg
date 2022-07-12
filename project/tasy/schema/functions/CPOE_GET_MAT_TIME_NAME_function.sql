-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_get_mat_time_name ( cd_intervalo_p intervalo_prescricao.cd_intervalo%type, dt_horario_p prescr_mat_hor.dt_horario%type ) RETURNS varchar AS $body$
DECLARE


ds_return_w varchar(500) := null;
ds_hor_w varchar(5) := null;
ds_n_w bigint := 0;
qt_period_w bigint := 0;
ds_horarios_w intervalo_prescricao.ds_horarios%type;


BEGIN
  SELECT  i.ds_horarios,
          (
            SELECT  COUNT(1)
            FROM    intervalo_prescr_period p
            WHERE   p.cd_intervalo = i.cd_intervalo
          ) qt_period
	INTO STRICT    ds_horarios_w,
          qt_period_w
	FROM    intervalo_prescricao i
	WHERE   i.cd_intervalo = cd_intervalo_p;

  -- Horario fixo com nome
  IF (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') AND (qt_period_w > 0) THEN
    SELECT  MAX(TO_CHAR(dt_horario_p, 'dd/mm/yyyy ') || p.nm_period)
    INTO STRICT    ds_return_w
    FROM    prescr_interval_period p,
            intervalo_prescr_period i
    WHERE   i.nr_seq_period = p.nr_sequencia
            AND i.cd_intervalo = cd_intervalo_p
            AND dt_horario_p BETWEEN
              TO_DATE(
                TO_CHAR(dt_horario_p, 'dd/mm/yyyy')
                || ' ' || TO_CHAR(p.hr_start_time, 'hh24:mi'),
                'dd/mm/yyyy hh24:mi'
              ) AND TO_DATE(
                TO_CHAR(dt_horario_p + CASE WHEN TO_CHAR(p.hr_start_time, 'hh24') > TO_CHAR(p.hr_end_time, 'hh24') THEN 1 ELSE 0 END, 'dd/mm/yyyy')
                || ' ' || TO_CHAR(p.hr_end_time, 'hh24:mi'),
                'dd/mm/yyyy hh24:mi'
              );
  END IF;

  -- Horario fixo sem nome
  ds_horarios_w := ds_horarios_w || ' ';
  WHILE(ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') AND (position(' ' in ds_horarios_w) > 0) AND (coalesce(ds_return_w::text, '') = '') LOOP
    ds_n_w := ds_n_w + 1;
    ds_hor_w := substr(ds_horarios_w, 1, position(' ' in ds_horarios_w) - 1);
    ds_horarios_w := substr(ds_horarios_w, position(' ' in ds_horarios_w) + 1, length(ds_horarios_w));

    IF ((
      (length(ds_hor_w) = 2) AND (ds_hor_w = TO_CHAR(dt_horario_p, 'hh24'))
    ) OR (
      (length(ds_hor_w) = 5) AND (ds_hor_w = TO_CHAR(dt_horario_p, 'hh24:mi'))  
    )) THEN
      ds_return_w := TO_CHAR(dt_horario_p, 'dd/mm/yyyy ') || wheb_mensagem_pck.get_texto(1163940, 'NR_TIME='||ds_n_w);
    END IF;
  END LOOP;

  -- Horario mutavel
  IF (coalesce(ds_return_w::text, '') = '') THEN
    ds_return_w := TO_CHAR(dt_horario_p, 'dd/mm/yyyy hh24:mi');
  END IF;

  RETURN ds_return_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_get_mat_time_name ( cd_intervalo_p intervalo_prescricao.cd_intervalo%type, dt_horario_p prescr_mat_hor.dt_horario%type ) FROM PUBLIC;
