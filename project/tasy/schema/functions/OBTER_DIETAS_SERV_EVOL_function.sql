-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dietas_serv_evol (nr_seq_serv_dia_p bigint, ie_opcao_origem_p bigint, ie_tipo_evolucao_p bigint) RETURNS varchar AS $body$
DECLARE


nr_atendimento_w	bigint;
dt_servico_w		timestamp;
ds_dieta_w		varchar(255);
ds_retorno_w	varchar(2000) := null;
qt_rep_defindos_w	bigint;

C01 CURSOR FOR
SELECT	c.nm_dieta
FROM 	prescr_medica a,
	prescr_dieta b,
	dieta c
WHERE 	a.nr_prescricao = b.nr_prescricao
AND	c.cd_dieta = b.cd_dieta
AND 	dt_servico_w BETWEEN a.dt_inicio_prescr AND a.dt_validade_prescr
AND	coalesce(a.dt_suspensao::text, '') = ''
AND	obter_cod_funcao_usuario_orig(a.nm_usuario_original) = ie_tipo_evolucao_p
ORDER BY 1;

C02 CURSOR FOR
SELECT	c.nm_dieta
FROM 	nut_atend_serv_dia_rep d,
	prescr_medica a,
	prescr_dieta b,
	dieta c
WHERE 	a.nr_prescricao = b.nr_prescricao
AND	c.cd_dieta = b.cd_dieta
AND 	a.nr_prescricao = d.nr_prescr_oral
AND	d.NR_SEQ_SERV_DIA = nr_seq_serv_dia_p
AND	coalesce(a.dt_suspensao::text, '') = ''
AND	obter_cod_funcao_usuario_orig(a.nm_usuario_original) = ie_tipo_evolucao_p
ORDER BY 1;


BEGIN
Select	coalesce(count(*),0)
into STRICT	qt_rep_defindos_w
from	nut_atend_serv_dia_rep a
where	a.NR_SEQ_SERV_DIA = nr_seq_serv_dia_p;

if (qt_rep_defindos_w  > 0) then
	open C02;
	loop
	fetch C02 into
		ds_dieta_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		ds_retorno_w := ds_retorno_w||ds_dieta_w||',';
	end loop;
	close C02;
else
	Select	max(a.dt_servico),
		max(a.nr_atendimento)
	into STRICT	dt_servico_w,
		nr_atendimento_w
	from	nut_atend_serv_dia a,
		nut_servico b
	where	a.nr_sequencia = nr_seq_serv_dia_p
	and	a.nr_seq_servico = b.nr_sequencia
	and	((coalesce(b.ie_tipo_prescricao_servico::text, '') = '') or (b.ie_tipo_prescricao_servico = ie_opcao_origem_p));

	open C01;
	loop
	fetch C01 into
		ds_dieta_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		ds_retorno_w := ds_retorno_w||ds_dieta_w||',';
	end loop;
	close C01;
end if;

return	substr(ds_retorno_w,1,length(ds_retorno_w)-1)	;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dietas_serv_evol (nr_seq_serv_dia_p bigint, ie_opcao_origem_p bigint, ie_tipo_evolucao_p bigint) FROM PUBLIC;

