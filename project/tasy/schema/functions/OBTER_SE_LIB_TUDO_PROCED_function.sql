-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_lib_tudo_proced (nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE



ie_liberar_tudo_w		varchar(1) := 'N';
ie_cursor_N_w			varchar(1);
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
ie_tipo_atendimento_w		bigint;
nr_seq_proc_interno_w		bigint;
cd_setor_atendimento_w		bigint;

c01 CURSOR FOR
SELECT	ie_liberar_tudo
from	regra_proced_liberacao
where	((coalesce(cd_procedimento::text, '') = '') or (cd_procedimento = cd_procedimento_w))
and	((coalesce(cd_area_procedimento::text, '') = '') or (cd_area_procedimento = obter_area_procedimento(cd_procedimento_w, ie_origem_proced_w)))
and	((coalesce(cd_especialidade::text, '') = '') or (cd_especialidade = Obter_Especialidade_Proced(cd_procedimento_w, ie_origem_proced_w)))
and	((coalesce(cd_grupo_proc::text, '') = '') or (cd_grupo_proc = obter_grupo_procedimento(cd_procedimento_w, ie_origem_proced_w, 'C')))
and	((coalesce(nr_seq_proc_interno::text, '') = '') or (nr_seq_proc_interno = nr_seq_proc_interno_w))
and	((coalesce(ie_tipo_atendimento::text, '') = '') or (ie_tipo_atendimento = ie_tipo_atendimento_w))
and	((coalesce(cd_setor_atendimento::text, '') = '') or (cd_setor_atendimento = cd_setor_atendimento_w))
order by coalesce(NR_SEQ_PRIORIDADE,999) desc,
	 cd_area_procedimento,
	 cd_especialidade,
	 cd_grupo_proc,
	 cd_procedimento;

c02 CURSOR FOR
SELECT	cd_procedimento,
	ie_origem_proced,
	nr_seq_proc_interno
from	prescr_procedimento
where	nr_prescricao	= nr_prescricao_p;


BEGIN

select	max(ie_tipo_atendimento),
	max(a.cd_setor_atendimento)
into STRICT	ie_tipo_atendimento_w,
	cd_setor_atendimento_w
from	prescr_medica a,
	atendimento_paciente b
where	a.nr_atendimento = b.nr_atendimento
and	a.nr_prescricao = nr_prescricao_p;

open C02;
loop
fetch C02 into
	cd_procedimento_w,
	ie_origem_proced_w,
	nr_seq_proc_interno_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
		open C01;
		loop
		fetch C01 into
			ie_liberar_tudo_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			ie_liberar_tudo_w	:= ie_liberar_tudo_w;
			if (ie_liberar_tudo_w = 'N') then
				ie_cursor_N_w	:= 'S';
			end if;
		end loop;
		close C01;
end loop;
close C02;

if (ie_cursor_N_w = 'S') then
	ie_liberar_tudo_w	:= 'N';
end if;

return	ie_liberar_tudo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_lib_tudo_proced (nr_prescricao_p bigint) FROM PUBLIC;
