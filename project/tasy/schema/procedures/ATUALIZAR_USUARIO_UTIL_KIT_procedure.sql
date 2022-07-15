-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_usuario_util_kit ( nr_prescricao_p bigint, nr_atendimento_p bigint, nr_seq_kit_estoque_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_seq_kit_estoque_p IS NOT NULL AND nr_seq_kit_estoque_p::text <> '') then
	begin
	update 	kit_estoque
	set 	dt_utilizacao 	= clock_timestamp(),
		nm_usuario_util = nm_usuario_p,
		nr_prescricao 	= nr_prescricao_p,
		nr_atendimento 	= nr_atendimento_p,
		dt_atualizacao 	= clock_timestamp(),
		nm_usuario 	= nm_usuario_p
	where 	nr_sequencia 	= nr_seq_kit_estoque_p;
	end;
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_usuario_util_kit ( nr_prescricao_p bigint, nr_atendimento_p bigint, nr_seq_kit_estoque_p bigint, nm_usuario_p text) FROM PUBLIC;

