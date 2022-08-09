-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fleury_ws_grava_result_laborat ( nr_ficha_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, cd_exame_p text, ds_resultado_p text, cd_unidade_p text, nm_usuario_p text, ie_final_p text, nr_seq_prescr_out_p INOUT bigint ) AS $body$
DECLARE

 
nr_prescricao_w			bigint := NULL;
nr_seq_prescr_w			bigint := NULL;
nr_seq_exame_w			bigint := NULL;
nr_seq_result_w			bigint;
ie_agrupa_w				varchar(1);
qt_result_final_w		bigint;
qt_result_parcial_w		bigint;
cd_estabelecimento_w	bigint;
ie_existe_param_maq_w	varchar(1);

nr_seq_exame_prescr_w	exame_laboratorio.nr_seq_exame%TYPE;
nr_seq_exame_atual_w	exame_laboratorio.nr_seq_exame%TYPE;
nr_seq_superior_w		exame_laboratorio.nr_seq_superior%TYPE;
qt_exame_dep_w			bigint;
nr_seq_prescr_nova_w	prescr_procedimento.nr_sequencia%TYPE;
nr_seq_resultado_laborat_w	result_laboratorio.nr_sequencia%type;
IE_MANTER_RESULTADO_EXAME_W	lab_parametro.IE_MANTER_RESULTADO_EXAME%type;

 
/*Cursor C01 is 
	select	el.nr_seq_exame 
	from	exame_laboratorio el 
	where nvl(el.cd_exame_integracao, el.cd_exame) = cd_exame_p 
	union 
	select	e.nr_seq_exame 
	from	exame_laboratorio e 
	where	e.nr_seq_exame 	= obter_equip_exame_integracao(cd_exame_p,'FLEURY',1) 
	order by 1;*/
 
 
C01 CURSOR FOR 
	SELECT	el.nr_seq_exame, 
		el.nr_seq_superior 
	FROM	exame_laboratorio el 
	WHERE coalesce(el.cd_exame_integracao, el.cd_exame) = cd_exame_p 
	
UNION
 
	SELECT	e.nr_seq_exame, 
		e.nr_seq_superior 
	FROM	exame_laboratorio e 
	WHERE	e.nr_seq_exame 	= obter_equip_exame_integracao(cd_exame_p,'FLEURY',1) 
	
UNION
 
	SELECT	e.nr_seq_exame, 
		e.nr_seq_superior 
	FROM	exame_laboratorio e 
	WHERE	e.nr_seq_exame 	= obter_equip_exame_integracao(cd_exame_p,'LABEXT',1) 
	ORDER BY 1;


BEGIN 
 
CALL gerar_lab_log_interf_imp(nr_prescricao_p, 
			NULL, 
			NULL, 
			NULL, 
			SUBSTR('fleury_ws_grava_result_laborat - cd_exame_p: '||cd_exame_p||' ds_resultado_p: '||ds_resultado_p||' nr_seq_prescr_p: '||nr_seq_prescr_p,1,1999), 
			'FleuryWS', 
			'', 
			nm_usuario_p, 
			'N');
 
 
IF	(nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '' AND nr_prescricao_p > 0) THEN 
 
	nr_prescricao_w := nr_prescricao_p;
 
ELSE 
	SELECT	fleury_obter_dados_unidade(cd_unidade_p, 'E'), 
			fleury_obter_dados_unidade(cd_unidade_p, 'AF') 
	INTO STRICT	cd_estabelecimento_w, 
			ie_agrupa_w 
	;
 
	/*select	nvl(max(ie_agrupa_ficha_fleury),'N'), 
		nvl(max(cd_estabelecimento),0) 
	into	ie_agrupa_w, 
		cd_estabelecimento_w 
	from	lab_parametro 
	where	nvl(cd_unidade_fleury,nvl(cd_unidade_p,'0')) = nvl(cd_unidade_p,'0');*/
 
 
	IF (ie_agrupa_w <> 'N') THEN 
		SELECT	CASE WHEN COUNT(*)=0 THEN 'N'  ELSE 'S' END  
		INTO STRICT	ie_existe_param_maq_w 
		FROM	lab_param_maquina a 
		WHERE	a.cd_estabelecimento = cd_estabelecimento_w;
 
		IF (ie_existe_param_maq_w = 'S') THEN 
			SELECT	MAX(a.nr_prescricao) 
			INTO STRICT	nr_prescricao_w 
			FROM ( 
					SELECT	a.nr_prescricao, 
							SUBSTR(lab_obter_parametro(cd_estabelecimento_w, a.nr_prescricao, NULL, 'UF'),1,255) cd_unidade_fleury 
					FROM	prescr_procedimento a 
					WHERE	a.nr_controle_ext = nr_ficha_p 
					) a 
			WHERE	a.cd_unidade_fleury = cd_unidade_p;
		ELSE 
			SELECT	MAX(a.nr_prescricao) 
			INTO STRICT	nr_prescricao_w 
			FROM	prescr_procedimento a, 
					prescr_medica b 
			WHERE	a.nr_prescricao = b.nr_prescricao 
			AND		a.nr_controle_ext = nr_ficha_p 
			AND		b.cd_estabelecimento = cd_estabelecimento_w;
		END IF;
	ELSE 
		SELECT	MAX(a.nr_prescricao) 
		INTO STRICT	nr_prescricao_w 
		FROM	prescr_medica a 
		WHERE	a.nr_controle = nr_ficha_p 
		AND		a.cd_estabelecimento = cd_estabelecimento_w;
 
		/*if (nr_prescricao_w is null) then 
			select	max(b.nr_prescricao) 
			into	nr_prescricao_w 
			from	prescr_procedimento a, prescr_medica b 
			where	a.nr_prescricao = b.nr_prescricao 
			and		a.nr_controle_ext = nr_ficha_p 
			and		((b.cd_estabelecimento = cd_estabelecimento_w) or (cd_estabelecimento_w = 0)); 
		end if;*/
 
 
	END IF;
 
