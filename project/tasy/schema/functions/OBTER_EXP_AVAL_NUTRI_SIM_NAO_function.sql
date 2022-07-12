-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_exp_aval_nutri_sim_nao (opcao_p text) RETURNS varchar AS $body$
DECLARE


        ds_retorno_w            bigint;


BEGIN
    if (opcao_p = 'S' or opcao_p = '1') then
        ds_retorno_w := 928855;
    end if;

    if (opcao_p = 'N' or opcao_p = '2') then
        ds_retorno_w := 928857;
    end if;

    if (opcao_p = '8') then
        ds_retorno_w := 928857;
    end if;

    return obter_desc_expressao(ds_retorno_w);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_exp_aval_nutri_sim_nao (opcao_p text) FROM PUBLIC;

