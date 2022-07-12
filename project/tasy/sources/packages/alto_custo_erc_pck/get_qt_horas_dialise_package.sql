-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_erc_pck.get_qt_horas_dialise ( cd_pessoa_fisica_p text ) RETURNS bigint AS $body$
DECLARE

         ds_retorno_w bigint;

BEGIN
        select  sum(trunc((dt_fim_dialise - dt_inicio_dialise) * 24))
        into STRICT    ds_retorno_w
        from    hd_dialise
        where   cd_pessoa_fisica = cd_pessoa_fisica_p
		and 	trunc(dt_inicio_dialise) >= add_months(trunc(alto_custo_pck.get_data_corte), -3)
		and     trunc(dt_inicio_dialise) <= trunc(alto_custo_pck.get_data_corte)
        and     (dt_fim_dialise IS NOT NULL AND dt_fim_dialise::text <> '');

      return ds_retorno_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION alto_custo_erc_pck.get_qt_horas_dialise ( cd_pessoa_fisica_p text ) FROM PUBLIC;
