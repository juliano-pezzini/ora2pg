-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_processo_area ( nr_seq_processo_p bigint, nr_seq_area_prep_p bigint) RETURNS varchar AS $body$
DECLARE


ie_status_w		varchar(15)	:= 'X';
ie_status_processo_w	varchar(15);
dt_preparo_w		timestamp;
dt_higienizacao_w	timestamp;
dt_dispensacao_w	timestamp;


BEGIN
if (nr_seq_processo_p IS NOT NULL AND nr_seq_processo_p::text <> '') and (nr_seq_area_prep_p IS NOT NULL AND nr_seq_area_prep_p::text <> '') then
	if (coalesce(nr_seq_area_prep_p,0) = 0) then
		select	max(dt_preparo),
			max(dt_higienizacao),
			max(dt_dispensacao)
		into STRICT	dt_preparo_w,
			dt_higienizacao_w,
			dt_dispensacao_w
		from	adep_processo_area
		where	nr_seq_processo		= nr_seq_processo_p;
	else
		select	max(dt_preparo),
			max(dt_higienizacao),
			max(dt_dispensacao)
		into STRICT	dt_preparo_w,
			dt_higienizacao_w,
			dt_dispensacao_w
		from	adep_processo_area
		where	nr_seq_processo		= nr_seq_processo_p
		and	nr_seq_area_prep	= nr_seq_area_prep_p;
	end if;

	select	max(ie_status_processo)
	into STRICT	ie_status_processo_w
	from	adep_processo
	where	nr_sequencia	= nr_seq_processo_p;

	if (ie_status_processo_w = 'A') then
		ie_status_w	:= 'A';
	elsif (ie_status_processo_w	= 'R') then /* Dalcastagne em 07/07/2009 Adicionei este if OS 152492 */
		ie_status_w	:= 'R';
	elsif (ie_status_processo_w	= 'L') then
		ie_status_w	:= 'L';
	elsif (ie_status_processo_w = 'E') then
		ie_status_w	:= 'E';
	elsif (dt_preparo_w IS NOT NULL AND dt_preparo_w::text <> '') or (ie_status_processo_w = 'P') then
		ie_status_w	:= 'P';
	elsif (dt_higienizacao_w IS NOT NULL AND dt_higienizacao_w::text <> '') then
		ie_status_w	:= 'H';
	elsif (dt_dispensacao_w IS NOT NULL AND dt_dispensacao_w::text <> '') then
		ie_status_w	:= 'D';
	else
		ie_status_w	:= obter_status_processo(nr_seq_processo_p);
	end if;

elsif (nr_seq_processo_p IS NOT NULL AND nr_seq_processo_p::text <> '') then
	ie_status_w	:= obter_status_processo(nr_seq_processo_p);
end if;

return ie_status_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_processo_area ( nr_seq_processo_p bigint, nr_seq_area_prep_p bigint) FROM PUBLIC;

