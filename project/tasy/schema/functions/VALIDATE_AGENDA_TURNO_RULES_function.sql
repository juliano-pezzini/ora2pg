-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION validate_agenda_turno_rules ( nm_tabela_p text, nr_seq_parent_p bigint, nr_sequencia_p bigint, qt_amount_p bigint, hr_inicial_p timestamp, hr_final_p timestamp, dt_inicio_vigencia_p timestamp, dt_final_vigencia_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_possui_w         varchar(15) := '0';
ie_data_exist_w     varchar(1);
dt_new_initial_w    timestamp;
dt_new_final_w      timestamp;


BEGIN

    dt_new_initial_w    := PKG_DATE_UTILS.get_datetime(clock_timestamp(), hr_inicial_p);
    dt_new_final_w      := PKG_DATE_UTILS.get_datetime(clock_timestamp(), hr_final_p);

    if (dt_new_final_w <= dt_new_initial_w) then
		ie_possui_w := '1161945';
        goto finalize;
    end if;

     if (PKG_DATE_UTILS.get_datetime(coalesce(dt_final_vigencia_p,clock_timestamp()), hr_final_p) <= PKG_DATE_UTILS.get_datetime(coalesce(dt_inicio_vigencia_p,clock_timestamp()), hr_inicial_p)) then
		ie_possui_w := '1161945';
        goto finalize;
    end if;

    if (coalesce(qt_amount_p, 0) < 1) then
        ie_possui_w := '1161948';
        goto finalize;
    end if;

    EXECUTE
    'select  nvl(max(''S''), ''N'')
     from    ' || nm_tabela_p ||
    ' where   nr_sequencia = :nr_seq_parent_p
      and     :dt_new_initial_w >= PKG_DATE_UTILS.get_datetime(sysdate, hr_inicial)
      and     :dt_new_final_w <= PKG_DATE_UTILS.get_datetime(sysdate, hr_final)
      and     (dt_inicio_vigencia is null or nvl(:dt_inicio_vigencia_p,sysdate) >= nvl(dt_inicio_vigencia,sysdate))
      and     (dt_final_vigencia is null or nvl(:dt_final_vigencia_p,sysdate) <= nvl(dt_final_vigencia,sysdate))'
      into STRICT    ie_data_exist_w
      using   nr_seq_parent_p, dt_new_initial_w, dt_new_final_w, dt_inicio_vigencia_p, dt_final_vigencia_p;

    if (ie_data_exist_w = 'N') then
        ie_possui_w := '1161946';
        goto finalize;
    end if;

    select  coalesce(max('S'), 'N')
    into STRICT    ie_data_exist_w
    from    agenda_turno_rules
    where   ((lower(nm_tabela_p) = 'agenda_horario' and nr_seq_horario  = nr_seq_parent_p) or (lower(nm_tabela_p) = 'agenda_turno' and nr_seq_age_turno  = nr_seq_parent_p))
    and     nr_sequencia != nr_sequencia_p
    and     ((PKG_DATE_UTILS.get_datetime(clock_timestamp(), hr_inicial) <= dt_new_initial_w
            and dt_new_initial_w < PKG_DATE_UTILS.get_datetime(clock_timestamp(), hr_final)
            and dt_inicio_vigencia_p between dt_inicio_vigencia and dt_final_vigencia)
        or (PKG_DATE_UTILS.get_datetime(clock_timestamp(), hr_inicial) < dt_new_final_w
            and dt_new_final_w < PKG_DATE_UTILS.get_datetime(clock_timestamp(), hr_final)
            and dt_final_vigencia_p between dt_inicio_vigencia and dt_final_vigencia));

    if (ie_data_exist_w = 'S') then
        ie_possui_w := '1161947';
    end if;

    <<finalize>>

return ie_possui_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION validate_agenda_turno_rules ( nm_tabela_p text, nr_seq_parent_p bigint, nr_sequencia_p bigint, qt_amount_p bigint, hr_inicial_p timestamp, hr_final_p timestamp, dt_inicio_vigencia_p timestamp, dt_final_vigencia_p timestamp) FROM PUBLIC;
