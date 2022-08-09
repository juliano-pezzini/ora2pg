-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE trocar_convenio_exame_lab (nr_interno_conta_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
nr_sequencia_w		bigint;
cd_convenio_w		integer;
nr_seq_exame_w		bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
ie_classificacao_w	varchar(5);
cd_edicao_amb_w		bigint;
cd_estabelecimento_w	bigint;
cd_categoria_w		varchar(10);
cd_exame_w		varchar(20);
nr_atendimento_w	bigint;

ie_tipo_atendimento_w	smallint;
ie_tipo_convenio_w	smallint;
nr_seq_proc_interno_w	bigint;
cd_setor_ret_w		bigint;
ds_erro_w		varchar(255);
nr_seq_proc_int_ret_w	bigint;
cd_plano_convenio_w	varchar(10);

c01 CURSOR FOR 
SELECT	nr_sequencia, 
	cd_convenio, 
	nr_seq_exame, 
	cd_categoria, 
	nr_atendimento, 
	nr_seq_proc_interno, 
	obter_plano_conv_atend(nr_atendimento) 
from	procedimento_paciente 
where	nr_interno_conta	= nr_interno_conta_p 
and	(nr_seq_exame IS NOT NULL AND nr_seq_exame::text <> '');

c02 CURSOR FOR 
SELECT	cd_procedimento, 
	ie_origem_proced 
from	exame_lab_convenio 
where	nr_seq_exame					= nr_seq_exame_w 
and	coalesce(cd_convenio, cd_convenio_w)			= cd_convenio_w 
and	coalesce(cd_edicao_amb, coalesce(cd_edicao_amb_w,0))	= coalesce(cd_edicao_amb_w,0) 
and 	coalesce(ie_situacao,'A')				= 'A' 
order	by DT_INICIO_VIGENCIA, 
	coalesce(cd_convenio, 0), 
	coalesce(cd_edicao_amb, 0);


BEGIN 
 
select	cd_estabelecimento 
into STRICT	cd_estabelecimento_w 
from	conta_paciente 
where	nr_interno_conta	= nr_interno_conta_p;
 
open c01;
loop 
fetch c01 into 
	nr_sequencia_w, 
	cd_convenio_w, 
	nr_seq_exame_w, 
	cd_categoria_w, 
	nr_atendimento_w, 
	nr_seq_proc_interno_w, 
	cd_plano_convenio_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
 
 
	select 	max(ie_tipo_atendimento) 
	into STRICT	ie_tipo_atendimento_w 
	from 	atendimento_paciente 
	where 	nr_atendimento = nr_atendimento_w;
	 
	select 	max(ie_tipo_convenio) 
	into STRICT	ie_tipo_convenio_w 
	from 	convenio 
	where 	cd_convenio = cd_convenio_w;
	 
	--cd_edicao_amb_w	:= OBTER_EDICAO_AMB(CD_ESTABELECIMENTO_w, CD_CONVENIO_w, CD_CATEGORIA_w, sysdate); 
	 
	select	max(cd_exame) 
	into STRICT	cd_exame_w 
	from 	exame_laboratorio 
	where 	nr_seq_exame = nr_seq_exame_w;
	 
	if (cd_exame_w IS NOT NULL AND cd_exame_w::text <> '') then 
		--Obter_Proc_Exame_Lab(cd_exame_w, nr_atendimento_w, cd_procedimento_w, ie_origem_proced_w, nr_seq_exame_w); 
		SELECT * FROM Obter_Exame_Lab_Convenio(nr_seq_exame_w, cd_convenio_w, cd_categoria_w, ie_tipo_atendimento_w, cd_estabelecimento_w, ie_tipo_convenio_w, nr_seq_proc_interno_w, null, cd_plano_convenio_w, cd_setor_ret_w, cd_procedimento_w, ie_origem_proced_w, ds_erro_w, nr_seq_proc_int_ret_w) INTO STRICT cd_setor_ret_w, cd_procedimento_w, ie_origem_proced_w, ds_erro_w, nr_seq_proc_int_ret_w;
	end if;
 
	if (coalesce(cd_procedimento_w,0) = 0) then 
		/*cd_procedimento_w	:= null; 
		ie_origem_proced_w	:= null;*/
 
		open c02;
		loop 
		fetch c02 into 
			cd_procedimento_w, 
			ie_origem_proced_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			cd_procedimento_w	:= cd_procedimento_w;
		end loop;
		close c02;		
	end if;
 
	if (coalesce(cd_procedimento_w,0) = 0) then 
 
		select	coalesce(max(a.cd_procedimento),0), 
			coalesce(max(a.ie_origem_proced),0) 
		into STRICT	cd_procedimento_w, 
			ie_origem_proced_w 
		from	exame_laboratorio a 
		where	a.nr_seq_exame		= nr_seq_exame_w;
 
	end if;
 
	if (coalesce(cd_procedimento_w,0) > 0) then 
		begin 
		update	procedimento_paciente 
		set	cd_procedimento		= cd_procedimento_w, 
			ie_origem_proced	= ie_origem_proced_w, 
			nm_usuario		= nm_usuario_p, 
			dt_atualizacao		= clock_timestamp() 
		where	nr_sequencia		= nr_sequencia_w;
 
		select	ie_classificacao 
		into STRICT	ie_classificacao_w 
		from	procedimento 
		where	cd_procedimento		= cd_procedimento_w 
		and	ie_origem_proced	= ie_origem_proced_w;
 
		CALL atualiza_preco_procedimento(nr_sequencia_w, cd_convenio_w, nm_usuario_p);
		 
		/*if	(ie_classificacao_w = 1) or (ie_classificacao_w = 3) then 
			atualiza_preco_procedimento(nr_sequencia_w, cd_convenio_w, nm_usuario_p); 
		elsif	(ie_classificacao_w = 2) then 
			atualiza_preco_servico(nr_sequencia_w, nm_usuario_p); 
		end if;*/
 
 
		end;
	end if;
 
end loop;
close c01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE trocar_convenio_exame_lab (nr_interno_conta_p bigint, nm_usuario_p text) FROM PUBLIC;
