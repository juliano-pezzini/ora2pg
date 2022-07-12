-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_agenda_sobreposta (cd_agenda_p bigint, dt_agenda_p timestamp, hr_inicio_p timestamp, nr_minuto_duracao_p bigint, nr_seq_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


ie_result_w     varchar(1)     := 'N';
qt_agenda_w	bigint	:= 0;
dt_agenda_w	timestamp;


BEGIN

dt_agenda_w	:= TO_DATE(TO_CHAR(dt_agenda_p,'dd/mm/yyyy') || ' ' || TO_CHAR(hr_inicio_p,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');

SELECT	COUNT(*)
INTO STRICT	qt_agenda_w
FROM	agenda_paciente
WHERE	cd_agenda		= cd_agenda_p
AND	dt_agenda		= TRUNC(dt_agenda_w, 'dd')
AND	((hr_inicio		BETWEEN dt_agenda_w AND dt_agenda_w + ((nr_minuto_duracao_p - 1) / 1440)) OR
	((dt_agenda_w		BETWEEN hr_inicio AND hr_inicio + ((nr_minuto_duracao - 1) / 1440))))
AND	coalesce(obter_tipo_classif_agenda(nr_seq_classif_agenda),'XX') <> 'E'
AND	nr_sequencia	<> nr_seq_agenda_p
and	ie_status_agenda not in ('C','L','II');


IF (qt_agenda_w > 0) THEN
	ie_result_w	:= 'S';
END IF;


RETURN  ie_result_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_agenda_sobreposta (cd_agenda_p bigint, dt_agenda_p timestamp, hr_inicio_p timestamp, nr_minuto_duracao_p bigint, nr_seq_agenda_p bigint) FROM PUBLIC;
