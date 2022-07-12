-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_cd_tiss_proc ( cd_versao_tiss_p text, cd_tipo_tabela_imp_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_despesa_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(10);


BEGIN

select	max(ie_tipo_tabela)
into STRICT	ds_retorno_w
from	pls_procedimento_vigencia
where	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p;

if (coalesce(ds_retorno_w::text, '') = '') then
	select	CASE WHEN cd_versao_tiss_p='3.02.00' THEN coalesce(cd_tipo_tabela_imp_p,CASE WHEN ie_origem_proced_p=4 THEN '00'  ELSE CASE WHEN ie_tipo_despesa_p='2' THEN '18' WHEN ie_tipo_despesa_p='4' THEN '98' WHEN ie_tipo_despesa_p='3' THEN '00' WHEN ie_tipo_despesa_p='1' THEN '22' END  END )  ELSE CASE WHEN ie_origem_proced_p=4 THEN '00'  ELSE CASE WHEN ie_tipo_despesa_p='2' THEN '18' WHEN ie_tipo_despesa_p='4' THEN '98' WHEN ie_tipo_despesa_p='3' THEN '00' WHEN ie_tipo_despesa_p='1' THEN '22' END  END  END  cd_edicao_amb
	into STRICT	ds_retorno_w
	;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_cd_tiss_proc ( cd_versao_tiss_p text, cd_tipo_tabela_imp_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_despesa_p text) FROM PUBLIC;
