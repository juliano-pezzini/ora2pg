-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_hor_ausencia ( dt_agenda_p timestamp, nr_minuto_duracao_p bigint, ds_erro_p INOUT text, nm_usuario_ausente_p text default null) AS $body$
DECLARE


ie_existe_w	bigint;


BEGIN

SELECT  COUNT(*)
into STRICT	ie_existe_w
FROM    ausencia_tasy
WHERE   ((dt_agenda_p BETWEEN dt_inicio AND dt_fim) OR
	(dt_agenda_p + (nr_minuto_duracao_p / 1440)  - (1/86400) BETWEEN dt_inicio AND dt_fim) OR
	((dt_agenda_p < dt_inicio) AND (dt_agenda_p + (nr_minuto_duracao_p / 1440) - (1/86400) > dt_fim)))
and	nm_usuario_ausente = nm_usuario_ausente_p;


if (ie_existe_w > 0) then
	ds_erro_p :=	wheb_mensagem_pck.get_texto(278506);

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_hor_ausencia ( dt_agenda_p timestamp, nr_minuto_duracao_p bigint, ds_erro_p INOUT text, nm_usuario_ausente_p text default null) FROM PUBLIC;

