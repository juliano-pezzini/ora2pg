-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE prescr_proc_atual_motivo_baixa ( nr_sequencia_p bigint, nr_prescricao_p bigint, dt_baixa_p timestamp, cd_motivo_baixa_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	prescr_procedimento
set	cd_motivo_baixa		= cd_motivo_baixa_p,
	ie_status_execucao		= 'BE',
	dt_baixa			= dt_baixa_p,
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia		= nr_sequencia_p
and	nr_prescricao		= nr_prescricao_p;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE prescr_proc_atual_motivo_baixa ( nr_sequencia_p bigint, nr_prescricao_p bigint, dt_baixa_p timestamp, cd_motivo_baixa_p bigint, nm_usuario_p text) FROM PUBLIC;

