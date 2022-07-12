-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_apresenta_grupo_cpoe ( ie_grupo_p text, ie_subgrupo_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*
Descrição					ie_opcao_p
Grupo						G
Subgrupo					S

*/
retorno_w	varchar(1) := 'N';


BEGIN


if (ie_opcao_p = 'G') then

	if (  ie_grupo_p = 'MEDICAMENTO_SOLUCAO') or ( ie_grupo_p = 'NUTRICAO')  or ( ie_grupo_p = 'DIALISE') then

		retorno_w := 'S';

	end if;


elsif (ie_opcao_p = 'S')  then

	if (  ie_subgrupo_p = obter_desc_expressao(774110)) or ( ie_subgrupo_p = 'SOLUCOES')  or ( ie_subgrupo_p = 'DIALISE') then

		retorno_w := 'S';

	elsif (ie_grupo_p = 'PROCEDIMENTO') then

		retorno_w := 'S';

	end if;



end if;


return retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_apresenta_grupo_cpoe ( ie_grupo_p text, ie_subgrupo_p text, ie_opcao_p text) FROM PUBLIC;
