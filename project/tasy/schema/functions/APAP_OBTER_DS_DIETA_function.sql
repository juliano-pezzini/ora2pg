-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION apap_obter_ds_dieta (ie_tipo_dieta_p text, cd_dieta_p bigint, cd_material_p bigint, cd_mat_prod1_p bigint, nr_seq_tipo_p bigint, nr_seq_cpoe_p bigint default null) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	 			varchar(4000);
ie_dieta_enteral_w			cpoe_dieta.ie_dieta_enteral%type;
ie_via_aplicacao_w			cpoe_dieta.ie_via_aplicacao%type;
			

BEGIN

if (ie_tipo_dieta_p = 'O') and (cd_dieta_p IS NOT NULL AND cd_dieta_p::text <> '') then
	ds_retorno_w	:= substr(obter_nome_dieta(cd_dieta_p),1,80);
elsif (ie_tipo_dieta_p = 'S') and (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
	ds_retorno_w	:= obter_desc_material(cd_material_p);
elsif (ie_tipo_dieta_p = 'L') then
	ds_retorno_w	:= obter_desc_material(cd_mat_prod1_p);
elsif (ie_tipo_dieta_p = 'E') then
	if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
		ds_retorno_w	:= obter_desc_material(cd_material_p);
	elsif (cd_dieta_p IS NOT NULL AND cd_dieta_p::text <> '') then
		ds_retorno_w	:= obter_nome_dieta(cd_dieta_p);
	end if;
elsif (ie_tipo_dieta_p = 'J')  and (nr_seq_tipo_p IS NOT NULL AND nr_seq_tipo_p::text <> '')then
   begin
   select   max(ds_tipo)
   into STRICT     ds_retorno_w
   from     rep_tipo_jejum
   where    nr_sequencia = nr_seq_tipo_p;
   end;
elsif (ie_tipo_dieta_p = 'P') then --Nutricao Parenteral
	select 	max(ie_dieta_enteral),
			max(ie_via_aplicacao)
	into STRICT 	ie_dieta_enteral_w,
			ie_via_aplicacao_w
	from 	cpoe_dieta
	where 	nr_sequencia = nr_seq_cpoe_p;
		
	if (ie_dieta_enteral_w = 'S') then
		ds_retorno_w	:= obter_desc_expressao(304204) ||' '||cpoe_add_span(coalesce(obter_desc_via(ie_via_aplicacao_w), ''));
	else
		ds_retorno_w	:= obter_desc_expressao(305331);
	end if;
elsif (ie_tipo_dieta_p = 'I') then --Nutricao Parenteral Infantil
	ds_retorno_w	:= obter_desc_expressao(722485);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION apap_obter_ds_dieta (ie_tipo_dieta_p text, cd_dieta_p bigint, cd_material_p bigint, cd_mat_prod1_p bigint, nr_seq_tipo_p bigint, nr_seq_cpoe_p bigint default null) FROM PUBLIC;

