-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_regra_prot_simul_onc (cd_protocolo_p bigint) RETURNS varchar AS $body$
DECLARE


ie_regra_w		varchar(1) := 'S';
qt_reg_w		bigint;
cd_perfil_w		integer;


BEGIN

cd_perfil_w 		:= obter_perfil_Ativo;


select	count(*)
into STRICT	qt_reg_w
from	regra_prot_simultaneo_onc;

if (qt_reg_w	> 0) then

	ie_regra_w	:= 'N';

	select	count(*)
	into STRICT	qt_reg_w
	from	regra_prot_simultaneo_onc
	where	cd_protocolo = cd_protocolo_p
	and	coalesce(cd_perfil,cd_perfil_w) = cd_perfil_w;

	if (qt_reg_w > 0) then

		ie_regra_w	:= 'S';

	end if;

end if;

return	ie_regra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_regra_prot_simul_onc (cd_protocolo_p bigint) FROM PUBLIC;

