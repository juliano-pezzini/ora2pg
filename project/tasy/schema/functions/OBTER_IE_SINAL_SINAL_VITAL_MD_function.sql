-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ie_sinal_sinal_vital_md (qt_min_aviso_p bigint, qt_max_aviso_p bigint, qt_minimo_per_p bigint, vl_maximo_per_p bigint, vl_item_p bigint ) RETURNS varchar AS $body$
DECLARE


   ie_sinal_w varchar(1);

BEGIN
	--INICIO MD 2
	if	((qt_min_aviso_p = 0) and (qt_max_aviso_p = 0) and (qt_minimo_per_p = 0) and (vl_maximo_per_p = 0)) or ((vl_item_p = 0) or (vl_item_p between qt_min_aviso_p and qt_max_aviso_p)) then
		ie_sinal_w	:= 'N';
	elsif	((qt_minimo_per_p > 0) or (vl_maximo_per_p > 0)) and
		((qt_min_aviso_p > 0) or (qt_max_aviso_p > 0)) and (not(vl_item_p between qt_minimo_per_p and vl_maximo_per_p)) then
		ie_sinal_w	:= 'E';
	elsif	((qt_minimo_per_p > 0) or (vl_maximo_per_p > 0)) and
		((qt_min_aviso_p > 0) or (qt_max_aviso_p > 0)) and (not(vl_item_p between qt_min_aviso_p and qt_max_aviso_p)) then
		ie_sinal_w	:= 'A';
	elsif (qt_minimo_per_p = 0) and (vl_maximo_per_p = 0) and
		((qt_min_aviso_p > 0) or (qt_max_aviso_p > 0)) and (not(vl_item_p between qt_min_aviso_p and qt_max_aviso_p)) then	
		ie_sinal_w	:= 'A';
	elsif (qt_min_aviso_p = 0) and (qt_max_aviso_p = 0) and
		((qt_minimo_per_p > 0) or (vl_maximo_per_p > 0)) and (not(vl_item_p between qt_minimo_per_p and vl_maximo_per_p)) then
		ie_sinal_w	:= 'E';
	elsif (not(vl_item_p between qt_minimo_per_p and vl_maximo_per_p)) then
		ie_sinal_w	:= 'E';
	else
		ie_sinal_w	:= 'N';
	end if;
	--FIM MD 2
    RETURN ie_sinal_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ie_sinal_sinal_vital_md (qt_min_aviso_p bigint, qt_max_aviso_p bigint, qt_minimo_per_p bigint, vl_maximo_per_p bigint, vl_item_p bigint ) FROM PUBLIC;

