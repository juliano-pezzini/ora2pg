-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_exame_lab_result_item ( nr_sequencia_p bigint, nr_seq_resultado_p bigint, ds_observacao_p text, dt_atualizacao_p timestamp, nm_usuario_p text, ds_resultado_p text, pr_resultado_p bigint, qt_resultado_p bigint) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nr_seq_resultado_p IS NOT NULL AND nr_seq_resultado_p::text <> '') then
	begin
	update	exame_lab_result_item
	set	qt_resultado 	= qt_resultado_p,
		pr_resultado 	= pr_resultado_p,
		ds_resultado 	= ds_resultado_p,
		nm_usuario 	= nm_usuario_p,
		dt_atualizacao 	= dt_atualizacao_p,
		ds_observacao 	= ds_observacao_p
	where 	nr_seq_resultado = nr_seq_resultado_p
	and	nr_sequencia 	= nr_sequencia_p;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_exame_lab_result_item ( nr_sequencia_p bigint, nr_seq_resultado_p bigint, ds_observacao_p text, dt_atualizacao_p timestamp, nm_usuario_p text, ds_resultado_p text, pr_resultado_p bigint, qt_resultado_p bigint) FROM PUBLIC;
