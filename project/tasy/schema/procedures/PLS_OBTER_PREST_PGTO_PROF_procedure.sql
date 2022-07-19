-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_prest_pgto_prof ( nr_seq_prestador_p bigint, cd_profissional_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, nm_usuario_p text, nr_seq_grupo_serv_p bigint, dt_referencia_p timestamp, nr_seq_prestador_pgto_p INOUT bigint, nr_seq_regra_p INOUT bigint) AS $body$
DECLARE


ie_liberado_w			varchar(1)	:= 'N';
ie_liberado_ww			varchar(1);
cd_area_procedimento_w		bigint;
cd_especialidade_w		bigint;
cd_grupo_proc_w			bigint;
cd_procedimento_prest_w		bigint;
cd_especialidade_prest_w	bigint;
cd_grupo_proc_prest_w		bigint;
cd_area_procedimento_prest_w	bigint;
nr_seq_regra_w			bigint;
nr_seq_profissional_w		bigint;
nr_seq_prestador_pgto_w		bigint;
ie_origem_proced_w		bigint;
nr_seq_grupo_serv_w		bigint;
nr_seq_grupo_serv_ww		bigint;
nr_seq_prestador_pgto_ww	bigint;
nr_seq_regra_ww			bigint;
nr_seq_grupo_serv_prest_w	bigint;
ie_cooperado_w			varchar(1) := 'S';
qt_regra_w			integer;

C01 CURSOR FOR
	SELECT	nr_seq_prestador_pgto,
		nr_sequencia,
		coalesce(ie_liberado,'S'),
		coalesce(nr_seq_grupo_serv,0) nr_seq_grupo_serv,
		coalesce(cd_area_procedimento,0) cd_area_procedimento,
		coalesce(cd_especialidade,0) cd_especialidade,
		coalesce(cd_grupo_proc,0) cd_grupo_proc,
		coalesce(cd_procedimento,0) cd_procedimento
	from	pls_prestador_prof_pgto
	where	nr_seq_profissional	= nr_seq_profissional_w
	and	((coalesce(cd_procedimento::text, '') = '') or ( cd_procedimento 	= cd_procedimento_p AND ie_origem_proced = ie_origem_proced_w))
	and	((coalesce(cd_grupo_proc::text, '') = '') or (cd_grupo_proc	= cd_grupo_proc_w))
	and	((coalesce(cd_especialidade::text, '') = '') or (cd_especialidade	= cd_especialidade_w))
	and	((coalesce(cd_area_procedimento::text, '') = '') or (cd_area_procedimento =cd_area_procedimento_w))
	and	((coalesce(nr_seq_grupo_serv::text, '') = '') or (exists (SELECT	1
							from	table(pls_grupos_pck.obter_procs_grupo_servico(nr_seq_grupo_serv, ie_origem_proced_p, cd_procedimento_p)) grupo)))
	and	ie_situacao		= 'A'
	and (dt_referencia_p between dt_inicio_vigencia_ref and fim_dia(dt_fim_vigencia_ref))
	
union all

	select	nr_seq_prestador_pgto,
		nr_sequencia,
		coalesce(ie_liberado,'S'),
		coalesce(nr_seq_grupo_serv,0) nr_seq_grupo_serv,
		coalesce(cd_area_procedimento,0) cd_area_procedimento,
		coalesce(cd_especialidade,0) cd_especialidade,
		coalesce(cd_grupo_proc,0) cd_grupo_proc,
		coalesce(cd_procedimento,0) cd_procedimento
	from	pls_prestador_prof_pgto
	where	nr_seq_prestador	= nr_seq_prestador_p
	and	((coalesce(cd_procedimento::text, '') = '') or ( cd_procedimento 	= cd_procedimento_p AND ie_origem_proced = ie_origem_proced_w))
	and	((coalesce(cd_grupo_proc::text, '') = '') or (cd_grupo_proc	= cd_grupo_proc_w))
	and	((coalesce(cd_especialidade::text, '') = '') or (cd_especialidade	= cd_especialidade_w))
	and	((coalesce(cd_area_procedimento::text, '') = '') or (cd_area_procedimento =cd_area_procedimento_w))
	and	((coalesce(nr_seq_grupo_serv::text, '') = '') or (exists (select	1
							from	table(pls_grupos_pck.obter_procs_grupo_servico(nr_seq_grupo_serv, ie_origem_proced_p, cd_procedimento_p)) grupo)))
	and	ie_situacao		= 'A'
	and (dt_referencia_p between dt_inicio_vigencia_ref and fim_dia(dt_fim_vigencia_ref))
	order by
		cd_procedimento,
		cd_grupo_proc,
		cd_especialidade,
		cd_area_procedimento,
		nr_seq_grupo_serv;

C02 CURSOR FOR
	SELECT	nr_seq_prestador_pgto,
		nr_sequencia,
		coalesce(ie_liberado,'S'),
		coalesce(nr_seq_grupo_serv,0) nr_seq_grupo_serv,
		coalesce(cd_area_procedimento,0) cd_area_procedimento,
		coalesce(cd_especialidade,0) cd_especialidade,
		coalesce(cd_grupo_proc,0) cd_grupo_proc,
		coalesce(cd_procedimento,0) cd_procedimento
	from	pls_prestador_prof_pgto
	where	nr_seq_profissional	= nr_seq_profissional_w
	and	((coalesce(cd_procedimento::text, '') = '') or ( cd_procedimento 	= cd_procedimento_p AND ie_origem_proced = ie_origem_proced_w))
	and	((coalesce(cd_grupo_proc::text, '') = '') or (cd_grupo_proc	= cd_grupo_proc_w))
	and	((coalesce(cd_especialidade::text, '') = '') or (cd_especialidade	= cd_especialidade_w))
	and	((coalesce(cd_area_procedimento::text, '') = '') or (cd_area_procedimento =cd_area_procedimento_w))
	and	((coalesce(nr_seq_grupo_serv::text, '') = '') or (exists (SELECT	1
								 from	pls_grupo_servico_tm grupo
								 where	grupo.nr_seq_grupo_servico = nr_seq_grupo_serv
								 and	grupo.ie_origem_proced = ie_origem_proced_p
								 and	grupo.cd_procedimento = cd_procedimento_p)))
	and	ie_situacao		= 'A'
	and (dt_referencia_p between dt_inicio_vigencia_ref and fim_dia(dt_fim_vigencia_ref))
	
