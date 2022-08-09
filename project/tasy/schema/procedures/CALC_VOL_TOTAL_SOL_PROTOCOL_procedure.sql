-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calc_vol_total_sol_protocol ( nr_prescricao_p bigint, nr_seq_hd_prescricao_p bigint, nr_seq_solucao_p bigint) AS $body$
DECLARE



qt_multiplicacao_w	hd_prescricao.qt_hora_sessao%type;
ie_unid_vel_inf_w	prescr_solucao.ie_unid_vel_inf%type;
qt_dosagem_w		prescr_solucao.qt_dosagem%type;
qt_solucao_total_w	prescr_solucao.qt_solucao_total%type;
ie_tipo_solucao_w	prescr_solucao.ie_tipo_solucao%type;
nr_seq_solucao_w	prescr_solucao.nr_seq_solucao%type;

c01 CURSOR FOR
SELECT	ie_unid_vel_inf,
		qt_dosagem,
		ie_tipo_solucao,
		nr_seq_solucao
from	prescr_solucao
where	nr_prescricao = nr_prescricao_p
and		((nr_seq_solucao = nr_seq_solucao_p) or
		 ((coalesce(nr_seq_solucao_p,0) = 0) and (nr_seq_dialise = nr_seq_hd_prescricao_p)));

BEGIN

open c01;
loop
fetch c01 into	ie_unid_vel_inf_w,
				qt_dosagem_w,
				ie_tipo_solucao_w,
				nr_seq_solucao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	CASE WHEN ie_unid_vel_inf_w='mlm' THEN  qt_min_sessao WHEN ie_unid_vel_inf_w='mlh' THEN  qt_hora_sessao  ELSE 0 END  qt_multiplicacao
	into STRICT	qt_multiplicacao_w
	from	hd_prescricao
	where	nr_sequencia = nr_seq_hd_prescricao_p
	and		nr_prescricao = nr_prescricao_p;

	if (ie_tipo_solucao_w = 'C') then
		qt_solucao_total_w := 0;
	elsif (ie_tipo_solucao_w <> 'C') then
		qt_solucao_total_w :=	coalesce(qt_dosagem_w,0) * coalesce(qt_multiplicacao_w,0);
	end if;

	if (qt_solucao_total_w IS NOT NULL AND qt_solucao_total_w::text <> '') then
		CALL ajustar_vol_sol_dialise(nr_prescricao_p, nr_seq_solucao_w, qt_solucao_total_w);
	end if;
	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calc_vol_total_sol_protocol ( nr_prescricao_p bigint, nr_seq_hd_prescricao_p bigint, nr_seq_solucao_p bigint) FROM PUBLIC;
