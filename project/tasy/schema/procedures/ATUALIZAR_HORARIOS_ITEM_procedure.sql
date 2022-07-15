-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_horarios_item ( hr_prim_horario_p text, ds_horarios_p text, nr_prescricao_p bigint, cd_item_p bigint, ie_tipo_item_p text, nr_seq_item_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (ie_tipo_item_p in ('M', 'IAH', 'S')) then

	update	prescr_material
	set	ds_horarios = ds_horarios_p,
		hr_prim_horario = hr_prim_horario_p
	where	nr_prescricao = nr_prescricao_p
	and	nr_sequencia = coalesce(nr_seq_item_p, nr_sequencia)
	and	cd_material = cd_item_p;

elsif (ie_tipo_item_p in ('P','L','HM')) then

	update	prescr_procedimento
	set	dt_prev_execucao = to_date(to_char(dt_prev_execucao, 'dd/mm/yyyy')||' '||hr_prim_horario_p, 'dd/mm/yyyy hh24:mi:ss'),
		ds_horarios = ds_horarios_p
	where	nr_prescricao = nr_prescricao_p
	and	cd_procedimento = cd_item_p
	and	nr_sequencia = coalesce(nr_seq_item_p, nr_sequencia);


elsif (ie_tipo_item_p = 'SOL') then

	update	prescr_solucao
	set	hr_prim_horario = hr_prim_horario_p,
		ds_horarios = ds_horarios_p
	where	nr_prescricao = nr_prescricao_p
	and	nr_seq_solucao = nr_seq_item_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_horarios_item ( hr_prim_horario_p text, ds_horarios_p text, nr_prescricao_p bigint, cd_item_p bigint, ie_tipo_item_p text, nr_seq_item_p bigint, nm_usuario_p text) FROM PUBLIC;

