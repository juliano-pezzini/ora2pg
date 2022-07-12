-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_gmfm_dim_e_md ( ie_item_65_p bigint, ie_item_66_p bigint, ie_item_67_p bigint, ie_item_68_p bigint, ie_item_69_p bigint, ie_item_70_p bigint, ie_item_71_p bigint, ie_item_72_p bigint, ie_item_73_p bigint, ie_item_74_p bigint, ie_item_75_p bigint, ie_item_76_p bigint, ie_item_77_p bigint, ie_item_78_p bigint, ie_item_79_p bigint, ie_item_80_p bigint, ie_item_81_p bigint, ie_item_82_p bigint, ie_item_83_p bigint, ie_item_84_p bigint, ie_item_85_p bigint, ie_item_86_p bigint, ie_item_87_p bigint, ie_item_88_p bigint ) RETURNS bigint AS $body$
DECLARE

    qt_dimensao_e_w bigint := 0;

BEGIN
    qt_dimensao_e_w := (coalesce(ie_item_65_p,0) + coalesce(ie_item_66_p,0) + coalesce(ie_item_67_p,0) + coalesce(ie_item_68_p,0) +
                        coalesce(ie_item_69_p,0) + coalesce(ie_item_70_p,0) + coalesce(ie_item_71_p,0) + coalesce(ie_item_72_p,0) + 
                        coalesce(ie_item_73_p,0) + coalesce(ie_item_74_p,0) + coalesce(ie_item_75_p,0) + coalesce(ie_item_76_p,0) + 
                        coalesce(ie_item_77_p,0) + coalesce(ie_item_78_p,0) + coalesce(ie_item_79_p,0) + coalesce(ie_item_80_p,0) + 
                        coalesce(ie_item_81_p,0) + coalesce(ie_item_82_p,0) + coalesce(ie_item_83_p,0) + coalesce(ie_item_84_p,0) +
                        coalesce(ie_item_85_p,0) + coalesce(ie_item_86_p,0) + coalesce(ie_item_87_p,0) + coalesce(ie_item_88_p,0));

     return qt_dimensao_e_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_gmfm_dim_e_md ( ie_item_65_p bigint, ie_item_66_p bigint, ie_item_67_p bigint, ie_item_68_p bigint, ie_item_69_p bigint, ie_item_70_p bigint, ie_item_71_p bigint, ie_item_72_p bigint, ie_item_73_p bigint, ie_item_74_p bigint, ie_item_75_p bigint, ie_item_76_p bigint, ie_item_77_p bigint, ie_item_78_p bigint, ie_item_79_p bigint, ie_item_80_p bigint, ie_item_81_p bigint, ie_item_82_p bigint, ie_item_83_p bigint, ie_item_84_p bigint, ie_item_85_p bigint, ie_item_86_p bigint, ie_item_87_p bigint, ie_item_88_p bigint ) FROM PUBLIC;

