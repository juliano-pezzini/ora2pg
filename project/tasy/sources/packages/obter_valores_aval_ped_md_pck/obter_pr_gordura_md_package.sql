-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION obter_valores_aval_ped_md_pck.obter_pr_gordura_md (qt_prega_cut_tricip_p bigint, qt_prega_cut_suprailiaca_p bigint, qt_prega_cut_subesc_p bigint, qt_prega_cut_abd_p bigint ) RETURNS bigint AS $body$
DECLARE

	   pr_gordura_w bigint;
	
BEGIN
		if (qt_prega_cut_tricip_p IS NOT NULL AND qt_prega_cut_tricip_p::text <> '') and (qt_prega_cut_suprailiaca_p IS NOT NULL AND qt_prega_cut_suprailiaca_p::text <> '') and (qt_prega_cut_subesc_p IS NOT NULL AND qt_prega_cut_subesc_p::text <> '') and (qt_prega_cut_abd_p IS NOT NULL AND qt_prega_cut_abd_p::text <> '') then
			pr_gordura_w := ((qt_prega_cut_tricip_p + qt_prega_cut_suprailiaca_p + qt_prega_cut_subesc_p + qt_prega_cut_abd_p ) * 0.153) + 5.783;
		end if;

		return pr_gordura_w;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valores_aval_ped_md_pck.obter_pr_gordura_md (qt_prega_cut_tricip_p bigint, qt_prega_cut_suprailiaca_p bigint, qt_prega_cut_subesc_p bigint, qt_prega_cut_abd_p bigint ) FROM PUBLIC;