-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qt_obter_dt_ciclo_sup ( nr_seq_atendimento_p bigint, dt_prevista_p timestamp) RETURNS varchar AS $body$
DECLARE

ds_retorno_w		varchar(1);
nr_seq_pend_agenda_w	bigint;
ds_dia_ciclo_w		varchar(10);
nr_ciclo_w		bigint;

BEGIN

	select	max(nr_seq_pend_agenda),
		max(ds_dia_ciclo),
		max(nr_ciclo)
	into STRICT	nr_seq_pend_agenda_w,
		ds_dia_ciclo_w,
		nr_ciclo_w
	from	paciente_atendimento
	where	nr_seq_atendimento = nr_seq_atendimento_p;



	begin

		select	'N'
		into STRICT	ds_retorno_w
		from	paciente_atendimento
		where	nr_seq_pend_agenda		= 	nr_seq_pend_agenda_w
		and	dt_prevista 			<=	dt_prevista_p
		and	((nr_ciclo			=	nr_ciclo_w AND somente_numero(ds_dia_ciclo)	>=	somente_numero(ds_dia_ciclo_w)) or (nr_ciclo			>	nr_ciclo_w))
		and	nr_seq_atendimento	 	<> 	nr_seq_atendimento_p  LIMIT 1;
	exception
	when others then
		ds_retorno_w	:= 'S';
	end;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qt_obter_dt_ciclo_sup ( nr_seq_atendimento_p bigint, dt_prevista_p timestamp) FROM PUBLIC;

