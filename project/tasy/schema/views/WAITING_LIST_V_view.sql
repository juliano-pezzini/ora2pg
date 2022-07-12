-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW waiting_list_v (cd_estabelecimento, cd_fila, filadescription, aguardando, esperamin, open_time, close_time, is_open_now) AS SELECT DISTINCT
        cd_estabelecimento,
        cd_fila,
        Max(ds_fila) filaDescription,
        Max(ds_aguardando) aguardando,
        Max(media_espera_min) esperaMin,
       open_time,
       close_time,
       is_open_now
  FROM (
    SELECT  a.cd_estabelecimento cd_estabelecimento,
        a.nr_sequencia cd_fila,
        a.ds_fila ds_fila,
        (obter_qt_senhas_aguar_fila_why(a.nr_sequencia, (PKG_DATE_UTILS.start_of(LOCALTIMESTAMP, 'DAY', 0)), PKG_DATE_UTILS.GET_DATETIME(PKG_DATE_UTILS.END_OF(LOCALTIMESTAMP, 'DAY'), PKG_DATE_UTILS.get_Time(23,59,59)))) ds_aguardando,
        (obter_med_temp_espera_fila_min(a.nr_sequencia, (PKG_DATE_UTILS.start_of(LOCALTIMESTAMP, 'DAY', 0)), PKG_DATE_UTILS.GET_DATETIME(PKG_DATE_UTILS.END_OF(LOCALTIMESTAMP, 'DAY'), PKG_DATE_UTILS.get_Time(23,59,59))) / 60) media_espera_min,  --wait_time_in_minutes
        to_char(d.dt_horario_inicial, 'HH24') || ':00' open_time,
        to_char(d.dt_horario_final, 'HH24') || ':00' close_time,
        (CASE WHEN pkg_date_utils.get_weekday(LOCALTIMESTAMP) =  d.ie_dia_semana THEN (CASE WHEN d.dt_horario_inicial IS NOT NULL THEN (CASE WHEN d.dt_horario_final IS NOT NULL THEN (CASE WHEN(to_char(LOCALTIMESTAMP, 'HH24MI') between to_char(d.dt_horario_inicial, 'HH24MI')
                    AND to_char(d.dt_horario_final, 'HH24MI')) THEN 'true'
                ELSE 'false' END)
              ELSE 'true' end)
            ELSE 'true' end)
         ELSE 'false' end)
        is_open_now
      FROM    fila_espera_senha a,
        paciente_senha_fila b,
        atendimentos_senha c,
        turno_senha d,
        turno_senha_config e
      WHERE   c.nr_seq_pac_senha_fila = b.nr_sequencia
      AND     a.nr_sequencia = c.nr_seq_fila_espera
      AND     e.nr_seq_fila_espera_senha = a.nr_sequencia
      AND     e.nr_seq_turno_senha = d.nr_sequencia

UNION ALL

     SELECT  a.cd_estabelecimento cd_estabelecimento,  
        a.nr_sequencia cd_fila,
        a.ds_fila ds_fila,
        (obter_qt_senhas_aguar_fila_why(a.nr_sequencia, (PKG_DATE_UTILS.start_of(LOCALTIMESTAMP, 'DAY', 0)), PKG_DATE_UTILS.GET_DATETIME(PKG_DATE_UTILS.END_OF(LOCALTIMESTAMP, 'DAY'), PKG_DATE_UTILS.get_Time(23,59,59)))) ds_aguardando,
        (obter_med_temp_espera_fila_min(a.nr_sequencia, (PKG_DATE_UTILS.start_of(LOCALTIMESTAMP, 'DAY', 0)), PKG_DATE_UTILS.GET_DATETIME(PKG_DATE_UTILS.END_OF(LOCALTIMESTAMP, 'DAY'), PKG_DATE_UTILS.get_Time(23,59,59))) / 60) media_espera_min,  --wait_time_in_minutes
        to_char(d.dt_horario_inicial, 'HH24') || ':00' open_time,
        to_char(d.dt_horario_final, 'HH24') || ':00' close_time,
        (CASE WHEN pkg_date_utils.get_weekday(LOCALTIMESTAMP) =  d.ie_dia_semana THEN (CASE WHEN d.dt_horario_inicial IS NOT NULL THEN (CASE WHEN d.dt_horario_final IS NOT NULL THEN (CASE WHEN(to_char(LOCALTIMESTAMP, 'HH24MI') between to_char(d.dt_horario_inicial, 'HH24MI')
                    AND to_char(d.dt_horario_final, 'HH24MI')) THEN 'true'
                ELSE 'false' END)
              ELSE 'true' end)
            ELSE 'true' end)
         ELSE 'false' end)
        is_open_now
        FROM      fila_espera_senha a,
        paciente_senha_fila b,
        turno_senha d,
        turno_senha_config e
        WHERE   a.nr_sequencia = coalesce(b.nr_seq_fila_senha, b.nr_seq_fila_senha_origem)
        AND     e.nr_seq_fila_espera_senha = a.nr_sequencia
        AND     e.nr_seq_turno_senha = d.nr_sequencia
    ) alias54
  GROUP BY cd_estabelecimento,
        cd_fila,
        open_time,
       close_time,
       is_open_now
  ORDER BY cd_estabelecimento, cd_fila, open_time, close_time;

