-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_ativar_usuario_medico ( cd_medico_p text, nm_usuario_p text) AS $body$
DECLARE


nm_usuario_medico_w			varchar(15);


BEGIN

select	coalesce(max(nm_usuario),'X')
into STRICT	nm_usuario_medico_w
from	usuario
where	cd_pessoa_fisica	= cd_medico_p
and	ie_situacao		= 'I';

if (nm_usuario_medico_w <> 'X') then

	update	usuario
	set	ie_situacao	= 'A',
		dt_atualizacao	= clock_timestamp(),
		nm_usuario_atual	= nm_usuario_p,
		dt_inativacao	 = NULL
	where	nm_usuario	= nm_usuario_medico_w;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_ativar_usuario_medico ( cd_medico_p text, nm_usuario_p text) FROM PUBLIC;
