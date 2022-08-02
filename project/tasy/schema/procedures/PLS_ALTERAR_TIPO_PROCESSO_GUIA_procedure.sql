-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_tipo_processo_guia ( nr_seq_guia_p bigint, ie_tipo_processo_p text, nm_usuario_p text) AS $body$
BEGIN

update	pls_guia_plano
set	ie_tipo_processo	= ie_tipo_processo_p,
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp(),
	ie_tipo_intercambio	= 'I'
where	nr_sequencia		= nr_seq_guia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_tipo_processo_guia ( nr_seq_guia_p bigint, ie_tipo_processo_p text, nm_usuario_p text) FROM PUBLIC;

