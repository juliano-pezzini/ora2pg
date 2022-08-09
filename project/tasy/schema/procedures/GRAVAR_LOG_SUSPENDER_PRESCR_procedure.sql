-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_log_suspender_prescr ( nr_atendimento_p bigint, dt_validade_prescr_p INOUT timestamp, nm_usuario_p text) AS $body$
DECLARE


dt_limite_w	timestamp;

BEGIN
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin

	select	max(dt_validade_prescr)
	into STRICT	dt_limite_w
	from	prescr_medica
	where	nr_atendimento = nr_atendimento_p;
	end;
end if;
commit;
dt_validade_prescr_p	:= dt_limite_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_log_suspender_prescr ( nr_atendimento_p bigint, dt_validade_prescr_p INOUT timestamp, nm_usuario_p text) FROM PUBLIC;
