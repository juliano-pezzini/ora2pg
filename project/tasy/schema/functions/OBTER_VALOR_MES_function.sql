-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_mes (ie_status_protocolo_p bigint, dt_envio_p timestamp, nr_interno_conta_p bigint, dt_ano_filtro_p text, ie_data_prot_p text, nr_mes_p text) RETURNS bigint AS $body$
DECLARE

		 
vl_retorno_w	double precision;
dt_envio_w	varchar(2);
dt_envio_ano_w	varchar(4);
		

BEGIN 
 
dt_envio_w := to_char(coalesce(dt_envio_p,clock_timestamp()),'mm');
dt_envio_ano_w := to_char(coalesce(dt_envio_p,clock_timestamp()),'yyyy');
 
 
if (coalesce(ie_status_protocolo_p,1) = 2) then 
 
	if (ie_data_prot_p = 'N') then 
	 
		if (dt_envio_ano_w = dt_ano_filtro_p) then 
		 
			if (dt_envio_w = nr_mes_p) then 
				 
				vl_retorno_w := obter_valor_conta(nr_interno_conta_p,0);
				 
			else 
				vl_retorno_w:= 0;
			 
			end if;
		else 
			vl_retorno_w:= 0;
		end if;
		 
	else	 
		if (dt_envio_w = nr_mes_p) then 
			 
			vl_retorno_w :=	obter_valor_conta(nr_interno_conta_p,0);
		else 
			vl_retorno_w := 0;
		end if;
	end if;
else 
	vl_retorno_w := 0;
end if;
 
return vl_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_mes (ie_status_protocolo_p bigint, dt_envio_p timestamp, nr_interno_conta_p bigint, dt_ano_filtro_p text, ie_data_prot_p text, nr_mes_p text) FROM PUBLIC;

