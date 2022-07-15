-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_prescr_medica (dt_entrada_unidade_p timestamp, nr_atendimento_p bigint, nr_prescricao_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (dt_entrada_unidade_p IS NOT NULL AND dt_entrada_unidade_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	update	prescr_medica
	set	dt_entrada_unidade	= dt_entrada_unidade_p,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_prescricao		= nr_prescricao_p
	and	nr_atendimento		= nr_atendimento_p;
	end;
end if;



commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_prescr_medica (dt_entrada_unidade_p timestamp, nr_atendimento_p bigint, nr_prescricao_p bigint, nm_usuario_p text) FROM PUBLIC;

