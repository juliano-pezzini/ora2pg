-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nut_obter_dietas_serv_def (nr_seq_serv_dia_p bigint) RETURNS varchar AS $body$
DECLARE

				
ds_dieta_w	varchar(2000);
ds_retorno_w	varchar(2000) := null;
ie_prescr_hor_w	varchar(1);

C01 CURSOR FOR
        SELECT 	c.nm_dieta
	FROM prescr_dieta_hor z, nut_atend_serv_dia x, nut_servico f, nut_servico_horario e, nut_atend_serv_dia_rep d, dieta c, prescr_medica a, prescr_dieta b
LEFT OUTER JOIN cpoe_dieta y ON (b.nr_seq_dieta_cpoe = y.nr_sequencia)
WHERE b.nr_prescricao = a.nr_prescricao AND c.cd_dieta = b.cd_dieta AND d.nr_prescr_oral = a.nr_prescricao  AND d.nr_seq_serv_dia = nr_seq_serv_dia_p AND x.nr_sequencia = d.nr_seq_serv_dia AND z.nr_prescricao = a.nr_prescricao AND f.nr_sequencia = x.nr_seq_servico AND e.nr_seq_servico = f.nr_sequencia AND z.nr_seq_dieta = b.nr_sequencia AND (((b.ie_suspenso = 'N' or coalesce(b.ie_suspenso::text, '') = '') and coalesce(y.nr_sequencia::text, '') = '')
		or (coalesce(y.dt_lib_suspensao::text, '') = '' OR y.dt_lib_suspensao > x.dt_servico) 
		AND x.dt_servico BETWEEN PKG_DATE_UTILS.get_Time(y.dt_inicio, e.ds_horarios) and PKG_DATE_UTILS.get_Time(coalesce(y.dt_fim, x.dt_servico), e.ds_horarios_fim))
	 
UNION
 
	SELECT 	Obter_desc_expressao(304828) 
	FROM   	nut_atend_serv_dia_rep d, 
		nut_atend_serv_dia a, 
		rep_jejum c, 
		prescr_medica e 
	WHERE  	e.nr_prescricao = c.nr_prescricao 
	AND 	a.nr_sequencia = d.nr_seq_serv_dia 
	AND 	d.nr_prescr_jejum = c.nr_prescricao 
	AND 	a.nr_sequencia = nr_seq_serv_dia_p 
	AND (coalesce(c.ie_suspenso,'N') = 'N' and	a.dt_servico BETWEEN c.dt_inicio and coalesce(c.dt_fim,e.dt_validade_prescr))
	ORDER  BY 1;
	
C02 CURSOR FOR
        SELECT 	c.nm_dieta
	FROM nut_atend_serv_dia x, nut_atend_serv_dia_rep d, dieta c, prescr_medica a, prescr_dieta b
LEFT OUTER JOIN cpoe_dieta y ON (b.nr_seq_dieta_cpoe = y.nr_sequencia)
WHERE b.nr_prescricao = a.nr_prescricao AND c.cd_dieta = b.cd_dieta AND d.nr_prescr_oral = a.nr_prescricao  AND d.nr_seq_serv_dia = nr_seq_serv_dia_p AND x.nr_sequencia = d.nr_seq_serv_dia AND (((b.ie_suspenso = 'N' or coalesce(b.ie_suspenso::text, '') = '') and coalesce(y.nr_sequencia::text, '') = '')
		OR ((coalesce(y.dt_lib_suspensao::text, '') = '' OR y.dt_lib_suspensao > x.dt_servico) 
		AND x.dt_servico BETWEEN y.dt_inicio AND coalesce(y.dt_fim, x.dt_servico))) 
	 
UNION
 
	SELECT 	Obter_desc_expressao(304828) 
	FROM   	nut_atend_serv_dia_rep d, 
		nut_atend_serv_dia a, 
		rep_jejum c, 
		prescr_medica e 
	WHERE  	e.nr_prescricao = c.nr_prescricao 
	AND 	a.nr_sequencia = d.nr_seq_serv_dia 
	AND 	d.nr_prescr_jejum = c.nr_prescricao 
	AND 	a.nr_sequencia = nr_seq_serv_dia_p 
	AND (coalesce(c.ie_suspenso,'N') = 'N' and	a.dt_servico BETWEEN c.dt_inicio and coalesce(c.dt_fim,e.dt_validade_prescr))
	ORDER  BY 1;


BEGIN

ie_prescr_hor_w := obter_param_usuario(1003, 125, somente_numero(wheb_usuario_pck.get_cd_perfil), wheb_usuario_pck.get_nm_usuario, coalesce(wheb_usuario_pck.get_cd_estabelecimento,1), ie_prescr_hor_w);

if ( ie_prescr_hor_w = 'S' ) then
	open C01;
	loop
	fetch C01 into	
		ds_dieta_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		if (coalesce(ds_retorno_w::text, '') = '') then
			begin
			ds_retorno_w := ds_dieta_w;
			end;
		else
			ds_retorno_w := ds_retorno_w||', '||ds_dieta_w;
		end if;

	end loop;
	close C01;
else
	open C02;
	loop
	fetch C02 into	
		ds_dieta_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		if (coalesce(ds_retorno_w::text, '') = '') then
			begin
			ds_retorno_w := ds_dieta_w;
			end;
		else
			ds_retorno_w := ds_retorno_w||', '||ds_dieta_w;
		end if;

	end loop;
	close C02;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nut_obter_dietas_serv_def (nr_seq_serv_dia_p bigint) FROM PUBLIC;
