-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_solic_vaga_atend (nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

				 
vl_retorno_w	varchar(10);


BEGIN 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then 
	 
	select	coalesce(max(nr_sequencia),0) 
	into STRICT	vl_retorno_w 
	from	gestao_vaga 
	where	nr_atendimento	= nr_atendimento_p 
	and	dt_solicitacao	<= clock_timestamp() 
	and	ie_status		in ('P','A');
	 
	if (ie_opcao_p = 'IE') then 
	 
		if (vl_retorno_w = '0') then 
		 
			vl_retorno_w := 'N';
			 
		else 
		 
			vl_retorno_w := 'S';
		 
		end if;
		 
	else 
	 
		vl_retorno_w := vl_retorno_w;
		 
	end if;
	 
end if;
	 
return vl_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_solic_vaga_atend (nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;
