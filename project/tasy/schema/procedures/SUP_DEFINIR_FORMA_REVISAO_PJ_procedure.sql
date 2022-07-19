-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_definir_forma_revisao_pj ( cd_cgc_p text, ie_forma_revisao_p text, nm_usuario_p text) AS $body$
DECLARE

/*ie_forma_revisao
A - A revisar
N - Não revisado
R - Revisado*/
BEGIN
if (coalesce(ie_forma_revisao_p,'A') = 'A') then
	update	pessoa_juridica
	set	nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		ie_forma_revisao = coalesce(ie_forma_revisao_p,'A')
	where	cd_cgc = cd_cgc_p;
elsif (ie_forma_revisao_p = 'N') then
	update	pessoa_juridica
	set	nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		ie_forma_revisao = ie_forma_revisao_p
	where	cd_cgc = cd_cgc_p;
elsif (ie_forma_revisao_p = 'R') then
	update	pessoa_juridica
	set	nm_usuario = nm_usuario_p,
		nm_usuario_revisao = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		dt_ultima_revisao = clock_timestamp(),
		ie_forma_revisao = ie_forma_revisao_p
	where	cd_cgc = cd_cgc_p;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_definir_forma_revisao_pj ( cd_cgc_p text, ie_forma_revisao_p text, nm_usuario_p text) FROM PUBLIC;

