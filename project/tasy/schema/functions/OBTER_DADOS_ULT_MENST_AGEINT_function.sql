-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_ult_menst_ageint ( nr_seq_ageint_item_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

ds_retorno_w			varchar(20);
DT_ULTIMA_MENSTRUACAO_W		agenda_integrada.DT_ULTIMA_MENSTRUACAO%TYPE;
QT_IG_SEMANA_W			agenda_integrada.QT_IG_SEMANA%TYPE;
QT_IG_DIA_W				agenda_integrada.QT_IG_DIA%TYPE;

/*
ie_opcao_p
	M : Data da última menstruação (AGENDA_INTEGRADA)
	S : Idade gestacional em semanas
	D : Idade gestacional em dias
*/
BEGIN
IF (coalesce(nr_seq_ageint_item_p,0) > 0) THEN
	SELECT 	MAX(DT_ULTIMA_MENSTRUACAO),
        	MAX(QT_IG_SEMANA),
            MAX(QT_IG_DIA)
	INTO STRICT	DT_ULTIMA_MENSTRUACAO_W,
			QT_IG_SEMANA_W,
			QT_IG_DIA_W
	FROM 	agenda_integrada a,
			agenda_integrada_item b
	WHERE	a.nr_Sequencia =b. nr_seq_agenda_int
	AND		b.nr_Sequencia = nr_seq_ageint_item_p;

	IF (ie_opcao_p = 'M') THEN

		SELECT	MAX(TO_CHAR(a.dt_ultima_menstruacao,'dd/mm/yyyy'))
		INTO STRICT	ds_retorno_w
		FROM	agenda_integrada a,
				agenda_integrada_item b
		WHERE	a.nr_sequencia = b.nr_seq_agenda_int
		AND		b.nr_sequencia = nr_seq_ageint_item_p;

	ELSIF (ie_opcao_p = 'S') THEN

		IF (DT_ULTIMA_MENSTRUACAO_W IS NOT NULL AND DT_ULTIMA_MENSTRUACAO_W::text <> '') THEN
			SELECT	MAX(TRUNC((TRUNC(coalesce(coalesce(Obter_Horario_item_Ageint(b.nr_seq_agenda_cons, b.nr_Seq_Agenda_exame,b.nr_sequencia),qt_obter_horario_agendado(b.nr_sequencia)),clock_timestamp())) - TRUNC(a.dt_ultima_menstruacao))/7))
			INTO STRICT	ds_retorno_w
			FROM	agenda_integrada a,
					agenda_integrada_item b
			WHERE	a.nr_sequencia = b.nr_seq_agenda_int
			AND		b.nr_sequencia = nr_seq_ageint_item_p;
		ELSE
			ds_retorno_w := QT_IG_SEMANA_W;
		END IF;

	ELSIF (ie_opcao_p = 'D') THEN

		IF (DT_ULTIMA_MENSTRUACAO_W IS NOT NULL AND DT_ULTIMA_MENSTRUACAO_W::text <> '') THEN
			SELECT	MAX(MOD(TRUNC(TRUNC(coalesce(coalesce(Obter_Horario_item_Ageint(b.nr_seq_agenda_cons, b.nr_Seq_Agenda_exame,b.nr_sequencia),qt_obter_horario_agendado(b.nr_sequencia)),clock_timestamp())) - TRUNC(a.dt_ultima_menstruacao)),7))
			INTO STRICT	ds_retorno_w
			FROM	agenda_integrada a,
					agenda_integrada_item b
			WHERE	a.nr_sequencia = b.nr_seq_agenda_int
			AND		b.nr_sequencia = nr_seq_ageint_item_p;
		ELSE
			ds_retorno_w := QT_IG_DIA_W;
		END IF;
	END IF;
END IF;

RETURN	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_ult_menst_ageint ( nr_seq_ageint_item_p bigint, ie_opcao_p text) FROM PUBLIC;

