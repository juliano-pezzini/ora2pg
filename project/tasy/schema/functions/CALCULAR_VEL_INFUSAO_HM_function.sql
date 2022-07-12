-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION calcular_vel_infusao_hm (qt_volume_p bigint, qt_tempo_p bigint) RETURNS bigint AS $body$
DECLARE


qt_vel_infusao_w		double precision;
qt_tempo_w			double precision;


BEGIN

qt_tempo_w		:= dividir(qt_tempo_p,60);
qt_vel_infusao_w        := trim(Dividir(Dividir((Round(qt_volume_p) * 20) ,
	                                             qt_tempo_w) , 60));

return	qt_vel_infusao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION calcular_vel_infusao_hm (qt_volume_p bigint, qt_tempo_p bigint) FROM PUBLIC;
