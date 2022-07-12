-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_info_proced ( cd_setor_atendimento_p bigint, cd_procedimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_acm_w		varchar(1);
ie_se_necessario_w	varchar(1);
ds_retorno_w		varchar(1);


BEGIN

select	max(coalesce(ie_acm,'N')),
	max(coalesce(ie_se_necessario,'N'))
into STRICT	ie_acm_w,
	ie_se_necessario_w
from	regra_inf_padrao_proced
where	cd_procedimento 				 = cd_procedimento_p
and	coalesce(cd_setor_atendimento,cd_setor_atendimento_p) = cd_setor_atendimento_p;

if (ie_acm_w = 'N') and (ie_se_necessario_w = 'N') then
	ds_retorno_w	:= 'D';
elsif (ie_acm_w = 'S') and (ie_se_necessario_w = 'N') then
	ds_retorno_w	:= 'A';
elsif (ie_acm_w = 'N') and (ie_se_necessario_w = 'S') then
	ds_retorno_w	:= 'N';

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_info_proced ( cd_setor_atendimento_p bigint, cd_procedimento_p bigint) FROM PUBLIC;
