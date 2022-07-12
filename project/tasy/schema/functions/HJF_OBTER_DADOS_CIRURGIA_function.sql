-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hjf_obter_dados_cirurgia (nr_seq_item_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
/* ie_opcao_p= '1' - verifica se eh cirurgia 
  	   = '2' - retorna o carater da cirurgia 
	   = '3' - verifica de adicional Horario */
 
	 
ie_retorno_w		varchar(1);
nr_cirurgia_w		bigint;
IE_CARATER_CIRURGIA_w	varchar(1);
dt_procedimento_w	timestamp;
nr_interno_conta_w	bigint;
cd_estabelecimento_w	smallint;
dia_feriado_w		varchar(1) 	:= 'N';


BEGIN 
 
select	coalesce(max(nr_cirurgia),0) 
into STRICT	nr_cirurgia_w 
from 	procedimento_paciente 
where 	nr_sequencia = nr_seq_item_p;
 
if (ie_opcao_p = '1') then 
	 
	if (nr_cirurgia_w > 0) then 
	 
		ie_retorno_w:= 'S';
	 
	else 
		 
		ie_retorno_w:= 'N';	
 
	end if;
 
 
elsif (ie_opcao_p = '2') then 
 
	if (nr_cirurgia_w > 0) then 
 
		select 	CASE WHEN coalesce(max(IE_CARATER_CIRURGIA),'E')='E' THEN 'N'  ELSE 'S' END  
		into STRICT	ie_retorno_w 
		from 	cirurgia 
		where 	nr_cirurgia= nr_cirurgia_w;				
	 
	else 
		 
		ie_retorno_w:= 'N';	
 
	end if;
 
elsif (ie_opcao_p = '3') then 
 
	select 	max(dt_procedimento), 
		max(nr_interno_conta) 
	into STRICT	dt_procedimento_w, 
		nr_interno_conta_w 
	from 	procedimento_paciente 
	where 	nr_sequencia = nr_seq_item_p;
		 
	select 	max(cd_estabelecimento) 
	into STRICT	cd_estabelecimento_w 
	from 	conta_paciente 
	where 	nr_interno_conta = nr_interno_conta_w;
 
	begin 
	select 	'S' 
	into STRICT 	dia_feriado_w 
	from 	feriado 
	where 	cd_estabelecimento 			= cd_estabelecimento_w 
	and 	to_char(dt_feriado,'dd/mm/yyyy') 	= to_char(dt_procedimento_w,'dd/mm/yyyy');
	exception 
      when others then 
		dia_feriado_w	:= 'N';
	end;
	 
	if (dia_feriado_w = 'S') then 
		 
		ie_retorno_w:= 'S';
 
	else 
		 
		if ((to_char(dt_procedimento_w,'hh'))::numeric  > 22) or ((to_char(dt_procedimento_w,'hh'))::numeric  < 6) then 
		 
 
			ie_retorno_w:= 'S';
		else 
		 
			ie_retorno_w:=	'N';
 
		end if;
	 
	end if;
end if;
 
return ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hjf_obter_dados_cirurgia (nr_seq_item_p bigint, ie_opcao_p text) FROM PUBLIC;