END IF;
 
 
IF (coalesce(nr_prescricao_w::text, '') = '') THEN 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(194700);
END IF;
 
IF (coalesce(nr_seq_prescr_p::text, '') = '') OR 
	NOT(nr_seq_prescr_p > 0) THEN 
 
	nr_seq_prescr_w := obter_seq_prescr_prescricao(nr_prescricao_w, 'FLEURY', cd_exame_p);
 
	IF (coalesce(nr_seq_prescr_w::text, '') = '') THEN 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(194701, 'CD_EXAME='||cd_exame_p);
	END IF;
 
ELSE 
 
	nr_seq_prescr_w := nr_seq_prescr_p;
 
END IF;
 
 
OPEN C01;
LOOP 
FETCH C01 INTO 
	nr_seq_exame_atual_w, 
	nr_seq_superior_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	BEGIN 
 
	SELECT MAX(coalesce(nr_sequencia, NULL)) 
	INTO STRICT	nr_seq_prescr_nova_w 
	FROM	prescr_procedimento 
	WHERE	nr_prescricao		= nr_prescricao_p 
	 AND	nr_seq_exame		= nr_seq_exame_atual_w;
 
	IF (coalesce(nr_seq_prescr_nova_w::text, '') = '') THEN 
 
		SELECT	MAX(coalesce(nr_sequencia, NULL)) 
		INTO STRICT	nr_seq_prescr_nova_w 
		FROM	prescr_procedimento 
		WHERE	nr_prescricao = nr_prescricao_p 
		 AND	ie_status_atend >= 30 
		 AND	nr_seq_exame = nr_seq_superior_w;
 
		 IF (coalesce(nr_seq_prescr_nova_w::text, '') = '') THEN 
 
			SELECT	MAX(coalesce(nr_sequencia, NULL)) 
			INTO STRICT	nr_seq_prescr_nova_w 
			FROM	prescr_procedimento 
			WHERE	nr_prescricao = nr_prescricao_p 
			AND	nr_seq_exame = nr_seq_superior_w;
 
		END IF;
	END IF;
 
	IF (nr_seq_prescr_nova_w IS NOT NULL AND nr_seq_prescr_nova_w::text <> '') THEN 
		EXIT;
	END IF;
 
	END;
END LOOP;
CLOSE C01;
nr_seq_exame_w	:= nr_seq_exame_atual_w;
 
SELECT	MAX(nr_seq_exame) 
INTO STRICT	nr_seq_exame_prescr_w 
FROM	prescr_procedimento 
WHERE	nr_sequencia = coalesce(nr_seq_prescr_p, nr_seq_prescr_w) 
AND		nr_prescricao = nr_prescricao_p;
 
IF (nr_seq_exame_w <> nr_seq_exame_prescr_w) THEN 
 
	SELECT 	COUNT(*) 
	INTO STRICT	qt_exame_dep_w 
	FROM	EXAME_LAB_DEPENDENTE 
	WHERE	NR_SEQ_EXAME_DEP = nr_seq_exame_w 
	AND		nr_seq_exame = nr_seq_exame_prescr_w 
	AND		IE_GERACAO = 8;
 
	IF (qt_exame_dep_w > 0) THEN 
 
		nr_seq_prescr_w := fleury_lab_duplic_exame_interf(nr_prescricao_p, coalesce(nr_seq_prescr_p, nr_seq_prescr_w), nr_seq_exame_w, nm_usuario_p, nr_seq_prescr_w);
 
	END IF;
END IF;
 
nr_seq_prescr_out_p	:= nr_seq_prescr_w;
 
select	coalesce(max(b.IE_MANTER_RESULTADO_EXAME), 'N') 
into STRICT	IE_MANTER_RESULTADO_EXAME_W 
from	prescr_medica a, 
		lab_parametro b 
where	a.cd_estabelecimento = b.cd_estabelecimento 
and		a.nr_prescricao = nr_prescricao_w;
 
