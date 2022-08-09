-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ple_cancelar_acao ( nr_sequencia_p bigint, nr_seq_motivo_p bigint, ie_operacao_p text, nm_usuario_p text) AS $body$
BEGIN

if (ie_operacao_p	= 'C') then

	update	man_ordem_servico
	set	nr_seq_motivo_cancel_acao	= nr_seq_motivo_p,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp(),
		ie_status_ordem		= '3'
	where	nr_sequencia 		= nr_sequencia_p;

elsif (ie_operacao_p	= 'E') then

	update	man_ordem_servico
	set	nr_seq_motivo_cancel_acao	 = NULL,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp(),
		ie_status_ordem		= '1'
	where	nr_sequencia 		= nr_sequencia_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ple_cancelar_acao ( nr_sequencia_p bigint, nr_seq_motivo_p bigint, ie_operacao_p text, nm_usuario_p text) FROM PUBLIC;
