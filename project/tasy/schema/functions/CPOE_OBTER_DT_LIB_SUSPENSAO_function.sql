-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_dt_lib_suspensao (nr_sequencia_p bigint, ie_tipo_item_p text) RETURNS timestamp AS $body$
DECLARE

 
dt_lib_suspensao_w		timestamp;				
 

BEGIN 
 
if (coalesce(nr_sequencia_p,0) > 0) then 
	 
	if (ie_tipo_item_p = 'N') then 
		 
		select	max(dt_lib_suspensao) 
		into STRICT	dt_lib_suspensao_w 
		from	cpoe_dieta 
		where	(dt_lib_suspensao IS NOT NULL AND dt_lib_suspensao::text <> '') 
		and nr_sequencia = nr_sequencia_p;
	 
	elsif (ie_tipo_item_p = 'M') then 
	 
		select	max(dt_lib_suspensao) 
		into STRICT	dt_lib_suspensao_w 
		from	cpoe_material 
		where	(dt_lib_suspensao IS NOT NULL AND dt_lib_suspensao::text <> '') 
		and nr_sequencia = nr_sequencia_p;	
	 
	elsif (ie_tipo_item_p = 'P') then 
 
		select	max(dt_lib_suspensao) 
		into STRICT	dt_lib_suspensao_w 
		from	cpoe_procedimento 
		where	(dt_lib_suspensao IS NOT NULL AND dt_lib_suspensao::text <> '') 
		and nr_sequencia = nr_sequencia_p;	
		 
	elsif (ie_tipo_item_p = 'G') then 
	 
		select	max(dt_lib_suspensao) 
		into STRICT	dt_lib_suspensao_w 
		from	cpoe_gasoterapia 
		where	(dt_lib_suspensao IS NOT NULL AND dt_lib_suspensao::text <> '') 
		and nr_sequencia = nr_sequencia_p;		
	 
	elsif (ie_tipo_item_p = 'R') then 
 
		select	max(dt_lib_suspensao) 
		into STRICT	dt_lib_suspensao_w 
		from	cpoe_recomendacao 
		where	(dt_lib_suspensao IS NOT NULL AND dt_lib_suspensao::text <> '') 
		and nr_sequencia = nr_sequencia_p;		
	 
	elsif (ie_tipo_item_p = 'D') then 
	 
		select	max(dt_lib_suspensao) 
		into STRICT	dt_lib_suspensao_w 
		from	cpoe_dialise 
		where	(dt_lib_suspensao IS NOT NULL AND dt_lib_suspensao::text <> '') 
		and nr_sequencia = nr_sequencia_p;			
	 
	elsif (ie_tipo_item_p = 'H') then 
	 
		select	max(dt_lib_suspensao) 
		into STRICT	dt_lib_suspensao_w 
		from	cpoe_hemoterapia 
		where	(dt_lib_suspensao IS NOT NULL AND dt_lib_suspensao::text <> '') 
		and nr_sequencia = nr_sequencia_p;			
	 
	elsif (ie_tipo_item_p = 'AP') then 
	 
		select	max(dt_lib_suspensao) 
		into STRICT	dt_lib_suspensao_w 
		from	cpoe_anatomia_patologica 
		where	(dt_lib_suspensao IS NOT NULL AND dt_lib_suspensao::text <> '') 
		and nr_sequencia = nr_sequencia_p;	
	end if;
end if;
 
 
return	coalesce(dt_lib_suspensao_w,null);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_dt_lib_suspensao (nr_sequencia_p bigint, ie_tipo_item_p text) FROM PUBLIC;

