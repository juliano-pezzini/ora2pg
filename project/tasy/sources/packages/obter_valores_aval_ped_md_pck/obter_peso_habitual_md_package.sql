-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION obter_valores_aval_ped_md_pck.obter_peso_habitual_md (qt_altura_p bigint, qt_50_p bigint ) RETURNS bigint AS $body$
DECLARE

		qt_peso_habit_w bigint;
	
BEGIN
		qt_peso_habit_w := coalesce(trunc(((dividir_sem_round((qt_altura_p )::numeric, 100)) * (dividir_sem_round((qt_altura_p )::numeric, 100))) * qt_50_p,3),0);

		return qt_peso_habit_w;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valores_aval_ped_md_pck.obter_peso_habitual_md (qt_altura_p bigint, qt_50_p bigint ) FROM PUBLIC;
