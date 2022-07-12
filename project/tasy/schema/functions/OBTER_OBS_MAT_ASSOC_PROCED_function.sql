-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_obs_mat_assoc_proced ( nr_prescricao_p bigint, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


nr_sequencia_w		bigint;
ds_observacao_w		varchar(2000);
ds_material_w		varchar(80);
ds_retorno_w		varchar(2500);

C01 CURSOR FOR
	SELECT	qt_dose ||' '||cd_unidade_medida_dose ||' '||substr(obter_desc_material(cd_material),1,60)
	from	prescr_material
	where	nr_prescricao		= nr_prescricao_p
	and	nr_sequencia_proc	= nr_sequencia_p
	and	ie_agrupador		= 5;



BEGIN

Select	nr_sequencia,
	ds_observacao
into STRICT	nr_sequencia_w,
	ds_observacao_w
from	prescr_procedimento
where	nr_prescricao 	= nr_prescricao_p
and	nr_sequencia	= nr_sequencia_p;

OPEN C01;
LOOP
FETCH C01 into
	ds_material_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if (ds_material_w IS NOT NULL AND ds_material_w::text <> '') and (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
		ds_retorno_w	:= ds_retorno_w ||' - '	||ds_material_w;
	elsif (ds_material_w IS NOT NULL AND ds_material_w::text <> '') then
		ds_retorno_w	:= ds_material_w;
	end if;

	exception
		when others then
          		ds_retorno_w	:= ds_retorno_w;
	end;
END LOOP;
CLOSE C01;

if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
	ds_retorno_w	:= '('||ds_retorno_w||')';
end if;

if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
	ds_retorno_w	:= ds_retorno_w ||' ('||ds_observacao_w||')';
end if;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_obs_mat_assoc_proced ( nr_prescricao_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
