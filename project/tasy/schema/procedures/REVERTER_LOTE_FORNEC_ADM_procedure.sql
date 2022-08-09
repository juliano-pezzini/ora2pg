-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reverter_lote_fornec_adm ( nr_seq_horario_p bigint, nr_prescricao_p bigint, nr_seq_item_p bigint, dt_horario_p timestamp, nm_usuario_p text, ie_tipo_item_p text default null) AS $body$
DECLARE


nr_seq_lote_adm_w	administracao_lote_item.nr_seq_lote_adm%type;
nr_seq_horario_w	prescr_mat_hor.nr_sequencia%type;
qt_material_w		administracao_lote_item.qt_material%type;

c01 CURSOR FOR
SELECT	a.nr_sequencia
from	prescr_mat_hor a,
		prescr_material b
where	a.nr_prescricao		= b.nr_prescricao
and		a.nr_seq_material	= b.nr_sequencia
and		b.nr_prescricao		= nr_prescricao_p
and		b.nr_sequencia_diluicao	= nr_seq_item_p
and		a.dt_horario		= dt_horario_p
and		b.ie_agrupador		in (3,7,9)
and		coalesce(b.ie_suspenso,'N')	<> 'S'
and		coalesce(a.ie_situacao,'A')	= 'A'
and		Obter_se_horario_liberado(a.dt_lib_horario, a.dt_horario) = 'S'
and		ie_tipo_item_p = 'M'

union

select	nr_seq_horario_p

where	ie_tipo_item_p = 'M'

union

select	a.nr_sequencia
from	prescr_mat_hor a,
		prescr_material b
where	a.nr_prescricao		= b.nr_prescricao
and		a.nr_seq_material	= b.nr_sequencia
and		b.nr_prescricao		= nr_prescricao_p
and		a.dt_horario		= dt_horario_p
and		b.nr_sequencia_proc = nr_seq_item_p
and		b.ie_agrupador		in (5)
and		coalesce(b.ie_suspenso,'N')	<> 'S'
and		coalesce(a.ie_situacao,'A')	= 'A'
and		Obter_se_horario_liberado(a.dt_lib_horario, a.dt_horario) = 'S'
and		ie_tipo_item_p in ('IA', 'C', 'G')

union

select	a.nr_sequencia
from	prescr_mat_hor a,
		prescr_material b
where	a.nr_prescricao		= b.nr_prescricao
and		a.nr_seq_material	= b.nr_sequencia
and		b.nr_prescricao		= nr_prescricao_p
and		a.dt_horario		= dt_horario_p
and		b.nr_seq_gasoterapia = nr_seq_item_p
and		b.ie_agrupador		in (15)
and		coalesce(b.ie_suspenso,'N')	<> 'S'
and		coalesce(a.ie_situacao,'A')	= 'A'
and		Obter_se_horario_liberado(a.dt_lib_horario, a.dt_horario) = 'S'
and		ie_tipo_item_p in ('GAS')

union

select	a.nr_sequencia
from	prescr_mat_hor a,
		prescr_material b
where	a.nr_prescricao		= b.nr_prescricao
and		a.nr_seq_material	= b.nr_sequencia
and		b.nr_prescricao		= nr_prescricao_p
and		a.dt_horario		= dt_horario_p
and		b.nr_sequencia      = nr_seq_item_p
and		b.ie_agrupador		in (8)
and		coalesce(b.ie_suspenso,'N')	<> 'S'
and		coalesce(a.ie_situacao,'A')	= 'A'
and		Obter_se_horario_liberado(a.dt_lib_horario, a.dt_horario) = 'S'
and		ie_tipo_item_p in ('SNE');


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_horario_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	--Busca a qtde de cada horario
	select	coalesce(sum(qt_material),0),
			coalesce(max(nr_seq_lote_adm),0)
	into STRICT	qt_material_w,
			nr_seq_lote_adm_w
	from	administracao_lote_item
	where	nr_seq_horario = nr_seq_horario_w
	and		ie_situacao = 'S';

	if (qt_material_w > 0) and (nr_seq_lote_adm_w > 0) then

		--Atualiza situacao do registro selecionado
		update	administracao_lote_item
		set		ie_situacao = 'N'
		where	nr_seq_horario = nr_seq_horario_w;

		--Decrementa a qtde total do material
		update	administracao_lote_fornec
		set		qt_material = qt_material - qt_material_w
		where	nr_sequencia = nr_seq_lote_adm_w;


		if (ie_tipo_item_p = 'M') then
			update 	prescr_mat_alteracao
			set		ie_evento_valido = 'N'
			where	nr_seq_horario = nr_seq_horario_w
			and		ie_alteracao = 58;
		elsif (ie_tipo_item_p in ('IA', 'C', 'G')) then
			update 	prescr_mat_alteracao
			set		ie_evento_valido = 'N'
			where	nr_prescricao = nr_prescricao_p
			and		nr_seq_procedimento = nr_seq_item_p
			and		nr_seq_horario_proc = nr_seq_horario_p
			and		ie_alteracao = 58;

		elsif (ie_tipo_item_p = 'GAS') then
			update	prescr_gasoterapia_evento
			set		ie_evento_valido = 'N'
			where	nr_seq_horario = nr_seq_horario_p
			and		nr_seq_gasoterapia = nr_seq_item_p
			and 	ie_evento = 'CR';
		end if;


	end if;

	if (ie_tipo_item_p in ('SNE')) then
		update 	prescr_solucao_evento
		set		ie_evento_valido = 'N'
		where	nr_prescricao = nr_prescricao_p
		and		nr_seq_material = nr_seq_item_p
		and		ie_alteracao = 54
		and		dt_horario = dt_horario_p
		and		ie_evento_valido = 'S';
	end if;

	end;
end loop;
close C01;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reverter_lote_fornec_adm ( nr_seq_horario_p bigint, nr_prescricao_p bigint, nr_seq_item_p bigint, dt_horario_p timestamp, nm_usuario_p text, ie_tipo_item_p text default null) FROM PUBLIC;
