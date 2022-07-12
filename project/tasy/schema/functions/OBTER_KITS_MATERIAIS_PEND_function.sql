-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_kits_materiais_pend ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	substr(obter_desc_kit(b.cd_material_kit),1,255)
	from	prescr_medica a,
		prescr_material b
	where	a.nr_prescricao = b.nr_prescricao
	and	b.cd_motivo_baixa 	= 0
	and	b.ie_suspenso		= 'N'
	and	coalesce(a.dt_suspensao::text, '') = ''
	and	a.nr_atendimento 	= nr_atendimento_p
	and	(b.cd_material_kit IS NOT NULL AND b.cd_material_kit::text <> '')
	and	exists ( SELECT 1
		        from  cirurgia
		        where nr_prescricao = a.nr_prescricao)
	order by 1;


ds_retorno_w	varchar(1000);
ds_kit_w	varchar(255);

BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	open C01;
	loop
	fetch C01 into
		ds_kit_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (ds_kit_w IS NOT NULL AND ds_kit_w::text <> '') then
			ds_retorno_w := ds_retorno_w || ds_kit_w || ', ';
		end if;
		end;
	end loop;
	close C01;

	if (length(ds_retorno_w) > 1) then
			ds_retorno_w	:= substr(ds_retorno_w, 1, length(ds_retorno_w)-2);
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_kits_materiais_pend ( nr_atendimento_p bigint) FROM PUBLIC;

