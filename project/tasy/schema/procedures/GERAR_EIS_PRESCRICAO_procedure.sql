-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_eis_prescricao (dt_referencia_p timestamp, nm_usuario_p text, ie_mensal_p text) AS $body$
DECLARE

 
dt_inicial_w			timestamp;
dt_final_w			timestamp;
cd_setor_atendimento_w	integer;
cd_unidade_basica_w		varchar(10);
cd_unidade_compl_w		varchar(10);
ie_status_unidade_w		varchar(03) := 'L';
ie_temporario_w		varchar(01);
ie_situacao_w			varchar(01);
nr_pacientes_w		integer   := 0;
ie_status_paciente_w		varchar(03) := 'L';
nr_atendimento_w		bigint;
qt_prescricao_w		bigint;
cd_estabelecimento_w		smallint   := 1;
cd_pessoa_fisica_w		varchar(10);
cd_medico_w				varchar(10);
hr_inicio_prescricao_w	varchar(20);
nr_sequencia_w		bigint;
nr_gravado_w			bigint;
dt_saida_unidade_w		timestamp;
nr_prescricao_w		bigint;
dt_liberacao_medico_w	timestamp;
dt_inicio_setor_w		timestamp;
dt_baixa_w			timestamp;
hr_limite_medico_w		varchar(05);
ie_motivo_prescricao_w		varchar(05);
hr_limite_atendimento_w	varchar(05);
qt_prescr_em_tempo_w		bigint;
qt_prescr_fora_tempo_w		bigint;
qt_prescricao_atendida_w	bigint;
dt_parametro_mes_w		timestamp;
dt_limite_medico_w		timestamp;
dt_limite_atendimento_w	timestamp;
qt_prescr_medico_w		bigint;
qt_prescr_nao_medico_w	bigint;
cd_setor_usuario_w	integer;
nm_usuario_original_w	varchar(15);
cd_cargo_w		bigint;
ie_tipo_atendimento_w	smallint;
ie_analisada_farm_w   varchar(1);
ie_inconsistencia_farm_w varchar(1);

C01 CURSOR FOR 
	SELECT	DISTINCT 
		a.cd_setor_atendimento, 
		a.cd_unidade_basica, 
		a.cd_unidade_compl, 
		coalesce(a.ie_status_unidade,'L') ie_status_unidade, 
		coalesce(a.ie_temporario,'N'), 
		coalesce(a.ie_situacao,'A'), 
		b.hr_limite_medico, 
		b.hr_limite_atendimento, 
		TO_CHAR(b.hr_inicio_prescricao,'hh24:mi:ss') 
	FROM	unidade_atendimento a, 
		setor_atendimento b 
	WHERE	a.cd_setor_atendimento = b.cd_setor_atendimento 
	AND (coalesce(dt_criacao, dt_inicial_w) -1) <= dt_referencia_p 
	ORDER BY a.cd_setor_atendimento, 
		 a.cd_unidade_basica, 
		 a.cd_unidade_compl;

C02 CURSOR FOR 
	SELECT /*+ INDEX(B ATEPACU_I1) INDEX(a atepaci_pk) */ 
		DISTINCT 
		a.nr_atendimento, 
		a.cd_estabelecimento, 
		a.cd_pessoa_fisica, 
		coalesce(b.dt_saida_unidade, dt_final_w + 1), 
		ie_tipo_atendimento 
	FROM	atendimento_paciente a, 
		atend_paciente_unidade b 
	WHERE	a.nr_atendimento 	= b.nr_atendimento 
	AND	b.cd_setor_atendimento 	= cd_setor_atendimento_w 
	AND	b.cd_unidade_basica  	= cd_unidade_basica_w 
	AND	b.cd_unidade_compl   	= cd_unidade_compl_w 
	AND	b.dt_entrada_unidade  	< dt_final_w 
	AND	b.dt_saida_interno	>= dt_inicial_w 
	AND	NOT EXISTS (SELECT	x.cd_motivo_alta 
		FROM	motivo_alta x 
		WHERE	x.ie_censo_diario = 'N' 
		AND	a.cd_motivo_alta 	= x.cd_motivo_alta) 
    ORDER BY 1;

