-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_result_pont_meld_md ( ie_realiza_dialise_p text, vl_result_creat_p INOUT bigint, vl_result_rni_p INOUT bigint, vl_result_bil_p INOUT bigint, vl_result_albumina_p INOUT bigint ) AS $body$
BEGIN

  IF (ie_realiza_dialise_p = 'S') or (vl_result_creat_p > 4) THEN
    vl_result_creat_p  := 4;
  END IF;
  IF (vl_result_creat_p < 1) THEN
    vl_result_creat_p  := 1;
  END IF;
  IF (vl_result_rni_p < 1) then
    vl_result_rni_p    := 1;
  END IF;
  IF (vl_result_bil_p < 1) THEN
    vl_result_bil_p    := 1;
  END IF;
  IF (vl_result_albumina_p < 1) THEN
    vl_result_albumina_p := 1;
  END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_result_pont_meld_md ( ie_realiza_dialise_p text, vl_result_creat_p INOUT bigint, vl_result_rni_p INOUT bigint, vl_result_bil_p INOUT bigint, vl_result_albumina_p INOUT bigint ) FROM PUBLIC;

