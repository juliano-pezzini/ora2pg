-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_mat_ger_pres_atend ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_localizacao_p text, cd_local_estoque_p bigint, ie_generico_p text) RETURNS varchar AS $body$
DECLARE


/* ie_generico_p  'S '  ou 'N' */

ds_retorno_w		varchar(128);
ds_material_w		varchar(250);
ds_generico_w		varchar(250);
ie_tipo_fonte_w		varchar(003);
ds_local_w		varchar(80);
cd_material_w		integer;
dt_baixa_w		timestamp;
ie_urgencia_w		varchar(01);
cd_local_w		integer;


BEGIN

if (ie_localizacao_p = 'S') and (coalesce(cd_local_estoque_p,0) = 0) then
	SELECT	max(b.cd_local_estoque)
	into STRICT	cd_local_w
	FROM	setor_atendimento b,
		prescr_medica a
	where	nr_prescricao	= nr_prescricao_p
	and	a.cd_setor_atendimento	= b.cd_setor_atendimento;
end if;

cd_local_w := coalesce(cd_local_w, cd_local_estoque_p);

select	cd_material,
	dt_baixa,
	coalesce(ie_urgencia,'N')
into STRICT	cd_material_w,
	dt_baixa_w,
	ie_urgencia_w
from	Prescr_material
where	nr_prescricao		= nr_prescricao_p
  and	nr_sequencia		= nr_sequencia_p;

select	substr(max(ds_material),1,100),
	max(obter_desc_material(coalesce(cd_material_generico,cd_material))) ds_generico,
	max(coalesce(ie_tipo_fonte_prescr,' '))
into STRICT	ds_material_w,
	ds_generico_w,
	ie_tipo_fonte_w
from 	material
where	cd_material = cd_material_w;

ds_local_w			:= '';
if (ie_localizacao_p = 'S') and (coalesce(cd_local_w,0) > 0) then
	Select substr(obter_localizacao_material(cd_material_w, cd_local_w),1,60)
	into STRICT	ds_local_w
	;
	if (ds_local_w IS NOT NULL AND ds_local_w::text <> '') then
		ds_local_w	:= ' [' || ds_local_w || ']';
	end if;
end if;

if (ie_generico_p = 'N') then
	ds_retorno_w		:= ds_material_w || ds_local_w;
else
	ds_retorno_w		:= ds_generico_w || ds_local_w;
end if;

if (ie_urgencia_w = 'S') then
	if (coalesce(dt_baixa_w::text, '') = '') then
		ds_retorno_w	:= '#' || ds_retorno_w || '#' || 'NI' ||'#P';
	else
		ds_retorno_w	:= '#' || ds_retorno_w || '#' || 'KNI' ||'#P';
	end if;
elsif (ie_tipo_fonte_w = 'MS') and (coalesce(dt_baixa_w::text, '') = '')then
	begin
	ds_retorno_w 	:= upper(ds_retorno_w);
	ie_tipo_fonte_w	:= 'S';
	ds_retorno_w	:= '#' || ds_retorno_w || '#' || ie_tipo_fonte_w ||'#P';
	end;
elsif (ie_tipo_fonte_w = 'MN') and (coalesce(dt_baixa_w::text, '') = '')then
	begin
	ds_retorno_w 	:= upper(ds_retorno_w);
	ds_retorno_w	:= '#' || ds_retorno_w || '#' || ie_tipo_fonte_w ||'#P';
	end;
elsif (ie_tipo_fonte_w <> ' ') and (ie_tipo_fonte_w <> 'M') then
	if (coalesce(dt_baixa_w::text, '') = '') then
		ds_retorno_w	:= '#' || ds_retorno_w || '#' || ie_tipo_fonte_w ||'#P';
	else
		ds_retorno_w	:= '#' || ds_retorno_w || '#K' || ie_tipo_fonte_w ||'#P';
	end if;
elsif (ie_tipo_fonte_w <> ' ') and (ie_tipo_fonte_w = 'M') then
	if (coalesce(dt_baixa_w::text, '') = '') then
		ds_retorno_w	:= upper('#' || ds_retorno_w || '#' || ' ' ||'#P');
	else
		ds_retorno_w	:= upper('#' || ds_retorno_w || '#' || 'K ' ||'#P');
	end if;
elsif (dt_baixa_w IS NOT NULL AND dt_baixa_w::text <> '') then
	ds_retorno_w	:= '#' || ds_retorno_w || '#' || 'K' ||'#P';
end if;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_mat_ger_pres_atend ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_localizacao_p text, cd_local_estoque_p bigint, ie_generico_p text) FROM PUBLIC;
