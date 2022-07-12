-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_teste_rel_web ( cd_relatorio_p bigint, cd_classif_relat_p text, vl_padrao_p text, cd_parametro_p text) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(255);

BEGIN

select	coalesce(max(vl_parametro), vl_padrao_p)
into STRICT	ds_retorno_w
from	teste_relatorio_web
where	cd_relatorio = cd_relatorio_p
and	cd_classif_relat = cd_classif_relat_p
and	cd_parametro = cd_parametro_p;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_teste_rel_web ( cd_relatorio_p bigint, cd_classif_relat_p text, vl_padrao_p text, cd_parametro_p text) FROM PUBLIC;

