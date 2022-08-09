-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_atualiz_ativ_real_ini_fim (nr_sequencia_p bigint, dt_inicio_real_p timestamp, dt_fim_real_p timestamp, nm_usuario_p text) AS $body$
DECLARE



dt_inicio_real_w	timestamp;
dt_fim_real_w	timestamp;


BEGIN

select	coalesce(dt_inicio_real_p, dt_inicio_real),
	coalesce(dt_fim_real, dt_fim_real_p)
into STRICT	dt_inicio_real_w,
	dt_fim_real_w
from	man_ordem_servico
where	nr_sequencia = nr_sequencia_p;

if (dt_inicio_real_w IS NOT NULL AND dt_inicio_real_w::text <> '') and (dt_fim_real_w IS NOT NULL AND dt_fim_real_w::text <> '') then
	update	man_ordem_serv_ativ
	set	dt_atividade		= dt_inicio_real_w,
		dt_fim_atividade		= dt_fim_real_w,
		qt_minuto			= substr(((dt_fim_real_w - dt_inicio_real_w) * 1440),1,10),
		nm_usuario		= nm_usuario_p
	where	nr_seq_ordem_serv		= nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_atualiz_ativ_real_ini_fim (nr_sequencia_p bigint, dt_inicio_real_p timestamp, dt_fim_real_p timestamp, nm_usuario_p text) FROM PUBLIC;
