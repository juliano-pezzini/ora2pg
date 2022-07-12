-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_obter_dia_fase_vol_roent ( nr_seq_volume_p bigint, nr_seq_campo_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_dia_w	bigint;

/*

DT - Dia tratamento
DF - Dia fase

*/
BEGIN

if (nr_seq_volume_p IS NOT NULL AND nr_seq_volume_p::text <> '') and (nr_seq_campo_p IS NOT NULL AND nr_seq_campo_p::text <> '') then
	begin
	if (ie_opcao_p = 'DT') then

		select	coalesce(max(nr_seq_dia),0) + 1
		into STRICT	nr_seq_dia_w
		from	rxt_agenda_fase
		where	nr_seq_volume	= nr_seq_volume_p;

	elsif (ie_opcao_p = 'DF') then

		select	coalesce(max(nr_seq_dia_fase),0) + 1
		into STRICT	nr_seq_dia_w
		from	rxt_agenda_fase
		where	nr_seq_volume		= nr_seq_volume_p
		and	nr_seq_campo_roentgen	= nr_seq_campo_p;

	end if;
	end;
end if;

return nr_seq_dia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_obter_dia_fase_vol_roent ( nr_seq_volume_p bigint, nr_seq_campo_p bigint, ie_opcao_p text) FROM PUBLIC;

