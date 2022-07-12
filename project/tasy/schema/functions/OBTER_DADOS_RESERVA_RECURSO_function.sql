-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_reserva_recurso ( nr_seq_agenda_p bigint, cd_equipamento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p
S - Status
R - Existe reserva?
*/
ds_retorno_w		varchar(255):=null;
nr_seq_recurso_w	bigint:=null;
qt_reserva_w		bigint:=0;


BEGIN

if (coalesce(nr_seq_agenda_p,0) > 0) and (coalesce(cd_equipamento_p,0) > 0) then
	if (ie_opcao_p = 'S') then
		select	max(nr_seq_status)
		into STRICT	nr_seq_recurso_w
		from	reserva_agenda_equip
		where	nr_seq_agenda		= nr_seq_agenda_p
		and	cd_equipamento_agenda	= cd_equipamento_p;
		if (nr_seq_recurso_w IS NOT NULL AND nr_seq_recurso_w::text <> '') then
			ds_retorno_w := obter_desc_status_recurso(nr_seq_recurso_w);
		end if;
	elsif (ie_opcao_p = 'R') then
		select	count(*)
		into STRICT	qt_reserva_w
		from	reserva_agenda_equip
		where	nr_seq_agenda		= nr_seq_agenda_p
		and	cd_equipamento_agenda	= cd_equipamento_p;
		if (qt_reserva_w > 0) then
			ds_retorno_w := 'S';
		else
			ds_retorno_w := 'N';
		end if;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_reserva_recurso ( nr_seq_agenda_p bigint, cd_equipamento_p bigint, ie_opcao_p text) FROM PUBLIC;