C03 CURSOR FOR 
	SELECT	nr_prescricao, 
		cd_medico, 
		coalesce(dt_liberacao_medico, dt_liberacao), 
		CASE WHEN SUBSTR(Obter_Prescr_Medico(nr_prescricao),1,1)='S' THEN 1  ELSE 0 END  qt_prescr_medico, 
		CASE WHEN SUBSTR(Obter_Prescr_Medico(nr_prescricao),1,1)='N' THEN 1  ELSE 0 END  qt_prescr_nao_medico, 
		nm_usuario_original, 
		ie_motivo_prescricao 
	FROM	prescr_medica 
	WHERE	nr_atendimento			= nr_atendimento_w 
	AND	cd_setor_atendimento		= cd_setor_atendimento_w 
	AND	TRUNC(dt_prescricao,'dd')	= dt_inicial_w 
	AND	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

C09 CURSOR FOR 
SELECT 	cd_estabelecimento	, 
	cd_setor_atendimento	, 
	cd_medico		, 
	ie_tipo_atendimento	, 
	SUM(qt_paciente)	, 
	SUM(qt_prescricao)	, 
	SUM(qt_prescr_em_tempo)	, 
	SUM(qt_prescricao_atendida), 
	SUM(qt_prescr_medico), 
	SUM(qt_prescr_nao_medico), 
	nm_usuario_original, 
	ie_motivo_prescricao, 
	SUM(qt_prescr_fora_tempo), 
	coalesce(MAX(ie_analisada_farm),'N'), 
	coalesce(MAX(ie_inconsistencia_farm),'N') 
FROM 	eis_prescricao 
WHERE 	dt_referencia BETWEEN dt_parametro_mes_w AND LAST_DAY(dt_parametro_mes_w) + 86399/86400 
AND	ie_periodo		= 'D' 
AND	ie_mensal_p		= 'S' 
GROUP BY 
	cd_estabelecimento	, 
	cd_setor_atendimento, 
	cd_medico, 
	ie_tipo_atendimento, 
	ie_motivo_prescricao, 
	nm_usuario_original;

 

BEGIN 
dt_inicial_w		:= TRUNC(dt_referencia_p, 'dd');
dt_final_w		:= TRUNC(dt_referencia_p, 'dd') + 1 - 1/86400;
dt_parametro_mes_w	:= TRUNC(dt_referencia_p, 'month');
 
DELETE FROM eis_prescricao 
WHERE 	dt_referencia 	= dt_inicial_w 
AND	ie_periodo		= 'D';
 
