-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_func_cogni_eortc_atu (IE_DIF_CONCENTRAR_P bigint, IE_DIF_LEMBRAR_P bigint ) RETURNS bigint AS $body$
DECLARE


   qt_bruto_cf_w	double precision := 0;

BEGIN
	--- Inicio MD 5
	qt_bruto_cf_w	:= 	(coalesce(IE_DIF_CONCENTRAR_P,0) + coalesce(IE_DIF_LEMBRAR_P,0)) / 2;
	qt_bruto_cf_w	:= 	(1 - (coalesce(qt_bruto_cf_w,0) - 1) / 3) * 100;
	--- Fim MD 5
    RETURN coalesce(qt_bruto_cf_w,0);
   
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_func_cogni_eortc_atu (IE_DIF_CONCENTRAR_P bigint, IE_DIF_LEMBRAR_P bigint ) FROM PUBLIC;
