-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_registro_ans ( cd_estabelecimento_p text) RETURNS varchar AS $body$
DECLARE


/*
 * Retorna o registro ANS a partir do estabelecimento passado por parâmetro.
 */
ds_retorno_w	pls_outorgante.cd_ans%type;


BEGIN

select	max(cd_ans)
into STRICT	ds_retorno_w
from	pls_outorgante
where	cd_estabelecimento = cd_estabelecimento_p;

if (coalesce(ds_retorno_w::text, '') = '') then
    select	max(cd_ans)
    into STRICT	ds_retorno_w
    from	pls_outorgante;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_registro_ans ( cd_estabelecimento_p text) FROM PUBLIC;
