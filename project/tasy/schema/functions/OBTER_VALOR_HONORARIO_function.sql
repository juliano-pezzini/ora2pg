-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_honorario (nr_interno_conta_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

			 
vl_retorno_w		double precision := 0;
vl_medico_w		double precision;
cd_estrutura_w		integer;

C01 CURSOR FOR 
	SELECT	cd_estrutura 
	from	convenio_estrutura_conta 
	where	coalesce(ie_regra_total_honor,'S') = 'H' 
	order by cd_estrutura;

/* 
ie_opcao_p 
MED - valor do médico das estruturas de honorários 
*/
 
 

BEGIN 
 
open C01;
loop 
fetch C01 into	 
	cd_estrutura_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	select	coalesce(sum(vl_medico),0) 
	into STRICT	vl_medico_w 
	from 	conta_paciente_honorario_v 
	where	ie_emite_conta = to_char(cd_estrutura_w) 
	and	nr_interno_conta = nr_interno_conta_p;
	 
	vl_retorno_w := vl_retorno_w + vl_medico_w;
	 
	end;
end loop;
close C01;
 
return	vl_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_honorario (nr_interno_conta_p bigint, ie_opcao_p text) FROM PUBLIC;
