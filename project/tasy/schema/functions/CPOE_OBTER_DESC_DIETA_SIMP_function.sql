-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_desc_dieta_simp ( nr_sequencia_p cpoe_dieta.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE

 
cd_material_w		cpoe_dieta.cd_material%type;
cd_dieta_w			cpoe_dieta.cd_dieta%type;
cd_mat_prod1_w		cpoe_dieta.cd_mat_prod1%type;
nr_seq_tipo_w		cpoe_dieta.nr_seq_tipo%type;
ie_tipo_dieta_w		cpoe_dieta.ie_tipo_dieta%type;
					
ds_retorno_w		varchar(2000);


BEGIN 
 
select	max(ie_tipo_dieta), 
		max(cd_dieta), 
		max(cd_material), 
		max(nr_seq_tipo), 
		max(cd_mat_prod1) 
into STRICT	ie_tipo_dieta_w, 
		cd_dieta_w, 
		cd_material_w, 
		nr_seq_tipo_w, 
		cd_mat_prod1_w 
from	cpoe_dieta 
where	nr_sequencia = nr_sequencia_p;
 
if (ie_tipo_dieta_w = 'O') then 
	ds_retorno_w	:= substr(obter_nome_dieta(cd_dieta_w),1,80);
elsif (ie_tipo_dieta_w = 'S') then 
  	ds_retorno_w	:= substr(obter_desc_material(cd_material_w),1,255);
elsif (ie_tipo_dieta_w = 'L') then 
  	ds_retorno_w	:= substr(obter_desc_material(cd_mat_prod1_w),1,255);
elsif (ie_tipo_dieta_w = 'E') then 
	ds_retorno_w	:= substr(obter_desc_material(cd_material_w),1,255);
elsif (ie_tipo_dieta_w = 'J') then 
	select  substr(max(ds_tipo),1,255) 
	into STRICT   ds_retorno_w 
	from   rep_tipo_jejum  
	where  nr_sequencia = nr_seq_tipo_w;
elsif (ie_tipo_dieta_w = 'P')then --Nutrição Parenteral 
	select	substr(max(ds_expressao),1,255) 
	into STRICT	ds_retorno_w 
	from	valor_dominio_v 
	where	vl_dominio = 'P' 
	and		cd_dominio = 6919;	
elsif (ie_tipo_dieta_w = 'I') then --Nutrição Parenteral Infantil 
	select	substr(max(ds_expressao),1,255) 
	into STRICT	ds_retorno_w 
	from	valor_dominio_v 
	where	vl_dominio = 'I' 
	and		cd_dominio = 6919;
end if;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_desc_dieta_simp ( nr_sequencia_p cpoe_dieta.nr_sequencia%type) FROM PUBLIC;
