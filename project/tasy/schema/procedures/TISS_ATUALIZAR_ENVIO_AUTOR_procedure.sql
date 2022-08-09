-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_atualizar_envio_autor (nm_usuario_p text, nr_sequencia_autor_p bigint) AS $body$
BEGIN

update	procedimento_autorizado
set	ie_enviado_tiss		= 'S',
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia_autor	= nr_sequencia_autor_p;

update	material_autorizado
set	ie_enviado_tiss		= 'S',
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia_autor	= nr_sequencia_autor_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_atualizar_envio_autor (nm_usuario_p text, nr_sequencia_autor_p bigint) FROM PUBLIC;
