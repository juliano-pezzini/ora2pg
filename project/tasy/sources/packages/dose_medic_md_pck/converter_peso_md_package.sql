-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION dose_medic_md_pck.converter_peso_md (qt_peso_p bigint, ie_peso_p text) RETURNS bigint AS $body$
DECLARE

    qt_peso_w double precision;

BEGIN
    qt_peso_w := qt_peso_p;
		if (ie_peso_p = 'G') then
		  qt_peso_w := coalesce(qt_peso_p, 0) * 1000;
		end if;
    return qt_peso_w;
  end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION dose_medic_md_pck.converter_peso_md (qt_peso_p bigint, ie_peso_p text) FROM PUBLIC;
