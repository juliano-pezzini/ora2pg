-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_limita_turno (CD_CLASSIFICACAO_P text, CD_PROCEDIMENTO_P bigint, IE_ORIGEM_PROCED_P bigint, NR_SEQ_PROC_INTERNO_P bigint, NR_SEQ_TURNO_P bigint, DT_AGENDA_P timestamp, NR_SEQ_AGENDA_P bigint) RETURNS varchar AS $body$
DECLARE


QT_CLASSIF_W 			AGENDA_TURNO_CLASSIF.QT_CLASSIF%TYPE := 0;
QT_AGENDAMENTOS_W		bigint := 0;
RETORNO_W 				varchar(1) := 'N';


BEGIN

SELECT	coalesce(MIN(QT_CLASSIF),0)
INTO STRICT 	QT_CLASSIF_W
FROM 	AGENDA_TURNO_CLASSIF
WHERE	CD_CLASSIFICACAO = CD_CLASSIFICACAO_P
AND 	NR_SEQ_PROC_INTERNO = NR_SEQ_PROC_INTERNO_P
--AND		CD_PROCEDIMENTO = CD_PROCEDIMENTO_P
--AND		IE_ORIGEM_PROCED = IE_ORIGEM_PROCED_P
AND     IE_LIMITAR_QT_TURNO = 'S'
AND 	NR_SEQ_TURNO = NR_SEQ_TURNO_P;

IF QT_CLASSIF_W > 0 THEN

	SELECT 	COUNT(NR_SEQUENCIA) QT_AGENDA
	INTO STRICT 	QT_AGENDAMENTOS_W
	FROM 	AGENDA_CONSULTA
	WHERE 	IE_CLASSIF_AGENDA = CD_CLASSIFICACAO_P
	AND 	NR_SEQ_PROC_INTERNO = NR_SEQ_PROC_INTERNO_P
	--AND		CD_PROCEDIMENTO = CD_PROCEDIMENTO_P
	--AND		IE_ORIGEM_PROCED = IE_ORIGEM_PROCED_P
	AND 	NR_SEQ_TURNO = NR_SEQ_TURNO_P
	AND		NR_SEQUENCIA <> NR_SEQ_AGENDA_P
	and		dt_agenda between trunc(dt_agenda_p) and trunc(dt_agenda_p) + 86399/86400
	AND 	IE_STATUS_AGENDA NOT IN ('L','F','I','B','LF','C');

	IF 	QT_AGENDAMENTOS_W >= QT_CLASSIF_W THEN
		RETURN 'S';
	END IF;

END IF;

RETURN RETORNO_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_limita_turno (CD_CLASSIFICACAO_P text, CD_PROCEDIMENTO_P bigint, IE_ORIGEM_PROCED_P bigint, NR_SEQ_PROC_INTERNO_P bigint, NR_SEQ_TURNO_P bigint, DT_AGENDA_P timestamp, NR_SEQ_AGENDA_P bigint) FROM PUBLIC;