union all

	select	nr_seq_prestador_pgto,
		nr_sequencia,
		coalesce(ie_liberado,'S'),
		coalesce(nr_seq_grupo_serv,0) nr_seq_grupo_serv,
		coalesce(cd_area_procedimento,0) cd_area_procedimento,
		coalesce(cd_especialidade,0) cd_especialidade,
		coalesce(cd_grupo_proc,0) cd_grupo_proc,
		coalesce(cd_procedimento,0) cd_procedimento
	from	pls_prestador_prof_pgto
	where	nr_seq_prestador	= nr_seq_prestador_p
	and	((coalesce(cd_procedimento::text, '') = '') or ( cd_procedimento 	= cd_procedimento_p AND ie_origem_proced = ie_origem_proced_w))
	and	((coalesce(cd_grupo_proc::text, '') = '') or (cd_grupo_proc	= cd_grupo_proc_w))
	and	((coalesce(cd_especialidade::text, '') = '') or (cd_especialidade	= cd_especialidade_w))
	and	((coalesce(cd_area_procedimento::text, '') = '') or (cd_area_procedimento =cd_area_procedimento_w))
	and	((coalesce(nr_seq_grupo_serv::text, '') = '') or (exists (select	1
								 from	pls_grupo_servico_tm grupo
								 where	grupo.nr_seq_grupo_servico = nr_seq_grupo_serv
								 and	grupo.ie_origem_proced = ie_origem_proced_p
								 and	grupo.cd_procedimento = cd_procedimento_p)))
	and	ie_situacao		= 'A'
	and (dt_referencia_p between dt_inicio_vigencia_ref and fim_dia(dt_fim_vigencia_ref))
	order by
		cd_procedimento,
		cd_grupo_proc,
		cd_especialidade,
		cd_area_procedimento,
		nr_seq_grupo_serv;


BEGIN

select 	count(1)
into STRICT	qt_regra_w
from 	pls_prestador_prof_pgto
where	ie_situacao	= 'A';

if (qt_regra_w	> 0) then
	SELECT * FROM pls_obter_estrut_proc(cd_procedimento_p, ie_origem_proced_p, cd_area_procedimento_w, cd_especialidade_w, cd_grupo_proc_w, ie_origem_proced_w) INTO STRICT cd_area_procedimento_w, cd_especialidade_w, cd_grupo_proc_w, ie_origem_proced_w;

	select	max(a.nr_sequencia)
	into STRICT	nr_seq_profissional_w
	from	pls_prestador_medico	a
	where	a.nr_seq_prestador	= nr_seq_prestador_p
	and	a.cd_medico		= cd_profissional_p
	and	trunc(coalesce(dt_referencia_p,clock_timestamp()),'dd') between trunc(coalesce(a.dt_inclusao,coalesce(dt_referencia_p,clock_timestamp())),'dd') and  fim_dia(coalesce(a.dt_exclusao,coalesce(dt_referencia_p,clock_timestamp())));

	if (pls_util_cta_pck.usar_novo_agrup = 'S') then

		open C02;
		loop
		fetch C02 into
			nr_seq_prestador_pgto_w,
			nr_seq_regra_w,
			ie_liberado_w,
			nr_seq_grupo_serv_prest_w,
			cd_area_procedimento_prest_w,
			cd_especialidade_prest_w,
			cd_grupo_proc_prest_w,
			cd_procedimento_prest_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			if (ie_liberado_w = 'S') then
				nr_seq_prestador_pgto_ww	:= nr_seq_prestador_pgto_w;
				nr_seq_regra_ww			:= nr_seq_regra_w;
			else
				nr_seq_prestador_pgto_ww	:= null;
				nr_seq_regra_ww			:= null;
			end if;
			end;
		end loop;
		close C02;
	else
		open C01;
		loop
		fetch C01 into
			nr_seq_prestador_pgto_w,
			nr_seq_regra_w,
			ie_liberado_w,
			nr_seq_grupo_serv_prest_w,
			cd_area_procedimento_prest_w,
			cd_especialidade_prest_w,
			cd_grupo_proc_prest_w,
			cd_procedimento_prest_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			if (ie_liberado_w = 'S') then
				nr_seq_prestador_pgto_ww	:= nr_seq_prestador_pgto_w;
				nr_seq_regra_ww			:= nr_seq_regra_w;
			else
				nr_seq_prestador_pgto_ww	:= null;
				nr_seq_regra_ww			:= null;
			end if;
			end;
		end loop;
		close C01;
	end if;
end if;

nr_seq_prestador_pgto_p	:= nr_seq_prestador_pgto_ww;
nr_seq_regra_p		:= nr_seq_regra_ww;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_prest_pgto_prof ( nr_seq_prestador_p bigint, cd_profissional_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, nm_usuario_p text, nr_seq_grupo_serv_p bigint, dt_referencia_p timestamp, nr_seq_prestador_pgto_p INOUT bigint, nr_seq_regra_p INOUT bigint) FROM PUBLIC;

