-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcula_velocidade_inf_dialise (( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_seq_dialise_p hd_prescricao.nr_sequencia%type, nr_seq_solucao_p prescr_solucao.nr_seq_solucao%type) is qt_hora_sessao_w hd_prescricao.qt_hora_sessao%type) RETURNS bigint AS $body$
BEGIN
		if (ie_unid_vel_inf_p = 'mlh') then
			return (qt_hora_sessao_w + (dividir(qt_min_sessao_w,60)));
		else
			return (qt_min_sessao_w + (qt_hora_sessao_w * 60));
		end if;
	end;
begin

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_dialise_p IS NOT NULL AND nr_seq_dialise_p::text <> '') then

select	coalesce(max(qt_hora_sessao),0),
		coalesce(max(qt_min_sessao),0)
into STRICT	qt_hora_sessao_w,
		qt_min_sessao_w
from	hd_prescricao
where	nr_prescricao = nr_prescricao_p
and		nr_sequencia = nr_seq_dialise_p;

open c01;
loop
fetch c01 into	nr_seq_solucao_w,
				qt_solucao_total_w,
				ie_unid_vel_inf_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	qt_dosagem_w := dividir(qt_solucao_total_w, obter_tempo_vel_inf(ie_unid_vel_inf_w));

	update	prescr_solucao
	set		qt_dosagem 		= qt_dosagem_w
	where	nr_prescricao	= nr_prescricao
	and		nr_seq_solucao	= nr_seq_solucao_w
	and		nr_seq_dialise	= nr_seq_dialise_p;
	end;
end loop;
close c01;

commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcula_velocidade_inf_dialise (( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_seq_dialise_p hd_prescricao.nr_sequencia%type, nr_seq_solucao_p prescr_solucao.nr_seq_solucao%type) is qt_hora_sessao_w hd_prescricao.qt_hora_sessao%type) FROM PUBLIC;
