-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_gerar_resultados_ant ( nr_seq_cliente_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_cliente_p IS NOT NULL AND nr_seq_cliente_p::text <> '') then
	begin
	/* Exclui os resultados sem valor e descrição  */

	CALL med_excluir_result_exame(nr_seq_cliente_p);

	/* Gera os resultados de exames */

	CALL criar_med_result_exame(nr_seq_cliente_p, nm_usuario_p);
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_gerar_resultados_ant ( nr_seq_cliente_p bigint, nm_usuario_p text) FROM PUBLIC;

