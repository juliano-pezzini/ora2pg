-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gel_obter_se_prescr_andar (nr_prescricao_p bigint, cd_setor_p bigint) RETURNS varchar AS $body$
DECLARE

			 
ds_retorno_w	varchar(255);		
cd_setor_atendimento_w	integer;			
nr_atendimento_w	bigint;
ds_setor_atendimento_w	varchar(255);
			

BEGIN 
 
if (nr_prescricao_p > 0) then 
 
	select	max(nr_atendimento) 
	into STRICT	nr_atendimento_w 
	from	prescr_medica 
	where	nr_prescricao	= nr_prescricao_p;
 
	select	max(obter_setor_atendimento(nr_atendimento)) 
	into STRICT	cd_setor_atendimento_w 
	from	atendimento_paciente 
	where	nr_atendimento	= nr_atendimento_w;
 
	if (cd_setor_atendimento_w IS NOT NULL AND cd_setor_atendimento_w::text <> '') and (cd_setor_atendimento_w	= cd_setor_p) then 
		 
		ds_retorno_w	:= 'S';
 
	elsif (cd_setor_atendimento_w IS NOT NULL AND cd_setor_atendimento_w::text <> '') and (cd_setor_atendimento_w	<> cd_setor_p) then 
 
		select	substr(obter_desc_expressao(max(cd_exp_setor_atend),max(ds_setor_atendimento)),1,100) 
		into STRICT	ds_setor_atendimento_w 
		from	setor_atendimento 
		where	cd_setor_atendimento	= cd_setor_atendimento_w;
		 
		ds_retorno_w	:= Wheb_mensagem_pck.get_texto(308446, 'DS_SETOR_ATENDIMENTO_W='||ds_setor_atendimento_w); --'Esta prescrição pertence ao andar '||ds_setor_atendimento_w||'!'; 
		
	end if;
 
end if;	
	 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gel_obter_se_prescr_andar (nr_prescricao_p bigint, cd_setor_p bigint) FROM PUBLIC;
