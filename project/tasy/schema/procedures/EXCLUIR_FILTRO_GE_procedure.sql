-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_filtro_ge ( nm_filtro_p text, nm_usuario_p text) AS $body$
BEGIN

if (nm_filtro_p IS NOT NULL AND nm_filtro_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	delete from   funcao_filtro
	where  cd_funcao = 942
	and    ie_tipo_filtro = 'D'
	and    nm_usuario_ref = nm_usuario_p
	and    nm_filtro = nm_filtro_p;

	commit;

end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_filtro_ge ( nm_filtro_p text, nm_usuario_p text) FROM PUBLIC;
