-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_devolucao_mat_med ( nr_seq_solic_entrega_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	pls_solic_entrega_mat_med
set	dt_devolucao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp(),
	ie_estagio	= 3
where	nr_sequencia	= nr_seq_solic_entrega_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_devolucao_mat_med ( nr_seq_solic_entrega_p bigint, nm_usuario_p text) FROM PUBLIC;

