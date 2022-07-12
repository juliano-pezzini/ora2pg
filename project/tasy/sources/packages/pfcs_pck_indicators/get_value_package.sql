-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_pck_indicators.get_value ( nr_seq_indicator_p bigint, cd_establishment_p bigint, ds_department_p text default null, cd_unit_p bigint default null) RETURNS bigint AS $body$
DECLARE

        vl_return_w     pfcs_panel.vl_indicator%type := 0;

BEGIN
        if (nr_seq_indicator_p IS NOT NULL AND nr_seq_indicator_p::text <> '') then
            vl_return_w := pfcs_pck_indicators.get_indicator_value(nr_seq_indicator_p, cd_establishment_p, ds_department_p, cd_unit_p);
        end if;

        return vl_return_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pfcs_pck_indicators.get_value ( nr_seq_indicator_p bigint, cd_establishment_p bigint, ds_department_p text default null, cd_unit_p bigint default null) FROM PUBLIC;