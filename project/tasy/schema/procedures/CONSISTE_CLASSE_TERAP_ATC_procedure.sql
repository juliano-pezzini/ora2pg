-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_classe_terap_atc ( cd_classe_terap_p text, ds_classe_terap_p text, cd_grupo_anatomico_p text, nm_usuario_p text) AS $body$
DECLARE


qt_registros_w		bigint;


BEGIN

begin
select	count(*)
into STRICT	qt_registros_w
from	med_classe_terapeutica
where	cd_classe_terapeutica	= cd_classe_terap_p;
exception
	when others then
	qt_registros_w	:= 0;
end;

if (qt_registros_w = 0) then
	insert into med_classe_terapeutica(
		cd_classe_terapeutica,
		dt_atualizacao,
		nm_usuario,
		ds_classe_terapeutica,
		cd_grupo_anatomico,
		dt_atualizacao_nrec,
		nm_usuario_nrec
	) values (
		cd_classe_terap_p,
		clock_timestamp(),
		nm_usuario_p,
		ds_classe_terap_p,
		cd_grupo_anatomico_p,
		clock_timestamp(),
		nm_usuario_p
	);
else
	update	med_classe_terapeutica
	set	ds_classe_terapeutica	= ds_classe_terap_p,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_classe_terapeutica	= cd_classe_terap_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_classe_terap_atc ( cd_classe_terap_p text, ds_classe_terap_p text, cd_grupo_anatomico_p text, nm_usuario_p text) FROM PUBLIC;
