-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE definir_status_relat_validacao ( nr_seq_relatorio_p bigint, ie_status_comparacao_p text, nm_usuario_p text) AS $body$
BEGIN

update	relatorio_validacao
set	ie_status_comparacao 	= ie_status_comparacao_p,
	dt_atualizacao		= clock_timestamp()
where	nr_seq_relatorio 		= nr_seq_relatorio_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE definir_status_relat_validacao ( nr_seq_relatorio_p bigint, ie_status_comparacao_p text, nm_usuario_p text) FROM PUBLIC;

