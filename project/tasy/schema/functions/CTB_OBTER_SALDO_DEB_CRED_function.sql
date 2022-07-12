-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_saldo_deb_cred ( cd_empresa_p bigint, cd_conta_contabil_p text, vl_saldo_p bigint, ie_deb_cred_p text) RETURNS bigint AS $body$
DECLARE


vl_saldo_w		double precision;
ie_debito_credito_w	varchar(01);


BEGIN

vl_saldo_w		:= coalesce(vl_saldo_p,0);
if (vl_saldo_w	<> 0) then
	select	coalesce(max(ie_debito_credito), ie_deb_cred_p)
	into STRICT	ie_debito_credito_w
	FROM conta_contabil b
LEFT OUTER JOIN ctb_grupo_conta c ON (b.cd_grupo = c.cd_grupo)
WHERE b.cd_conta_contabil	= cd_conta_contabil_p and b.cd_empresa		= cd_empresa_p;
	if (ie_deb_cred_p 	= ie_debito_credito_w) then
		vl_saldo_w		:= vl_saldo_w * -1;
	end if;
	if (ie_deb_cred_p = 'D') then
		begin
		if (vl_saldo_w < 0) then
			vl_saldo_w		:= abs(vl_saldo_w);
		else
			vl_saldo_w		:= 0;
		end if;
		end;
	end if;
	if (ie_deb_cred_p = 'C') then
		begin
		if (vl_saldo_w < 0) then
			vl_saldo_w		:= abs(vl_saldo_w);
		else
			vl_saldo_w		:= 0;
		end if;
		end;
	end if;
end if;

return vl_saldo_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_saldo_deb_cred ( cd_empresa_p bigint, cd_conta_contabil_p text, vl_saldo_p bigint, ie_deb_cred_p text) FROM PUBLIC;
