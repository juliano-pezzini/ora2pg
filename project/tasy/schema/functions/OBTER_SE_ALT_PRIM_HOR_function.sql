-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_alt_prim_hor ( cd_setor_atendimento_p bigint, cd_intervalo_p text) RETURNS char AS $body$
DECLARE

ie_retorno_w	char(1);

BEGIN

select	coalesce(max('N'),'S')
into STRICT	ie_retorno_w
from	rep_alteracao_campo LIMIT 1;

if (ie_retorno_w = 'N') then
	if (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') then
		select	coalesce(max(ie_altera_prim_hor),'S')
		into STRICT	ie_retorno_w
		from	rep_alteracao_campo
		where	coalesce(cd_setor_atendimento,cd_setor_atendimento_p) = cd_setor_atendimento_p;
	else
		ie_retorno_w	:= 'S';
	end if;
elsif (cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '') then
	select	coalesce(max(ie_editar_prim_hor),'S')
	into STRICT	ie_retorno_w
	from	intervalo_prescricao
	where	cd_intervalo = cd_intervalo_p;
else
	ie_retorno_w	:= 'S';
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_alt_prim_hor ( cd_setor_atendimento_p bigint, cd_intervalo_p text) FROM PUBLIC;
