-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_pck_los.get_description (vl_los_remaining_p bigint) RETURNS varchar AS $body$
DECLARE

        ds_return_w varchar(50);
        ds_hours_w varchar(10) := obter_desc_expressao(1060804);

BEGIN
        if (vl_los_remaining_p < 1) then
            ds_return_w := ('<24 ' || ds_hours_w);
        elsif (vl_los_remaining_p < 2) then
            ds_return_w := ('<48 ' || ds_hours_w);
        elsif (vl_los_remaining_p >= 2) then
            ds_return_w := ('>=48 ' || ds_hours_w);
        end if;
        RETURN ds_return_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pfcs_pck_los.get_description (vl_los_remaining_p bigint) FROM PUBLIC;