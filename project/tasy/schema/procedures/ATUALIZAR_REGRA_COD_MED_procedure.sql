-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_regra_cod_med ( nr_seq_item_p bigint, nr_interno_conta_p bigint, cd_convenio_p bigint, nr_seq_partic_p bigint) AS $body$
DECLARE


cd_medico_convenio_w	varchar(15);
cd_cgc_prestador_w	varchar(14);
--cd_cgc_prestador_ww	varchar2(14);
cd_medico_exec_w	varchar(10);
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
cd_area_procedimento_w	bigint;
cd_especialidade_w	bigint;
cd_grupo_proc_w		bigint;
ie_prioridade_w		bigint;
cd_estabelecimento_w	smallint;
qt_regra_w		bigint := 0;
ie_funcao_medico_w	varchar(10);

C01 CURSOR FOR
	SELECT	cd_medico_convenio,
		ie_prioridade
	from	regra_medico_convenio
	where	coalesce(cd_cgc_prestador, coalesce(cd_cgc_prestador_w,'0')) = coalesce(cd_cgc_prestador_w,'0')
	and	coalesce(cd_medico_executor, coalesce(cd_medico_exec_w,0)) = coalesce(cd_medico_exec_w,0)
	and	coalesce(cd_procedimento, coalesce(cd_procedimento_w,0)) = coalesce(cd_procedimento_w,0)
	and	coalesce(ie_origem_proced, coalesce(ie_origem_proced_w,0)) = coalesce(ie_origem_proced_w,0)
	and	coalesce(cd_area_procedimento, coalesce(cd_area_procedimento_w,0)) = coalesce(cd_area_procedimento_w,0)
	and	coalesce(cd_especialidade, coalesce(cd_especialidade_w,0)) = coalesce(cd_especialidade_w,0)
	and	coalesce(cd_grupo_proc, coalesce(cd_grupo_proc_w,0)) = coalesce(cd_grupo_proc_w,0)
	and	coalesce(cd_convenio, coalesce(cd_convenio_p,0)) = coalesce(cd_convenio_p,0)
	and	coalesce(cd_estabelecimento_w, coalesce(cd_estabelecimento_w,0)) = coalesce(cd_estabelecimento_w,0)
	and	coalesce(ie_situacao,'N') = 'A'
	and	coalesce(ie_funcao_medico, coalesce(ie_funcao_medico_w,'0')) 	= coalesce(ie_funcao_medico_w,'0')
	order by	ie_prioridade desc,
		coalesce(ie_funcao_medico,'0');


BEGIN

cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;

select 	count(*)
into STRICT	qt_regra_w
from	regra_medico_convenio
where	coalesce(cd_convenio, coalesce(cd_convenio_p,0)) = coalesce(cd_convenio_p,0)
and	coalesce(cd_estabelecimento_w, coalesce(cd_estabelecimento_w,0)) = coalesce(cd_estabelecimento_w,0)
and	coalesce(ie_situacao,'N') = 'A';

if (qt_regra_w > 0) then

	if (nr_seq_partic_p = 0) then
		select	max(cd_medico_executor),
			max(cd_cgc_prestador),
			max(cd_procedimento),
			max(ie_origem_proced),
			max(ie_funcao_medico)
		into STRICT	cd_medico_exec_w,
			cd_cgc_prestador_w,
			cd_procedimento_w,
			ie_origem_proced_w,
			ie_funcao_medico_w
		from	procedimento_paciente
		where	nr_sequencia = nr_seq_item_p
		and	nr_interno_conta = nr_interno_conta_p;
	else
		select	max(b.cd_pessoa_fisica),
			max(b.cd_cgc),
			max(a.cd_procedimento),
			max(a.ie_origem_proced),
			max(b.ie_funcao)
		into STRICT	cd_medico_exec_w,
			cd_cgc_prestador_w,
			cd_procedimento_w,
			ie_origem_proced_w,
			ie_funcao_medico_w
		from	procedimento_participante b,
			procedimento_paciente a
		where	b.nr_sequencia = nr_seq_item_p
		and	a.nr_interno_conta = nr_interno_conta_p
		and	b.nr_seq_partic = nr_seq_partic_p
		and	a.nr_sequencia = b.nr_sequencia;
	end if;

	select	max(cd_area_procedimento),
		max(cd_especialidade),
		max(cd_grupo_proc)
	into STRICT	cd_area_procedimento_w,
		cd_especialidade_w,
		cd_grupo_proc_w
	from	estrutura_procedimento_v
	where	cd_procedimento 	= cd_procedimento_w
	and	ie_origem_proced	= ie_origem_proced_w;

	/*
	select	max(cd_cgc_prestador)
	into	cd_cgc_prestador_ww
	from	material_atend_paciente
	where	nr_sequencia = nr_seq_item_p
	and	nr_interno_conta = nr_interno_conta_p;
	*/
	open C01;
	loop
	fetch C01 into
		cd_medico_convenio_w,
		ie_prioridade_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (nr_seq_partic_p = 0) then
			update	procedimento_paciente
			set	cd_medico_convenio 	= cd_medico_convenio_w
			where	nr_sequencia		= nr_seq_item_p
			and	nr_interno_conta	= nr_interno_conta_p;
		else
			update	procedimento_participante
			set	cd_medico_convenio 	= cd_medico_convenio_w
			where	nr_sequencia		= nr_seq_item_p
			and	nr_seq_partic		= nr_seq_partic_p;
		end if;

		--if (nvl(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if; tbschulz - retirado commit foi é chamado na trigger da result_laboratorio
		end;
	end loop;
	close C01;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_regra_cod_med ( nr_seq_item_p bigint, nr_interno_conta_p bigint, cd_convenio_p bigint, nr_seq_partic_p bigint) FROM PUBLIC;

