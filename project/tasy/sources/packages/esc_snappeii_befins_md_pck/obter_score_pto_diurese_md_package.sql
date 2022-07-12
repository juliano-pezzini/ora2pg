-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION esc_snappeii_befins_md_pck.obter_score_pto_diurese_md (QT_PESO_P bigint, qt_peso_atual_p bigint, qt_diurese_p bigint ) RETURNS bigint AS $body$
DECLARE

		qt_peso_atual_kg_w	double precision;
		qt_diurese_w		double precision;
		qt_pto_diurese_w    bigint;
	
BEGIN
		qt_peso_atual_kg_w := dividir_md(coalesce(QT_PESO_P,qt_peso_atual_p), 1000);
		qt_diurese_w	   := dividir_md(qt_diurese_p, qt_peso_atual_kg_w);
		qt_diurese_w		:= dividir_md(qt_diurese_w,12);

		if (qt_diurese_p IS NOT NULL AND qt_diurese_p::text <> '') and (qt_diurese_w < 0.1) then
			qt_pto_diurese_w:= 18;
		elsif (qt_diurese_w >= 0.1) and (qt_diurese_w <= 0.9) then
			qt_pto_diurese_w:= 5;
		elsif (qt_diurese_w >= 1) then
			qt_pto_diurese_w:= 0;
		elsif (coalesce(qt_diurese_p::text, '') = '') then
			qt_pto_diurese_w:= 0;
		end if;

		return coalesce(qt_pto_diurese_w,0);
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION esc_snappeii_befins_md_pck.obter_score_pto_diurese_md (QT_PESO_P bigint, qt_peso_atual_p bigint, qt_diurese_p bigint ) FROM PUBLIC;