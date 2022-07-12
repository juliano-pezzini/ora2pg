-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_etapa_atual_hm (nr_prescricao_p bigint, nr_seq_solucao_p bigint) RETURNS varchar AS $body$
DECLARE


qt_etapa_w		bigint;
nr_etapa_atual_w	smallint;
qt_etapa_susp_w		bigint := 0;
ie_etapa_susp_w		varchar(1);

c01 CURSOR FOR
SELECT	distinct nr_etapa_sol
from	prescr_mat_hor
where	nr_prescricao 	= nr_prescricao_p
and	nr_seq_solucao	= nr_seq_solucao_p
and	coalesce(dt_inicio_horario::text, '') = ''
and	coalesce(dt_fim_horario::text, '') = ''
order by nr_etapa_sol;


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '')then
	
	open C01;
	loop
	fetch C01 into	
		nr_etapa_atual_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	coalesce(max('S'),'N')
		into STRICT	ie_etapa_susp_w
		from	hd_prescricao_evento
		where	nr_prescricao	= nr_prescricao_p
		and	nr_seq_solucao	= nr_seq_solucao_p
		and	nr_etapa_evento = nr_etapa_atual_w
		and	ie_evento	= 'SE';

		if (ie_etapa_susp_w = 'S') then
			qt_etapa_susp_w := qt_etapa_susp_w + 1;
		else
			exit;
		end if;
		
		end;
	end loop;
	close C01;

	select	count(*) + qt_etapa_susp_w
	into STRICT	qt_etapa_w
	from	hd_prescricao_evento
	where	nr_prescricao	= nr_prescricao_p
	and	nr_seq_solucao	= nr_seq_solucao_p
  and coalesce(ie_evento_valido, 'S') <> 'N'
	and	ie_evento	in ('II');
	
end if;

return qt_etapa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_etapa_atual_hm (nr_prescricao_p bigint, nr_seq_solucao_p bigint) FROM PUBLIC;
