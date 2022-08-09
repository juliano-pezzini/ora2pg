-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_status_ordem ( nr_seq_estagio_p bigint, nr_sequencia_p bigint, ie_grau_satisfacao_p text, nm_usuario_p text) AS $body$
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	update	man_ordem_servico
	set	ie_status_ordem		= 3,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p,
		nm_usuario_encer	= nm_usuario_p,
		nr_seq_estagio		= CASE WHEN nr_seq_estagio_p=0 THEN  nr_seq_estagio  ELSE nr_seq_estagio_p END ,
		dt_inicio_previsto	= coalesce(dt_inicio_previsto,dt_ordem_servico),
		dt_inicio_real		= coalesce(dt_inicio_real,dt_ordem_servico),
		dt_fim_real		= clock_timestamp(),
		dt_fim_previsto		= coalesce(dt_fim_previsto,clock_timestamp()),
		ie_grau_satisfacao	= ie_grau_satisfacao_p
	where	nr_sequencia		= nr_sequencia_p;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_status_ordem ( nr_seq_estagio_p bigint, nr_sequencia_p bigint, ie_grau_satisfacao_p text, nm_usuario_p text) FROM PUBLIC;
