-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_express_ingestao (opcao_p text) RETURNS varchar AS $body$
DECLARE


    ds_retorno_w            bigint;


BEGIN
    if (opcao_p = 'I') then
        ds_retorno_w := 1047977;
    end if;

    if (opcao_p = 'O') then
        ds_retorno_w := 291969;
    end if;

    if (opcao_p = 'E') then
        ds_retorno_w := 1047975;
    end if;

    return obter_desc_expressao(ds_retorno_w);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_express_ingestao (opcao_p text) FROM PUBLIC;
