-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE aprov_desaprov_rel_news_idioma ( ie_aprovar_desaprovar_p text, nm_usuario_p text, nr_sequencia_p bigint) AS $body$
BEGIN

	if (ie_aprovar_desaprovar_p	= 'A') then
		update	release_news_idioma
		set	dt_aprovacao 	= clock_timestamp(),
			nm_usuario_aprov = nm_usuario_p,
			nm_usuario	 = nm_usuario_p
		where	nr_sequencia	= nr_sequencia_p;
	else
		update	release_news_idioma
		set	dt_aprovacao 	 = NULL,
			nm_usuario_aprov  = NULL,
			nm_usuario	 = nm_usuario_p
		where	nr_sequencia	= nr_sequencia_p;
	end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aprov_desaprov_rel_news_idioma ( ie_aprovar_desaprovar_p text, nm_usuario_p text, nr_sequencia_p bigint) FROM PUBLIC;
