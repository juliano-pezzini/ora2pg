-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rxt_inserir_proced_fat ( nr_seq_tratamento_p bigint, nm_usuario_p text, nr_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, nr_seq_agenda_rxt_p bigint, cd_procedimento_p bigint, ie_origem_proceD_p bigint, nr_seq_proc_interno_p bigint, ie_tipo_lancamento_p text ) AS $body$
DECLARE

 
nr_seq_protocolo_w	bigint;
nr_sequencia_proc_w	bigint;				
cd_procedimento_w  	bigint 	:= 0;
ie_origem_proced_w  	smallint 	:= null;
nr_seq_proc_pac_w 	bigint 	:= 0;
nr_atendimento_w 	bigint 	:= 0;
nr_seq_atepacu_w 	bigint 	:= 0;
nr_seq_proc_interno_w 	bigint 	:= 0;
cd_convenio_w  	bigint 	:= 0;
cd_categoria_w		bigint 	:= 0;
cd_pessoa_fisica_w	bigint 	:= 0;
dt_ent_unidade_w	timestamp 		:= clock_timestamp();
cd_local_estoque_w	bigint;
ds_erro_w		varchar(255);
qt_registros_w		bigint;
cd_doenca_cid_w		varchar(10);
ie_gerar_w		varchar(1);
qt_cid_w		bigint;
qt_agenda_rxt_w		bigint;
nr_seq_tumor_w		bigint;
cd_medico_w		varchar(10);
ie_tipo_atendimento_w	integer;
ie_medico_executor_w	varchar(30);
cd_cgc_prestador_w	varchar(14);
cd_cgc_consistido_w	varchar(14);
cd_medico_regra_w	varchar(10);
cd_profissional_w	varchar(10);
nr_seq_classificacao_w	bigint;


BEGIN 
 
