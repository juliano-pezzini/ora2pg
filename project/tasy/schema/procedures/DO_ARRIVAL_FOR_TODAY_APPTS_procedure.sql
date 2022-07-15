-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE do_arrival_for_today_appts (cd_pessoa_fisica_p text) AS $body$
DECLARE


c_appointments_not_arrived CURSOR FOR
  SELECT  v.cd_agenda, v.nr_sequencia
  FROM    scheduling_check_today_appts_v v
  WHERE   v.ie_status_agenda IN ('N', 'CN')
  AND     v.cd_pessoa_fisica = cd_pessoa_fisica_p;

BEGIN
  CALL wheb_usuario_pck.set_ie_commit('N');

  FOR reg IN c_appointments_not_arrived LOOP
    CALL do_arrival_for_appointment(reg.cd_agenda, reg.nr_sequencia);
  END LOOP;

  COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE do_arrival_for_today_appts (cd_pessoa_fisica_p text) FROM PUBLIC;

