-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lancar_procedimento_conta_hc ( nr_seq_agenda_p text, nm_usuario_p text, cd_funcionario_p text default null, nr_lista_proc_p text default null) AS $body$
DECLARE


					
nr_atendimento_w	varchar(10);
nr_seq_profissional_w	varchar(10);
cd_setor_atendimento_w	varchar(10);
Atepacu_paciente_w	varchar(10);
cd_procedimento_w	varchar(15);
ie_origem_proced_w	varchar(15);
cd_categoria_w		varchar(10);
nr_sequencia_w		bigint;
cd_convenio_w		integer;
cd_procedimento_adic_w       varchar(15);
ie_origem_proced_adic_w	varchar(15);
cd_pessoa_fisica_w	varchar(10);
ie_permite_funcionario_w varchar(1);
dt_agendamento_w	timestamp;
ie_agenda_retroativo_w	varchar(1);
lista_informacao_w	varchar(32000);
ie_contador_w 		smallint := 0;
tam_lista_w		bigint;
ie_pos_virgula_w	smallint;
ie_pos_traco_w		bigint;
lista_inf_w		varchar(100);
nr_seq_lista_prof_w	varchar(2000);
nr_lista_proc_adic_w	varchar(2000);
nr_atendimento_origem_w	bigint;
ie_selec_proc_w		varchar(1);
ie_tipo_w		varchar(5);
nr_seq_proc_prof_w	bigint;
nr_seq_paciente_w	bigint;
ie_atendimento_alta_w	varchar(1);
cd_pessoa_atend_w	varchar(10);
nr_lista_proc_w		varchar(2000);
nr_seq_proc_interno_w	bigint;
dt_entrada_unidade_w	timestamp;
ie_gera_autorizacao_w	varchar(1);
cd_cgc_prestador_w	procedimento_paciente.cd_cgc_prestador%type;
nr_doc_convenio_w	procedimento_paciente.nr_doc_convenio%type;
ie_tipo_guia_w		procedimento_paciente.ie_tipo_guia%type;


cd_pessoa_fisica_eup_w  atendimento_paciente.cd_pessoa_fisica%type;
cd_estabelecimento_w    atendimento_paciente.cd_estabelecimento%type;
ie_tipo_atendimento_w   atendimento_paciente.ie_tipo_atendimento%type;
nr_seq_classificacao_w  atendimento_paciente.nr_seq_classificacao%type;
cd_cgc_prest_regra_w    consiste_setor_proc.cd_cgc%type;
ie_medico_executor_w    varchar(10);
cd_medico_executor_w    varchar(10);
cd_pes_fis_regra_w      varchar(10);
cd_medico_laudo_sus_w   varchar(10);
cd_medico_exec_w        varchar(10);
cd_profissional_w       varchar(10);
ie_vincula_emp_resp_w	varchar(1);
cd_empresa_w			procedimento_paciente.cd_cgc_prestador%type;
	
C01 CURSOR FOR
	SELECT	nr_atendimento_origem_w,
		obter_setor_atendimento(nr_atendimento_origem_w),
		Obter_Atepacu_paciente(nr_atendimento_origem_w,'IA'),
		a.cd_procedimento,
		a.ie_origem_proced,
		a.nr_sequencia,
		a.cd_pessoa_fisica	
	from	hc_profissional a		
	where	obter_se_contido(a.nr_sequencia,nr_seq_lista_prof_w) = 'S';		
	
C02 CURSOR FOR
	SELECT	nr_atendimento_origem_w,
		obter_setor_atendimento(nr_atendimento_origem_w),
		Obter_Atepacu_paciente(nr_atendimento_origem_w,'IA'),
		b.cd_procedimento,
		b.ie_origem_proced,
		a.nr_sequencia,
		a.cd_pessoa_fisica
	from	hc_profissional a,
		hc_profissional_proc b
	where	a.nr_sequencia = b.nr_seq_profissional
	and	obter_se_contido(b.nr_sequencia,nr_lista_proc_adic_w) = 'S';

C03 CURSOR FOR
	SELECT	nr_atendimento_origem_w,
		obter_setor_atendimento(nr_atendimento_origem_w),
		Obter_Atepacu_paciente(nr_atendimento_origem_w,'IA'),
		c.cd_procedimento,
		c.ie_origem_proced,
		c.nr_seq_proc_interno
	from	paciente_home_care a,
		hc_paciente_servico b,
		hc_paciente_servico_proc c
	where	a.nr_sequencia = b.nr_seq_pac_home_care
	and	b.nr_sequencia = c.nr_seq_servico
	and	obter_se_contido(b.nr_sequencia,nr_lista_proc_w) = 'S';


