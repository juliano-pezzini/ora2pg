-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_oper_origem ( nr_seq_operadora_p bigint, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE


/* IE_TIPO_P
	CGC - Código CGC da operadora
	R - Razão social
*/
ds_retorno_w			varchar(255);
cd_cgc_w			varchar(14);
ds_razao_social_w		varchar(80);


BEGIN

select	cd_cgc,
	substr(obter_razao_social(cd_cgc),1,80)
into STRICT	cd_cgc_w,
	ds_razao_social_w
from	pls_portab_operadora
where	nr_sequencia	= nr_seq_operadora_p;

if (ie_tipo_p	= 'CGC') then
	ds_retorno_w	:= cd_cgc_w;
elsif (ie_tipo_p	= 'R') then
	ds_retorno_w	:= ds_razao_social_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_oper_origem ( nr_seq_operadora_p bigint, ie_tipo_p text) FROM PUBLIC;
