-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_conpaci_guia (nr_interno_conta_p bigint, cd_autorizacao_p text, ie_opcao_p bigint) RETURNS bigint AS $body$
DECLARE

vl_guia_w 		double precision;
ie_titulo_receber_w	varchar(1);
/*
1 - valor da guia
*/
BEGIN

select 	obter_valor_conv_estab(cd_convenio_parametro, cd_estabelecimento,'IE_TITULO_RECEBER')
into STRICT	ie_titulo_receber_w
from 	conta_paciente
where	nr_interno_conta = nr_interno_conta_p;

begin
select  vl_guia
into STRICT 	vl_guia_w
from	conta_paciente_guia
where  	cd_autorizacao  = cd_autorizacao_p
and 	nr_interno_conta = nr_interno_conta_p;
exception
	when others then

	if (ie_titulo_receber_w = 'C') then

		select  sum(vl_guia)
		into STRICT 	vl_guia_w
		from	conta_paciente_guia
		where	nr_interno_conta = nr_interno_conta_p;

	end if;
	end;
return 	vl_guia_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_conpaci_guia (nr_interno_conta_p bigint, cd_autorizacao_p text, ie_opcao_p bigint) FROM PUBLIC;
