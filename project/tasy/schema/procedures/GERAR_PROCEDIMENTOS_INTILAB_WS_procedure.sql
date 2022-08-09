-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_procedimentos_intilab_ws (cd_convenio_p bigint, cd_exame_p text, nr_prontuario_p bigint, cd_plano_convenio_p text, dt_procedimento_p text, nr_carteirinha_pf text, cd_estabelecimento_p bigint, cd_medico_p text, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

					
  cd_estabelecimento_w		atendimento_paciente.cd_estabelecimento%type;					
  nr_atendimento_w			atendimento_paciente.nr_atendimento%type;
  ie_tipo_atendimento_w		atendimento_paciente.ie_tipo_atendimento%type;

  nr_sequencia_w			procedimento_paciente.nr_sequencia%type;
  nr_interno_conta_w		procedimento_paciente.nr_interno_conta%type;
  cd_setor_atendimento_w	procedimento_paciente.cd_setor_atendimento%type;
  nr_seq_atepacu_w			procedimento_paciente.nr_seq_atepacu%type;
  nr_seq_proc_interno_w		procedimento_paciente.nr_seq_proc_interno%type;
  dt_entrada_unidade_w		procedimento_paciente.dt_entrada_unidade%type;
  cd_procedimento_w  		procedimento_paciente.cd_procedimento%type;
  ie_origem_proced_w  		procedimento_paciente.ie_origem_proced%type;

  cd_pessoa_fisica_w  	pessoa_fisica.cd_pessoa_fisica%type;
  cd_convenio_w			atend_categoria_convenio.cd_convenio%type;
  cd_categoria_w    	atend_categoria_convenio.cd_categoria%type;
  cd_tipo_acomodacao_w	atend_categoria_convenio.cd_tipo_acomodacao%type;

  nr_seq_exame_w    	exame_laboratorio.nr_seq_exame%type;

  ie_medico_executor_w	consiste_setor_proc.ie_medico_executor%type;
  cd_cgc_regra_w		consiste_setor_proc.cd_cgc%type;
  cd_medico_regra_w		consiste_setor_proc.cd_medico_executor%type;
  cd_pessoa_regra_w		consiste_setor_proc.cd_pessoa_fisica%type;

  ds_retorno_w		    varchar(2000);
  ie_bloqueia_agenda_w	varchar(10);
  ie_regra_w		    varchar(10);
  nr_seq_regra_w	    bigint;


  dt_procedimento_w  timestamp;
  dt_procedimento_varchar_w   varchar(40);
  ds_erro_w          varchar(2000);


BEGIN
  
  cd_estabelecimento_w := 1;

  -- Nome da variavel com nome incorreto. O correto é setor atendimento.
  cd_setor_atendimento_w := cd_estabelecimento_p;
	
 if (coalesce(dt_procedimento_p::text, '') = ''
    or dt_procedimento_p = ' ') then
     begin
        dt_procedimento_w := clock_timestamp();
     end;
     else
        begin
        select substr(dt_procedimento_p,9,2)||'/'||
               substr(dt_procedimento_p,6,2)||'/'||                
               substr(dt_procedimento_p,1,4)||' '||
               substr(dt_procedimento_p,12,2)||':'||
               substr(dt_procedimento_p,15,2) ||':'||
               substr(dt_procedimento_p,18,2)
               into STRICT dt_procedimento_varchar_w
;
        exception
        when others then
             dt_procedimento_w := clock_timestamp();
        end;
    end if;
       
    dt_procedimento_w := coalesce(to_date(dt_procedimento_varchar_w,'dd/MM/yyyy HH24:mi:ss'), dt_procedimento_w);

    begin
      select cd_pessoa_fisica
      into STRICT   cd_pessoa_fisica_w
      from   pessoa_fisica
      where  nr_prontuario = nr_prontuario_p;

      exception
      when others then        
      ds_erro_w  := obter_desc_expressao(513083,'');
      goto final_ds_erro;	
    end;
  
    begin
      select cd_convenio
      into STRICT   cd_convenio_w
      from   convenio
      where  cd_convenio = cd_convenio_p;

      exception
      when others then
      ds_erro_w  := obter_desc_expressao(871391,'');
      goto final_ds_erro;

      select  cd_categoria
      into STRICT  cd_categoria_w          
      from     atendimento_paciente_v
      where    nr_prontuario = nr_prontuario_p
      and      cd_convenio = cd_convenio_p;
    end;


    begin
      select	nr_seq_proc_interno				
	  into STRICT		nr_seq_proc_interno_w	
	  from		exame_laboratorio
	  where		cd_exame	= cd_exame_p;

      exception
      when others then        
      ds_erro_w  := obter_desc_expressao(621266,'');
      goto final_ds_erro;	
    end;
  
	  select  coalesce(max(a.nr_atendimento),0) nr_atendimento
      into STRICT    nr_atendimento_w
      from    pessoa_fisica b,
              atendimento_paciente_v a
      where   a.cd_pessoa_fisica = b.cd_pessoa_fisica
      and     b.nr_prontuario = nr_prontuario_p;
	
	  select  ie_tipo_atendimento,
			  cd_tipo_acomod_conv
      into STRICT    ie_tipo_atendimento_w,
			  cd_tipo_acomodacao_w
      from    atendimento_paciente_v
	  where   nr_atendimento = nr_atendimento_w;
	
	  nr_seq_atepacu_w :=  obter_atepacu_paciente(nr_atendimento_w, 'A');
	
	  select   max(dt_entrada_unidade)
	  into STRICT	   dt_entrada_unidade_w
	  from	   atend_paciente_unidade
	  where	   nr_seq_interno = nr_seq_atepacu_w;

      begin
      SELECT * FROM Obter_Proc_Tab_Interno_Conv(nr_seq_proc_interno_w, cd_estabelecimento_w, cd_convenio_p, cd_categoria_w, cd_plano_convenio_p, cd_setor_atendimento_w, cd_procedimento_w, ie_origem_proced_w, null, dt_procedimento_w, cd_tipo_acomodacao_w, null, null, null, ie_tipo_atendimento_w, null, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
      exception
			when others then
			ds_erro_w	:= obter_desc_expressao(738325,'');
			goto final_ds_erro;
	   end;
    
   SELECT * FROM consiste_plano_mat_proc(cd_estabelecimento_w, cd_convenio_p, cd_categoria_w, cd_plano_convenio_p, null, cd_procedimento_w, ie_origem_proced_w, null, ie_tipo_atendimento_w, 0, 0, null, nr_seq_proc_interno_w, ds_retorno_w, ie_bloqueia_agenda_w, ie_regra_w, nr_seq_regra_w) INTO STRICT ds_retorno_w, ie_bloqueia_agenda_w, ie_regra_w, nr_seq_regra_w;

      
      
      SELECT * FROM consiste_medico_executor(cd_estabelecimento_w, cd_convenio_p, cd_setor_atendimento_w, cd_procedimento_w, ie_origem_proced_w, ie_tipo_atendimento_w, null, nr_seq_proc_interno_w, ie_medico_executor_w, cd_cgc_regra_w, cd_medico_regra_w, cd_pessoa_regra_w, cd_medico_p, dt_procedimento_w, null, null, null, null, null) INTO STRICT ie_medico_executor_w, cd_cgc_regra_w, cd_medico_regra_w, cd_pessoa_regra_w;


       select	nextval('procedimento_paciente_seq')
        into STRICT	nr_sequencia_w
;
      		
        begin
        insert into procedimento_paciente(
          nr_sequencia,
          nr_atendimento,
          dt_atualizacao,
          nm_usuario,
          nm_usuario_original,
          cd_procedimento,
          ie_origem_proced,
          nr_seq_proc_interno,
          qt_procedimento,
          dt_procedimento,
          dt_conta,
          cd_convenio,
          cd_categoria,
          nr_seq_atepacu,
          cd_setor_atendimento,
          dt_entrada_unidade,
          cd_setor_paciente,
          cd_medico_executor,
          cd_pessoa_fisica,
          cd_cgc_prestador,
          tx_anestesia,
          tx_procedimento,
          tx_medico,
          ie_valor_informado,
          ie_auditoria,
          ie_video,
          ie_guia_informada,
          ie_dispersao,
          ie_intercorrencia,
          ie_proc_princ_atend,
          ds_observacao
        ) values (
          nr_sequencia_w,
          nr_atendimento_w,
          clock_timestamp(),
          nm_usuario_p,
          nm_usuario_p,
          cd_procedimento_w,
          ie_origem_proced_w,
          nr_seq_proc_interno_w,
          1,
          dt_procedimento_w,
          dt_procedimento_w,
          cd_convenio_p,
          cd_categoria_w,
          nr_seq_atepacu_w,
          cd_setor_atendimento_w,
          dt_entrada_unidade_w,
          cd_setor_atendimento_w,
          coalesce(cd_medico_regra_w, cd_medico_p),
          cd_pessoa_regra_w,
          cd_cgc_regra_w,
          100,
          100,
          100,
          'N',
          'N',
          'N',
          'N',
          'N',
          'N',
          'N',
          null
        );
        exception
          when others then
          ds_erro_w	:= sqlerrm;
          goto final_ds_erro;
        end;
      		
        begin
        CALL atualiza_preco_procedimento(nr_sequencia_w, cd_convenio_p, nm_usuario_p);
        exception
          when others then
          ds_erro_w	:= obter_desc_expressao(619362,'');
          goto final_ds_erro;
        end;
      		
        select	max(nr_interno_conta)
        into STRICT	nr_interno_conta_w
        from	procedimento_paciente
        where	nr_sequencia = nr_sequencia_w;
      		
        begin
        CALL gerar_lancamento_automatico(nr_atendimento_w, null, 34, nm_usuario_p, nr_sequencia_w, null, null, null, null, nr_interno_conta_w);
        exception
          when others then
          ds_erro_w	:= obter_desc_expressao(738323,'');
          goto final_ds_erro;
        end;
      		
        begin
        CALL gerar_autor_regra(nr_atendimento_w, null, nr_sequencia_w, null, null, null, 'EP', nm_usuario_p, null, nr_seq_proc_interno_w, null, null, null, null, '', '', '');
        exception
          when others then
          ds_erro_w	:= obter_desc_expressao(755534,'');
          goto final_ds_erro;
        end;	

  <<final_ds_erro>>
  ds_erro_p  := substr(ds_erro_w,1,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_procedimentos_intilab_ws (cd_convenio_p bigint, cd_exame_p text, nr_prontuario_p bigint, cd_plano_convenio_p text, dt_procedimento_p text, nr_carteirinha_pf text, cd_estabelecimento_p bigint, cd_medico_p text, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
