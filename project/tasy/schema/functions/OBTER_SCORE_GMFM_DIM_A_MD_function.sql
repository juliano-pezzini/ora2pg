-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_gmfm_dim_a_md ( ie_item_1_p bigint, ie_item_2_p bigint, ie_item_3_p bigint, ie_item_4_p bigint, ie_item_5_p bigint, ie_item_6_p bigint, ie_item_7_p bigint, ie_item_8_p bigint, ie_item_9_p bigint, ie_item_10_p bigint, ie_item_11_p bigint, ie_item_12_p bigint, ie_item_13_p bigint, ie_item_14_p bigint, ie_item_15_p bigint, ie_item_16_p bigint, ie_item_17_p bigint ) RETURNS bigint AS $body$
DECLARE

    qt_dimensao_a_w bigint := 0;

BEGIN
    qt_dimensao_a_w := (coalesce(ie_item_1_p,0) + coalesce(ie_item_2_p,0) + coalesce(ie_item_3_p,0) + coalesce(ie_item_4_p,0) +
                        coalesce(ie_item_5_p,0) + coalesce(ie_item_6_p,0) + coalesce(ie_item_7_p,0) + coalesce(ie_item_8_p,0) + 
                        coalesce(ie_item_9_p,0) + coalesce(ie_item_10_p,0) + coalesce(ie_item_11_p,0) + coalesce(ie_item_12_p,0) + 
                        coalesce(ie_item_13_p,0) + coalesce(ie_item_14_p,0) + coalesce(ie_item_15_p,0) + coalesce(ie_item_16_p,0) + 
                        coalesce(ie_item_17_p,0));

    return qt_dimensao_a_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_gmfm_dim_a_md ( ie_item_1_p bigint, ie_item_2_p bigint, ie_item_3_p bigint, ie_item_4_p bigint, ie_item_5_p bigint, ie_item_6_p bigint, ie_item_7_p bigint, ie_item_8_p bigint, ie_item_9_p bigint, ie_item_10_p bigint, ie_item_11_p bigint, ie_item_12_p bigint, ie_item_13_p bigint, ie_item_14_p bigint, ie_item_15_p bigint, ie_item_16_p bigint, ie_item_17_p bigint ) FROM PUBLIC;
