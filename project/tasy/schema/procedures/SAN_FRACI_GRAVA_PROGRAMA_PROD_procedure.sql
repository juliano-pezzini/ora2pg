-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_fraci_grava_programa_prod (nr_seq_producao_p bigint, nr_seq_programa_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nr_seq_producao_p IS NOT NULL AND nr_seq_producao_p::text <> '') then
	update	san_producao
	set	nr_opcao_frac			= nr_seq_programa_p,
		dt_conferencia_integracao	= clock_timestamp(),
		nm_usuario_conf_integracao	= nm_usuario_p,
		ie_em_reproducao		= 'S'
	where	nr_sequencia			= nr_seq_producao_p;
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_fraci_grava_programa_prod (nr_seq_producao_p bigint, nr_seq_programa_p bigint, nm_usuario_p text) FROM PUBLIC;
