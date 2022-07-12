-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_campo_relatorio ( cd_tipo_p text) RETURNS varchar AS $body$
DECLARE

	ds_retorno_w varchar(12) := 'TEXTBOX';


BEGIN

/*L = soon
N = report name
D = system date
P = page
U = user
C = report code pay*/
if (cd_tipo_p IS NOT NULL AND cd_tipo_p::text <> '') then
    if (cd_tipo_p in ('L'))then
        ds_retorno_w := 'IMAGEM';
    elsif (cd_tipo_p in ('N','D','P','U', 'C'))then
        ds_retorno_w := 'TEXTBOX';
    end if;
else
    ds_retorno_w := 'TEXTBOX';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_campo_relatorio ( cd_tipo_p text) FROM PUBLIC;

