-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_medico_auditor ( nr_atendimento_p bigint, ie_opcao_p bigint) RETURNS varchar AS $body$
DECLARE

 
/* IE_OPCAP_P 
	1 - Código 
	2 - CPF 
*/
 
 
cd_estabelecimento_w	smallint;
cd_medico_auditor_w	varchar(10);
ie_auditor_laudo_w	varchar(1);
nr_cpf_w		varchar(11);
ds_retorno_w		varchar(11);


BEGIN 
 
select	cd_estabelecimento 
into STRICT	cd_estabelecimento_w 
from	atendimento_paciente 
where	nr_atendimento	= nr_atendimento_p;
 
select	cd_medico_auditor, 
	ie_auditor_laudo 
into STRICT	cd_medico_auditor_w, 
	ie_auditor_laudo_w 
from	sus_parametros 
where	cd_estabelecimento	= cd_estabelecimento_w;
 
if (ie_auditor_laudo_w	= 'S') then 
	begin 
	select	cd_medico_responsavel 
	into STRICT	cd_medico_auditor_w 
	from	sus_laudo_paciente 
	where	nr_atendimento	= nr_atendimento_p 
	and	ie_tipo_laudo_sus = 0;
	exception 
		when others then 
		cd_medico_auditor_w	:= cd_medico_auditor_w;
	end;
end if;
 
ds_retorno_w	:= cd_medico_auditor_w;
 
if (ie_opcao_p	= 2) then 
	select	nr_cpf 
	into STRICT	nr_cpf_w 
	from	pessoa_fisica 
	where	cd_pessoa_fisica	= cd_medico_auditor_w;
	ds_retorno_w	:= nr_cpf_w;
end if;
 
return	ds_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_medico_auditor ( nr_atendimento_p bigint, ie_opcao_p bigint) FROM PUBLIC;
