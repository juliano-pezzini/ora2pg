-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_cancel_proc_alta ( nr_atendimento_p bigint ) RETURNS timestamp AS $body$
DECLARE

qt_regs_w		bigint := 0;
ds_return_w		timestamp;

BEGIN
	select	count(*)
	into STRICT 	qt_regs_w
	from	atend_pac_proc_alta
	where 	nr_atendimento = nr_atendimento_p
	and		(nr_seq_motivo_cancel IS NOT NULL AND nr_seq_motivo_cancel::text <> '');
	if (qt_regs_w > 0) then
		select 	dt_cancelamento
		into STRICT	ds_return_w
		from	atend_pac_proc_alta
		where	nr_atendimento = nr_atendimento_p
		and		(nr_seq_motivo_cancel IS NOT NULL AND nr_seq_motivo_cancel::text <> '');
	end if;

  return ds_return_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_cancel_proc_alta ( nr_atendimento_p bigint ) FROM PUBLIC;

