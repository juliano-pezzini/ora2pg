-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_pck_dynamic_charts.check_column_name (nm_column_p text) RETURNS varchar AS $body$
DECLARE

        ds_column_name_w pfcs_card_indicator.nm_first_column%type;

BEGIN
        ds_column_name_w := case when (nm_column_p IS NOT NULL AND nm_column_p::text <> '') then current_setting('pfcs_pck_dynamic_charts.cd_default_alias_w')::varchar(2) || '.' || nm_column_p else 'null' end;
        return ds_column_name_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION pfcs_pck_dynamic_charts.check_column_name (nm_column_p text) FROM PUBLIC;