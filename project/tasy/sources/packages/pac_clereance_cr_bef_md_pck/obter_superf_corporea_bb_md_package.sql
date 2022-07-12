-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pac_clereance_cr_bef_md_pck.obter_superf_corporea_bb_md (qt_altura_cm_p bigint, qt_peso_p bigint, ie_formula_sup_corporea_p text, nr_dec_sc_p bigint ) RETURNS bigint AS $body$
DECLARE

		qt_superf_corporea_bb_w	 double precision;
	
BEGIN
		--- Inicio MD6
		qt_superf_corporea_bb_w := OBTER_SUPERFICIE_CORPOREA_MD(qt_altura_cm_p,qt_peso_p,ie_formula_sup_corporea_p,nr_dec_sc_p);
		--- Fim MD6
		return qt_superf_corporea_bb_w;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pac_clereance_cr_bef_md_pck.obter_superf_corporea_bb_md (qt_altura_cm_p bigint, qt_peso_p bigint, ie_formula_sup_corporea_p text, nr_dec_sc_p bigint ) FROM PUBLIC;
