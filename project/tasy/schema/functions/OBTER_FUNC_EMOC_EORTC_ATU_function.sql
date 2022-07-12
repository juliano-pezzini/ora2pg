-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_func_emoc_eortc_atu (IE_TENSO_P bigint, IE_PREOCUPADO_P bigint, IE_IRRITADO_P bigint, IE_DEPRIMIDO_P bigint ) RETURNS bigint AS $body$
DECLARE


   qt_bruto_ef_w	double precision := 0;

BEGIN
    --- Inicio MD 4
    qt_bruto_ef_w	:= (coalesce(IE_TENSO_P,0)      + 
                      coalesce(IE_PREOCUPADO_P,0) + 
                      coalesce(IE_IRRITADO_P,0)   + 
                      coalesce(IE_DEPRIMIDO_P,0)) / 4;

    qt_bruto_ef_w  	:= 	(1 - (coalesce(qt_bruto_ef_w,0) - 1) / 3) * 100;
    --- Fim MD 4
    RETURN coalesce(qt_bruto_ef_w,0);
   
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_func_emoc_eortc_atu (IE_TENSO_P bigint, IE_PREOCUPADO_P bigint, IE_IRRITADO_P bigint, IE_DEPRIMIDO_P bigint ) FROM PUBLIC;
