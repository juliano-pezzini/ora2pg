-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estglosau_qv_e_eortc_atu (IE_CLASSIF_SAUDE_P bigint, IE_CLASSIF_QUALIDADE_VIDA_P bigint ) RETURNS bigint AS $body$
DECLARE


   qt_bruto_ql2_w	double precision := 0;

BEGIN
	--- Inicio MD 1
	qt_bruto_ql2_w  := 	((coalesce(IE_CLASSIF_SAUDE_P,0) + coalesce(IE_CLASSIF_QUALIDADE_VIDA_P,0)) / 2);
	qt_bruto_ql2_w  := 	(((coalesce(qt_bruto_ql2_w,0) - 1) / 6) * 100);
	--- Fim MD 1
    RETURN coalesce(qt_bruto_ql2_w,0);
   
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estglosau_qv_e_eortc_atu (IE_CLASSIF_SAUDE_P bigint, IE_CLASSIF_QUALIDADE_VIDA_P bigint ) FROM PUBLIC;

