-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_guia_proc_autor (nr_sequencia_autor_p bigint) RETURNS bigint AS $body$
DECLARE

ie_tipo_guia_tiss_w	integer;
cd_grupo_proc_w		tiss_regra_guia_proc_autor.cd_grupo_proc%type;
cd_especialidade_w	tiss_regra_guia_proc_autor.cd_especialidade%type;
cd_area_procedimento_w	tiss_regra_guia_proc_autor.cd_area_procedimento%type;
ie_origem_proced_w	tiss_regra_guia_proc_autor.ie_origem_proced%type;
nr_atendimento_w	bigint;
nr_seq_agenda_w		autorizacao_convenio.nr_seq_agenda%type;
nr_seq_agenda_consulta_w agenda_consulta.nr_sequencia%type;
ie_tipo_atendimento_w	integer;
cd_procedimento_w	procedimento_autorizado.cd_procedimento%type;
cont_w			bigint := 0;
qt_existe_regra_w	bigint := 0;
C01 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced
	from	procedimento_autorizado
	where	nr_sequencia_autor = nr_sequencia_autor_p;

C02 CURSOR FOR
	SELECT	ie_tiss_tipo_guia
	from	tiss_regra_guia_proc_autor
	where	coalesce(cd_procedimento,cd_procedimento_w) = cd_procedimento_w
	and	coalesce(cd_area_procedimento,cd_area_procedimento_w) = cd_area_procedimento_w
	and	coalesce(cd_especialidade, cd_especialidade_w)		= cd_especialidade_w
	and	coalesce(cd_grupo_proc, cd_grupo_proc_w)			= cd_grupo_proc_w
	and	((ie_origem_proced = ie_origem_proced_w) or (coalesce(ie_origem_proced::text, '') = ''))
	and	((ie_tipo_atendimento = ie_tipo_atendimento_w) or (coalesce(ie_tipo_atendimento::text, '') = ''))
	and	coalesce(ie_situacao,'A') = 'A'
	order by cd_area_procedimento,
		 cd_especialidade,
		 cd_grupo_proc,
		 ie_tipo_atendimento,
		 cd_procedimento;


BEGIN

select	count(*)
into STRICT	cont_w
from	procedimento_autorizado
where	nr_sequencia_autor = nr_sequencia_autor_p;

select	count(*)
into STRICT	qt_existe_regra_w
from	tiss_regra_guia_proc_autor
where	coalesce(ie_situacao,'A') = 'A';

if (coalesce(cont_w,0) > 0) and (coalesce(qt_existe_regra_w,0) > 0)then
	begin
	open C01;
	loop
	fetch C01 into	
		cd_procedimento_w,
		ie_origem_proced_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') then
			select	max(cd_grupo_proc),
				max(cd_especialidade),
				max(cd_area_procedimento)
			into STRICT	cd_grupo_proc_w,
				cd_especialidade_w,
				cd_area_procedimento_w
			from	estrutura_procedimento_v
			where	cd_procedimento	= cd_procedimento_w
			and	ie_origem_proced	= ie_origem_proced_w;
			
			
			select	nr_atendimento,
				nr_seq_agenda,
				nr_seq_agenda_consulta
			into STRICT	nr_atendimento_w,
				nr_seq_agenda_w,
				nr_seq_agenda_consulta_w
			from	autorizacao_convenio
			where	nr_sequencia = nr_sequencia_autor_p;
			
			if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
				select 	ie_tipo_atendimento
				into STRICT	ie_tipo_atendimento_w
				from 	atendimento_paciente
				where	nr_atendimento = nr_atendimento_w;
			elsif (nr_seq_agenda_w IS NOT NULL AND nr_seq_agenda_w::text <> '') then
				select	ie_tipo_atendimento
				into STRICT	ie_tipo_atendimento_w
				from	agenda_paciente
				where	nr_sequencia = nr_seq_agenda_w;
			elsif (nr_seq_agenda_consulta_w IS NOT NULL AND nr_seq_agenda_consulta_w::text <> '') then
				select	ie_tipo_atendimento
				into STRICT	ie_tipo_atendimento_w
				from	agenda_consulta
				where	nr_sequencia = nr_seq_agenda_consulta_w;
			end if;
			
			open C02;
			loop
			fetch C02 into	
				ie_tipo_guia_tiss_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				ie_tipo_guia_tiss_w := ie_tipo_guia_tiss_w;
				end;
			end loop;
			close C02;
			
		end if;
		end;
	end loop;
	close C01;
	end;
end if;

return	ie_tipo_guia_tiss_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_guia_proc_autor (nr_sequencia_autor_p bigint) FROM PUBLIC;