BEGIN

ie_permite_funcionario_w := obter_param_usuario(867, 50, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_permite_funcionario_w);
ie_agenda_retroativo_w := obter_param_usuario(867, 52, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_agenda_retroativo_w);
ie_selec_proc_w := obter_param_usuario(867, 81, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_selec_proc_w);
ie_gera_autorizacao_w := obter_param_usuario(867, 94, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_gera_autorizacao_w);
ie_vincula_emp_resp_w := obter_param_usuario(867, 95, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_vincula_emp_resp_w);

if (ie_agenda_retroativo_w = 'S') then
	select (dt_agenda)
	into STRICT	dt_agendamento_w
	from	agenda_hc_paciente
	where	nr_sequencia = nr_seq_agenda_p;
	
	if (trunc(dt_agendamento_w) >= trunc(clock_timestamp())) then
		dt_agendamento_w := clock_timestamp();
	end if;
else
	dt_agendamento_w := clock_timestamp();	
end if;

if (nr_lista_proc_p IS NOT NULL AND nr_lista_proc_p::text <> '') then
	begin	
	nr_atendimento_origem_w := hc_obter_atendimento_agenda(nr_seq_agenda_p);	
	
	if (coalesce(nr_atendimento_origem_w::text, '') = '') then
		select	max(cd_pessoa_fisica)
		into STRICT	cd_pessoa_fisica_w
		from	agenda_hc_paciente
		where	nr_sequencia = nr_seq_agenda_p;
	
	
		select	max(nr_sequencia)
		into STRICT	nr_seq_paciente_w
		from	paciente_home_care
		where	cd_pessoa_fisica = cd_pessoa_fisica_w
		and	((coalesce(dt_final::text, '') = '') or (dt_final < clock_timestamp()))
		and	ie_situacao = 'A';
		
		select	max(nr_atendimento_origem)
		into STRICT	nr_atendimento_origem_w
		from	paciente_home_care
		where	nr_sequencia = nr_seq_paciente_w;				
		
	end if;	
	
	if (nr_atendimento_origem_w IS NOT NULL AND nr_atendimento_origem_w::text <> '') then
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_atendimento_alta_w
		from	atendimento_paciente
		where	nr_atendimento = nr_atendimento_origem_w
		and	(dt_alta IS NOT NULL AND dt_alta::text <> '');
		
		if (ie_atendimento_alta_w = 'S') then			
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(264551);
		end if;
		
		select	max(cd_pessoa_fisica)
		into STRICT	cd_pessoa_atend_w
		from	atendimento_paciente
		where	nr_atendimento = nr_atendimento_origem_w;
		
		select	max(cd_pessoa_fisica)
		into STRICT	cd_pessoa_fisica_w
		from	agenda_hc_paciente
		where	nr_sequencia = nr_seq_agenda_p;
		
		if (cd_pessoa_atend_w <> cd_pessoa_fisica_w) then
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(264552);						
		end if;
	end if;
		
	
	lista_informacao_w := nr_lista_proc_p;

	while(lista_informacao_w IS NOT NULL AND lista_informacao_w::text <> '') and (ie_contador_w 		< 1000) loop
		begin
		tam_lista_w			:= length(lista_informacao_w);
		ie_pos_virgula_w		:= position(',' in lista_informacao_w);
		ie_pos_traco_w			:= position('-' in lista_informacao_w);
		lista_inf_w			:= substr(lista_informacao_w,1,ie_pos_virgula_w - 1);
		
		if (ie_pos_virgula_w <> 0) then
			begin
			nr_seq_proc_prof_w	:= substr(lista_inf_w,1,(ie_pos_traco_w - 1));
			lista_inf_w		:= substr(lista_inf_w,ie_pos_traco_w + 1,100);
			ie_tipo_w		:= lista_inf_w;
			lista_informacao_w	:= substr(lista_informacao_w,(ie_pos_virgula_w + 1),tam_lista_w);
			
			if (ie_tipo_w = 'P') then
				nr_seq_lista_prof_w  := nr_seq_proc_prof_w||','||nr_seq_lista_prof_w;
			elsif (ie_tipo_w = 'A') then
				nr_lista_proc_adic_w := nr_seq_proc_prof_w ||','||nr_lista_proc_adic_w;
			elsif (ie_tipo_w = 'S') then
				nr_lista_proc_w	 := nr_seq_proc_prof_w || ',' || nr_lista_proc_w;
			end if;
			
			end;
		end if;
		
		ie_contador_w := ie_contador_w +1;
		end;
	end loop;
	
		
	open C01;
	loop
	fetch C01 into	
		nr_atendimento_w,
		cd_setor_atendimento_w,
		Atepacu_paciente_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		nr_seq_profissional_w,
		cd_pessoa_fisica_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (coalesce(nr_atendimento_w::text, '') = '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(206735);
		end if;	
		select  max(a.cd_cgc)
		into STRICT	cd_cgc_prestador_w
		from 	estabelecimento a,
			atendimento_paciente b
		where 	a.cd_estabelecimento = b.cd_estabelecimento
		and	b.nr_atendimento = nr_atendimento_w;		
		
		select 	nextval('procedimento_paciente_seq')
		into STRICT 	nr_sequencia_w
		;
		
		select	max(cd_convenio),
			max(cd_categoria),
			max(nr_doc_convenio),
			max(ie_tipo_guia)
		into STRICT	cd_convenio_w,
			cd_categoria_w,
			nr_doc_convenio_w,
			ie_tipo_guia_w
		from	atendimento_paciente_v
		where	nr_atendimento = nr_atendimento_w;
		
		select	max(dt_entrada_unidade)
		into STRICT	dt_entrada_unidade_w
		from	atend_paciente_unidade
		where	nr_seq_interno = Atepacu_paciente_w;

		insert 	into 	procedimento_paciente(
				nr_sequencia,
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
				cd_convenio,
				ds_observacao,
				cd_categoria,
				cd_pessoa_fisica,
				cd_cgc_prestador,
				nr_doc_convenio,
				ie_tipo_guia)
			values ( 
				nr_sequencia_w,
				nr_atendimento_w,
				dt_entrada_unidade_w,
				coalesce(cd_procedimento_w,1),
				dt_agendamento_w,
				1,
				clock_timestamp(),
				nm_usuario_p,
				cd_setor_atendimento_w,
				ie_origem_proced_w,
				Atepacu_paciente_w,
				cd_convenio_w,
				WHEB_MENSAGEM_PCK.get_texto(302304) || nr_seq_agenda_p, --Cuidado ao alterar!!!! Usado a sequencia da agenda na Procedure 'hc_desfazer_proc_conta' Cornetet Texto -> Gerado a partir da funcao Gestao de Home Care - Sequencia da agenda:
				cd_categoria_w,
				CASE WHEN ie_permite_funcionario_w='S' THEN coalesce(cd_funcionario_p,cd_pessoa_fisica_w)  ELSE cd_pessoa_fisica_w END ,
				cd_cgc_prestador_w,
				nr_doc_convenio_w,
				ie_tipo_guia_w);
				
		CALL atualiza_preco_procedimento(nr_sequencia_w, cd_convenio_w, nm_usuario_p);
		
		if (ie_gera_autorizacao_w = 'S') then			
			CALL gerar_autor_regra(nr_atendimento_w, null, nr_sequencia_w, null, null, null, 'CP', nm_usuario_p, null, nr_seq_proc_interno_w, null, null, null, null, null, null, null);
		end if;
		end;
					
	end loop;
	close C01;

	open C02;
	loop
	fetch C02 into	
		nr_atendimento_w,
		cd_setor_atendimento_w,
		Atepacu_paciente_w,
		cd_procedimento_adic_w,
		ie_origem_proced_adic_w,
		nr_seq_profissional_w,
		cd_pessoa_fisica_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		select 	nextval('procedimento_paciente_seq')
		into STRICT 	nr_sequencia_w
		;
		
		select  max(a.cd_cgc)
		into STRICT	cd_cgc_prestador_w
		from 	estabelecimento a,
			atendimento_paciente b
		where 	a.cd_estabelecimento = b.cd_estabelecimento
		and	b.nr_atendimento = nr_atendimento_w;	
		
		select	max(cd_convenio),
			max(cd_categoria),
			max(nr_doc_convenio),
			max(ie_tipo_guia)
		into STRICT	cd_convenio_w,
			cd_categoria_w,
			nr_doc_convenio_w,
			ie_tipo_guia_w
		from	atendimento_paciente_v
		where	nr_atendimento = nr_atendimento_w;
		
		select	max(dt_entrada_unidade)
		into STRICT	dt_entrada_unidade_w
		from	atend_paciente_unidade
		where	nr_seq_interno = Atepacu_paciente_w;

		insert 	into 	procedimento_paciente(
				nr_sequencia,
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
				cd_convenio,
				ds_observacao,
				cd_categoria,
				cd_pessoa_fisica,
				cd_cgc_prestador,
				nr_doc_convenio,
				ie_tipo_guia)
			values ( 
				nr_sequencia_w,
				nr_atendimento_w,
				dt_entrada_unidade_w,
				coalesce(cd_procedimento_adic_w,1),
				dt_agendamento_w,
				1,
				clock_timestamp(),
				nm_usuario_p,
				cd_setor_atendimento_w,
				coalesce(ie_origem_proced_adic_w,1),
				Atepacu_paciente_w,
				cd_convenio_w,
				WHEB_MENSAGEM_PCK.get_texto(302304) ||nr_seq_agenda_p, --Texto -> Gerado a partir da funcao Gestao de Home Care - Sequencia da agenda:
				cd_categoria_w,
				CASE WHEN ie_permite_funcionario_w='S' THEN coalesce(cd_funcionario_p,cd_pessoa_fisica_w)  ELSE cd_pessoa_fisica_w END ,
				cd_cgc_prestador_w,
				nr_doc_convenio_w,
				ie_tipo_guia_w);
				
		CALL atualiza_preco_procedimento(nr_sequencia_w, cd_convenio_w, nm_usuario_p);
		if (ie_gera_autorizacao_w = 'S') then			
			CALL gerar_autor_regra(nr_atendimento_w, null, nr_sequencia_w, null, null, null, 'CP', nm_usuario_p, null, nr_seq_proc_interno_w, null, null, null, null, null, null, null);
		end if;
		end;				
		
	end loop;
	close C02;
	
	open C03;
	loop
	fetch C03 into	
		nr_atendimento_w,
		cd_setor_atendimento_w,
		Atepacu_paciente_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		nr_seq_proc_interno_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		if (coalesce(nr_atendimento_w::text, '') = '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(206735);
		end if;

		select 	nextval('procedimento_paciente_seq')
		into STRICT 	nr_sequencia_w
		;
		
		select  max(a.cd_cgc)
		into STRICT	cd_cgc_prestador_w
		from 	estabelecimento a,
			atendimento_paciente b
		where 	a.cd_estabelecimento = b.cd_estabelecimento
		and	b.nr_atendimento = nr_atendimento_w;	
		
		select	max(cd_convenio),
			max(cd_categoria),
			max(nr_doc_convenio),
			max(ie_tipo_guia),
      max(cd_pessoa_fisica),
      max(cd_estabelecimento),
      max(ie_tipo_atendimento),
      max(ie_tipo_atendimento)
		into STRICT	cd_convenio_w,
			cd_categoria_w,
			nr_doc_convenio_w,
			ie_tipo_guia_w,
      			cd_pessoa_fisica_eup_w,
      			cd_estabelecimento_w,
      			ie_tipo_atendimento_w,
      			nr_seq_classificacao_w
		from	atendimento_paciente_v
		where	nr_atendimento = nr_atendimento_w;
		
		select	max(dt_entrada_unidade)
		into STRICT	dt_entrada_unidade_w
		from	atend_paciente_unidade
		where	nr_seq_interno = Atepacu_paciente_w;

    SELECT * FROM consiste_medico_executor(cd_estabelecimento_w, cd_convenio_w, cd_setor_atendimento_w, cd_procedimento_w, ie_origem_proced_w, ie_tipo_atendimento_w, null, nr_seq_proc_interno_w, ie_medico_executor_w, cd_cgc_prest_regra_w, cd_medico_executor_w, cd_pes_fis_regra_w, null, clock_timestamp(), nr_seq_classificacao_w, 'N', null, null) INTO STRICT ie_medico_executor_w, cd_cgc_prest_regra_w, cd_medico_executor_w, cd_pes_fis_regra_w;

    if (cd_medico_executor_w IS NOT NULL AND cd_medico_executor_w::text <> '') and (coalesce(cd_medico_exec_w::text, '') = '') then
	    cd_medico_exec_w := cd_medico_executor_w;
    end if;

    if (coalesce(cd_medico_executor_w::text, '') = '') and (ie_medico_executor_w = 'N') then
        cd_medico_exec_w := null;
    end if;

    if (ie_medico_executor_w = 'S') then
        select max(cd_medico_requisitante)
        into STRICT cd_medico_laudo_sus_w
        from sus_laudo_paciente
              where nr_atendimento      = nr_atendimento_w
              and cd_procedimento_solic = cd_procedimento_w
              and ie_origem_proced      = ie_origem_proced_w;

        cd_medico_exec_w         := coalesce(cd_medico_laudo_sus_w,cd_medico_exec_w);
    end if;

    if (ie_medico_executor_w = 'M') then
        begin
        cd_medico_laudo_sus_w := sus_obter_dados_sismama_atend(nr_atendimento_w,'N','CMR');
        cd_medico_exec_w      := coalesce(cd_medico_laudo_sus_w,cd_medico_exec_w);
        end;
    end if;

    if (ie_medico_executor_w = 'A') and (coalesce(cd_medico_exec_w::text, '') = '') then
        select max(cd_medico_resp)
        into STRICT cd_medico_exec_w
        from atendimento_paciente
        where nr_atendimento = nr_atendimento_w;
    end if;

    if (ie_medico_executor_w = 'F') and (cd_medico_executor_w IS NOT NULL AND cd_medico_executor_w::text <> '') then
       cd_medico_exec_w      := cd_medico_executor_w;
    end if;

    if (cd_pessoa_fisica_eup_w IS NOT NULL AND cd_pessoa_fisica_eup_w::text <> '') or (cd_profissional_w IS NOT NULL AND cd_profissional_w::text <> '') and (ie_medico_executor_w = 'Y') then
        cd_pes_fis_regra_w   := null;
        cd_profissional_w    := null;
    end if;
				
		if (ie_vincula_emp_resp_w = 'S' ) then
				
			select	max(nr_sequencia)
			into STRICT	nr_seq_paciente_w
			from	paciente_home_care
			where	cd_pessoa_fisica = cd_pessoa_fisica_w
			and	((coalesce(dt_final::text, '') = '') or (dt_final < clock_timestamp()))
			and	ie_situacao = 'A';

			select	max(e.cd_cgc_prestador)
			into STRICT	cd_empresa_w
			from	hc_resp_servico_paciente a,
					hc_paciente_servico b,
					empresa_referencia c,
					pessoa_juridica d,
					procedimento_paciente e
			where	b.nr_sequencia = a.nr_seq_pac_servico
			and   	a.cd_empresa = c.cd_empresa
			and   	c.cd_cgc = d.cd_cgc
			and   	c.cd_cgc = e.cd_cgc_prestador
			and		b.nr_seq_pac_home_care = nr_seq_paciente_w;			
		
		end if;
		
		insert 	into 	procedimento_paciente(
				nr_sequencia,
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
				cd_convenio,
				ds_observacao,
				cd_categoria,
				cd_pessoa_fisica,
				cd_medico_executor,
				cd_cgc_prestador,
				nr_doc_convenio,
				ie_tipo_guia,
				nr_seq_proc_interno)
			values ( 
				nr_sequencia_w,
				nr_atendimento_w,
				dt_entrada_unidade_w,
				coalesce(cd_procedimento_w,1),
				dt_agendamento_w,
				1,
				clock_timestamp(),
				nm_usuario_p,
				cd_setor_atendimento_w,
				ie_origem_proced_w,
				Atepacu_paciente_w,
				cd_convenio_w,
				WHEB_MENSAGEM_PCK.get_texto(302304) ||nr_seq_agenda_p, --Texto -> Gerado a partir da funcao Gestao de Home Care - Sequencia da agenda:
				cd_categoria_w,
				coalesce(cd_profissional_w, cd_pes_fis_regra_w, CASE WHEN ie_permite_funcionario_w='S' THEN coalesce(cd_funcionario_p,cd_pessoa_fisica_w)  ELSE cd_pessoa_fisica_w END ),
				cd_medico_exec_w,
				coalesce(cd_empresa_w, cd_cgc_prestador_w, cd_cgc_prest_regra_w),
				nr_doc_convenio_w,
				ie_tipo_guia_w,
				nr_seq_proc_interno_w);
				
		CALL atualiza_preco_procedimento(nr_sequencia_w, cd_convenio_w, nm_usuario_p);
		if (ie_gera_autorizacao_w = 'S') then
			CALL gerar_autor_regra(nr_atendimento_w, null, nr_sequencia_w, null, null, null, 'CP', nm_usuario_p, null, nr_seq_proc_interno_w, null, null, null, null, null, null, null);
		end if;
		end;				
		
	end loop;
	close C03;
	
	end;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lancar_procedimento_conta_hc ( nr_seq_agenda_p text, nm_usuario_p text, cd_funcionario_p text default null, nr_lista_proc_p text default null) FROM PUBLIC;
