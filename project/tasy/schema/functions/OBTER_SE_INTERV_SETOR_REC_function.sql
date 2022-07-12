-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_interv_setor_rec ( cd_recomendacao_p bigint, cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


cd_intervalo_w	varchar(7);


BEGIN

if (coalesce(cd_setor_atendimento_p,0) > 0) then

	select	max(cd_intervalo)
	into STRICT	cd_intervalo_w
	from	regra_intervalo_rec_setor
	where	cd_recomendacao = cd_recomendacao_p
	and	cd_setor_atendimento = cd_setor_atendimento_p;

end if;

return	cd_intervalo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_interv_setor_rec ( cd_recomendacao_p bigint, cd_setor_atendimento_p bigint) FROM PUBLIC;

