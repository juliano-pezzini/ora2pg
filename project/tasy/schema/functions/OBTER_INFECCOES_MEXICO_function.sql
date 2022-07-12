-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_infeccoes_mexico (nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


ie_sintomatico_w    varchar(10);
cd_retorno_w        smallint;


BEGIN

	select obter_se_ie_sintomatico(nr_atendimento_p)
		   into STRICT ie_sintomatico_w
	;

	if (obter_verificador_antibiotico(nr_atendimento_p) = 'S') then
		cd_retorno_w := 2;

	elsif (ie_sintomatico_w = 'N') then
			cd_retorno_w := 1;
	else
   	        cd_retorno_w := 3;
  	end if;

return cd_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_infeccoes_mexico (nr_atendimento_p bigint) FROM PUBLIC;

