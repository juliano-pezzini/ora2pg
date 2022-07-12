-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_min_intervalo_prescr_md ( qt_hora_intervalo_p bigint, qt_min_intervalo_p bigint ) RETURNS bigint AS $body$
DECLARE


    qt_min_intervalo_w		double precision;


BEGIN

    qt_min_intervalo_w := ( coalesce(qt_hora_intervalo_p, 0) * 60 ) + coalesce(qt_min_intervalo_p, 0);

    RETURN qt_min_intervalo_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_min_intervalo_prescr_md ( qt_hora_intervalo_p bigint, qt_min_intervalo_p bigint ) FROM PUBLIC;
