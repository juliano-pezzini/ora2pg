-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_favorito_dic_objeto ( cd_funcao_p bigint, ds_favoritos_p text) RETURNS varchar AS $body$
DECLARE


ie_favorito_w	varchar(1) := 'N';


BEGIN
if (cd_funcao_p IS NOT NULL AND cd_funcao_p::text <> '') and (ds_favoritos_p IS NOT NULL AND ds_favoritos_p::text <> '') then
	begin
	ie_favorito_w := obter_se_contido(cd_funcao_p,ds_favoritos_p);
	end;
end if;
return ie_favorito_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_favorito_dic_objeto ( cd_funcao_p bigint, ds_favoritos_p text) FROM PUBLIC;
