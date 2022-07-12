-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_obter_dia_fase_trat_agenda ( nr_seq_tratamento_p bigint, nr_seq_fase_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_dia_w	bigint;

/*

DT - Dia tratamento
DF - Dia fase

*/
BEGIN

if (nr_seq_tratamento_p IS NOT NULL AND nr_seq_tratamento_p::text <> '') then
	begin
	if (ie_opcao_p = 'DT') then

		select	coalesce(max(nr_seq_dia),0) + 1
		into STRICT	nr_seq_dia_w
		from	rxt_agenda
		where	nr_seq_tratamento	= nr_seq_tratamento_p
		and	ie_tipo_agenda		= 'T'
		and	ie_status_Agenda <> 'C';

	elsif (ie_opcao_p = 'DF') and (nr_seq_fase_p IS NOT NULL AND nr_seq_fase_p::text <> '') then

		select	coalesce(max(nr_seq_dia_fase),0) + 1
		into STRICT	nr_seq_dia_w
		from	rxt_agenda
		where	nr_seq_tratamento	= nr_seq_tratamento_p
		and	nr_seq_fase		= nr_seq_fase_p
		and	ie_tipo_agenda		= 'T'
		and	ie_status_Agenda <> 'C';

	end if;
	end;
end if;

return nr_seq_dia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_obter_dia_fase_trat_agenda ( nr_seq_tratamento_p bigint, nr_seq_fase_p bigint, ie_opcao_p text) FROM PUBLIC;
