-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_item_prescr ( nr_seq_horario_p bigint, ie_tipo_item_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_item_w		bigint;
				

BEGIN

nr_seq_item_w	:= null;

if (nr_seq_horario_p IS NOT NULL AND nr_seq_horario_p::text <> '') then
	if (ie_tipo_item_p = 'M') then
		select	max(a.nr_seq_material)
		into STRICT	nr_seq_item_w
		from	prescr_mat_hor		a
		where	a.nr_sequencia	= nr_seq_horario_p;
	elsif (ie_tipo_item_p = 'SOL') then
		select	max(a.nr_seq_solucao)
		into STRICT	nr_seq_item_w
		from	prescr_mat_hor		a
		where	a.nr_sequencia	= nr_seq_horario_p;
	elsif (ie_tipo_item_p	= 'P') then
		select	max(a.nr_seq_procedimento)
		into STRICT	nr_seq_item_w
		from	prescr_proc_hor	a
		where	a.nr_sequencia	= nr_seq_horario_p;
	end if;
end if;

return	nr_seq_item_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_item_prescr ( nr_seq_horario_p bigint, ie_tipo_item_p text) FROM PUBLIC;
