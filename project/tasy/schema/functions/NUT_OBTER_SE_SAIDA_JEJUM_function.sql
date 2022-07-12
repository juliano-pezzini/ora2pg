-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nut_obter_se_saida_jejum (dt_servico_p timestamp, cd_setor_atendimento_p bigint, nr_atendimento_p bigint, nr_Seq_Servico_p bigint) RETURNS varchar AS $body$
DECLARE

				
dt_liberacao_w	        timestamp;
nr_prescricao_w	        bigint;
qt_prescr_w	        bigint;
ds_retorno_w	        varchar(1) := 'N';
dt_fim_w	        timestamp;
dt_servico_inicio_w	timestamp;
dt_servico_fim_w	timestamp;
dt_presc_inicio_w	timestamp;
dt_presc_fim_w		timestamp;


BEGIN
IF (dt_servico_p IS NOT NULL AND dt_servico_p::text <> '') THEN
	
        dt_servico_inicio_w 	:= PKG_DATE_UTILS.start_of(dt_servico_p, 'DAY');
        dt_servico_fim_w	:= PKG_DATE_UTILS.start_of(dt_servico_p, 'DAY') + 86399/86400;
        dt_presc_inicio_w	:= PKG_DATE_UTILS.start_of(dt_servico_p, 'DAY') - 7;
        dt_presc_fim_w		:= PKG_DATE_UTILS.start_of(dt_servico_p, 'DAY') + 86399/86400;

      
	begin
		SELECT	'S'
		INTO STRICT	ds_retorno_w
		FROM  	nut_atend_serv_dia a,
			prescr_medica b,
			prescr_dieta_hor c
		WHERE	a.nr_Atendimento 	= b.nr_atendimento
		AND	b.nr_prescricao 	= c.nr_prescricao
		AND	(coalesce(b.dt_liberacao,b.dt_liberacao_medico) IS NOT NULL AND (coalesce(b.dt_liberacao,b.dt_liberacao_medico))::text <> '')
		AND	a.dt_Servico BETWEEN b.dt_inicio_prescr AND b.dt_validade_prescr
		AND	PKG_DATE_UTILS.start_of(a.dt_servico, 'MI') = PKG_DATE_UTILS.start_of(c.dt_horario, 'MI')
		AND	(c.dt_desbloqueio_dieta IS NOT NULL AND c.dt_desbloqueio_dieta::text <> '')
		AND	a.nr_Seq_Servico 	= nr_Seq_Servico_p
		AND	a.nr_atendimento 	= nr_Atendimento_p
		AND	a.cd_setor_Atendimento 	= cd_setor_Atendimento_p
		and	b.dt_prescricao	between dt_presc_inicio_w and dt_presc_fim_w
		AND	a.dt_servico BETWEEN dt_servico_inicio_w AND dt_servico_fim_w;
	exception
		when others then
		ds_retorno_w := 'N';
	end;

	if (ds_retorno_w <> 'S') then
		SELECT	max(coalesce(b.dt_liberacao,b.dt_liberacao_medico))
		INTO STRICT	dt_liberacao_w
		FROM  	nut_atend_serv_dia a,
			prescr_medica b
		WHERE	a.nr_Atendimento 	= b.nr_atendimento
		AND	(coalesce(b.dt_liberacao,b.dt_liberacao_medico) IS NOT NULL AND (coalesce(b.dt_liberacao,b.dt_liberacao_medico))::text <> '')
		AND	a.dt_Servico BETWEEN b.dt_inicio_prescr AND b.dt_validade_prescr
		AND	a.nr_Seq_Servico 	= nr_Seq_Servico_p
		AND	a.nr_atendimento 	= nr_Atendimento_p
		AND	a.cd_setor_Atendimento 	= cd_setor_Atendimento_p
		and	b.dt_prescricao	between dt_presc_inicio_w and dt_presc_fim_w
		AND	a.dt_servico BETWEEN dt_servico_inicio_w AND dt_servico_fim_w
		and	exists (	SELECT	1
				from	rep_jejum c
				where	c.nr_prescricao = b.nr_prescricao);
	
		if (coalesce(dt_liberacao_w::text, '') = '') then
			SELECT	max(coalesce(b.dt_liberacao,b.dt_liberacao_medico))
			INTO STRICT	dt_liberacao_w
			FROM  	nut_atend_serv_dia a,
				prescr_medica b
			WHERE	a.nr_Atendimento 	= b.nr_atendimento
			AND	(coalesce(b.dt_liberacao,b.dt_liberacao_medico) IS NOT NULL AND (coalesce(b.dt_liberacao,b.dt_liberacao_medico))::text <> '')
			AND	a.dt_Servico BETWEEN b.dt_inicio_prescr AND b.dt_validade_prescr
			AND	a.nr_Seq_Servico 	= nr_Seq_Servico_p
			AND	a.nr_atendimento 	= nr_Atendimento_p
			AND	a.cd_setor_Atendimento 	= cd_setor_Atendimento_p
			and	b.dt_prescricao	between dt_presc_inicio_w and dt_presc_fim_w
			AND	a.dt_servico BETWEEN dt_servico_inicio_w AND dt_servico_fim_w;
		end if;
		
                if (dt_liberacao_w IS NOT NULL AND dt_liberacao_w::text <> '') then
                        SELECT	MAX(b.nr_prescricao)
                        into STRICT	nr_prescricao_w
                        FROM  	nut_atend_serv_dia a,
                                prescr_medica b
                        WHERE	a.nr_Atendimento 	= b.nr_atendimento
                        AND	(coalesce(b.dt_liberacao,b.dt_liberacao_medico) IS NOT NULL AND (coalesce(b.dt_liberacao,b.dt_liberacao_medico))::text <> '')
                        AND	a.dt_Servico BETWEEN b.dt_inicio_prescr AND b.dt_validade_prescr
                        AND	a.nr_Seq_Servico 	= nr_Seq_Servico_p
                        AND	a.nr_atendimento 	= nr_Atendimento_p
                        AND	a.cd_setor_Atendimento 	= cd_setor_Atendimento_p
                        and	b.dt_prescricao	between dt_presc_inicio_w and dt_presc_fim_w
                        AND	a.dt_servico BETWEEN dt_servico_inicio_w AND dt_servico_fim_w
                        AND (dt_liberacao_w = b.dt_liberacao or dt_liberacao_w = b.dt_liberacao_medico);

                        if (nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '') THEN
                                SELECT	CASE WHEN COUNT(*)=0 THEN 'N'  ELSE 'S' END 
                                INTO STRICT	ds_retorno_w
                                FROM	rep_jejum a
                                WHERE	a.nr_prescricao = nr_prescricao_w
                                and	coalesce(a.dt_fim,dt_servico_p) < dt_servico_p;
                        end if;
                end if;
		
        else
                SELECT	coalesce(max('S'),'N')
                INTO STRICT	ds_retorno_w
                FROM  	nut_atend_serv_dia a,
                        prescr_medica b,
                        rep_jejum c
                WHERE	a.nr_Atendimento 	= b.nr_atendimento
                AND	b.nr_prescricao 	= c.nr_prescricao
                AND	(coalesce(b.dt_liberacao,b.dt_liberacao_medico) IS NOT NULL AND (coalesce(b.dt_liberacao,b.dt_liberacao_medico))::text <> '')
                AND	a.dt_Servico BETWEEN b.dt_inicio_prescr AND b.dt_validade_prescr
                AND	a.nr_Seq_Servico 	= nr_Seq_Servico_p
                AND	a.nr_atendimento 	= nr_Atendimento_p
                AND	a.cd_setor_Atendimento  = cd_setor_Atendimento_p
                AND	a.dt_servico BETWEEN dt_servico_inicio_w AND dt_servico_fim_w
                and	coalesce(c.dt_fim,dt_servico_p) < dt_servico_p
                and	b.dt_prescricao	between dt_presc_inicio_w and dt_presc_fim_w
                and     exists (SELECT	1
                                FROM  	prescr_dieta_hor x
                                WHERE   x.nr_prescricao = b.nr_prescricao
                                and     x.dt_horario >= c.dt_fim);

                if (ds_retorno_w = 'N') then
                        SELECT	coalesce(max('S'),'N')
                        INTO STRICT	ds_retorno_w
                        FROM  	nut_atend_serv_dia a,
                                prescr_medica b,
                                rep_jejum c
                        WHERE	a.nr_Atendimento 	= b.nr_atendimento
                        AND	b.nr_prescricao 	= c.nr_prescricao
                        AND	(coalesce(b.dt_liberacao,b.dt_liberacao_medico) IS NOT NULL AND (coalesce(b.dt_liberacao,b.dt_liberacao_medico))::text <> '')
                        AND	a.dt_Servico BETWEEN b.dt_inicio_prescr AND b.dt_validade_prescr
                        AND	a.nr_Seq_Servico 	= nr_Seq_Servico_p
                        AND	a.nr_atendimento 	= nr_Atendimento_p
                        AND	a.cd_setor_Atendimento  = cd_setor_Atendimento_p
                        AND	a.dt_servico BETWEEN dt_servico_inicio_w AND dt_servico_fim_w
                        and	coalesce(c.dt_fim,dt_servico_p) < dt_servico_p
                        and	b.dt_prescricao	between dt_presc_inicio_w and dt_presc_fim_w
                        and     exists (SELECT	1
                                        FROM	prescr_mat_hor x
                                        WHERE   x.nr_prescricao = b.nr_prescricao
                                        and     x.dt_horario >= c.dt_fim);
                end if;
			
	end if;
END IF;

RETURN	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nut_obter_se_saida_jejum (dt_servico_p timestamp, cd_setor_atendimento_p bigint, nr_atendimento_p bigint, nr_Seq_Servico_p bigint) FROM PUBLIC;
