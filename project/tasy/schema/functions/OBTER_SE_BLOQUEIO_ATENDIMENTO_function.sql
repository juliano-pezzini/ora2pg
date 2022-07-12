-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_bloqueio_atendimento ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w			varchar(1) := 'N';					
dt_entrada_w			timestamp;
cd_convenio_w			bigint;
cd_estabelecimento_w	bigint;
ie_tipo_atendimento_w	varchar(255);
qt_reg_w				bigint;
qt_horas_w				bigint;				
				 

BEGIN 
 
 
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_atendimento_p > 0) then 
	 
	select	count(1) 
	into STRICT	qt_reg_w 
	from	regra_bloqueio_atendimento;
	 
	if (qt_reg_w	> 0)then 
 
		cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;
		 
		Select 	ie_tipo_atendimento, 
				dt_entrada, 
				coalesce(obter_convenio_atendimento(nr_atendimento),0) 
		into STRICT	ie_tipo_atendimento_w, 
				dt_entrada_w, 
				cd_convenio_w 
		from	atendimento_paciente 
		where	nr_atendimento = nr_atendimento_p;
			 
		qt_horas_w := ((clock_timestamp() - dt_entrada_w)*24);
		 
		select	count(*) 
		into STRICT	qt_reg_w 
		from	regra_bloqueio_atendimento 
		where	ie_tipo_atendimento = ie_tipo_atendimento_w 
		and		coalesce(cd_convenio,cd_convenio_w) = cd_convenio_w 
		and		coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w 
		and		qt_horas_w between qt_hora_inicial and qt_hora_final;
 
		if (qt_reg_w > 0) then 
 
			ds_retorno_w := 'S';
 
		end if;
	end if;
	 
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_bloqueio_atendimento ( nr_atendimento_p bigint) FROM PUBLIC;
