-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_op_nota_consignada ( cd_operacao_nf_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(01);
ie_consignado_operacao_w	varchar(1);


BEGIN

select	coalesce(max(b.ie_consignado),'0')
into STRICT	ie_consignado_operacao_w
from	operacao_estoque b,
	operacao_nota a
where	a.cd_operacao_estoque	= b.cd_operacao_estoque
and	a.cd_operacao_nf 	= cd_operacao_nf_p;


ie_retorno_w	:= 'N';
if (ie_consignado_operacao_w <> '0') then
	ie_retorno_w	:= 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_op_nota_consignada ( cd_operacao_nf_p bigint) FROM PUBLIC;
