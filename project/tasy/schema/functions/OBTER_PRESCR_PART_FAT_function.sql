-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prescr_part_fat (nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE

 
nr_atendimento_w	bigint;
cd_tipo_conenveio_w	smallint;
ds_retorno_w		varchar(20);	
qt_conta_def_w		bigint;
qt_conta_w		bigint;
vl_saldo_w		double precision;
			

BEGIN 
 
select 	max(nr_atendimento) 
into STRICT	nr_atendimento_w 
from	prescr_medica 
where 	nr_prescricao = nr_prescricao_p;
 
ds_retorno_w	:='N';
 
if (nr_atendimento_w > 0) then 
	 
	select	OBTER_TIPO_CONVENIO(OBTER_CONVENIO_ATENDIMENTO(nr_atendimento_w)) 
	into STRICT	cd_tipo_conenveio_w 
	;
	 
	if (cd_tipo_conenveio_w = 1) then 
	 
		select 	count(*) 
		into STRICT	qt_conta_w 
		from	conta_paciente 
		where	nr_atendimento = nr_atendimento_w;
		 
		select 	count(*) 
		into STRICT	qt_conta_def_w 
		from	conta_paciente 
		where	nr_atendimento = nr_atendimento_w 
		and	ie_status_acerto	= 2;
		 
		if (qt_conta_w = 0) or (qt_conta_def_w <> qt_conta_w) then			 
			ds_retorno_w	:= 'S';
		end if;
		 
		select 	sum(vl_saldo_titulo) 
		into STRICT	vl_saldo_w 
		from	titulo_receber a 
		where	a.nr_atendimento = nr_atendimento_w 
		and	a.ie_situacao = '1';
		 
		if (vl_saldo_w > 0) then 
			ds_retorno_w	:= 'S';
		end if;
		 
		 
	end if;
 
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prescr_part_fat (nr_prescricao_p bigint) FROM PUBLIC;

