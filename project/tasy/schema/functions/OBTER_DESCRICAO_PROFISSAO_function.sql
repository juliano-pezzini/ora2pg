-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_descricao_profissao (cd_occupation_p profissao.cd_profissao%type) RETURNS varchar AS $body$
DECLARE

			
ds_retorno_w		profissao.ds_profissao%type;


BEGIN

    if (cd_occupation_p IS NOT NULL AND cd_occupation_p::text <> '') then
        begin
            select	ds_profissao
            into STRICT	ds_retorno_w
            from	profissao
            where       cd_profissao = cd_occupation_p;
        exception
            when others then
             ds_retorno_w := null;
        end;
    end if;

    return	ds_retorno_w;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_descricao_profissao (cd_occupation_p profissao.cd_profissao%type) FROM PUBLIC;

