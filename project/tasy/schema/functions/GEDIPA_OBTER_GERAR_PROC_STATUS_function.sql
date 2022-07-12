-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gedipa_obter_gerar_proc_status ( dt_virada_p timestamp, ie_processo_atual_p text, nr_seq_ap_lote_p bigint, ie_gedipa_P text, nr_seq_processo_p bigint default null, nr_seq_area_prep_p bigint default null, ie_origem_processo_p text default null) RETURNS varchar AS $body$
DECLARE


ie_gerar_processo_w	varchar(1) := 'N';
ie_gedipa_w		varchar(1);


BEGIN
	
if (ie_gerar_processo_w = 'N') and (coalesce(nr_seq_processo_p::text, '') = '') and (dt_virada_p IS NOT NULL AND dt_virada_p::text <> '') and (coalesce(ie_gedipa_p,'S') <> 'N') then
	if	((ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(clock_timestamp()) - ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_virada_p)) < 2) then
		if (ie_processo_atual_p = 'AP_LOTE') then
			if (nr_seq_ap_lote_p IS NOT NULL AND nr_seq_ap_lote_p::text <> '') then
				select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
				into STRICT	ie_gerar_processo_w
				from	ap_lote
				where	nr_sequencia	= nr_seq_ap_lote_p
				and	((coalesce(dt_impressao::text, '') = '') or (dt_impressao	> dt_virada_p));
			else
				ie_gerar_processo_w	:= 'S';
			end if;
		else
			ie_gerar_processo_w	:= 'S';
		end if;
	else
		ie_gerar_processo_w	:= 'S';
	end if;
end if;

if (nr_seq_processo_p IS NOT NULL AND nr_seq_processo_p::text <> '') then	
	select	coalesce(max('N'),'S')
	into STRICT	ie_gerar_processo_w
	from	adep_processo
	where	nr_sequencia = nr_seq_processo_p
	and	ie_origem_processo = 'GGP';
	
	if (ie_gerar_processo_w = 'S') then
		select	coalesce(max('S'),'N')
		into STRICT	ie_gerar_processo_w
		from	adep_processo a
		where	a.nr_sequencia = nr_seq_processo_p
		and		a.ie_origem_processo <> 'GGP'
		and		obter_status_processo_area(a.nr_sequencia, nr_seq_area_prep_p) in ('G','D','L')
		and		exists (SELECT 1 from atend_paciente_unidade x where x.nr_atendimento = a.nr_atendimento and x.dt_entrada_unidade > clock_timestamp() - interval '1 days'/96);		
	end if;
end if;

return ie_gerar_processo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gedipa_obter_gerar_proc_status ( dt_virada_p timestamp, ie_processo_atual_p text, nr_seq_ap_lote_p bigint, ie_gedipa_P text, nr_seq_processo_p bigint default null, nr_seq_area_prep_p bigint default null, ie_origem_processo_p text default null) FROM PUBLIC;

