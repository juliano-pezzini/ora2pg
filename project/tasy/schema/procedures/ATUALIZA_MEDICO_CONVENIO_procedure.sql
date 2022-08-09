-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_medico_convenio ( nr_interno_conta_p bigint) AS $body$
DECLARE

 
nr_sequencia_w		bigint;
cd_estabelecimento_w	smallint;
cd_convenio_w		integer;
cd_categoria_w		varchar(10);
cd_especialidade_w	integer;
cd_cgc_prestador_w	varchar(14);
cd_setor_atendimento_w	integer;
cd_medico_executor_w	varchar(10);
cd_medico_convenio_w	varchar(15);
nr_seq_participante_w	bigint;
dt_procedimento_w	timestamp;
ie_funcao_medico_w	varchar(10);
ie_carater_inter_sus_w	varchar(2);

c01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		b.cd_estabelecimento, 
		a.cd_especialidade, 
		a.cd_convenio, 
		a.cd_categoria, 
		a.cd_cgc_prestador, 
		a.cd_setor_atendimento, 
		a.cd_medico_executor, 
		a.dt_procedimento, 
		a.ie_funcao_medico, 
		substr(obter_carater_atend(b.nr_atendimento),1,2) 
	from	procedimento_paciente a, 
		conta_paciente b 
	where	a.nr_interno_conta	= b.nr_interno_conta 
	and	b.nr_interno_conta	= nr_interno_conta_p 
	and	coalesce(a.cd_motivo_exc_conta::text, '') = '';

c02 CURSOR FOR 
	SELECT	nr_seq_partic, 
		cd_especialidade, 
		cd_pessoa_fisica 
	from	procedimento_participante 
	where	nr_sequencia	= nr_sequencia_w;

BEGIN
 
open c01;
loop 
fetch c01 into	 
	nr_sequencia_w, 
	cd_estabelecimento_w, 
	cd_especialidade_w, 
	cd_convenio_w, 
	cd_categoria_w, 
	cd_cgc_prestador_w, 
	cd_setor_atendimento_w, 
	cd_medico_executor_w, 
	dt_procedimento_w, 
	ie_funcao_medico_w, 
	ie_carater_inter_sus_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	cd_medico_convenio_w	:= obter_medico_convenio(	cd_estabelecimento_w, 
								cd_medico_executor_w, 
								cd_convenio_w, 
								cd_cgc_prestador_w, 
								cd_especialidade_w, 
								cd_categoria_w, 
								cd_setor_atendimento_w, 
								dt_procedimento_w, 
								null, 
								ie_funcao_medico_w, 
								ie_carater_inter_sus_w);
	if (cd_medico_convenio_w IS NOT NULL AND cd_medico_convenio_w::text <> '') then 
		update	procedimento_paciente 
		set	cd_medico_convenio	= coalesce(cd_medico_convenio_w,cd_medico_convenio) 
		where	nr_sequencia		= nr_sequencia_w;
	end if;
	 
	CALL atualizar_regra_cod_med(nr_sequencia_w,nr_interno_conta_p, cd_convenio_w, 0);
	 
	open c02;
	loop 
	fetch c02 into	 
		nr_seq_participante_w, 
		cd_especialidade_w, 
		cd_medico_executor_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin 
		cd_medico_convenio_w	:= obter_medico_convenio(	cd_estabelecimento_w, 
									cd_medico_executor_w, 
									cd_convenio_w, 
									cd_cgc_prestador_w, 
									cd_especialidade_w, 
									cd_categoria_w, 
									cd_setor_atendimento_w, 
									dt_procedimento_w, 
									null, 
									ie_funcao_medico_w, 
									ie_carater_inter_sus_w);
			if (cd_medico_convenio_w IS NOT NULL AND cd_medico_convenio_w::text <> '') then 
				update	procedimento_participante 
				set	cd_medico_convenio	= coalesce(cd_medico_convenio_w,cd_medico_convenio) 
				where	nr_sequencia		= nr_sequencia_w 
				and	nr_seq_partic		= nr_seq_participante_w;
			end if;
		end;
		 
		CALL atualizar_regra_cod_med(nr_sequencia_w,nr_interno_conta_p, cd_convenio_w, nr_seq_participante_w);
		 
	end loop;
	close c02;
	 
	end;
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_medico_convenio ( nr_interno_conta_p bigint) FROM PUBLIC;
