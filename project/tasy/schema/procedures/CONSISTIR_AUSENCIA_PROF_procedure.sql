-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_ausencia_prof (cd_profissional_p text, dt_ausencia_p timestamp) AS $body$
DECLARE


qt_existe_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	escala_afastamento_prof
where	cd_profissional = cd_profissional_p
and	dt_ausencia_p between dt_inicio and dt_final;

if (qt_existe_w > 0) then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(262561);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_ausencia_prof (cd_profissional_p text, dt_ausencia_p timestamp) FROM PUBLIC;

