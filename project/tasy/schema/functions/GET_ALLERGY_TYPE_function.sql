-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_allergy_type (NR_SEQ_TIPO_ALERGIA_P bigint) RETURNS varchar AS $body$
DECLARE

  LV_ALERGY_W varchar(50);
  ALERGY RECORD;

BEGIN
  FOR ALERGY IN (SELECT * FROM TIPO_ALERGIA WHERE nr_sequencia = NR_SEQ_TIPO_ALERGIA_P) LOOP
    IF (ALERGY.ds_tipo_alergia IS NOT NULL AND ALERGY.ds_tipo_alergia::text <> '') THEN
      LV_ALERGY_W := alergy.ds_tipo_alergia;
    END IF;
  END LOOP;
  RETURN(LV_ALERGY_W);
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_allergy_type (NR_SEQ_TIPO_ALERGIA_P bigint) FROM PUBLIC;
