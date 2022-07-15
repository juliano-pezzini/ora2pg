-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_adiantamento_caixa ( nr_adiantamento_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_adiantamento_p IS NOT NULL AND nr_adiantamento_p::text <> '') then
	update	adiantamento
	set	nr_seq_caixa_rec 	 = NULL,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where 	nr_adiantamento		= nr_adiantamento_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_adiantamento_caixa ( nr_adiantamento_p bigint, nm_usuario_p text) FROM PUBLIC;

