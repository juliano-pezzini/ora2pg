-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_pck_dynamic_charts.get_ds_column_color (nm_column_p text, nr_seq_wcpanel_p bigint) RETURNS varchar AS $body$
DECLARE

        ds_column_color_name_w  dic_objeto.nm_campo_base%type;
        ds_color_sufix_w        constant PFCS_PCK_SUBTYPES.VARCHAR_6_T := '_COLOR';

BEGIN
        select  max(o.nm_campo_base)
        into STRICT    ds_column_color_name_w
        from    dic_objeto o
        where   o.nr_seq_obj_sup = nr_seq_wcpanel_p
        and     o.nm_campo_base = concat(nm_column_p,ds_color_sufix_w);

        return ds_column_color_name_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION pfcs_pck_dynamic_charts.get_ds_column_color (nm_column_p text, nr_seq_wcpanel_p bigint) FROM PUBLIC;
