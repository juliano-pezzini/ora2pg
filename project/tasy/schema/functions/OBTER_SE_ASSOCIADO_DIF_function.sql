-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_associado_dif ( nr_prescricao_p bigint, nr_seq_item_p bigint) RETURNS char AS $body$
DECLARE


cd_procedimento_w	procedimento.cd_procedimento%type;
cd_procedimento_ww	cd_procedimento_w%type;
cd_intervalo_w		intervalo_prescricao.cd_intervalo%type;
ie_retorno_w		char(1);
ie_origem_proced_w	bigint;
nr_sequencia_w		integer;
nr_sequencia_ww		integer;
cd_material_w		integer;
cd_material_ww		integer;
ie_aux_w			char(1);
nr_atendimento_w	bigint;
nr_prescricao_w		bigint;
qt_mat_w			integer;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	prescr_procedimento
	where	nr_prescricao = nr_prescricao_p
	and		cd_procedimento = cd_procedimento_w
	and		coalesce(cd_intervalo,cd_intervalo_w) = cd_intervalo_w
	and		coalesce(ie_origem_proced,ie_origem_proced_w) = ie_origem_proced_w;

C02 CURSOR FOR
	SELECT	cd_material
	from	prescr_material
	where	nr_prescricao = nr_prescricao_p
	and		ie_agrupador = 5
	and		nr_sequencia_proc = nr_sequencia_w;

C04 CURSOR FOR
	SELECT	a.nr_sequencia,
			b.nr_prescricao
	from	prescr_procedimento a,
			prescr_medica b
	where	a.nr_prescricao = b.nr_prescricao
	and		b.nr_atendimento = nr_atendimento_w
	and		a.cd_procedimento = cd_procedimento_w
	and		coalesce(a.cd_intervalo,cd_intervalo_w) = cd_intervalo_w
	and		coalesce(a.ie_origem_proced,ie_origem_proced_w) = ie_origem_proced_w
	and		b.dt_validade_prescr > clock_timestamp()
	and		b.nr_prescricao <> nr_prescricao_p;


BEGIN

select	max(cd_procedimento),
		coalesce(max(cd_intervalo),'XPTO'),
		coalesce(max(ie_origem_proced),0)
into STRICT	cd_procedimento_w,
		cd_intervalo_w,
		ie_origem_proced_w
from	prescr_procedimento
where	nr_prescricao = nr_prescricao_p
and		nr_sequencia = nr_seq_item_p;

select 	max(nr_atendimento)
into STRICT	nr_atendimento_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

open C01;
loop
fetch C01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	open C02;
	loop
	fetch C02 into
		cd_material_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		if (coalesce(ie_retorno_w::text, '') = '') then

			select	coalesce(max('S'),'N')
			into STRICT	ie_aux_w
			from	prescr_material a where		a.cd_material = cd_material_w
			and		a.ie_agrupador = 5
			and		a.nr_prescricao = nr_prescricao_p
			and		a.nr_sequencia_proc <> nr_sequencia_w
			and		exists (	SELECT	1
							from	prescr_procedimento b
							where	b.cd_procedimento = cd_procedimento_w
							and		b.nr_sequencia = a.nr_sequencia_proc
							and		b.nr_prescricao = nr_prescricao_p) LIMIT 1;

			if (ie_aux_w = 'N') then
				ie_retorno_w := 'N';
			end if;
		end if;

		end;
	end loop;
	close C02;

	end;
end loop;
close C01;

if (coalesce(ie_retorno_w,'N') = 'N') then

	ie_aux_w := null;

	open C01;
	loop
	fetch C01 into
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		open C02;
		loop
		fetch C02 into
			cd_material_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

			open C04;
			loop
			fetch C04 into
				nr_sequencia_ww,
				nr_prescricao_w;
			EXIT WHEN NOT FOUND; /* apply on C04 */
				begin

				select	count(*)
				into STRICT	qt_mat_w
				from	prescr_material a where		a.nr_prescricao = nr_prescricao_w
				and		a.nr_sequencia_proc = nr_sequencia_ww
				and		a.ie_agrupador = 5
				and		not exists (	SELECT	1
									from 	prescr_material b
									where 	b.nr_prescricao = nr_prescricao_p
									and 	b.nr_sequencia_proc  = nr_seq_item_p
									and		b.ie_agrupador = 5
									and 	b.cd_material = a.cd_material) LIMIT 1;

				if	(((coalesce(ie_aux_w::text, '') = '') or (ie_aux_w <> 'N')) and (qt_mat_w > 0)) then
					ie_aux_w := 'N';
				elsif (qt_mat_w = 0) and (coalesce(ie_aux_w::text, '') = '') then
					ie_aux_w := 'S';
				end if;

				end;
			end loop;
			close C04;

			if (ie_aux_w IS NOT NULL AND ie_aux_w::text <> '') then
				ie_retorno_w := ie_aux_w;
			end if;

			end;
		end loop;
		close C02;

		end;
	end loop;
	close C01;

	if (ie_aux_w IS NOT NULL AND ie_aux_w::text <> '') then
		ie_retorno_w := ie_aux_w;
	end if;

end if;

return	coalesce(ie_retorno_w,'S');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_associado_dif ( nr_prescricao_p bigint, nr_seq_item_p bigint) FROM PUBLIC;
