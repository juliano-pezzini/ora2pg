-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_sim_conta ( nr_interno_conta_p bigint, ie_retorno_p text) RETURNS varchar AS $body$
DECLARE

 
/* Tipos de retorno 
I - Idade 
N - Data de Nascimento 
E - Data Entrada 
S - Data de Saida 
M - Medico Responsável 
D - Quantidade dias 
V - Valor conta 
*/
 
 
ds_resultado_w		varchar(50);
ds_retorno_w			varchar(50);
cd_pessoa_fisica_w		varchar(10);
dt_nascimento_w		timestamp;
qt_idade_w			varchar(50);
dt_entrada_w			timestamp;
dt_alta_w			timestamp;
cd_medico_resp_w		varchar(10);
nm_medico_resp_w		varchar(50);
vl_conta_w			double precision;


BEGIN 
 
select	b.dt_entrada, 
	coalesce(b.dt_alta, clock_timestamp()), 
	b.cd_medico_resp, 
	b.cd_pessoa_fisica, 
	a.vl_conta 
into STRICT	dt_entrada_w, 
	dt_alta_w, 
	cd_medico_resp_w, 
	cd_pessoa_fisica_w, 
	vl_conta_w 
from	atendimento_paciente b, 
	conta_paciente a 
where	a.nr_atendimento	= b.nr_atendimento 
and	a.nr_interno_conta	= nr_interno_conta_p;
 
if (ie_retorno_p in ('I','N')) then 
	select	coalesce(dt_nascimento,null) 
	into STRICT	dt_nascimento_w 
	from	pessoa_fisica 
	where	cd_pessoa_fisica = cd_pessoa_fisica_w;
	if (ie_retorno_p = 'I') and (dt_nascimento_w IS NOT NULL AND dt_nascimento_w::text <> '') then 
		select	Obter_Idade(	dt_nascimento_w, null, 'A') 
		into STRICT	qt_idade_w 
		;
	end if;
elsif (ie_retorno_p = 'M') then 
	select substr(obter_nome_medico(cd_medico_resp_w,'G'),1,50) 
	into STRICT	nm_medico_resp_w 
	;
end if;
 
if (ie_retorno_p = 'I') then 
	ds_resultado_w	:= qt_idade_w;
elsif (ie_retorno_p = 'N') then 
	ds_resultado_w	:= dt_nascimento_w;
elsif (ie_retorno_p = 'E') then 
	ds_resultado_w	:= dt_entrada_w;
elsif (ie_retorno_p = 'S') then 
	ds_resultado_w	:= dt_alta_w;
elsif (ie_retorno_p = 'M') then 
	ds_resultado_w	:= nm_medico_resp_w;
elsif (ie_retorno_p = 'D') then 
	ds_resultado_w	:= trunc(dt_alta_w) - trunc(dt_entrada_w);
elsif (ie_retorno_p = 'V') then 
	ds_resultado_w	:= vl_conta_w;
end if;
 
ds_retorno_w	:= ds_resultado_w;
 
RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_sim_conta ( nr_interno_conta_p bigint, ie_retorno_p text) FROM PUBLIC;

