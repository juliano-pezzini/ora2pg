-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_se_atual_resumo (nr_interno_conta_p conta_paciente.nr_interno_conta%type) RETURNS varchar AS $body$
DECLARE

				 
ds_retorno_w		varchar(1) := 'S';
cd_convenio_w		conta_paciente.cd_convenio_parametro%type;
ie_status_acerto_w	conta_paciente.ie_status_acerto%type;
ie_tipo_convenio_w	convenio.ie_tipo_convenio%type;
qt_rateio_sus_w		bigint := 0;


BEGIN 
 
begin 
select	coalesce(cd_convenio_parametro,0), 
	coalesce(ie_status_acerto,1) 
into STRICT	cd_convenio_w, 
	ie_status_acerto_w 
from	conta_paciente 
where	nr_interno_conta = nr_interno_conta_p  LIMIT 1;
exception 
when others then 
	cd_convenio_w		:= 0;
	ie_status_acerto_w	:= 1;
end;
 
if (cd_convenio_w > 0) then 
	begin 
	 
	ie_tipo_convenio_w := coalesce(Obter_Tipo_Convenio(cd_convenio_w),0);
	 
	if (ie_tipo_convenio_w = 3) and (ie_status_acerto_w = 2) then 
		begin 
		 
		select	count(1) 
		into STRICT	qt_rateio_sus_w 
		from	material_atend_paciente 
		where	nr_interno_conta = nr_interno_conta_p 
		and	coalesce(cd_motivo_exc_conta::text, '') = '' 
		and	coalesce(vl_material,0) > 0  LIMIT 1;
		 
		if (qt_rateio_sus_w > 0) then 
			ds_retorno_w := 'N';
		end if;
		 
		end;
	end if;
	 
	end;
end if;	
 
return	coalesce(ds_retorno_w,'S');
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_se_atual_resumo (nr_interno_conta_p conta_paciente.nr_interno_conta%type) FROM PUBLIC;
