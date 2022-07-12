-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_ie_general_name_jp ( cd_material_p CPOE_MATERIAL.CD_MATERIAL%type default 0, nr_seq_cpoe_order_unit_p CPOE_MATERIAL.NR_SEQ_CPOE_ORDER_UNIT%type DEFAULT NULL, ie_validate_locale_p text default 'N') RETURNS varchar AS $body$
DECLARE


ds_retorno_w    varchar(400);
ds_sql_w        varchar(5000);


BEGIN
    ds_sql_w := ' SELECT CASE WHEN ';

    IF (ie_validate_locale_p IS NOT NULL AND ie_validate_locale_p::text <> '') AND ie_validate_locale_p = 'S' THEN
        ds_sql_w := ds_sql_w || ' pkg_i18n.get_user_locale = ''ja_JP'' AND ';
    END IF;

    IF coalesce(cd_material_p::text, '') = '' OR cd_material_p = 0 THEN
        ds_sql_w := ds_sql_w || ' ( SELECT  max(uni.SI_GENERAL_NAME_TYPE) FROM CPOE_ORDER_UNIT uni WHERE uni.NR_SEQUENCIA = ' || to_char(nr_seq_cpoe_order_unit_p) || ' ) = ''G'' ';
    ELSE
        ds_sql_w := ds_sql_w || ' ( SELECT  max(uni.SI_GENERAL_NAME_TYPE) FROM CPOE_ORDER_UNIT uni, CPOE_MATERIAL mat WHERE mat.NR_SEQ_CPOE_ORDER_UNIT = uni.NR_SEQUENCIA AND mat.CD_MATERIAL = ' || to_char(cd_material_p) || ' ) = ''G'' ';
    END IF;

    ds_sql_w := ds_sql_w || ' THEN ''S'' ELSE ''N'' END';
    ds_sql_w := ds_sql_w || ' FROM dual';

    EXECUTE ds_sql_w into STRICT ds_retorno_w;
    RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_ie_general_name_jp ( cd_material_p CPOE_MATERIAL.CD_MATERIAL%type default 0, nr_seq_cpoe_order_unit_p CPOE_MATERIAL.NR_SEQ_CPOE_ORDER_UNIT%type DEFAULT NULL, ie_validate_locale_p text default 'N') FROM PUBLIC;

