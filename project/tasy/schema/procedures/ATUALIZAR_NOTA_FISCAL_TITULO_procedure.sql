-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_nota_fiscal_titulo ( nr_titulo_p bigint, nr_nota_fiscal_p text, nm_usuario_p text) AS $body$
BEGIN

	if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') and (nr_nota_fiscal_p IS NOT NULL AND nr_nota_fiscal_p::text <> '') then

		update	titulo_receber
		set	nr_nota_fiscal	= nr_nota_fiscal_p,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_titulo	= nr_titulo_p;

	commit;

	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_nota_fiscal_titulo ( nr_titulo_p bigint, nr_nota_fiscal_p text, nm_usuario_p text) FROM PUBLIC;

