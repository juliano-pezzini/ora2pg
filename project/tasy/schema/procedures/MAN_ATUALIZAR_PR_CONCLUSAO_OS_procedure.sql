-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_atualizar_pr_conclusao_os (nr_sequencia_p bigint, pr_conclusao_p bigint, dt_inicio_prev_p timestamp, dt_fim_prev_p timestamp, nm_usuario_p text, dt_fim_repactuado_p timestamp) AS $body$
DECLARE


ie_status_ordem_w man_ordem_servico.ie_status_ordem%type;


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	if (coalesce(pr_conclusao_p,0) = 0) then
		ie_status_ordem_w := '1';
	elsif (coalesce(pr_conclusao_p,0) > 0 and coalesce(pr_conclusao_p,0) < 100) then
		ie_status_ordem_w := '2';
	elsif (coalesce(pr_conclusao_p,0) = 100) then
		ie_status_ordem_w := '3';
	end if;

	update	man_ordem_servico
	set	pr_conclusao_os	= pr_conclusao_p,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		ie_status_ordem = ie_status_ordem_w,
		dt_inicio_previsto = coalesce(dt_inicio_prev_p,dt_inicio_previsto),
		dt_fim_previsto = coalesce(dt_fim_prev_p,dt_fim_previsto),
		dt_fim_repactuado 	= coalesce(dt_fim_repactuado_p, dt_fim_repactuado)
	where	nr_sequencia	= nr_sequencia_p;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_atualizar_pr_conclusao_os (nr_sequencia_p bigint, pr_conclusao_p bigint, dt_inicio_prev_p timestamp, dt_fim_prev_p timestamp, nm_usuario_p text, dt_fim_repactuado_p timestamp) FROM PUBLIC;
