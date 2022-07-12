-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hjf_obter_se_tipo_percentual ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, dt_vigencia_p timestamp, cd_procedimento_p bigint, ie_origem_proced_p bigint, qt_item_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_ultrapassou_incidencia_w	varchar(1):= 'N';
cd_edicao_amb_w			integer;
nr_incidencia_w			smallint;
			

BEGIN 
 
cd_edicao_amb_w:= obter_edicao(cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, dt_vigencia_p, cd_procedimento_p);	
 
if (cd_edicao_amb_w > 0) and (cd_edicao_amb_w IS NOT NULL AND cd_edicao_amb_w::text <> '') then 
	 
	select 	coalesce(max(nr_incidencia),0) 
	into STRICT	nr_incidencia_w 
	from 	preco_amb 
	where 	cd_edicao_amb = cd_edicao_amb_w 
	and	cd_procedimento = cd_procedimento_p 
	and 	ie_origem_proced = ie_origem_proced_p;
	 
	if (qt_item_p > nr_incidencia_w) then 
		ie_ultrapassou_incidencia_w:= 'S';
	end if;
		 
end if;
 
if (cd_procedimento_p in (31010040 , 31070086)) then 
	ie_ultrapassou_incidencia_w:= 'S';
end if;
 
return	ie_ultrapassou_incidencia_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hjf_obter_se_tipo_percentual ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, dt_vigencia_p timestamp, cd_procedimento_p bigint, ie_origem_proced_p bigint, qt_item_p bigint) FROM PUBLIC;

