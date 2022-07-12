-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION obter_valores_aval_ped_md_pck.obter_gasto_ener_repouso_md (ie_sexo_p text, qt_peso_atual_p bigint, qt_altura_p bigint, qt_altura_estimada_p bigint, qt_idade_p bigint ) RETURNS bigint AS $body$
DECLARE

	   qt_gasto_ener_repouso_w bigint;
	
BEGIN
		if (ie_sexo_p = 'M') then
			qt_gasto_ener_repouso_w	:= 66.5 + (13.7 * qt_peso_atual_p) + (5 * coalesce(qt_altura_p,qt_altura_estimada_p)) - (6.8 * qt_idade_p);
		elsif (ie_sexo_p = 'F') then
			qt_gasto_ener_repouso_w	:= 665 + (9.6 * qt_peso_atual_p) + (1.9 * coalesce(qt_altura_p,qt_altura_estimada_p)) - (4.7 * qt_idade_p);	
		end if;

		return qt_gasto_ener_repouso_w;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valores_aval_ped_md_pck.obter_gasto_ener_repouso_md (ie_sexo_p text, qt_peso_atual_p bigint, qt_altura_p bigint, qt_altura_estimada_p bigint, qt_idade_p bigint ) FROM PUBLIC;
