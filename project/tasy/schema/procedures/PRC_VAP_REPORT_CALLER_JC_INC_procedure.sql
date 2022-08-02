-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE prc_vap_report_caller_jc_inc ( start_date_p timestamp, end_date_p timestamp, age_p bigint, cd_setor_p text) AS $body$
BEGIN
  INSERT INTO W_VAP_REPORT_LOG(
    nr_sequencia,
    dt_inicio,
    dt_fim, 
    nr_idade, 
    cd_setor, 
    ie_protocolo,
    ie_incidencia,
    nm_usuario) 
  VALUES (
    nextval('w_vap_report_log_seq'), start_date_p, end_date_p, coalesce(age_p, 0), coalesce(cd_setor_p, '0'), 'J', 'S', wheb_usuario_pck.get_nm_usuario);
  --
  COMMIT;
  --
  CALL PKG_VAP_REPORT.RUN(start_date_p, end_date_p, coalesce(age_p, 0), coalesce(cd_setor_p, '0'), 'J', 'S');
  --
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE prc_vap_report_caller_jc_inc ( start_date_p timestamp, end_date_p timestamp, age_p bigint, cd_setor_p text) FROM PUBLIC;

