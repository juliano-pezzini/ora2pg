-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nut_obter_se_prim_prescricao ( nr_atendimento_p bigint, dt_inicio_p timestamp, dt_final_p timestamp, cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_resultado_w		varchar(1) := 'N';
dt_servico_w		timestamp;
nr_prescricao_w		bigint;
nr_primeira_prescr_w	bigint;
nr_min_prescr_w		bigint;
dt_inicio_filtro_w	timestamp;
dt_fim_filtro_w		timestamp;
dt_inicio_w		timestamp;
dt_final_w		timestamp;
qtd_dias_prim_prescr_w	bigint;

c01 CURSOR FOR 
	SELECT	a.dt_servico 
	from	nut_Atend_serv_dia a 
	where	a.dt_servico between dt_inicio_w and dt_final_w 
	and	a.cd_setor_atendimento 		= cd_setor_atendimento_p 
	and	a.nr_atendimento 		= nr_atendimento_p;


BEGIN 
 
IF (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') THEN 
 
	dt_inicio_w := trunc(Dt_inicio_p);
	dt_final_w := trunc(dt_final_p) + 86399/86400;
	 
	qtd_dias_prim_prescr_w := coalesce(Obter_Valor_Param_Usuario(1003, 70, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento),1000);
 
	open c01;
	loop 
	fetch c01 into dt_servico_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		 
		dt_inicio_filtro_w	:= trunc(dt_servico_w);
		dt_fim_filtro_w		:= trunc(dt_servico_w) + 86400/86399;
		 
		 
		select	min(a.nr_prescricao) 
		into STRICT	nr_primeira_prescr_w 
		from	atendimento_paciente c, 
			PRESCR_MEDICA A, 
			PRESCR_DIETA B 
		WHERE 	A.NR_PRESCRICAO 	= B.NR_PRESCRICAO 
		and	c.nr_atendimento	= a.nr_atendimento 
		AND 	a.nr_atendimento 	= nr_atendimento_p 
		AND 	(coalesce(A.DT_LIBERACAO, a.dt_liberacao_medico) IS NOT NULL AND (coalesce(A.DT_LIBERACAO, a.dt_liberacao_medico))::text <> '') 
		and	a.dt_prescricao	between inicio_dia(c.dt_entrada) and c.dt_entrada + qtd_dias_prim_prescr_w 
		AND 	NOT EXISTS (	SELECT 	1 
					FROM 	REP_JEJUM E 
					WHERE 	E.NR_PRESCRICAO = A.NR_PRESCRICAO);
					 
		nr_min_prescr_w := nr_primeira_prescr_w;
		 
		select	min(a.nr_prescricao) 
		into STRICT	nr_primeira_prescr_w 
		from	atendimento_paciente c, 
			PRESCR_MEDICA A, 
			PRESCR_MATERIAL B 
		WHERE 	A.NR_PRESCRICAO 	= B.NR_PRESCRICAO 
		and	c.nr_atendimento	= a.nr_atendimento 
		AND 	a.nr_atendimento 	= nr_atendimento_p 
		and	B.IE_AGRUPADOR IN (8,12) 
		AND 	(coalesce(A.DT_LIBERACAO, a.dt_liberacao_medico) IS NOT NULL AND (coalesce(A.DT_LIBERACAO, a.dt_liberacao_medico))::text <> '') 
		and	a.dt_prescricao	between inicio_dia(c.dt_entrada) and c.dt_entrada + qtd_dias_prim_prescr_w 
		AND 	NOT EXISTS (	SELECT 	1 
					FROM 	REP_JEJUM E 
					WHERE 	E.NR_PRESCRICAO = A.NR_PRESCRICAO);
					 
		if (nr_primeira_prescr_w < nr_min_prescr_w) then 
			nr_min_prescr_w := nr_primeira_prescr_w;
		end if;
		 
		select	min(a.nr_prescricao) 
		into STRICT	nr_primeira_prescr_w 
		from	atendimento_paciente c, 
			PRESCR_MEDICA A, 
			NUT_PAC B 
		WHERE 	A.NR_PRESCRICAO = B.NR_PRESCRICAO 
		and	c.nr_atendimento	= a.nr_atendimento 
		AND 	a.nr_atendimento 	= nr_atendimento_p 
		AND 	(coalesce(A.DT_LIBERACAO, a.dt_liberacao_medico) IS NOT NULL AND (coalesce(A.DT_LIBERACAO, a.dt_liberacao_medico))::text <> '') 
		and	a.dt_prescricao	between inicio_dia(c.dt_entrada) and c.dt_entrada + qtd_dias_prim_prescr_w 
		AND 	NOT EXISTS (	SELECT 	1 
					FROM 	REP_JEJUM E 
					WHERE 	E.NR_PRESCRICAO = A.NR_PRESCRICAO);
		 
		if (nr_primeira_prescr_w < nr_min_prescr_w) then 
			nr_min_prescr_w := nr_primeira_prescr_w;
		end if;
		 
		select	min(a.nr_prescricao) 
		into STRICT	nr_primeira_prescr_w 
		from	atendimento_paciente c, 
			PRESCR_MEDICA A, 
			PRESCR_LEITE_DERIV B 
		WHERE 	A.NR_PRESCRICAO 	= B.NR_PRESCRICAO 
		and	c.nr_atendimento	= a.nr_atendimento 
		AND 	a.nr_atendimento 	= nr_atendimento_p 
		AND 	(coalesce(A.DT_LIBERACAO, a.dt_liberacao_medico) IS NOT NULL AND (coalesce(A.DT_LIBERACAO, a.dt_liberacao_medico))::text <> '') 
		and	a.dt_prescricao	between inicio_dia(c.dt_entrada) and c.dt_entrada + qtd_dias_prim_prescr_w 
		AND 	NOT EXISTS (	SELECT 	1 
					FROM 	REP_JEJUM E 
					WHERE 	E.NR_PRESCRICAO = A.NR_PRESCRICAO);
 
		if (nr_primeira_prescr_w < nr_min_prescr_w) then 
			nr_min_prescr_w := nr_primeira_prescr_w;
		end if;
		 
		SELECT 	CASE WHEN COUNT(*)=1 THEN 'S'  ELSE ds_resultado_w END  
		into STRICT	ds_resultado_w 
		from ( 
			SELECT	nr_prescricao 
			FROM 	PRESCR_MEDICA A 
			WHERE	a.nr_prescricao = nr_min_prescr_w 
			AND 	dt_servico_w BETWEEN A.DT_INICIO_PRESCR AND A.DT_VALIDADE_PRESCR 
			and	a.dt_prescricao	between dt_inicio_filtro_w and dt_fim_filtro_w 
		) alias1;					
					 
					 
					 
		/* Juli - comentado - performance Sírio 
		select	min(nr_prescricao) 
		into	nr_primeira_prescr_w 
		from	PRESCR_MEDICA A 
		WHERE 	(EXISTS (	SELECT 	1 
					FROM 	PRESCR_DIETA B 
					WHERE 	A.NR_PRESCRICAO = B.NR_PRESCRICAO) 
			OR EXISTS (	SELECT 	1 
					FROM 	PRESCR_MATERIAL B 
					WHERE 	A.NR_PRESCRICAO = B.NR_PRESCRICAO 
					AND	B.IE_AGRUPADOR IN(8,12)) 
			OR EXISTS (	SELECT 	1 
					FROM 	NUT_PAC E 
					WHERE 	A.NR_PRESCRICAO = E.NR_PRESCRICAO) 
			or exists (	select	1 
					from	prescr_leite_deriv e 
					where	a.nr_prescricao = e.nr_prescricao)) 
		AND 	a.nr_atendimento 	= nr_atendimento_p 
		AND 	NVL(A.DT_LIBERACAO, a.dt_liberacao_medico) IS NOT NULL 
		AND 	NOT EXISTS (	SELECT 	1 
					FROM 	REP_JEJUM E 
					WHERE 	E.NR_PRESCRICAO = A.NR_PRESCRICAO); 
					 
		SELECT 	DECODE(COUNT(*),1,'S',ds_resultado_w) 
		into	ds_resultado_w 
		from ( 
			Select	nr_prescricao 
			FROM 	PRESCR_MEDICA A 
			WHERE 	(EXISTS (	SELECT 	1 
						FROM 	PRESCR_DIETA B 
						WHERE 	A.NR_PRESCRICAO = B.NR_PRESCRICAO) 
				OR EXISTS (	SELECT 	1 
						FROM 	PRESCR_MATERIAL B 
						WHERE 	A.NR_PRESCRICAO = B.NR_PRESCRICAO 
						AND	B.IE_AGRUPADOR IN(8,12)) 
				OR EXISTS (	SELECT 	1 
						FROM 	NUT_PAC E 
						WHERE 	A.NR_PRESCRICAO = E.NR_PRESCRICAO) 
				or exists (	select	1 
						from	prescr_leite_deriv e 
						where	a.nr_prescricao = e.nr_prescricao)) 
			AND 	a.nr_atendimento 	= nr_atendimento_p 
			->AND 	dt_servico_w BETWEEN A.DT_INICIO_PRESCR AND A.DT_VALIDADE_PRESCR 
			AND 	NVL(A.DT_LIBERACAO, a.dt_liberacao_medico) IS NOT NULL 
			AND 	NOT EXISTS (	SELECT 	1 
						FROM 	REP_JEJUM E 
						WHERE 	E.NR_PRESCRICAO = A.NR_PRESCRICAO) 
			->and	a.dt_prescricao	between dt_inicio_filtro_w and dt_fim_filtro_w 
			group by nr_prescricao 
			having nr_prescricao = nr_primeira_prescr_w 
		); 
		*/
 
		 
		/*SELECT	DECODE(COUNT(*),1,'S',decode(ds_resultado_w,'S','S','N')) 
		INTO	ds_resultado_w 
		from	prescr_medica a 
		where	(EXISTS (SELECT 1 FROM prescr_dieta b 		WHERE a.nr_prescricao = b.nr_prescricao) 
		OR	 EXISTS (SELECT 1 FROM prescr_material b 	WHERE a.nr_prescricao = b.nr_prescricao AND b.ie_agrupador IN(8,12)) 
		OR	 EXISTS (SELECT 1 FROM nut_pac e 		WHERE a.nr_prescricao = e.nr_prescricao)) 
		AND	 a.nr_atendimento = nr_atendimento_p	 
		and	 dt_servico_w between a.dt_inicio_prescr and a.dt_validade_prescr 
		AND	 NVL(a.dt_liberacao, a.dt_liberacao_medico) IS NOT NULL 
		and	 a.nr_prescricao = (	select	min(x.nr_prescricao) 
						from	prescr_medica x 
						where	(EXISTS (SELECT 1 FROM prescr_dieta b WHERE x.nr_prescricao = b.nr_prescricao) 
						OR	 EXISTS (SELECT 1 FROM prescr_material b WHERE x.nr_prescricao = b.nr_prescricao AND b.ie_agrupador IN(8,12)) 
						OR	 EXISTS (SELECT 1 FROM rep_jejum b WHERE x.nr_prescricao = b.nr_prescricao) 
						OR	 EXISTS (SELECT 1 FROM nut_pac e WHERE x.nr_prescricao = e.nr_prescricao)) 
						AND	 x.nr_atendimento = a.nr_atendimento 
						AND	 NVL(x.dt_liberacao, x.dt_liberacao_medico) IS NOT NULL) 
		and	a.dt_prescricao	between dt_inicio_filtro_w and dt_fim_filtro_w 
		AND	NOT EXISTS (SELECT 1 FROM rep_jejum e WHERE e.nr_prescricao = a.nr_prescricao);*/
 
		 
		 
		end;
	end loop;
	close c01;
 
END IF;
 
 
RETURN	ds_resultado_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nut_obter_se_prim_prescricao ( nr_atendimento_p bigint, dt_inicio_p timestamp, dt_final_p timestamp, cd_setor_atendimento_p bigint) FROM PUBLIC;
