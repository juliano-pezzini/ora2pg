-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_cancer_pck.get_dt_first_surgery (cd_pessoa_fisica_p text) RETURNS timestamp AS $body$
DECLARE


        ds_retorno_w			timestamp;


BEGIN

        select  min(dt_inicio_real)
        into STRICT    ds_retorno_w
        from    cirurgia
        where   cd_pessoa_fisica = cd_pessoa_fisica_p
        and     ie_status_cirurgia in (2,4)
        and     (dt_fim_cirurgia IS NOT NULL AND dt_fim_cirurgia::text <> '');

      return ds_retorno_w;

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION alto_custo_cancer_pck.get_dt_first_surgery (cd_pessoa_fisica_p text) FROM PUBLIC;