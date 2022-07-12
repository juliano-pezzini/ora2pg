-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vl_cotacao_conta ( nr_interno_conta_p bigint) RETURNS bigint AS $body$
DECLARE


vl_cotacao_w 		cotacao_moeda.vl_cotacao%type;

BEGIN

vl_cotacao_w 	:= 0;

if ( coalesce(nr_interno_conta_p,0) > 0) then
	select	coalesce(max(vl_cotacao),0)
	into STRICT	vl_cotacao_w
	from 	conta_paciente_excedente
	where 	nr_interno_conta = nr_interno_conta_p;
end if;

return vl_cotacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vl_cotacao_conta ( nr_interno_conta_p bigint) FROM PUBLIC;

