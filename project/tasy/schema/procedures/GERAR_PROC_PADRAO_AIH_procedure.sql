-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_proc_padrao_aih ( nr_atendimento_p bigint, nr_interno_conta_p bigint, cd_setor_atendimento_p bigint, dt_entrada_unidade_p timestamp, nr_seq_interno_P bigint, nr_seq_padrao_proc_p bigint, cd_convenio_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
cd_proc_padrao_w	bigint;
ie_origem_padrao_w	bigint;	
qt_proc_padrao_w	double precision;
ie_tipo_servico_sus_w	smallint;
ie_tipo_ato_sus_w	smallint;
cd_medico_executor_w	varchar(10);
cd_cgc_prestador_w	varchar(14);
dt_alta_w		timestamp;
dt_entrada_w		timestamp;
dt_procedimento_w	timestamp;
ie_define_setor_w	smallint;
cd_setor_w		integer;
nr_seq_interno_w 	bigint;
dt_entrada_unidade_w 	timestamp;
dt_acerto_conta_w	timestamp;
cd_setor_padrao_w	integer;
qt_passagem_setor_w	bigint;
nr_sequencia_w		bigint;
cd_categoria_w		varchar(10);
ie_tipo_guia_w		varchar(1);
cd_convenio_w		integer;
nr_doc_convenio_w	varchar(20);
ie_classificacao_w	varchar(1);
cd_senha_w		varchar(20);

 

BEGIN 
 
select	cd_proc_padrao, 
	ie_origem_padrao, 
	qt_proc_padrao, 
	ie_tipo_servico_sus, 
	ie_tipo_ato_sus, 
	cd_medico_executor, 
	cd_cgc_prestador, 
	ie_define_setor, 
	cd_setor_atendimento 
into STRICT	cd_proc_padrao_w, 
	ie_origem_padrao_w,	 
	qt_proc_padrao_w, 
	ie_tipo_servico_sus_w, 
	ie_tipo_ato_sus_w, 
	cd_medico_executor_w, 
	cd_cgc_prestador_w, 
	ie_define_setor_w, 
	cd_setor_padrao_w 
from	sus_aih_padrao_proc 
where	nr_sequencia	= nr_seq_padrao_proc_p;
 
if (coalesce(cd_cgc_prestador_w::text, '') = '') then 
	begin 
	select	a.cd_cgc 
	into STRICT	cd_cgc_prestador_w	 
	from	estabelecimento		a, 
		atendimento_paciente	b 
	where	a.cd_estabelecimento 	= b.cd_estabelecimento 
	and	b.nr_atendimento 	= nr_atendimento_p;
	end;
end if;
 
select dt_alta, 
	dt_entrada 
into STRICT	dt_alta_w, 
	dt_entrada_w 
from	atendimento_paciente 
where	nr_atendimento	= nr_atendimento_p;
 
select	dt_acerto_conta 
into STRICT	dt_acerto_conta_w 
from 	conta_paciente 
where 	nr_interno_conta = nr_interno_conta_p;
 
select	nextval('procedimento_paciente_seq') 
into STRICT	nr_sequencia_w
;
 
/* Regra em relação ao domínio 1420 (SUS - Setor lançamento AIH) */
 
 
if (ie_define_setor_w = 1) then 
	begin 
	select	coalesce(cd_setor_exclusivo,cd_setor_atendimento_p) 
	into STRICT	cd_setor_w 
	from	procedimento 
	where	cd_procedimento		= cd_proc_padrao_w 
	and	ie_origem_proced	= ie_origem_padrao_w;
 
	select	count(*) 
	into STRICT	qt_passagem_setor_w 
	from	atend_paciente_unidade 
	where	nr_atendimento		= nr_atendimento_p 
	and	cd_setor_atendimento	= cd_setor_w;	
 
	if (qt_passagem_setor_w = 0) then 
		CALL gerar_passagem_setor_atend(nr_atendimento_p, 
			cd_setor_w, 
			dt_entrada_w, 
			'S', 
			nm_usuario_p);
	end if;
 
	select	a.nr_seq_interno, 
		a.dt_entrada_unidade 
	into STRICT	nr_seq_interno_w, 
		dt_entrada_unidade_w 
	from	atend_paciente_unidade	a 
	where	a.nr_seq_interno = (SELECT max(x.nr_seq_interno) 
				  from  atend_paciente_unidade	x 
	 			  where x.nr_atendimento 		= nr_atendimento_p 
				  and 	 x.cd_setor_atendimento 	= cd_setor_w);
	end;
 
elsif (ie_define_setor_w = 2) then 
	begin 
	select	a.cd_setor_atendimento,  
		a.nr_seq_interno, 
  		a.dt_entrada_unidade 
	into STRICT	cd_setor_w, 
		nr_seq_interno_w, 
		dt_entrada_unidade_w 
	from  atend_paciente_unidade	a 
	where  a.nr_seq_interno = (SELECT min(x.nr_seq_interno) 
	              from  setor_atendimento 	  s,  
					  atend_paciente_unidade x 
     	          where x.cd_setor_atendimento = s.cd_setor_atendimento 
				  and  x.nr_atendimento    = nr_atendimento_p 
				  and  s.cd_classif_setor   = 3);
	exception 
	when others then 
		CALL gerar_passagem_setor_atend(nr_atendimento_p, 
			cd_setor_atendimento_p, 
			dt_entrada_w, 
			'S', 
			nm_usuario_p);
	 
		select	a.cd_setor_atendimento,  
			a.nr_seq_interno, 
	  		a.dt_entrada_unidade 
		into STRICT	cd_setor_w, 
			nr_seq_interno_w, 
			dt_entrada_unidade_w 
		from  atend_paciente_unidade	a 
		where  a.nr_seq_interno = (SELECT max(x.nr_seq_interno) 
				  	  from  atend_paciente_unidade	x 
	 			  	  where x.nr_atendimento 		= nr_atendimento_p 
				  	  and 	 x.cd_setor_atendimento 	=  cd_setor_atendimento_p);
	end;
 
elsif (ie_define_setor_w = 3) then 
	begin 
	select	a.cd_setor_atendimento,  
		a.nr_seq_interno, 
  		a.dt_entrada_unidade 
	into STRICT	cd_setor_w, 
		nr_seq_interno_w, 
		dt_entrada_unidade_w 
	from  atend_paciente_unidade	a 
	where  a.nr_seq_interno = (SELECT max(x.nr_seq_interno) 
	              from  setor_atendimento 	  s,  
					  atend_paciente_unidade x 
     	          where x.cd_setor_atendimento = s.cd_setor_atendimento 
				  and  x.nr_atendimento    = nr_atendimento_p 
				  and  s.cd_classif_setor   = 3);
	exception 
	when others then 
		CALL gerar_passagem_setor_atend(nr_atendimento_p, 
			cd_setor_atendimento_p, 
			dt_entrada_w, 
			'S', 
			nm_usuario_p);
	 
		select	a.cd_setor_atendimento,  
			a.nr_seq_interno, 
	  		a.dt_entrada_unidade 
		into STRICT	cd_setor_w, 
			nr_seq_interno_w, 
			dt_entrada_unidade_w 
		from  atend_paciente_unidade	a 
		where  a.nr_seq_interno = (SELECT max(x.nr_seq_interno) 
				  	  from  atend_paciente_unidade	x 
	 			  	  where x.nr_atendimento 		= nr_atendimento_p 
				  	  and 	 x.cd_setor_atendimento 	=  cd_setor_atendimento_p);
	end;
 
elsif (ie_define_setor_w = 4) then 
	begin 
	select	a.cd_setor_atendimento, 
 		a.nr_seq_interno, 
   		a.dt_entrada_unidade 
	into STRICT	cd_setor_w, 
		nr_seq_interno_w, 
		dt_entrada_unidade_w 
	from  atend_paciente_unidade a 
	where  a.nr_seq_interno = 	(SELECT	max(x.nr_seq_interno) 
               		from  	atend_paciente_unidade	x 
               		where  x.nr_atendimento    = nr_atendimento_p);
	end;
 
elsif (ie_define_setor_w = 5) then 
	begin 
	if (coalesce(cd_setor_padrao_w::text, '') = '') then 
		cd_setor_W	:= cd_setor_atendimento_p;
	else 
		cd_setor_w	:= cd_setor_padrao_w;	
	end if;
 
	select	count(*) 
	into STRICT	qt_passagem_setor_w 
	from	atend_paciente_unidade 
	where	nr_atendimento		= nr_atendimento_p 
	and	cd_setor_atendimento	= cd_setor_w;	
 
	if (qt_passagem_setor_w = 0) then 
		CALL gerar_passagem_setor_atend(nr_atendimento_p, 
			cd_setor_w, 
			dt_entrada_w, 
			'S', 
			nm_usuario_p);
	end if;
 
	select	a.nr_seq_interno, 
		a.dt_entrada_unidade 
	into STRICT	nr_seq_interno_w, 
		dt_entrada_unidade_w 
	from	atend_paciente_unidade a 
	where  a.nr_seq_interno = 	(SELECT	max(x.nr_seq_interno) 
    	           		from  	atend_paciente_unidade	x 
        	       		where  x.nr_atendimento    = nr_atendimento_p 
					and	x.cd_setor_atendimento = cd_setor_w);
	end;
 
 
elsif (ie_define_setor_w = 6) then 
	begin 
	cd_setor_w		:=	cd_setor_atendimento_p;
	nr_seq_interno_w	:=	nr_seq_interno_P;
	dt_entrada_unidade_w	:=	dt_entrada_unidade_p;
	end;
 
end if;
 
if (dt_alta_w IS NOT NULL AND dt_alta_w::text <> '') then 
	dt_procedimento_w	:= dt_entrada_unidade_w;
 
else 
	dt_procedimento_w	:= clock_timestamp();
	dt_entrada_w		:= clock_timestamp();
 
end if;
 
SELECT * FROM obter_convenio_execucao(nr_atendimento_p, dt_procedimento_w, cd_convenio_w, cd_categoria_w, nr_doc_convenio_w, ie_tipo_guia_w, cd_senha_w) INTO STRICT cd_convenio_w, cd_categoria_w, nr_doc_convenio_w, ie_tipo_guia_w, cd_senha_w;
	 
insert into procedimento_paciente( 
	nr_sequencia, 
	nr_atendimento, 
	nr_interno_conta, 
	cd_setor_atendimento, 
	dt_entrada_unidade, 
	nr_seq_atepacu, 
	cd_procedimento, 
	ie_origem_proced, 
	dt_procedimento, 
	qt_procedimento, 
	ie_tipo_servico_sus, 
	ie_tipo_ato_sus, 
	cd_medico_executor, 
	cd_convenio, 
	cd_cgc_prestador, 
	cd_categoria, 
	ie_tipo_guia, 
	dt_acerto_conta, 
	ie_auditoria, 
	ie_guia_informada, 
	ie_proc_princ_atend, 
	dt_atualizacao, 
	nm_usuario, 
	cd_senha) 
values (nr_sequencia_w, 
	nr_atendimento_p, 
	nr_interno_conta_p, 
	cd_setor_w, 
	dt_entrada_unidade_w,					 
	nr_seq_interno_w, 
	cd_proc_padrao_w, 
	ie_origem_padrao_w,	 
	dt_procedimento_w, 
	qt_proc_padrao_w, 
	ie_tipo_servico_sus_w, 
	ie_tipo_ato_sus_w, 
	cd_medico_executor_w, 
	cd_convenio_p, 
	cd_cgc_prestador_w, 
	cd_categoria_w, 
	ie_tipo_guia_w, 
	dt_acerto_conta_w, 
	'N', 
	'N', 
	'N', 
	clock_timestamp(), 
	nm_usuario_p, cd_senha_w);
 
select	ie_classificacao 
into STRICT	ie_classificacao_w 
from  procedimento 
where  cd_procedimento	 = cd_proc_padrao_w 
and	ie_origem_proced = ie_origem_padrao_w;
 
if (ie_classificacao_w in (1,8)) then 
	begin 
	CALL atualiza_preco_procedimento(nr_sequencia_w, cd_convenio_p, nm_usuario_p);
	CALL Gerar_Taxa_Sala_Porte(nr_atendimento_p, dt_entrada_unidade_w, dt_procedimento_w, cd_proc_padrao_w, nr_sequencia_w, nm_usuario_p);
	end;
else	 
	CALL atualiza_preco_servico(nr_sequencia_w, nm_usuario_p);
end if;
 
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_proc_padrao_aih ( nr_atendimento_p bigint, nr_interno_conta_p bigint, cd_setor_atendimento_p bigint, dt_entrada_unidade_p timestamp, nr_seq_interno_P bigint, nr_seq_padrao_proc_p bigint, cd_convenio_p bigint, nm_usuario_p text) FROM PUBLIC;