OPEN C01;
LOOP 
FETCH C01 INTO 
	cd_setor_atendimento_w, 
	cd_unidade_basica_w, 
	cd_unidade_compl_w, 
	ie_status_unidade_w, 
	ie_temporario_w, 
	ie_situacao_w, 
	hr_limite_medico_w, 
	hr_limite_atendimento_w, 
	hr_inicio_prescricao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	nr_pacientes_w     := 0;
	qt_prescricao_w			:= 0;
 
	OPEN C02;
	LOOP 
	FETCH C02 INTO 
		nr_atendimento_w, 
		cd_estabelecimento_w, 
		cd_pessoa_fisica_w, 
		dt_saida_unidade_w, 
		ie_tipo_atendimento_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		nr_pacientes_w        	:= 0;
		qt_prescricao_w					:= 0;
		qt_prescr_em_tempo_w			:= 0;
		qt_prescr_fora_tempo_w			:= 0;
		qt_prescricao_atendida_w		:= 0;
		IF	dt_saida_unidade_w > dt_final_w THEN 
			nr_pacientes_w		:= 1;
		END IF;
 
 
		OPEN C03;
		LOOP 
		FETCH C03 INTO 
			nr_prescricao_w, 
			cd_medico_w, 
			dt_liberacao_medico_w, 
			qt_prescr_medico_w, 
			qt_prescr_nao_medico_w, 
			nm_usuario_original_w, 
			ie_motivo_prescricao_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			qt_prescricao_w			:= 1;
 
			SELECT	MAX(cd_setor_atendimento) 
			INTO STRICT	cd_setor_usuario_w 
			FROM	usuario 
			WHERE	cd_pessoa_fisica	= cd_medico_w;
 
			SELECT	MAX(b.cd_cargo) 
			INTO STRICT	cd_cargo_w 
			FROM	pessoa_fisica b, 
				usuario a 
			WHERE	a.cd_pessoa_fisica	= b.cd_pessoa_fisica 
			AND	a.nm_usuario		= nm_usuario_original_w;
 
			SELECT	MIN(dt_baixa) 
			INTO STRICT	dt_baixa_w 
			FROM	prescr_material 
			WHERE	nr_prescricao		= nr_prescricao_w;
 
			SELECT coalesce(MAX('S'),'N') 
			INTO STRICT  ie_analisada_farm_w 
			FROM prescr_medica 
			WHERE ((dt_inicio_analise_farm IS NOT NULL AND dt_inicio_analise_farm::text <> '' AND dt_liberacao_farmacia IS NOT NULL AND dt_liberacao_farmacia::text <> '') OR (dt_liberacao_parc_farm IS NOT NULL AND dt_liberacao_parc_farm::text <> '')) 
			AND  nr_prescricao = nr_prescricao_w;
 
			SELECT coalesce(MAX('S'),'N') 
			INTO STRICT ie_inconsistencia_farm_w 
			FROM prescr_material a, 
				 inconsistencia_med_farm b 
			WHERE a.nr_seq_inconsistencia = b.nr_sequencia 
			AND ((a.nr_seq_inconsistencia IS NOT NULL AND a.nr_seq_inconsistencia::text <> '') OR ((SELECT coalesce(COUNT(*),0) 
															FROM inconsistencia_med_farm a, 
																 prescr_material b 
															WHERE b.nr_seq_inconsistencia = a.nr_sequencia 
															AND  nr_prescricao = nr_prescricao_w) > 0)) 
			AND a.nr_prescricao = nr_prescricao_w;
 
			IF (dt_liberacao_medico_w IS NOT NULL AND dt_liberacao_medico_w::text <> '') AND (hr_limite_medico_w IS NOT NULL AND hr_limite_medico_w::text <> '') AND (hr_limite_atendimento_w IS NOT NULL AND hr_limite_atendimento_w::text <> '') THEN 
 
				BEGIN 
				dt_limite_medico_w		:= TO_DATE(TO_CHAR(dt_liberacao_medico_w, 'dd/mm/yyyy') || 
								' ' || hr_limite_medico_w, 'dd/mm/yyyy hh24:mi');
				dt_limite_atendimento_w	:= TO_DATE(TO_CHAR(dt_liberacao_medico_w, 'dd/mm/yyyy') || 
								' ' || hr_limite_atendimento_w, 'dd/mm/yyyy hh24:mi');
				EXCEPTION WHEN OTHERS THEN 
				NULL;
				END;
 
			END IF;
 
			IF (dt_liberacao_medico_w <= dt_limite_medico_w) THEN 
				qt_prescr_em_tempo_w	:= 1;
			END IF;
 
			IF (dt_liberacao_medico_w IS NOT NULL AND dt_liberacao_medico_w::text <> '') AND (hr_inicio_prescricao_w IS NOT NULL AND hr_inicio_prescricao_w::text <> '') THEN 
 
				--begin 
				dt_inicio_setor_w		:= TO_DATE(TO_CHAR(dt_liberacao_medico_w, 'dd/mm/yyyy') || 
								' ' || hr_inicio_prescricao_w, 'dd/mm/yyyy hh24:mi:ss');
				/*exception when others then 
				null; 
				end;*/
 
 
			END IF;
 
			IF (dt_liberacao_medico_w > dt_inicio_setor_w) THEN 
				qt_prescr_fora_tempo_w	:= 1;
			END IF;
 
			IF (dt_baixa_w <= dt_limite_atendimento_w) THEN 
				qt_prescricao_atendida_w	:= 1;
			END IF;
 
			SELECT	nextval('eis_prescricao_seq') 
			INTO STRICT	nr_sequencia_w 
			;
 
			INSERT	INTO eis_prescricao(nr_sequencia, 
				cd_estabelecimento, 
				ie_periodo, 
				dt_referencia, 
				dt_atualizacao, 
				nm_usuario, 
				cd_setor_atendimento, 
				cd_medico, 
				qt_prescricao, 
				qt_prescr_em_tempo, 
				qt_prescricao_atendida, 
				qt_paciente, 
				qt_prescr_medico, 
				qt_prescr_nao_medico, 
				cd_setor_usuario, 
				cd_cargo_prescritor, 
				ie_tipo_atendimento, 
				nm_usuario_original, 
				ie_motivo_prescricao, 
				qt_prescr_fora_tempo, 
				ie_analisada_farm, 
				ie_inconsistencia_farm) 
			VALUES (nr_sequencia_w, 
				cd_estabelecimento_w, 
				'D', 
				dt_inicial_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				cd_setor_atendimento_w, 
				cd_medico_w, 
				qt_prescricao_w, 
				qt_prescr_em_tempo_w, 
				qt_prescricao_atendida_w, 
				nr_pacientes_w, 
				qt_prescr_medico_w, 
				qt_prescr_nao_medico_w, 
				cd_setor_usuario_w, 
				cd_cargo_w, 
				ie_tipo_atendimento_w, 
				nm_usuario_original_w, 
				ie_motivo_prescricao_w, 
				qt_prescr_fora_tempo_w, 
				ie_analisada_farm_w, 
				ie_inconsistencia_farm_w);
