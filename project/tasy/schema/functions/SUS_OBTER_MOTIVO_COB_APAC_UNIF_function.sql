-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_motivo_cob_apac_unif ( nr_interno_conta_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
cd_motivo_cobranca_w	bigint;
ds_motivo_cobranca_w	varchar(255);


BEGIN

select	coalesce(max(cd_motivo_cobranca),0)
into STRICT	cd_motivo_cobranca_w
from	sus_apac_unif
where	nr_interno_conta = nr_interno_conta_p;

if (ie_opcao_p = 'C') then
	ds_retorno_w := cd_motivo_cobranca_w;
else
	ds_motivo_cobranca_w := substr(Sus_Obter_Mot_Cobranca_unif(cd_motivo_cobranca_w),1,255);
	if (ds_motivo_cobranca_w = '0') then
		ds_retorno_w := 'Não informado';
	else
		ds_retorno_w := ds_motivo_cobranca_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_motivo_cob_apac_unif ( nr_interno_conta_p bigint, ie_opcao_p text) FROM PUBLIC;
