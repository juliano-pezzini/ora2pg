-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_preco_sus_bpa (cd_estabelecimento_p bigint, ie_opcao_preco_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint) RETURNS bigint AS $body$
DECLARE


/* 0 - Procedimento
   1 - SADT + MATMED*/
vl_procedimento_w	double precision := 0;
vl_sadtmed_w		double precision := 0;
ie_versao_bpa_w	varchar(20);
vl_retorno_w		double precision;


BEGIN

select	coalesce(max(ie_versao_bpa),'0')
into STRICT	ie_versao_bpa_w
from	sus_parametros
where	cd_estabelecimento	= cd_estabelecimento_p;

if (ie_versao_bpa_w	<> '0') then
	begin
   	select  vl_procedimento,
        	vl_matmed
	into STRICT	vl_procedimento_w,
           	vl_sadtmed_w
	from	sus_preco_procbpa
	where	ie_versao		= ie_versao_bpa_w
	and	cd_procedimento		= cd_procedimento_p
	and	ie_origem_proced	= ie_origem_proced_p;

	if (ie_opcao_preco_p = 0) then
           	vl_retorno_w	:= vl_procedimento_w;
	elsif (ie_opcao_preco_p = 1) then
           	vl_retorno_w    := vl_sadtmed_w;
   	end if;
   	end;
end if;

return	vl_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_preco_sus_bpa (cd_estabelecimento_p bigint, ie_opcao_preco_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint) FROM PUBLIC;

