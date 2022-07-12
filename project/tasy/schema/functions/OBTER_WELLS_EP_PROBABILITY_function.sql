-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_wells_ep_probability ( qt_score_p bigint) RETURNS bigint AS $body$
DECLARE

  ds_retorno_w varchar(255);

BEGIN
IF (qt_score_p    < 2) THEN
	ds_retorno_w    := 1.3;
  elsif (qt_score_p >= 2) AND (qt_score_p <=6) THEN
	ds_retorno_w    := 16.2;
  elsif (qt_score_p  > 6) THEN
	ds_retorno_w    := 37.5;
  END IF;
RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_wells_ep_probability ( qt_score_p bigint) FROM PUBLIC;

