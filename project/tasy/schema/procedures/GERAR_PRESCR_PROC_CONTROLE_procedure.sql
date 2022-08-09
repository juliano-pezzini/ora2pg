-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_prescr_proc_controle ( nr_prescricao_p bigint) AS $body$
DECLARE


nr_seq_prescricao_w		prescr_procedimento.nr_sequencia%type;
cd_procedimento_w		procedimento.cd_procedimento%type;
ie_origem_proced_w		procedimento.ie_origem_proced%type;
cd_setor_w				setor_atendimento.cd_setor_atendimento%type;
cd_grupo_proc_w			grupo_proc.cd_grupo_proc%type;
cd_especialidade_w		especialidade_proc.cd_especialidade%type;
cd_area_procedimento_w	area_procedimento.cd_area_procedimento%type;
nr_seq_regra_w			regra_controle_criterio.nr_seq_regra%type;
qt_atual_w				bigint;
qt_maximo_w				bigint;
ie_existe_w				char(1) := 'N';

C01 CURSOR FOR
SELECT	a.nr_sequencia,
		a.cd_procedimento,
		a.ie_origem_proced,
		coalesce(a.cd_setor_atendimento,coalesce(b.cd_setor_entrega,b.cd_setor_atendimento)),
		c.cd_grupo_proc,
		c.cd_especialidade,
		c.cd_area_procedimento
from	estrutura_procedimento_v c,
		prescr_procedimento a,
		prescr_medica b
where	a.nr_prescricao		= nr_prescricao_p
and		a.nr_prescricao		= b.nr_prescricao
and		a.cd_procedimento	= c.cd_procedimento
and		a.ie_origem_proced	= c.ie_origem_proced
order by 1;

C02 CURSOR FOR
SELECT	a.nr_seq_regra
from	regra_controle_criterio a
where	coalesce(a.cd_setor_atendimento,cd_setor_w) = cd_setor_w
and		((coalesce(a.cd_procedimento,cd_procedimento_w) = cd_procedimento_w) or (coalesce(cd_procedimento_w::text, '') = ''))
and		((coalesce(a.ie_origem_proced,ie_origem_proced_w) = ie_origem_proced_w) or (coalesce(ie_origem_proced_w::text, '') = ''))
and		((coalesce(a.cd_grupo_proc,cd_grupo_proc_w) = cd_grupo_proc_w) or (coalesce(cd_grupo_proc_w::text, '') = ''))
and		((coalesce(a.cd_especialidade_proc,cd_especialidade_w) = cd_especialidade_w) or (coalesce(cd_especialidade_w::text, '') = ''))
and		((coalesce(a.cd_area_proc,cd_area_procedimento_w) = cd_area_procedimento_w) or (coalesce(cd_area_procedimento_w::text, '') = ''))
order by
	 coalesce(a.cd_procedimento,0),
	 coalesce(a.cd_grupo_proc,0),
	 coalesce(a.cd_especialidade_proc,0),
	 coalesce(a.cd_area_proc,0),
	 coalesce(a.cd_setor_atendimento,0);


BEGIN

select 	coalesce(max('S'),'N')
into STRICT	ie_existe_w
from	regra_controle_prescr where		coalesce(ie_integracao,'N') <> 'S' LIMIT 1;

if (ie_existe_w = 'S') then
	begin
	OPEN C01;
	LOOP
	FETCH C01 into
			nr_seq_prescricao_w,
			cd_procedimento_w,
			ie_origem_proced_w,
			cd_setor_w,
			cd_grupo_proc_w,
			cd_especialidade_w,
			cd_area_procedimento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		nr_seq_regra_w	:= 0;

		OPEN C02;
		LOOP
		FETCH C02 	into
			nr_seq_regra_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			nr_seq_regra_w	:= nr_seq_regra_w;
		END LOOP;
		close c02;

		if (nr_seq_regra_w	> 0) then
			begin
			/* busca próxima sequencia */

			select	coalesce(max(qt_atual),0) + 1,
					coalesce(max(qt_maximo),0)
			into STRICT	qt_atual_w,
					qt_maximo_w
			from	regra_controle_prescr
			where	nr_sequencia = nr_seq_regra_w
			and		coalesce(ie_integracao,'N') <> 'S';

			if (qt_maximo_w > 0) 		and (qt_atual_w > qt_maximo_w) 	then
				qt_atual_w	:= 1;
			end if;

			/* atualiza prescr procedimento */

			update	prescr_procedimento
			set		nr_controle 	= qt_atual_w
			where	nr_prescricao	= nr_prescricao_p
			and		nr_sequencia	= nr_seq_prescricao_w;

			/* atualiza controle de sequencia */

			update	regra_controle_prescr
			set		qt_atual		= qt_atual_w
			where	nr_sequencia	= nr_seq_regra_w;
			end;
		end if;
		end;
	END LOOP;
	close c01;
	end;
end if;
if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_prescr_proc_controle ( nr_prescricao_p bigint) FROM PUBLIC;
