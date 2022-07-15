-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fleury_ws_gravar_result_evol ( nr_ficha_fleury_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, cd_exame_p text, --ds_analito_p		VARCHAR2,
 nm_usuario_p text, cd_unidade_fleury_p text DEFAULT NULL, nr_seq_result_evol_p INOUT text DEFAULT NULL) AS $body$
DECLARE



nr_seq_result_w			result_laboratorio.nr_sequencia%type;
nr_prescricao_w			prescr_procedimento.nr_prescricao%type;
nr_seq_prescr_w			prescr_procedimento.nr_sequencia%type;
cd_estabelecimento_w	prescr_medica.cd_estabelecimento%type;

ie_exame_w				bigint;
nr_seq_exame_w			exame_laboratorio.nr_seq_exame%type;
nr_seq_superior_w		exame_laboratorio.nr_seq_superior%type;
nr_seq_exame_origem_w	exame_laboratorio.nr_seq_exame%type;
nr_seq_prescr_aux_w		prescr_procedimento.nr_sequencia%type;
nr_seq_result_evol_w	result_laboratorio_evol.nr_sequencia%type;

C01 CURSOR FOR
	SELECT  1,
		nr_seq_exame,
		nr_seq_superior,
		NULL
	FROM    exame_laboratorio
	WHERE 	coalesce(cd_exame_integracao, cd_exame) = cd_exame_p
	
UNION

	SELECT  2,
		c.nr_seq_exame,
		a.nr_seq_exame,
		c.nr_seq_exame AS nr_seq_exame_origem
	FROM    exame_lab_format a,
		exame_lab_format_item b,
		exame_laboratorio c
	WHERE   a.nr_seq_formato    = b.nr_seq_formato
	AND    	b.nr_seq_exame        = c.nr_seq_exame
	AND    	coalesce(c.cd_exame_integracao, c.cd_exame) = cd_exame_p
	
UNION

	SELECT  3,
		nr_seq_exame,
		nr_seq_superior,
		NULL
	FROM    exame_laboratorio
	WHERE 	coalesce(cd_exame_integracao, cd_exame) = REPLACE(cd_exame_p, 'URG', '')
	
UNION

	SELECT  4,
		c.nr_seq_exame,
		a.nr_seq_exame,
		c.nr_seq_exame AS nr_seq_exame_origem
	FROM    exame_lab_format a,
		exame_lab_format_item b,
		exame_laboratorio c
	WHERE   a.nr_seq_formato = b.nr_seq_formato
	AND    	b.nr_seq_exame   = c.nr_seq_exame
	AND    	coalesce(c.cd_exame_integracao, c.cd_exame) = REPLACE(cd_exame_p, 'URG', '')
	
UNION

	SELECT	5,
		e.nr_seq_exame,
		e.nr_seq_superior,
		NULL
	FROM	exame_laboratorio e
	WHERE	e.nr_seq_exame 	= obter_equip_exame_integracao(cd_exame_p,'FLEURY',1)
	ORDER 	BY 1,2;


BEGIN

nr_prescricao_w	:= nr_prescricao_p;
nr_seq_prescr_w := nr_seq_prescr_p;

IF (coalesce(nr_prescricao_w,0) = 0) THEN

	SELECT	MAX(cd_estabelecimento)
	INTO STRICT	cd_estabelecimento_w
	FROM	lab_parametro
	WHERE	cd_unidade_fleury = cd_unidade_fleury_p;


	SELECT  Obter_Prescr_Controle(nr_ficha_fleury_p, cd_estabelecimento_w)
	INTO STRICT   	nr_prescricao_w
	;

END IF;

IF (cd_exame_p IS NOT NULL AND cd_exame_p::text <> '') THEN

    OPEN C01;
    LOOP
    FETCH C01 INTO    ie_exame_w,
            nr_seq_exame_w,
            nr_seq_superior_w,
            nr_seq_exame_origem_w;
        EXIT WHEN NOT FOUND; /* apply on C01 */

        SELECT MIN(coalesce(nr_sequencia, NULL))
        INTO STRICT    nr_seq_prescr_aux_w
        FROM    prescr_procedimento
        WHERE nr_prescricao        = trim(both nr_prescricao_w)
          AND nr_seq_exame        = nr_seq_exame_w;

        IF    coalesce(nr_seq_prescr_w,0)=0  THEN

            SELECT MIN(coalesce(nr_sequencia, NULL))
            INTO STRICT    nr_seq_prescr_w
            FROM    prescr_procedimento
            WHERE nr_prescricao        = trim(both nr_prescricao_w)
              AND nr_seq_exame        = nr_seq_exame_w;
        END IF;

        IF (nr_seq_superior_w IS NOT NULL AND nr_seq_superior_w::text <> '') AND (coalesce(nr_seq_prescr_aux_w::text, '') = '') THEN

            IF (coalesce(nr_seq_prescr_w::text, '') = '') THEN
                SELECT    MAX(coalesce(nr_sequencia, NULL))
                INTO STRICT    nr_seq_prescr_w
                FROM    prescr_procedimento
                WHERE    nr_prescricao = trim(both nr_prescricao_w)
                  AND    ie_status_atend >= 30
                  AND    nr_seq_exame = nr_seq_superior_w;

                IF (coalesce(nr_seq_prescr_w::text, '') = '') THEN
                    SELECT    MAX(coalesce(nr_sequencia, NULL))
                    INTO STRICT    nr_seq_prescr_w
                    FROM    prescr_procedimento
                    WHERE    nr_prescricao = trim(both nr_prescricao_w)
                    AND    nr_seq_exame = nr_seq_superior_w;
                END IF;
            END IF;
            nr_seq_exame_w    := nr_seq_superior_w;
        END IF;

        IF (nr_seq_prescr_w IS NOT NULL AND nr_seq_prescr_w::text <> '') THEN
            EXIT;
        END IF;

    END LOOP;
    CLOSE C01;

END IF;

IF (coalesce(nr_seq_prescr_w::text, '') = '') THEN
    --A sequência da prescrição não foi encontrada. Prescrição:' || nr_prescricao_w  || 'Exame: ' || cd_exame_p ||' #@#@'
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(264078,'NR_PRESCRICAO='||nr_prescricao_w||';CD_EXAME='||cd_exame_p);

END IF;

SELECT	coalesce(MAX(a.nr_sequencia),0)
INTO STRICT	nr_seq_result_w
FROM	result_laboratorio a
WHERE	a.nr_seq_prescricao = nr_seq_prescr_w
AND		a.nr_prescricao = nr_prescricao_w;

IF (nr_seq_result_w > 0) THEN

	select	nextval('result_laboratorio_evol_seq')
	into STRICT	nr_seq_result_evol_w
	;

	insert into result_laboratorio_evol(
						nr_sequencia,
						nm_usuario,
						dt_atualizacao,
						--ds_resultado,
						nr_seq_result_lab)
	values (				nr_seq_result_evol_w,
						nm_usuario_p,
						clock_timestamp(),
						--ds_analito_p,
						nr_seq_result_w);

	nr_seq_result_evol_p	:= nr_seq_result_evol_w;

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fleury_ws_gravar_result_evol ( nr_ficha_fleury_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, cd_exame_p text,  nm_usuario_p text, cd_unidade_fleury_p text DEFAULT NULL, nr_seq_result_evol_p INOUT text DEFAULT NULL) FROM PUBLIC;