CALL Gravar_Result_Laboratorio( nr_prescricao_w, nr_seq_prescr_w, ds_resultado_p, nm_usuario_p, ie_final_p, cd_exame_p, 'N', nr_seq_exame_w);
 
IF (ie_final_p = 'S') THEN 
 
	update	prescr_procedimento 
	set		ie_status_atend = 35 
	where	nr_prescricao = nr_prescricao_w 
	and		nr_sequencia = nr_seq_prescr_w 
	and		ie_status_atend < 35;
 
	SELECT 	COUNT(*) 
	INTO STRICT	qt_result_final_w 
	FROM 	result_laboratorio 
	WHERE 	nr_prescricao = nr_prescricao_w 
	AND 	nr_seq_prescricao = nr_seq_prescr_w 
	AND 	ie_final = 'S' 
	AND		coalesce(ie_status,'A') <> 'I' 
	and		((IE_MANTER_RESULTADO_EXAME_W = 'N') or ((coalesce(cd_exame_p::text, '') = '') or (coalesce(cd_exame_p,'0') = coalesce(cd_exame_integracao, '0'))));
 
	IF (qt_result_final_w > 0) THEN 
 
		CALL gravar_log_lab(99877,'fleury_ws_grava_result_laborat - resultado final inativado: prescr: '||nr_prescricao_w||' nr_seq_prescr: '||nr_seq_prescr_w,'tasy',nr_prescricao_w,'fleury');
 
		SELECT	MAX(nr_sequencia) 
		INTO STRICT	nr_seq_result_w 
		FROM	result_laboratorio 
		WHERE	nr_prescricao = nr_prescricao_w 
		AND 	nr_seq_prescricao = nr_seq_prescr_w 
		AND 	ie_final = 'S' 
		AND		coalesce(ie_status,'A') <> 'I' 
		and		((IE_MANTER_RESULTADO_EXAME_W = 'N') or ((coalesce(cd_exame_p::text, '') = '') or (coalesce(cd_exame_p,'0') = coalesce(cd_exame_integracao, '0'))));
 
		UPDATE	result_laboratorio 
		SET		ie_status = 'I', 
				dt_atualizacao = clock_timestamp(), 
				nm_usuario = nm_usuario_p 
		WHERE	nr_prescricao = nr_prescricao_w 
		AND 	nr_seq_prescricao = nr_seq_prescr_w 
		AND 	ie_final = 'S' 
		AND		coalesce(ie_status,'A') <> 'I' 
		AND		coalesce(nr_seq_result_w, nr_sequencia) <> nr_sequencia 
		and		((IE_MANTER_RESULTADO_EXAME_W = 'N') or ((coalesce(cd_exame_p::text, '') = '') or (coalesce(cd_exame_p,'0') = coalesce(cd_exame_integracao, '0'))));
	END IF;
 
	SELECT 	COUNT(*) 
	INTO STRICT	qt_result_parcial_w 
	FROM 	result_laboratorio 
	WHERE 	nr_prescricao = nr_prescricao_w 
	AND 	nr_seq_prescricao = nr_seq_prescr_w 
	AND 	ie_final = 'N' 
	and		((IE_MANTER_RESULTADO_EXAME_W = 'N') or ((coalesce(cd_exame_p::text, '') = '') or (coalesce(cd_exame_p,'0') = coalesce(cd_exame_integracao, '0'))));
 
	IF (qt_result_parcial_w > 0) THEN 
 
		SELECT 	COUNT(*) 
		INTO STRICT	qt_result_final_w 
		FROM 	result_laboratorio 
		WHERE 	nr_prescricao = nr_prescricao_w 
		AND 	nr_seq_prescricao = nr_seq_prescr_w 
		AND 	ie_final = 'S' 
		and		((IE_MANTER_RESULTADO_EXAME_W = 'N') or ((coalesce(cd_exame_p::text, '') = '') or (coalesce(cd_exame_p,'0') = coalesce(cd_exame_integracao, '0'))));
 
		IF (qt_result_final_w > 0) THEN 
 
			CALL gravar_log_lab(99877,'fleury_ws_grava_result_laborat - resultado parcial deletado: prescr: '||nr_prescricao_w||' nr_seq_prescr: '||nr_seq_prescr_w,'tasy',nr_prescricao_w,'fleury');
 
			DELETE 	FROM result_laboratorio 
			WHERE 	nr_prescricao = nr_prescricao_w 
			AND 	nr_seq_prescricao = nr_seq_prescr_w 
			AND 	ie_final = 'N' 
			and		((IE_MANTER_RESULTADO_EXAME_W = 'N') or ((coalesce(cd_exame_p::text, '') = '') or (coalesce(cd_exame_p,'0') = coalesce(cd_exame_integracao, '0'))));
 
		END IF;
	END IF;
 
END IF;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fleury_ws_grava_result_laborat ( nr_ficha_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, cd_exame_p text, ds_resultado_p text, cd_unidade_p text, nm_usuario_p text, ie_final_p text, nr_seq_prescr_out_p INOUT bigint ) FROM PUBLIC;
