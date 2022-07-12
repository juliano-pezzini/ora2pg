-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION obter_valores_aval_ped_md_pck.obter_relacao_cint_quadri_md (qt_circ_quadril_p bigint, qt_circ_cintura_p bigint ) RETURNS bigint AS $body$
DECLARE

		qt_razao_cintura_quadril_w bigint;
	
BEGIN
		if (qt_circ_quadril_p IS NOT NULL AND qt_circ_quadril_p::text <> '') and (qt_circ_cintura_p IS NOT NULL AND qt_circ_cintura_p::text <> '')then
			qt_razao_cintura_quadril_w	:= dividir_md(qt_circ_cintura_p,qt_circ_quadril_p);
		end if;

		return qt_razao_cintura_quadril_w;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valores_aval_ped_md_pck.obter_relacao_cint_quadri_md (qt_circ_quadril_p bigint, qt_circ_cintura_p bigint ) FROM PUBLIC;
