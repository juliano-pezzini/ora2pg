-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_proced_repasse_valido (nr_interno_conta_p bigint, nr_seq_criterio_p bigint, nr_seq_proc_princ_p bigint, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
qt_proced_w		integer;
ie_criterio_valido_w	varchar(1);

cd_area_proc_regra_w           mat_criterio_rep_proc.cd_area_procedimento%type;
cd_especialidade_regra_w     mat_criterio_rep_proc.cd_especialidade_proc%type;
cd_grupo_regra_w                  mat_criterio_rep_proc.cd_grupo_proc%type;
ie_proc_princ_w		varchar(255);
cd_medico_executor_w	varchar(255);
nr_atendimento_w	bigint;

/*
'S' - Critério Válido
'N' - Critério inválido
*/
c01 CURSOR FOR
	SELECT 	cd_procedimento,
		ie_origem_proced,
		cd_area_procedimento,
		cd_especialidade_proc,
		cd_grupo_proc,
		coalesce(ie_proc_princ, 'N'),
		cd_medico_executor
	from	mat_criterio_rep_proc
	where	nr_seq_criterio = nr_seq_criterio_p;

BEGIN

ie_criterio_valido_w	:= 'S';

OPEN C01;
LOOP
FETCH C01 into
	cd_procedimento_w,
	ie_origem_proced_w,
	cd_area_proc_regra_w,
	cd_especialidade_regra_w,
	cd_grupo_regra_w,
	ie_proc_princ_w,
	cd_medico_executor_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ie_criterio_valido_w	:= 'S';
	if (ie_criterio_valido_w = 'S') then

		if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') and (ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '') then
			
			select 	count(*)
			into STRICT	qt_proced_w
			from 	procedimento_paciente
			where	cd_procedimento	 	= cd_procedimento_w
			and	ie_origem_proced		= ie_origem_proced_w
			and	nr_atendimento		= nr_atendimento_p
			and	coalesce(cd_motivo_exc_conta::text, '') = ''
			and	nr_sequencia		= CASE WHEN ie_proc_princ_w='S' THEN  nr_seq_proc_princ_p  ELSE nr_sequencia END
			and	coalesce(cd_medico_executor, 'X')	= coalesce(cd_medico_executor_w, coalesce(cd_medico_executor, 'X'));
			
			if (qt_proced_w = 0) then
				ie_criterio_valido_w := 'N';
			end if;
		else
			select 	count(*)
			into STRICT	qt_proced_w
			from 	estrutura_procedimento_v b,
				procedimento_paciente a
			where	a.cd_procedimento		= b.cd_procedimento
			and	a.ie_origem_proced	= b.ie_origem_proced
			and	a.nr_atendimento		= nr_atendimento_p
			and	coalesce(cd_area_proc_regra_w,b.cd_area_procedimento)	= b.cd_area_procedimento
			and	coalesce(cd_especialidade_regra_w,b.cd_especialidade)	= b.cd_especialidade
			and	coalesce(cd_grupo_regra_w,b.cd_grupo_proc)		= b.cd_grupo_proc
			and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
			and	a.nr_sequencia					= CASE WHEN ie_proc_princ_w='S' THEN  nr_seq_proc_princ_p  ELSE a.nr_sequencia END
			and	coalesce(cd_medico_executor, 'X')	= coalesce(cd_medico_executor_w, coalesce(cd_medico_executor, 'X'));

			if (qt_proced_w = 0) then
				ie_criterio_valido_w := 'N';
			end if;
		end if;
		
		if (ie_criterio_valido_w = 'S') then
			exit;
		end if;
	end if;

	end;
END LOOP;
CLOSE C01;

return ie_criterio_valido_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_proced_repasse_valido (nr_interno_conta_p bigint, nr_seq_criterio_p bigint, nr_seq_proc_princ_p bigint, nr_atendimento_p bigint) FROM PUBLIC;
