-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_se_conta_filtro ( cd_conta_contabil_p text, cd_conta_filtro_p text, cd_classificacao_p text) RETURNS varchar AS $body$
DECLARE



ds_retorno_w		varchar(2) := 'N';
qt_analitico_w		integer;
ie_tipo_W		varchar(10);


BEGIN

select 	max(ie_tipo)
into STRICT    ie_tipo_W
from	conta_contabil
where	cd_conta_contabil	= cd_conta_filtro_p;

	if (ie_tipo_W = 'A') then
		if (cd_conta_contabil_p = cd_conta_filtro_p) then
			ds_retorno_w := 'S';
		end if;
	else
		ds_retorno_w := ctb_Obter_se_conta_classif_sup(cd_conta_contabil_p,cd_classificacao_p);
	end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_se_conta_filtro ( cd_conta_contabil_p text, cd_conta_filtro_p text, cd_classificacao_p text) FROM PUBLIC;
