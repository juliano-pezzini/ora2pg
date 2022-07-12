-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION search_panorama_content.get_adjusted_missing_data (nr_value_p bigint) RETURNS varchar AS $body$
BEGIN

  if (coalesce(nr_value_p::text, '') = '' or nr_value_p = 0) then
    return '--';
  else
    return substr(nr_value_p, 1);
  end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION search_panorama_content.get_adjusted_missing_data (nr_value_p bigint) FROM PUBLIC;