cd_procedimento_w	:= cd_procedimento_p;
ie_origem_proced_w	:= ie_origem_proced_p;
nr_seq_proc_interno_w	:= nr_seq_proc_interno_p;
 
 
if 	(nr_atendimento_p <> '0' AND nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
		 
	select 	max(obter_convenio_Atendimento(a.nr_atendimento)), 
		max(obter_dados_categ_conv(a.nr_atendimento,'CA')), 
		max(a.cd_pessoa_fisica), 
		max(a.ie_tipo_atendimento), 
		max(obter_cgc_estabelecimento(a.cd_estabelecimento)), 
		max(obter_classif_atendimento(a.nr_atendimento)) 
	into STRICT 	cd_convenio_w, 
		cd_categoria_w, 
		cd_pessoa_fisica_w, 
		ie_tipo_atendimento_w, 
		cd_cgc_prestador_w, 
		nr_seq_classificacao_w 
	from 	atendimento_paciente a 
	where 	a.nr_atendimento = nr_atendimento_p;
	 
	-- NR_SEQ_ATEPACU -- obtem data entrada unidade do atendimento quando setor for igual ao do usuario no momento da dialise 
	select 	max(w.dt_entrada_unidade) 
	into STRICT	dt_ent_unidade_w 
	from  	atend_paciente_unidade w 
	where 	w.nr_atendimento 		= nr_atendimento_p 
	and  	w.cd_setor_atendimento 		= cd_setor_atendimento_p;
 
		BEGIN 
		select	max(a.nr_seq_interno) 
		into STRICT	nr_seq_atepacu_w 
		from 	atend_paciente_unidade a 
		where 	a.cd_setor_atendimento		= cd_setor_atendimento_p 
		and	a.nr_atendimento 		= nr_atendimento_p 
		and	trunc(a.dt_entrada_unidade) 	= trunc(dt_ent_unidade_w);
		EXCEPTION 
		WHEN others then 
			nr_seq_atepacu_w := 0;
		END;
 
	IF coalesce(dt_ent_unidade_w::text, '') = '' then 
		dt_ent_unidade_w := clock_timestamp(); --data entrada unidade, se tiver null eh pq nao teve passagem, atribui sysdate neste caso. 
	END IF;
 
	--Se não possuir passagem naquele setor / atendimento, é preciso gerar passagem, se precisar gerar passagem e não possuir NR_ATENDIMENTO, não será possivel gerar passagem, 
	--neste caso a procedure vai ter q abortar 
 
	IF ((nr_atendimento_p = '0') or (coalesce(nr_atendimento_p::text, '') = '')) then 
		--ds_erro_w := 'Para inserir o procedimento automaticamente na conta é necessário existir o número do atendimento '||chr(13); 
		ds_erro_w := wheb_mensagem_pck.get_texto(299021);
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(191446);
	END IF;
 
	--se nao achar passagem setor, gera passagem. 
	IF (coalesce(nr_seq_atepacu_w,0) = 0) then 
		CALL Gerar_Passagem_Setor_Atend(	nr_atendimento_p, 
							cd_setor_atendimento_p, 
							clock_timestamp(),--dt_ent_unidade_w, 
							'S', 
							nm_usuario_p);
	END IF;
 
	select	max(a.nr_seq_interno) 
	into STRICT	nr_seq_atepacu_w 
	from 	atend_paciente_unidade a 
	where 	a.cd_setor_atendimento		= cd_setor_atendimento_p 
	and	a.nr_atendimento 		= nr_atendimento_p 
	and	trunc(a.dt_entrada_unidade) 	= trunc(dt_ent_unidade_w);
 
	select	max(cd_local_estoque) 
	into STRICT	cd_local_estoque_w 
	from	setor_atendimento 
	where	cd_setor_atendimento	= cd_setor_atendimento_p;
 
	select 	max(nr_sequencia) 
	into STRICT  	nr_seq_proc_pac_w 
	from  	procedimento_paciente 
	where 	nr_atendimento		= nr_atendimento_p 
	and (coalesce(nr_seq_proc_interno, nr_seq_proc_interno_w) = nr_seq_proc_interno_w or (coalesce(nr_seq_proc_interno_w::text, '') = '' and coalesce(nr_seq_proc_interno::text, '') = '')) 
	and	cd_procedimento		= cd_procedimento_w 
	and	ie_origem_proced	= ie_origem_proced_w 
	and	dt_procedimento between trunc(clock_timestamp()) and trunc(clock_timestamp()) + 86399/86400;
	 
	select	max(nr_seq_tumor) 
	into STRICT	nr_seq_tumor_w 
	from	rxt_tratamento b 
	where 	b.nr_sequencia	= nr_seq_tratamento_p;
	 
	select 	max(cd_medico) 
	into STRICT	cd_medico_w 
	from	rxt_tumor 
	where	nr_sequencia = nr_seq_tumor_w;
	 
	/*if	(qt_agenda_rxt_w = 0)	then 
		obter_proc_tab_interno_conv( 
					nr_seq_proc_interno_w, 
					cd_estabelecimento_p, 
					cd_convenio_w, 
					cd_categoria_w, 
					null, 
					cd_procedimento_w, 
					ie_origem_proced_w, 
					null); 
	end if;*/
 
	if (coalesce(nr_seq_proc_pac_w::text, '') = '') then 
	 
		/* Consistir a regra 'Consiste setor proced' */
 
		SELECT * FROM consiste_medico_executor(cd_estabelecimento_p, cd_convenio_w, cd_setor_atendimento_p, cd_procedimento_w, ie_origem_proced_w, ie_tipo_atendimento_w, null, nr_seq_proc_interno_w, ie_medico_executor_w, cd_cgc_consistido_w, cd_medico_regra_w, cd_profissional_w, null, clock_timestamp(), nr_seq_classificacao_w, 'N', null, null) INTO STRICT ie_medico_executor_w, cd_cgc_consistido_w, cd_medico_regra_w, cd_profissional_w;
	 
		select 	nextval('procedimento_paciente_seq') 
		into STRICT 	nr_seq_proc_pac_w 
		;
		 
		 
		if (coalesce(nr_seq_proc_interno_w,0) > 0) then			 
			SELECT * FROM obter_proc_tab_interno(nr_seq_proc_interno_w, null, nr_atendimento_p, null, cd_procedimento_w, ie_origem_proced_w, null, null, cd_convenio_w) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
		end if;
			 
		insert into procedimento_paciente( 	nr_sequencia, 
			    nr_atendimento, 
			    dt_entrada_unidade, 
				cd_procedimento, 
			    dt_procedimento, 
			    qt_procedimento, 
			    dt_atualizacao, 
			    nm_usuario, 
			    cd_setor_atendimento, 
			    ie_origem_proced, 
				nr_seq_atepacu, 
			    nr_seq_proc_interno, 
				cd_convenio, 
				cd_categoria, 
				cd_pessoa_fisica, 
				nr_seq_agenda_rxt, 
				cd_medico_executor, 
				cd_cgc_prestador) 
		values (	nr_seq_proc_pac_w, 
				nr_atendimento_p, 
				dt_ent_unidade_w, 
				cd_procedimento_w, 
				clock_timestamp(), 
				1, 
				clock_timestamp(), 
				nm_usuario_p, 
				cd_setor_atendimento_p, 
				ie_origem_proced_w, 
				nr_seq_atepacu_w, 
				nr_seq_proc_interno_w, 
				cd_convenio_w, 
				cd_categoria_w, 
				'',--nvl(cd_profissional_w,obter_pf_usuario(nm_usuario_p,'C')), Alterado em 19/10/2011 OS 373914 
				nr_seq_agenda_rxt_p, 
				coalesce(cd_medico_regra_w,cd_medico_w), 
				coalesce(cd_cgc_consistido_w, cd_cgc_prestador_w));
 
		ds_erro_w := consiste_exec_procedimento(nr_seq_proc_pac_w, ds_erro_w);
		CALL atualiza_preco_procedimento(nr_seq_proc_pac_w, cd_convenio_w, nm_usuario_p);
		CALL gerar_lancamento_automatico(nr_atendimento_p,cd_local_estoque_w,34,nm_usuario_p,nr_seq_proc_pac_w,null,null,null,null,null);
	else 
		update	procedimento_paciente 
		set	qt_procedimento	= qt_procedimento + 1 
		where	nr_sequencia	= nr_seq_proc_pac_w;
		 
		ds_erro_w := consiste_exec_procedimento(nr_seq_proc_pac_w, ds_erro_w);
		CALL atualiza_preco_procedimento(nr_seq_proc_pac_w, cd_convenio_w, nm_usuario_p);
		CALL gerar_lancamento_automatico(nr_atendimento_p,cd_local_estoque_w,34,nm_usuario_p,nr_seq_proc_pac_w,null,null,null,null,null);
	end if;
 
	COMMIT;
 
end if;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rxt_inserir_proced_fat ( nr_seq_tratamento_p bigint, nm_usuario_p text, nr_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, nr_seq_agenda_rxt_p bigint, cd_procedimento_p bigint, ie_origem_proceD_p bigint, nr_seq_proc_interno_p bigint, ie_tipo_lancamento_p text ) FROM PUBLIC;

