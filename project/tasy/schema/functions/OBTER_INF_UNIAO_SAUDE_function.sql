-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_inf_uniao_saude ( nr_prescricao_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w	varchar(2000);

/*************************************************** 
 
CD	- Código doença 
D	- Diagnóstico 
DC	- Dados Clínicos/CID 
M	- Médico 
CRM	- CRM 
 
****************************************************/
 
 
C01 CURSOR FOR 
	SELECT	cd_doenca 
	from	diagnostico_doenca 
	where	nr_atendimento = (	SELECT	obter_atendimento_prescr(nr_prescricao_p) 
					);

C02 CURSOR FOR 
	SELECT	substr(obter_desc_cid(cd_doenca),1,100) 
	from	diagnostico_doenca 
	where	nr_atendimento = (	SELECT	obter_atendimento_prescr(nr_prescricao_p) 
					);

C03 CURSOR FOR 
	SELECT	ds_dado_clinico 
	from	prescr_procedimento 
	where	nr_prescricao = nr_prescricao_p 
	and	(ds_dado_clinico IS NOT NULL AND ds_dado_clinico::text <> '');


BEGIN 
 
if (ie_opcao_p = 'CD')	then 
	open c01;
	loop 
	fetch c01 into 
		ds_retorno_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
		ds_retorno_w	:= ds_retorno_w || chr(13);
	end;
	end loop;
elsif (ie_opcao_p = 'D')	then 
	open c02;
	loop 
	fetch c02 into 
		ds_retorno_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
	begin 
		ds_retorno_w	:= ds_retorno_w || chr(13);
	end;
	end loop;
elsif (ie_opcao_p = 'DC')	then	 
	open c03;
	loop 
	fetch c03 into 
		ds_retorno_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
	begin 
		ds_retorno_w	:= ds_retorno_w || chr(13);
	end;
	end loop;
elsif (ie_opcao_p = 'M')	then 
	select	substr(obter_nome_medico(cd_medico,'N'),1,60) 
	into STRICT	ds_retorno_w 
	from	prescr_medica 
	where	nr_prescricao = nr_prescricao_p;
elsif (ie_opcao_p = 'CRM')	then 
select	'CRM - ' || SUBSTR(obter_crm_medico(cd_medico),1,20) 
	into STRICT	ds_retorno_w 
	from	prescr_medica 
	where	nr_prescricao = nr_prescricao_p;
end	if;
 
return	ds_retorno_w;
 
end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_inf_uniao_saude ( nr_prescricao_p bigint, ie_opcao_p text) FROM PUBLIC;
