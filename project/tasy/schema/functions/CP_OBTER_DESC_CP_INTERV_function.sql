-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cp_obter_desc_cp_interv ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

  ds_retorno_w   varchar(2000);

BEGIN
  BEGIN
    SELECT ds_display_name
    INTO STRICT ds_retorno_w
    FROM cp_intervention
    WHERE nr_sequencia = nr_sequencia_p;
  EXCEPTION
  WHEN OTHERS THEN
    ds_retorno_w := '';
  END;
RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cp_obter_desc_cp_interv ( nr_sequencia_p bigint) FROM PUBLIC;

