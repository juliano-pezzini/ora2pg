-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_liberar_esclarecimento ( nr_seq_reg_info_adic_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (coalesce(nr_seq_reg_info_adic_p,0) > 0) then

	CALL gravar_integracao_regulacao(484, 'nr_sequencia='||nr_seq_reg_info_adic_p||';');

	update	regulacao_info_adicional
	set	dt_liberacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_reg_info_adic_p;

end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_liberar_esclarecimento ( nr_seq_reg_info_adic_p bigint, nm_usuario_p text) FROM PUBLIC;
