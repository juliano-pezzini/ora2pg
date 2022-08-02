-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_obter_se_gera_cid ( nr_interno_conta_p bigint, nr_seq_protocolo_p text, ie_tiss_tipo_guia_p text, ie_envio_p INOUT text, nm_usuario_p text) AS $body$
DECLARE


cd_procedimento_w		bigint;
cd_estabelecimento_w		bigint;
ie_origem_proced_w		bigint;
cd_grupo_proc_w			bigint;
cd_especialidade_w		bigint;
cd_area_procedimento_w		bigint;
cd_convenio_w			bigint;
cd_setor_atendimento_w		bigint;
ie_gera_cid_w			varchar(10);
nr_interno_conta_w			bigint;
nr_protocolo_w			varchar(255);

c01 CURSOR FOR
SELECT	a.cd_procedimento,
	a.ie_origem_proced,
	b.cd_estabelecimento,
	b.cd_convenio_parametro,
	a.cd_setor_atendimento
from	conta_paciente b,
	procedimento_paciente a
where	a.nr_interno_conta	= b.nr_interno_conta
and	a.nr_interno_conta	= coalesce(nr_interno_conta_w, nr_interno_conta_p)
and	ie_tiss_tipo_guia	= ie_tiss_tipo_guia_p;

c02 CURSOR FOR
SELECT	'N'
from	tiss_regra_cid
where	cd_estabelecimento					= cd_estabelecimento_w
and	coalesce(cd_area_procedimento, cd_area_procedimento_w)	= cd_area_procedimento_w
and	coalesce(cd_especialidade, cd_especialidade_w)		= cd_especialidade_w
and	coalesce(cd_grupo_proc, cd_grupo_proc_w)			= cd_grupo_proc_w
and	coalesce(cd_procedimento, cd_procedimento_w)		= cd_procedimento_w
and	coalesce(cd_convenio, cd_convenio_w)			= cd_convenio_w
and	coalesce(cd_setor_entrada, cd_setor_atendimento_w)		= cd_setor_atendimento_w
and	coalesce(ie_tiss_tipo_guia, ie_tiss_tipo_guia_p)		= ie_tiss_tipo_guia_p
and	((ie_origem_proced	= ie_origem_proced_w)
	 or (coalesce(ie_origem_proced::text, '') = ''))
and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp() - interval '1 days') and coalesce(dt_fim_vigencia, clock_timestamp() + interval '1 days')
order by coalesce(cd_procedimento, 0),
	coalesce(cd_grupo_proc, 0),
	coalesce(cd_especialidade, 0),
	coalesce(cd_area_procedimento, 0),
	coalesce(cd_convenio, 0),
	coalesce(cd_setor_entrada, 0),
	coalesce(ie_tiss_tipo_guia, 0),
	dt_inicio_vigencia;

c03 CURSOR FOR
SELECT	a.nr_interno_conta
from	conta_paciente a
where	a.nr_seq_protocolo	= nr_seq_protocolo_p
and	coalesce(nr_interno_conta_p::text, '') = ''

union

select	nr_interno_conta_p

where	coalesce(nr_seq_protocolo_p::text, '') = '';


BEGIN

/*select	max(nr_protocolo)
into	nr_protocolo_w
from	protocolo_convenio
where	nr_Seq_protocolo					= nr_seq_protocolo_p;*/
ie_gera_cid_w	:= 'S';

open c03;
loop
fetch c03 into
	nr_interno_conta_w;
EXIT WHEN NOT FOUND; /* apply on c03 */

	open c01;
	loop
	fetch c01 into
		cd_procedimento_w,
		ie_origem_proced_w,
		cd_estabelecimento_w,
		cd_convenio_w,
		cd_setor_atendimento_w;
	EXIT WHEN NOT FOUND or ie_gera_cid_w = 'N';  /* apply on c01 */

		select	max(cd_grupo_proc),
			max(cd_especialidade),
			max(cd_area_procedimento)
		into STRICT	cd_grupo_proc_w,
			cd_especialidade_w,
			cd_area_procedimento_w
		from	estrutura_procedimento_v
		where	cd_procedimento	= cd_procedimento_w
		and	ie_origem_proced	= ie_origem_proced_w;

		open c02;
		loop
		fetch c02 into
			ie_gera_cid_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
		end loop;
		close c02;

	end loop;
	close c01;

end loop;
close c03;

ie_envio_p	:= ie_gera_cid_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_obter_se_gera_cid ( nr_interno_conta_p bigint, nr_seq_protocolo_p text, ie_tiss_tipo_guia_p text, ie_envio_p INOUT text, nm_usuario_p text) FROM PUBLIC;

