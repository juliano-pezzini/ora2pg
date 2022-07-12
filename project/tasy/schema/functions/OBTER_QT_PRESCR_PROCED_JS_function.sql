-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_prescr_proced_js ( nr_sequencia_p bigint, ie_tipo_p text) RETURNS bigint AS $body$
DECLARE


qt_retorno_w	bigint := 0;

BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	if ('ME' = ie_tipo_p) then
		begin
		select	count(*)
		into STRICT	qt_retorno_w
		from	prescr_procedimento
		where	nr_seq_lote_externo = nr_sequencia_p
		and	ie_status_atend < 30
		and	(nr_seq_exame IS NOT NULL AND nr_seq_exame::text <> '');
		end;
	elsif ('MA' = ie_tipo_p) then
		begin
		select	count(*)
		into STRICT	qt_retorno_w
		from	prescr_procedimento
		where	nr_seq_lote_externo = nr_sequencia_p
		and	ie_status_atend >= 30
		and	(nr_seq_exame IS NOT NULL AND nr_seq_exame::text <> '');
		end;
	end if;
	end;
end if;
return	qt_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_prescr_proced_js ( nr_sequencia_p bigint, ie_tipo_p text) FROM PUBLIC;
