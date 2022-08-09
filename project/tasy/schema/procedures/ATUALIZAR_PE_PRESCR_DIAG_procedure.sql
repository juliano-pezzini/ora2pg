-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_pe_prescr_diag ( nr_seq_evolucao_diag_p bigint, nm_usuario_p text, nr_sequencia_p bigint) AS $body$
BEGIN
if (nr_seq_evolucao_diag_p IS NOT NULL AND nr_seq_evolucao_diag_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	update	pe_prescr_diag
	set	nr_seq_evolucao_diag = nr_seq_evolucao_diag_p,
		nm_usuario           = nm_usuario_p,
		dt_atualizacao       = clock_timestamp()
	where	nr_sequencia         = nr_sequencia_p;
	end;
end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_pe_prescr_diag ( nr_seq_evolucao_diag_p bigint, nm_usuario_p text, nr_sequencia_p bigint) FROM PUBLIC;
