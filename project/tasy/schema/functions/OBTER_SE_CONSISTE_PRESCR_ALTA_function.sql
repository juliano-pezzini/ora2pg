-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_consiste_prescr_alta (nr_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
qt_min_prescr_alta_w	bigint;
dt_prescr_alta_w		timestamp;
ds_consistencia_w		varchar(4000) := '';

BEGIN
 
qt_min_prescr_alta_w	:= coalesce(obter_valor_param_usuario(924, 43, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),0);
				 
if (coalesce(qt_min_prescr_alta_w,0) <> 0) then	 
	if (coalesce(nr_atendimento_p,0) > 0) then 
	 
		select (coalesce(dt_alta,clock_timestamp()) + qt_min_prescr_alta_w / 1440) 
		into STRICT	dt_prescr_alta_w 
		from	atendimento_paciente 
		where	nr_atendimento = nr_atendimento_p;
		 
		if (dt_prescr_alta_w < clock_timestamp()) then 
			ds_consistencia_w := obter_desc_expressao(510668);
		end if;
	end if;
end if;
 
return ds_consistencia_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_consiste_prescr_alta (nr_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
