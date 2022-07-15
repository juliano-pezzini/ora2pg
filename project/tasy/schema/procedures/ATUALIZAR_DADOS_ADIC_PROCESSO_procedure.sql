-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_dados_adic_processo ( ie_opcao_p bigint, ds_lista_p text, nr_sequencia_p bigint, cd_processo_p bigint, nm_usuario_p text) AS $body$
BEGIN


if (ie_opcao_p = 0) then

	update	processo_etapa
	set	ds_usuario_adicional 	= ds_lista_p
	where	cd_processo		= cd_processo_p
	and	nr_sequencia 		= nr_sequencia_p;
else

	update	processo_etapa
	set	ds_setor_adicional 	= ds_lista_p
	where	cd_processo		= cd_processo_p
	and	nr_sequencia 		= nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_dados_adic_processo ( ie_opcao_p bigint, ds_lista_p text, nr_sequencia_p bigint, cd_processo_p bigint, nm_usuario_p text) FROM PUBLIC;

