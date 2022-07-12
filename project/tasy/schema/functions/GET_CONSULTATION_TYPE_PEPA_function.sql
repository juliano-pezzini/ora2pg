-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_consultation_type_pepa (NR_SEQUENCIA_P bigint) RETURNS bigint AS $body$
DECLARE


IE_CLASSIF_AGENDA_P			AGENDA_CONSULTA.IE_CLASSIF_AGENDA%TYPE;
CD_ESPECIALIDADE_P			AGENDA_CONSULTA.CD_ESPECIALIDADE%TYPE;
NR_SEQ_TIPO_CONSULTA_P		AGENDA_CONSULTA.NR_SEQ_TIPO_CONSULTA%TYPE;
DS_RETORNO_W				bigint;
AUXILIAR1_W					bigint;
QT_ESPECIALIDADES			bigint;



BEGIN

SELECT 	A.IE_CLASSIF_AGENDA,
		coalesce(A.CD_ESPECIALIDADE, B.CD_ESPECIALIDADE),
		A.NR_SEQ_TIPO_CONSULTA
INTO STRICT	IE_CLASSIF_AGENDA_P,
		CD_ESPECIALIDADE_P,
		NR_SEQ_TIPO_CONSULTA_P
FROM	AGENDA_CONSULTA A, AGENDA B
WHERE	A.NR_SEQUENCIA = NR_SEQUENCIA_P
AND     A.CD_AGENDA = B.CD_AGENDA;

	
IF ((IE_CLASSIF_AGENDA_P IS NOT NULL AND IE_CLASSIF_AGENDA_P::text <> '') OR (CD_ESPECIALIDADE_P IS NOT NULL AND CD_ESPECIALIDADE_P::text <> '')) THEN

	SELECT 	MAX(NR_SEQUENCIA) NR_SEQUENCIA
	INTO STRICT	AUXILIAR1_W
	FROM	EHR_TIPO_REGISTRO
	WHERE	IE_CLASSIF_AGENDA = IE_CLASSIF_AGENDA_P
	AND		CD_ESPECIALIDADE = CD_ESPECIALIDADE_P;
	
	IF (AUXILIAR1_W IS NOT NULL AND AUXILIAR1_W::text <> '') THEN

	RETURN AUXILIAR1_W;

	ELSE
		
	SELECT 	MAX(NR_SEQUENCIA) NR_SEQUENCIA
	INTO STRICT	AUXILIAR1_W
	FROM	EHR_TIPO_REGISTRO
	WHERE	CD_ESPECIALIDADE = CD_ESPECIALIDADE_P
    AND		coalesce(IE_CLASSIF_AGENDA::text, '') = '';
		
			IF (AUXILIAR1_W IS NOT NULL AND AUXILIAR1_W::text <> '') THEN

                RETURN AUXILIAR1_W;

			ELSE
				
			SELECT 	MAX(NR_SEQUENCIA) NR_SEQUENCIA
			INTO STRICT	AUXILIAR1_W
			FROM	EHR_TIPO_REGISTRO
            WHERE	IE_CLASSIF_AGENDA = IE_CLASSIF_AGENDA_P
            AND		coalesce(CD_ESPECIALIDADE::text, '') = '';
			
				IF (AUXILIAR1_W IS NOT NULL AND AUXILIAR1_W::text <> '') THEN
			
					RETURN AUXILIAR1_W;
				
				ELSE
				
				SELECT 	COUNT(1)
				INTO STRICT 	QT_ESPECIALIDADES
				FROM 	EHR_ITEM_ADICIONAL
				WHERE 	CD_ESPECIALIDADE = CD_ESPECIALIDADE_P;
				
					IF (QT_ESPECIALIDADES > 0) THEN
					
						SELECT 	MAX(A.NR_SEQUENCIA) NR_SEQUENCIA
						INTO STRICT	AUXILIAR1_W
						FROM	EHR_TIPO_REGISTRO A, EHR_ITEM_ADICIONAL B
						WHERE 	B.NR_SEQ_TIPO_REG = A.NR_SEQUENCIA
						AND 	B.CD_ESPECIALIDADE = CD_ESPECIALIDADE_P;
					
						RETURN AUXILIAR1_W;
					END IF;	
				
				END IF;					
				
			END IF;
		
	END IF;
	
ELSIF (NR_SEQ_TIPO_CONSULTA_P IS NOT NULL AND NR_SEQ_TIPO_CONSULTA_P::text <> '') THEN
	DS_RETORNO_W:= NR_SEQ_TIPO_CONSULTA_P;
ELSE
	DS_RETORNO_W:= NULL;
END IF;

RETURN 	DS_RETORNO_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_consultation_type_pepa (NR_SEQUENCIA_P bigint) FROM PUBLIC;

