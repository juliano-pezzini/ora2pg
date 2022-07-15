-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_liberar_orcamento ( cd_empresa_p bigint, cd_estabelecimento_p bigint, nr_sequencia_p bigint, ie_operacao_p text, nm_usuario_p text) AS $body$
DECLARE


/*LIBERAR ou ESTORNAR a liberação do Orçamento*/

BEGIN

if (ie_operacao_p = 'L') then
	update	ctb_orcamento
	set	dt_liberacao	= clock_timestamp(),
		nm_usuario_lib	= nm_usuario_p
	where	nr_sequencia	= nr_sequencia_p;
elsif (ie_operacao_p = 'E') then

	update	ctb_orcamento
	set	dt_liberacao	 = NULL,
		nm_usuario_lib	= ''
	where	nr_sequencia	= nr_sequencia_p;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_liberar_orcamento ( cd_empresa_p bigint, cd_estabelecimento_p bigint, nr_sequencia_p bigint, ie_operacao_p text, nm_usuario_p text) FROM PUBLIC;

