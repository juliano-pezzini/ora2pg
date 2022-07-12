-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE range AS (range bigint[200]);


CREATE OR REPLACE FUNCTION obter_risco_escala_crusade_md ( qt_score_p bigint ) RETURNS bigint AS $body$
DECLARE

  range_w    range;

BEGIN
  range_w := range(2.5,2.6,2.7,2.8,2.9,3,3.1,3.2,3.3,3.4,3.5,3.6,3.8,3.9,4,4.1,4.3,4.4,4.6,4.7,
				   4.9,5,5.2,5.4,5.6,5.7,5.9,6.1,6.3,6.5,6.7,6.9,7.2,7.4,7.6,7.9,8.1,8.4,8.6,8.9, 
				   9.2,9.5,9.8,10.1,10.4,10.7,11.1,11.4,11.7,12.1,12.5,12.8,13.2,13.6,14,14.4,14.9, 
				   15.3,15.7,16.2,16.7,17.1,17.6,18.1,18.6,19.2,19.7,20.2,20.8,21.4,21.9,22.5,23.1, 
				   23.7,24.4,25,25.6,26.3,27,27.6,28.3,29,29.7,30.4,31.2,31.9,32.6,33.4,34.2,34.9, 
				   35.7,36.5,37.3,38.1,38.9,39.7,40.5,41.3,42.2,43,43.8);

  return range_w(qt_score_p + 1);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_risco_escala_crusade_md ( qt_score_p bigint ) FROM PUBLIC;
