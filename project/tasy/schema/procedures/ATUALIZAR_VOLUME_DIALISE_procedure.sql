-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_volume_dialise ( nr_seq_dialise_p bigint, nr_prescricao_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_volume_w				double precision;
qt_volume_ciclo_w		double precision;
nr_ciclos_w				smallint;
ie_tipo_peritoneal_w	varchar(15);
qt_hora_duracao_w		hd_prescricao.qt_hora_duracao%type;
qt_min_duracao_w		hd_prescricao.qt_min_duracao%type;
nr_etapas_dialise_w		hd_prescricao.nr_etapas%type;
nr_horas_validade_w		prescr_medica.nr_horas_validade%type;
qt_tempo_ciclo_w		integer;
qt_horas_etapa_w		integer;
qt_tempo_infusao_w		prescr_solucao.qt_tempo_infusao%type;
qt_tempo_perm_hor_w		prescr_solucao.qt_tempo_perm_hor%type;
qt_tempo_permanencia_w	prescr_solucao.qt_tempo_permanencia%type;
qt_tempo_drenagem_w		prescr_solucao.qt_tempo_drenagem%type;
qt_volume_total_w		hd_prescricao.qt_volume_total%type;
qt_min_sessao_w			hd_prescricao.qt_min_sessao%type;
nr_seq_solucao_w		prescr_solucao.nr_seq_solucao%type;
qt_solucao_w			prescr_material.qt_solucao%type;
qt_hora_perm_w			prescr_solucao.qt_hora_permanencia%type;

C01 CURSOR FOR
	SELECT	nr_seq_solucao
	from	prescr_solucao
	where	nr_prescricao 	= nr_prescricao_p
	and		nr_seq_dialise 	= nr_seq_dialise_p;


BEGIN

select	sum(qt_volume)
into STRICT	qt_volume_w
from	prescr_solucao
where	nr_prescricao	= nr_prescricao_p
and		nr_seq_dialise	= nr_seq_dialise_p;

select	max(a.nr_ciclos),
		max(a.ie_tipo_peritoneal),
		max(a.qt_volume_ciclo),
		max(coalesce(a.qt_hora_duracao,0)),
		max(coalesce(a.qt_min_duracao,0)),
		max(coalesce(a.qt_hora_sessao, b.nr_horas_validade)),
		max(coalesce(a.qt_min_sessao, 0))
into STRICT	nr_ciclos_w,
		ie_tipo_peritoneal_w,
		qt_volume_ciclo_w,
		qt_hora_duracao_w,
		qt_min_duracao_w,
		nr_horas_validade_w,
		qt_min_sessao_w
from	hd_prescricao a,
		prescr_medica b
where	a.nr_prescricao	= nr_prescricao_p
and		a.nr_sequencia	= nr_seq_dialise_p
and		a.nr_prescricao = b.nr_prescricao;

nr_ciclos_w	:= ceil(dividir(qt_volume_w, qt_volume_ciclo_w));

-- Removido cálculo exclusivo para DPA e DPI, conforme OS 1262559 e 1262560
select	coalesce(max(qt_tempo_infusao),0),
		coalesce(max(qt_tempo_perm_hor),0),
		coalesce(max(qt_tempo_permanencia),0),
		coalesce(max(qt_tempo_drenagem),0),
		coalesce(max(qt_hora_permanencia),0)
into STRICT	qt_tempo_infusao_w,
		qt_tempo_perm_hor_w,
		qt_tempo_permanencia_w,
		qt_tempo_drenagem_w,
		qt_hora_perm_w
from	prescr_solucao
where	nr_prescricao 	= nr_prescricao_p
and		nr_seq_dialise	= nr_seq_dialise_p;

if (ie_tipo_peritoneal_w = 'DPA') then
	qt_tempo_ciclo_w	:= (qt_hora_perm_w*60) + qt_tempo_permanencia_w;
else
	qt_tempo_ciclo_w	:= qt_tempo_infusao_w + (qt_tempo_perm_hor_w*60) + qt_tempo_permanencia_w + qt_tempo_drenagem_w;
end if;

if (coalesce(qt_tempo_ciclo_w,0) = 0) then
	qt_volume_total_w	:= 0;
else
	qt_volume_total_w	:= round((((nr_horas_validade_w * 60) + (qt_min_sessao_w)) / qt_tempo_ciclo_w) * qt_volume_ciclo_w);
end if;

qt_hora_duracao_w	:= trunc(qt_tempo_ciclo_w/60);
qt_min_duracao_w	:= trunc(qt_tempo_ciclo_w - (qt_hora_duracao_w*60));

open C01;
loop
fetch C01 into
	nr_seq_solucao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
		select	sum(qt_solucao)
		into STRICT	qt_solucao_w
		from	prescr_material
		where	nr_prescricao			= nr_prescricao_p
		and		nr_sequencia_solucao	= nr_seq_solucao_w;

		update	prescr_solucao
		set		qt_solucao_total	= qt_solucao_w
		where	nr_prescricao		= nr_prescricao_p
		and		nr_seq_solucao		= nr_seq_solucao_w;
	end;
end loop;
close C01;

select	sum(qt_solucao_total)
into STRICT	qt_volume_w
from	prescr_solucao
where	nr_prescricao	= nr_prescricao_p
and		nr_seq_dialise	= nr_seq_dialise_p;

if (coalesce(qt_volume_w,0) = 0) then
	nr_etapas_dialise_w	:= 0;
else
	nr_etapas_dialise_w	:= ceil(qt_volume_total_w / qt_volume_w);
end if;

nr_ciclos_w	:= ceil(dividir(qt_volume_w, qt_volume_ciclo_w));

update	hd_prescricao
set		nr_etapas			= nr_etapas_dialise_w,
		nr_ciclos			= nr_ciclos_w,
		qt_volume_total		= qt_volume_total_w,
		qt_hora_sessao		= nr_horas_validade_w,
		qt_min_duracao		= qt_min_duracao_w,
		qt_hora_duracao		= qt_hora_duracao_w
where	nr_prescricao		= nr_prescricao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_volume_dialise ( nr_seq_dialise_p bigint, nr_prescricao_p bigint, nm_usuario_p text) FROM PUBLIC;
