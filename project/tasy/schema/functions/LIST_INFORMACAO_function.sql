-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION list_informacao ( nr_prescricao_p bigint ) RETURNS varchar AS $body$
DECLARE


    retorno_list   varchar(4000) := null;


  ds_w RECORD;

BEGIN

    if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
        for ds_w in (SELECT a.ds_informacao
            from    prescr_proced_inf_adic a
            where   a.nr_prescricao = nr_prescricao_p
            and     (a.ds_informacao IS NOT NULL AND a.ds_informacao::text <> '')
            order by a.nr_sequencia)
        loop
            retorno_list := SUBSTR(ds_w.ds_informacao||chr(10)||retorno_list, 1, 4000);
        end loop;
    end if;

    RETURN retorno_list;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION list_informacao ( nr_prescricao_p bigint ) FROM PUBLIC;

