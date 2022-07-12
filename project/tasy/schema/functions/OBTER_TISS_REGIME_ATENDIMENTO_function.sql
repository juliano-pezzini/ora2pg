-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tiss_regime_atendimento ( cd_estabelecimento_p tiss_regra_regime_atend.cd_estabelecimento%type default null, cd_convenio_p tiss_regra_regime_atend.cd_convenio%type default null, ie_tipo_atendimento_p tiss_regra_regime_atend.ie_tipo_atendimento%type DEFAULT NULL) RETURNS varchar AS $body$
DECLARE

					
cd_retorno_w 	tiss_conta_atend.cd_regime_atendimento%type;

c_regras CURSOR FOR
	SELECT	ie_regime_atendimento
	from	tiss_regra_regime_atend
	where	ie_tipo_atendimento 	= ie_tipo_atendimento_p
	and	ie_situacao		= 'A'
	and (cd_convenio		= cd_convenio_p or coalesce(cd_convenio::text, '') = '')
	and (cd_estabelecimento	= cd_estabelecimento_p or coalesce(cd_estabelecimento::text, '') = '')
	order by coalesce(cd_convenio,0),
		 coalesce(cd_estabelecimento,0);
		
c_regras_w	c_regras%rowtype;

BEGIN

open c_regras;
loop
fetch c_regras into
	c_regras_w;
EXIT WHEN NOT FOUND; /* apply on c_regras */
	cd_retorno_w := c_regras_w.ie_regime_atendimento;
end loop;
close c_regras;

return cd_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tiss_regime_atendimento ( cd_estabelecimento_p tiss_regra_regime_atend.cd_estabelecimento%type default null, cd_convenio_p tiss_regra_regime_atend.cd_convenio%type default null, ie_tipo_atendimento_p tiss_regra_regime_atend.ie_tipo_atendimento%type DEFAULT NULL) FROM PUBLIC;
