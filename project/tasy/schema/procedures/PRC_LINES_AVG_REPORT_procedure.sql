-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE prc_lines_avg_report (dt_inicio_p timestamp, dt_fim_p timestamp, cd_unidade_p text) AS $body$
BEGIN
  -- Call the procedure
  CALL pck_lines_average_report.get_data_generate(dt_ini_p => dt_inicio_p,
                                 dt_fim_p => dt_fim_p,
                                 cd_unidade_p => cd_unidade_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE prc_lines_avg_report (dt_inicio_p timestamp, dt_fim_p timestamp, cd_unidade_p text) FROM PUBLIC;

