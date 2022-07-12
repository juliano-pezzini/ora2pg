-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gedipa_virada_obter_gerar_proc ( dt_virada_p timestamp, ie_processo_atual_p text, nr_seq_ap_lote_p bigint) RETURNS varchar AS $body$
DECLARE


ie_gerar_processo_w	varchar(1) := 'N';
ie_gedipa_w		varchar(1);


BEGIN
if (dt_virada_p IS NOT NULL AND dt_virada_p::text <> '') then

	if	((trunc(clock_timestamp(),'dd') - trunc(dt_virada_p,'dd')) < 2) then

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

	select	coalesce(max(ie_gedipa),'S')
	into STRICT	ie_gedipa_w
	from	prescr_mat_hor
	where	nr_seq_lote	=	nr_seq_ap_lote_p
	and	(dt_lib_horario IS NOT NULL AND dt_lib_horario::text <> '');

	if (ie_gerar_processo_w = 'S') and (ie_gedipa_w = 'N') then
		ie_gerar_processo_w := 'N';
	end if;

end if;

return ie_gerar_processo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gedipa_virada_obter_gerar_proc ( dt_virada_p timestamp, ie_processo_atual_p text, nr_seq_ap_lote_p bigint) FROM PUBLIC;

