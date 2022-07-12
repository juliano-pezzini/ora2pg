-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_medic_prescr_atend ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_mat_w	varchar(20000);
ds_retorno_sol_w	varchar(20000);
ds_retorno_w		varchar(20000);
ds_solucao_w		varchar(20000);

ds_material_w	varchar(20000);

C01 CURSOR FOR
	SELECT	distinct
		obter_desc_mat_generico(a.cd_material)
	from	prescr_material a,
		prescr_medica b
	where	a.nr_prescricao		= b.nr_prescricao
	and	b.nr_Atendimento	= nr_atendimento_p
	and	(coalesce(b.dt_liberacao, b.dt_liberacao_medico) IS NOT NULL AND (coalesce(b.dt_liberacao, b.dt_liberacao_medico))::text <> '')
	and	a.ie_suspenso		= 'N'
	and	a.ie_agrupador		= 1
	and	b.IE_ORIGEM_INF		= '1'
	order by 1;

C02 CURSOR FOR
	SELECT	distinct
		a.DS_SOLUCAO
	from	prescr_solucao a,
		prescr_medica b
	where	a.nr_prescricao		= b.nr_prescricao
	and	b.nr_Atendimento	= nr_atendimento_p
	and	(coalesce(b.dt_liberacao, b.dt_liberacao_medico) IS NOT NULL AND (coalesce(b.dt_liberacao, b.dt_liberacao_medico))::text <> '')
	and	a.ie_suspenso		= 'N'
	and	(a.DS_SOLUCAO IS NOT NULL AND a.DS_SOLUCAO::text <> '')
	and	b.IE_ORIGEM_INF		= '1'
	order by 1;

BEGIN

open C01;
loop
fetch C01 into
	ds_material_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (coalesce(ds_retorno_mat_w::text, '') = '') then
		ds_retorno_mat_w	:= wheb_mensagem_pck.get_texto(308634) || ': '||	ds_material_w; -- Medic
	else
		ds_retorno_mat_w	:= ds_retorno_mat_w||', '||ds_material_w;
	end if;
	end;
end loop;
close C01;


open C02;
loop
fetch C02 into
	ds_solucao_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	if (coalesce(ds_retorno_sol_w::text, '') = '') then
		ds_retorno_sol_w	:= chr(13)||chr(10)|| wheb_mensagem_pck.get_texto(308635) || ': '|| ds_solucao_w; -- Soluc
	else
		ds_retorno_sol_w	:= ds_retorno_sol_w||', '||ds_solucao_w;
	end if;
	end;
end loop;
close C02;

ds_retorno_w	:= ds_retorno_mat_w;
if (ds_retorno_sol_w IS NOT NULL AND ds_retorno_sol_w::text <> '') then
	ds_retorno_w	:= ds_retorno_w||ds_retorno_sol_w;
end if;


return	substr(ds_retorno_w,1,4000);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_medic_prescr_atend ( nr_atendimento_p bigint) FROM PUBLIC;

