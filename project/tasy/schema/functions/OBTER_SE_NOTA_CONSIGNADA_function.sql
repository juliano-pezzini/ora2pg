-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_nota_consignada ( nr_seq_nota_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(01);
ie_consignado_operacao_w	varchar(1);
cd_operacao_nota_w		smallint;


BEGIN

select	max(cd_operacao_nf)
into STRICT	cd_operacao_nota_w
from	nota_fiscal
where	nr_sequencia		= nr_seq_nota_p;

select	coalesce(max(b.ie_consignado),'0')
into STRICT	ie_consignado_operacao_w
from	operacao_estoque b,
	operacao_nota a
where	a.cd_operacao_estoque	= b.cd_operacao_estoque
and	a.cd_operacao_nf 	= cd_operacao_nota_w;


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
-- REVOKE ALL ON FUNCTION obter_se_nota_consignada ( nr_seq_nota_p bigint) FROM PUBLIC;

