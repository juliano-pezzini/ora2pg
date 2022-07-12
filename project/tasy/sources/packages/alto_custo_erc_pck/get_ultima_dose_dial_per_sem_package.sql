-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_erc_pck.get_ultima_dose_dial_per_sem ( cd_pessoa_fisica_p text ) RETURNS bigint AS $body$
DECLARE

         ds_retorno_w hd_dialise_peritonial.qt_ktv%type;

BEGIN
        begin
            select qt_ktv
            into STRICT    ds_retorno_w
            from (
                SELECT  a.qt_ktv qt_ktv
                from    hd_dialise_peritonial a
                where   a.cd_pessoa_fisica = cd_pessoa_fisica_p
				and 	trunc(a.dt_dialise_peritonial) >= add_months(trunc(alto_custo_pck.get_data_corte), -6)
				and     trunc(a.dt_dialise_peritonial) <= trunc(alto_custo_pck.get_data_corte)
                order by a.dt_dialise_peritonial  desc) alias5 LIMIT 1;
        exception
            when no_data_found then
                ds_retorno_w := 98;
        end;

      return ds_retorno_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION alto_custo_erc_pck.get_ultima_dose_dial_per_sem ( cd_pessoa_fisica_p text ) FROM PUBLIC;