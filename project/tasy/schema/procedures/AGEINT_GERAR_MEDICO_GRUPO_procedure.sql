-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_gerar_medico_grupo ( NR_SEQ_GRUPO_P bigint, CD_AGENDA_P bigint, DS_MEDICOS_P text, NM_USUARIO_P text) AS $body$
DECLARE


CD_MEDICO_W		varchar(10);
NR_SEQ_MEDICO_REGRA_W	bigint;
QT_MEDICO_W		bigint;
HR_INICIAL_W		timestamp;
HR_FINAL_W		timestamp;

C01 CURSOR FOR
	SELECT	NR_SEQUENCIA,
		CD_PESSOA_FISICA,
		HR_INICIAL,
		HR_FINAL
	FROM	AGEINT_MEDICO_REGRA
	WHERE	NR_SEQ_GRUPO	= NR_SEQ_GRUPO_P
	AND	IE_SITUACAO	= 'A'
	AND (OBTER_SE_CONTIDO_CHAR(CD_PESSOA_FISICA, DS_MEDICOS_P) = 'S'
	OR	coalesce(DS_MEDICOS_P::text, '') = '');

BEGIN

OPEN C01;
LOOP
FETCH C01 INTO
	NR_SEQ_MEDICO_REGRA_W,
	CD_MEDICO_W,
	HR_INICIAL_W,
	HR_FINAL_W;
EXIT WHEN NOT FOUND; /* apply on C01 */
	BEGIN
	SELECT	COUNT(*)
	INTO STRICT	QT_MEDICO_W
	FROM	AGENDA_MEDICO
	WHERE	CD_MEDICO	= CD_MEDICO_W
	AND	CD_AGENDA	= CD_AGENDA_P;

	IF (QT_MEDICO_W	= 0) THEN
		INSERT INTO AGENDA_MEDICO(NR_SEQUENCIA,
					CD_AGENDA,
					CD_MEDICO,
					DT_ATUALIZACAO,
					NM_USUARIO,
					DT_ATUALIZACAO_NREC,
					NM_USUARIO_NREC,
					IE_SITUACAO,
					IE_PERMITE,
					NR_SEQ_MEDICO_REGRA,
					HR_INICIAL,
					HR_FINAL)
				VALUES (nextval('agenda_medico_seq'),
					CD_AGENDA_P,
					CD_MEDICO_W,
					clock_timestamp(),
					NM_USUARIO_P,
					clock_timestamp(),
					NM_USUARIO_P,
					'A',
					'S',
					NR_SEQ_MEDICO_REGRA_W,
					HR_INICIAL_W,
					HR_FINAL_W);
	END IF;
	END;
END LOOP;
CLOSE C01;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_gerar_medico_grupo ( NR_SEQ_GRUPO_P bigint, CD_AGENDA_P bigint, DS_MEDICOS_P text, NM_USUARIO_P text) FROM PUBLIC;
