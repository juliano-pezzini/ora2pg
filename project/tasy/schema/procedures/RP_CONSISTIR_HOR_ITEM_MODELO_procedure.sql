-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rp_consistir_hor_item_modelo (cd_agenda_p bigint, hr_horario_p timestamp, ie_dia_semana_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE



ie_existe_hor_w		varchar(1);


BEGIN

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_existe_hor_w
from	agenda_turno
where	cd_agenda	= cd_agenda_p
and	hr_inicial	= hr_horario_p
and	((ie_dia_semana	= ie_dia_semana_p) or (ie_dia_semana = 9));

if (ie_existe_hor_w = 'N') then
	ds_erro_p	:= wheb_mensagem_pck.get_texto(280158,null);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rp_consistir_hor_item_modelo (cd_agenda_p bigint, hr_horario_p timestamp, ie_dia_semana_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

