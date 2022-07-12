-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_pck_dynamic_cards.get_detail_parameters_list (nr_seq_indicator_p bigint, cd_default_alias_p text default '', ie_dynamic_tablechart_p text default PFCS_PCK_CONSTANTS.IE_NO) RETURNS varchar AS $body$
DECLARE

        cur_parameters CURSOR FOR
        SELECT  p.ds_column,
                p.ds_parameter
        from    pfcs_indicator i,
                pfcs_indicator_param p
        where   i.nr_sequencia = nr_seq_indicator_p
        and     p.nr_seq_indicator = i.nr_sequencia;

        json_item_w         PHILIPS_JSON := PHILIPS_JSON();
        json_list_w         PHILIPS_JSON_LIST := PHILIPS_JSON_LIST();

BEGIN
        for c01_w in cur_parameters loop
            json_item_w.put('VL_PARAMETER', cd_default_alias_p||c01_w.ds_column);
            json_item_w.put('DS_PARAMETER', c01_w.ds_parameter);
            json_list_w.append(json_item_w.to_json_value());
        end loop;

        if (ie_dynamic_tablechart_p = PFCS_PCK_CONSTANTS.IE_YES) then
            return pfcs_pck_dynamic_charts.json_utils_replace(json_list_w.to_char());
        end if;
        return json_list_w.to_char();
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION pfcs_pck_dynamic_cards.get_detail_parameters_list (nr_seq_indicator_p bigint, cd_default_alias_p text default '', ie_dynamic_tablechart_p text default PFCS_PCK_CONSTANTS.IE_NO) FROM PUBLIC;