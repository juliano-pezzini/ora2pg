-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_etapa_evento_dp_adep (nr_prescricao_p bigint, nr_seq_solucao_p bigint, ie_dialise_p text, ie_evento_p text) RETURNS varchar AS $body$
DECLARE


nr_etapa_w	smallint;


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') and (ie_dialise_p IS NOT NULL AND ie_dialise_p::text <> '') and (ie_evento_p IS NOT NULL AND ie_evento_p::text <> '') then

	if (ie_dialise_p <> 'DPA') then

		select	count(*)
		into STRICT	nr_etapa_w
		from	hd_prescricao_evento
		where	nr_prescricao	= nr_prescricao_p
		and	nr_seq_solucao	= nr_seq_solucao_p
		and	ie_evento	= 'II';

		if (ie_evento_p = 'II') then
			nr_etapa_w := nr_etapa_w + 1;
		elsif (nr_etapa_w = 0) then
			nr_etapa_w := 1;
		end if;

	else

		select	count(*)
		into STRICT	nr_etapa_w
		from	hd_prescricao_evento
		where	nr_prescricao	= nr_prescricao_p
		and	nr_seq_solucao	= nr_seq_solucao_p
		and	ie_evento	= 'DPAI';

		if (ie_evento_p = 'DPAI') then
			nr_etapa_w := nr_etapa_w + 1;
		elsif (nr_etapa_w = 0) then
			nr_etapa_w := 1;
		end if;

	end if;

end if;

return nr_etapa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_etapa_evento_dp_adep (nr_prescricao_p bigint, nr_seq_solucao_p bigint, ie_dialise_p text, ie_evento_p text) FROM PUBLIC;
