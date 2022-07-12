-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_entra_fluxo (cd_empresa_p bigint, cd_conta_financ_p bigint, cd_estab_fluxo_p bigint, cd_estab_item_p bigint) RETURNS varchar AS $body$
DECLARE


cd_empresa_w		bigint;
cd_estab_exclusivo_w	bigint;
ie_entra_fluxo_w	varchar(1) := 'N';


BEGIN

select	cd_empresa
into STRICT	cd_empresa_w
from	estabelecimento
where	cd_estabelecimento	= cd_estab_item_p;

ie_entra_fluxo_w	:= 'N';
if (cd_empresa_w = cd_empresa_p) then	-- verificar se a empresa do item a entrar o fluxo é da a mesma do fluxo que está sendo gerado
	select	cd_estabelecimento
	into STRICT	cd_estab_exclusivo_w
	from	conta_financeira
	where	cd_conta_financ		= cd_conta_financ_p;

	if (coalesce(cd_estab_exclusivo_w::text, '') = '') then	-- verificar se a conta financeira é exclusivo de uma empresa
		ie_entra_fluxo_w		:= 'S';
	elsif (cd_estab_exclusivo_w = coalesce(cd_estab_fluxo_p, cd_estab_exclusivo_w)) then -- verificar se o estab exclusivo da cf
		ie_entra_fluxo_w		:= 'S';					-- é a mesma do fluxo que está sendo gerado
	end if;
end if;

return	ie_entra_fluxo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_entra_fluxo (cd_empresa_p bigint, cd_conta_financ_p bigint, cd_estab_fluxo_p bigint, cd_estab_item_p bigint) FROM PUBLIC;
