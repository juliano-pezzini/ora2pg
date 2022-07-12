-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_exec_os (nm_usuario_prev_p text) RETURNS varchar AS $body$
DECLARE


dt_atividade_w		timestamp;
nr_seq_ordem_serv_w	bigint;
nr_seq_ativ_prev_w	bigint;
qt_minutos_exec_w	bigint;
qt_min_prev_w		bigint;
ds_retorno_w		varchar(1);


BEGIN

select	max(dt_atividade),
	max(nr_seq_ordem_serv),
	max(nr_seq_ativ_prev)
into STRICT	dt_atividade_w,
	nr_seq_ordem_serv_w,
	nr_seq_ativ_prev_w
from	man_ordem_serv_ativ
where	nm_usuario_exec	= nm_usuario_prev_p
and	dt_atividade between trunc(clock_timestamp()) and trunc(clock_timestamp()) + 86399/86400
and	coalesce(dt_fim_atividade::text, '') = '';

if (coalesce(dt_atividade_w::text, '') = '') then
	ds_retorno_w	:= 'N';
else
	select	max(qt_min_prev)
	into STRICT	qt_min_prev_w
	from	man_ordem_ativ_prev
	where	nr_sequencia	= nr_seq_ativ_prev_w;

	select	coalesce(sum(qt_minuto),0)
	into STRICT	qt_minutos_exec_w
	from	man_ordem_serv_ativ
	where	nr_seq_ativ_prev	= nr_seq_ativ_prev_w
	and	nm_usuario_exec		= nm_usuario_prev_p
	and	dt_atividade 		between trunc(clock_timestamp()) and trunc(clock_timestamp()) + 86399/86400
	and	(dt_fim_atividade IS NOT NULL AND dt_fim_atividade::text <> '');

	qt_minutos_exec_w	:= qt_minutos_exec_w + Obter_Min_Entre_Datas(dt_atividade_w, clock_timestamp(), 1);

	if (qt_minutos_exec_w > qt_min_prev_w) then
		ds_retorno_w	:= 'V';
	elsif (dividir((qt_minutos_exec_w * 100), qt_min_prev_w) > 70) then
		ds_retorno_w	:= 'A';
	else
		ds_retorno_w	:= 'N';
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_exec_os (nm_usuario_prev_p text) FROM PUBLIC;

