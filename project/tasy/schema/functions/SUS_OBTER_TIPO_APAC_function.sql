-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_tipo_apac ( nr_interno_conta_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* Opção
C - Código
D - Descrição  */
ds_retorno_w		varchar(200);
ie_tipo_apac_w		smallint;
ds_tipo_apac_w		varchar(200);


BEGIN

select ie_tipo_apac,
	substr(obter_valor_dominio(1092, ie_tipo_apac),1,100)
into STRICT	ie_tipo_apac_w,
		ds_tipo_apac_w
from	sus_apac_unif
where	nr_interno_conta = nr_interno_conta_p
and	cd_procedimento = cd_procedimento_p
and	ie_origem_proced = ie_origem_proced_p;

if (ie_opcao_p = 'C') then
	ds_retorno_w := ie_tipo_apac_w;
else
	ds_retorno_w := ds_tipo_apac_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_tipo_apac ( nr_interno_conta_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_opcao_p text) FROM PUBLIC;

