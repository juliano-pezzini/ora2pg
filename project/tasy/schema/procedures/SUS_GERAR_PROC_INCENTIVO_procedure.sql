-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gerar_proc_incentivo ( nr_aih_p bigint, nr_seq_aih_p bigint, cd_procedimento_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_interno_conta_w	bigint;
nr_atendimento_w	bigint;
nr_prenatal_w		bigint;
nr_sequencia_w		bigint;
nr_sequencia_ww		bigint;
qt_reg_w		integer	:= 0;
cd_setor_atend_w	integer;
cd_setor_atendimento_w	integer;
cd_estabelecimento_w	smallint;
dt_procedimento_w	timestamp;	



BEGIN

/* Buscar a conta e o numero da gestante da AIH */

select	coalesce(max(nr_interno_conta),0),
	coalesce(max(nr_atendimento),0),
	coalesce(max(nr_gestante_prenatal),0),
	coalesce(max(cd_estabelecimento_w),0)
into STRICT	nr_interno_conta_w,
	nr_atendimento_w,
	nr_prenatal_w,
	cd_estabelecimento_w
from	sus_aih_unif
where	nr_aih		= nr_aih_p
and	nr_sequencia	= nr_seq_aih_p;

cd_setor_atendimento_w := obter_param_usuario(1123, 86, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, cd_setor_atendimento_w);

/* Verifica se possui algum procedimento de parto lancado na conta */

select	coalesce(min(nr_sequencia),0)
into STRICT	nr_sequencia_w
from	procedimento_paciente
where	nr_interno_conta	= nr_interno_conta_w
and	ie_origem_proced	= 7
and	sus_validar_regra(2, cd_procedimento, ie_origem_proced,dt_procedimento) > 0;

/* Verifica se já existe o procedimento de incentivo na conta */

select	count(*)
into STRICT	qt_reg_w
from	procedimento_paciente
where	nr_interno_conta	= nr_interno_conta_w
and	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced	= 7;

if (nr_sequencia_w	> 0) and (qt_reg_w	= 0) and (nr_prenatal_w	> 0) then
	nr_sequencia_ww := Duplicar_proc_paciente(nr_sequencia_w, nm_usuario_p, nr_sequencia_ww);
	
	select	coalesce(max(cd_setor_atendimento),0),
		coalesce(max(dt_procedimento),clock_timestamp())
	into STRICT	cd_setor_atend_w,
		dt_procedimento_w
	from	procedimento_paciente
	where	nr_sequencia = nr_sequencia_ww;
	
	if (coalesce(cd_setor_atendimento_w,0) <> 0) and (cd_setor_atendimento_w <> cd_setor_atend_w) then
		begin
		CALL Gerar_Passagem_Setor_Atend(nr_atendimento_w,cd_setor_atendimento_w,dt_procedimento_w,'N',nm_usuario_p);
		update	procedimento_paciente
		set	cd_procedimento		= cd_procedimento_p,
			cd_medico_executor	 = NULL,
			cd_setor_atendimento	= cd_setor_atendimento_w,
			dt_procedimento		= dt_procedimento_w
		where	nr_sequencia		= nr_sequencia_ww;
		end;
	else
		begin
		update	procedimento_paciente
		set	cd_procedimento		= cd_procedimento_p,
			cd_medico_executor	 = NULL
		where	nr_sequencia		= nr_sequencia_ww;
		end;
	end if;
	CALL sus_atualiza_valor_proc(nr_sequencia_ww, nm_usuario_p);
end if;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gerar_proc_incentivo ( nr_aih_p bigint, nr_seq_aih_p bigint, cd_procedimento_p bigint, nm_usuario_p text) FROM PUBLIC;

