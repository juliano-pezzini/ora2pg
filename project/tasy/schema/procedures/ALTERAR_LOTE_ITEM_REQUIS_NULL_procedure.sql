-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_lote_item_requis_null ( nm_usuario_p text, nr_sequencia_p bigint, nr_requisicao_p bigint) AS $body$
BEGIN

if (nr_requisicao_p IS NOT NULL AND nr_requisicao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	update	item_requisicao_material
	set	dt_atendimento  = NULL,
		qt_material_atendida = 0,
		cd_motivo_baixa = 0,
		nr_seq_lote_fornec  = NULL,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		nr_seq_cor_exec  = NULL
	where	nr_requisicao = nr_requisicao_p
	and	nr_sequencia = nr_sequencia_p;

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_lote_item_requis_null ( nm_usuario_p text, nr_sequencia_p bigint, nr_requisicao_p bigint) FROM PUBLIC;
