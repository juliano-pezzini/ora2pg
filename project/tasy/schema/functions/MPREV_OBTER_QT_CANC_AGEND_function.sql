-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_qt_canc_agend ( dt_inicial_p timestamp, dt_final_p timestamp, cd_agenda_p text ) RETURNS bigint AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Obter dados de um agendamento da agenda da Medicina Preventiva.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[X]  Objetos do dicionario [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
			
qt_retorno_w		bigint;


BEGIN

if (dt_inicial_p IS NOT NULL AND dt_inicial_p::text <> '')	or (dt_final_p IS NOT NULL AND dt_final_p::text <> '')	or (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '')	then

select count(1)
into STRICT	qt_retorno_w
from (
	SELECT  *
	from	mprev_agendamento a
	where	a.cd_agenda	= cd_agenda_p
	and	a.ie_status_agenda = 'C'
	and	dt_inicial_p between a.dt_agenda and a.dt_final_agenda
	and 	a.dt_final_agenda > dt_inicial_p
	
union

	SELECT  *
	from	mprev_agendamento a
	where	a.cd_agenda	= cd_agenda_p
	and	a.ie_status_agenda = 'C'
	and	dt_final_p between a.dt_agenda and a.dt_final_agenda
	and 	a.dt_agenda > dt_final_p
) alias4;

end if;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_qt_canc_agend ( dt_inicial_p timestamp, dt_final_p timestamp, cd_agenda_p text ) FROM PUBLIC;
