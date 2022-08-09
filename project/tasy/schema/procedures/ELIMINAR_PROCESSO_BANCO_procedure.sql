-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eliminar_processo_banco ( SID_p bigint, SERIAL_p bigint, nm_usuario_p text, ie_base_wheb_p text) AS $body$
BEGIN
/*insert into log_XXXtasy (     dt_atualizacao,
                           nm_usuario,
                           cd_log,
                           ds_log)
   values
                   (       sysdate,
                           nm_usuario_p,
                           950,
                           'Eliminar processo : ' || SID_p || ' no banco de dados');
commit; */
if (ie_base_wheb_p = 'S') then
	EXECUTE('begin kill_session('|| SID_p || ',' || SERIAL_p ||'); end;');
else
	EXECUTE('alter system kill session ' || chr(39) || SID_p || ',' || SERIAL_p || chr(39) ||' immediate');
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eliminar_processo_banco ( SID_p bigint, SERIAL_p bigint, nm_usuario_p text, ie_base_wheb_p text) FROM PUBLIC;
