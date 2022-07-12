-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qt_consistir_bloq_medic ( dt_agenda_p timestamp, nr_seq_atendimento_p bigint, nr_seq_local_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_dia_semana_w		integer;
qt_bloqueio_w		integer;
ds_Retorno_w		varchar(1)	:= 'N';
cd_material_w		bigint;
ie_Feriado_w		varchar(1);
cd_classe_material_w	integer;
cd_grupo_material_w	smallint;
cd_subgrupo_material_w	smallint;
ie_bloquear_w		varchar(1);
cd_protocolo_w		bigint	:= 0;
nr_seq_medicacao_w	integer	:= 0;
cd_setor_atendimento_w	paciente_setor.cd_setor_atendimento%type	:= 0;
nr_seq_grupo_quimio_w	qt_local.nr_seq_grupo_quimio%type		:= 0;

C01 CURSOR FOR
	SELECT	coalesce(cd_material, 0),
		coalesce(Obter_estrutura_material(cd_material,'C'), 0),
		coalesce(Obter_estrutura_material(cd_material,'G'), 0),
		coalesce(Obter_estrutura_material(cd_material,'S'), 0)
	from	paciente_atend_medic
	where	nr_seq_atendimento	= nr_seq_atendimento_p
	--and	ds_Retorno_w		= 'N'
	order by 1;


C02 CURSOR FOR
	SELECT	coalesce(ie_bloquear,'S')
	from	qt_bloqueio_medic
	where	coalesce(cd_material,cd_material_w)				= cd_material_w
	and	coalesce(cd_classe_material,cd_classe_material_w)		= cd_classe_material_w
	and	coalesce(cd_grupo_material,cd_grupo_material_w)		= cd_grupo_material_w
	and	coalesce(cd_protocolo, cd_protocolo_w)		= cd_protocolo_w
	and	coalesce(nr_seq_medicacao, nr_seq_medicacao_w)		= nr_seq_medicacao_w
	and	coalesce(cd_subgrupo_material,cd_subgrupo_material_w)	= cd_subgrupo_material_w
	and	coalesce(cd_setor_atendimento, cd_setor_atendimento_w)		= cd_setor_atendimento_w
	and	coalesce(nr_seq_local, nr_seq_local_p)						= nr_seq_local_p
	and	coalesce(nr_seq_grupo_quimio, nr_seq_grupo_quimio_w)			= nr_seq_grupo_quimio_w
	and (trunc(dt_agenda_p) 	>= coalesce(trunc(dt_inicial), trunc(dt_agenda_p)))
	and (trunc(dt_agenda_p)	<= coalesce(trunc(dt_final), trunc(dt_agenda_p)))
	and	((dt_agenda_p between to_date(to_char(dt_agenda_p,'dd/mm/yyyy') ||' '|| to_char(hr_inicial_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
			and (to_date(to_char(dt_agenda_p,'dd/mm/yyyy') ||' '|| to_char(hr_final_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') - 1/1440))
	or (coalesce(hr_inicial_bloqueio::text, '') = ''	and	coalesce(hr_final_bloqueio::text, '') = ''))
	and	(((ie_dia_semana = ie_dia_semana_w) or ((ie_dia_semana = 9) and (ie_dia_semana_w not in (7,1)))) or coalesce(ie_dia_semana::text, '') = '')
	and	((ie_feriado_w	<> 'S' and coalesce(ie_feriado,'N') = 'N') or (coalesce(ie_feriado, 'N') = 'S' and ie_feriado_w = 'S'))
	and	coalesce(cd_estabelecimento, cd_estabelecimento_p)	= cd_estabelecimento_p
	order by coalesce(cd_material,0),
		coalesce(cd_classe_material,0),
		coalesce(cd_grupo_material,0),
		coalesce(cd_subgrupo_material,0),
		coalesce(cd_setor_atendimento,0),
		coalesce(nr_seq_grupo_quimio,0),
		coalesce(nr_seq_local,0);


BEGIN

ie_dia_semana_w	:= obter_cod_dia_semana(dt_agenda_p);

if (nr_seq_atendimento_p IS NOT NULL AND nr_seq_atendimento_p::text <> '') then

	select	coalesce(max(a.cd_protocolo), 0),
		coalesce(max(a.nr_seq_medicacao), 0),
		coalesce(max(a.cd_setor_atendimento), 0)
	into STRICT	cd_protocolo_w,
		nr_seq_medicacao_w,
		cd_setor_atendimento_w
	from	paciente_setor a,
			paciente_atendimento b
	where	b.nr_seq_paciente = a.nr_seq_paciente
	and		b.nr_seq_atendimento = nr_seq_atendimento_p;

end if;


if (nr_seq_local_p IS NOT NULL AND nr_seq_local_p::text <> '') then
	select	coalesce(max(nr_seq_grupo_quimio), 0)
	into STRICT	nr_seq_grupo_quimio_w
	from	qt_local
	where	nr_sequencia = nr_seq_local_p;

end if;

if (nr_seq_atendimento_p IS NOT NULL AND nr_seq_atendimento_p::text <> '') then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_feriado_w
	from 	feriado a
	where 	a.cd_estabelecimento = cd_estabelecimento_p
	and	a.dt_feriado = trunc(dt_agenda_p);

	open C01;
	loop
	fetch C01 into
		cd_material_w,
		cd_classe_material_w,
		cd_grupo_material_w,
		cd_subgrupo_material_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		open C02;
		loop
		fetch C02 into
			ie_bloquear_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			ds_Retorno_w	:= ie_bloquear_w;
			end;
		end loop;
		close C02;

		end;
	end loop;
	close C01;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qt_consistir_bloq_medic ( dt_agenda_p timestamp, nr_seq_atendimento_p bigint, nr_seq_local_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