/*			end if; */
 
		qt_prescricao_w		:= 0;
		nr_pacientes_w		:= 0;
		END LOOP;
		CLOSE C03;
	END LOOP;
	CLOSE c02;
END LOOP;
CLOSE c01;
 
DELETE 	FROM eis_prescricao 
WHERE 	dt_referencia = dt_parametro_mes_w 
AND 	ie_periodo = 'M';
 
OPEN C09;
LOOP 
FETCH C09 INTO 
	cd_estabelecimento_w	, 
	cd_setor_atendimento_w , 
	cd_medico_w		, 
	ie_tipo_atendimento_w	, 
	nr_pacientes_w		, 
	qt_prescricao_w		, 
	qt_prescr_em_tempo_w	, 
	qt_prescricao_atendida_w, 
	qt_prescr_medico_w, 
	qt_prescr_nao_medico_w, 
	nm_usuario_original_w, 
	ie_motivo_prescricao_w, 
	qt_prescr_fora_tempo_w, 
	ie_analisada_farm_w, 
	ie_inconsistencia_farm_w;
EXIT WHEN NOT FOUND; /* apply on C09 */
	SELECT	nextval('eis_prescricao_seq') 
	INTO STRICT	nr_sequencia_w 
	;
	INSERT	INTO eis_prescricao(nr_sequencia, 
		cd_estabelecimento, 
		ie_periodo, 
		dt_referencia, 
		dt_atualizacao, 
		nm_usuario, 
		cd_setor_atendimento, 
		cd_medico, 
		qt_prescricao, 
		qt_prescr_em_tempo, 
		qt_prescricao_atendida, 
		qt_paciente, 
		qt_prescr_medico, 
		qt_prescr_nao_medico, 
		cd_setor_usuario, 
		cd_cargo_prescritor, 
		ie_tipo_atendimento, 
		nm_usuario_original, 
		ie_motivo_prescricao, 
		qt_prescr_fora_tempo, 
		ie_analisada_farm, 
		ie_inconsistencia_farm) 
	VALUES (nr_sequencia_w		, 
		cd_estabelecimento_w	, 
		'M'       	, 
		dt_parametro_mes_w	, 
		clock_timestamp()			, 
		nm_usuario_p		, 
		cd_setor_atendimento_w	, 
		cd_medico_w	    , 
		qt_prescricao_w		, 
		qt_prescr_em_tempo_w	, 
		qt_prescricao_atendida_w, 
		nr_pacientes_w, 
		qt_prescr_medico_w, 
		qt_prescr_nao_medico_w, 
		cd_setor_usuario_w, 
		cd_cargo_w, 
		ie_tipo_atendimento_w, 
		nm_usuario_original_w, 
		ie_motivo_prescricao_w, 
		qt_prescr_fora_tempo_w, 
		ie_analisada_farm_w, 
		ie_inconsistencia_farm_w);
END LOOP;
CLOSE C09;
 
COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_eis_prescricao (dt_referencia_p timestamp, nm_usuario_p text, ie_mensal_p text) FROM PUBLIC;

