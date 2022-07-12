-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nfe_obter_se_consiste_campo (ie_campo_consistir_p text, ie_tipo_nota_p text, cd_estabelecimento_p bigint, cd_empresa_p bigint) RETURNS varchar AS $body$
DECLARE


cd_campo_consostir_w	varchar(10);
ie_retorno_w		varchar(1) := 'N';
qt_existe_w		bigint;


BEGIN

select	count(*)
into STRICT	qt_existe_w
from   	regra_consistencia_nfe
where	ie_campo_consistir = ie_campo_consistir_p
and	ie_tipo_nota = ie_tipo_nota_p
and	coalesce(CD_EMP_EXCLUSIVA, cd_empresa_p) = cd_empresa_p
and	coalesce(CD_ESTAB_EXCLUSIVO, cd_estabelecimento_p) = cd_estabelecimento_p;

if (qt_existe_w > 0) then
	ie_retorno_w := 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nfe_obter_se_consiste_campo (ie_campo_consistir_p text, ie_tipo_nota_p text, cd_estabelecimento_p bigint, cd_empresa_p bigint) FROM PUBLIC;
