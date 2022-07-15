-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_ger_list_esp_agend_html (nr_seq_agenda_int_p bigint, nr_seq_agenda_int_item_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
 
cd_categoria_w		     varchar(10);
cd_pessoa_fisica_w	    varchar(20);
cd_convenio_w		      bigint;
nr_sequencia_w		     bigint;
cd_plano_w		       varchar(10);
cd_usuario_convenio_w	   varchar(30);
Ds_Observacao_W		     varchar(2000);
nm_pessoa_lista_w	     varchar(60);
nr_seq_proc_interno_w	   bigint;
ie_lado_w		        varchar(2);
cd_especialidade_w	    bigint;
cd_estabelecimento_w	   smallint;
nr_seq_tipo_classif_pac_w bigint;
ie_inserir_fila_w     varchar(1);
ie_prioridade_w      smallint;
cd_agenda_w        bigint;
cd_procedimento_w     bigint;
ie_origem_proced_w     bigint;
nm_paciente_w		      varchar(255);
nr_telefone_w		      varchar(255);
Nm_Pessoa_Contato_W	    varchar(50);
Nr_Seq_Lista_Espera_W   bigint;
ie_classif_agenda_w		   agenda_lista_espera.ie_classif_agenda%type;


BEGIN 
   
   if (coalesce(nr_seq_agenda_int_p,0) > 0) then 
 
      select coalesce(max(cd_categoria),''), coalesce(max(cd_convenio),''), coalesce(max(cd_estabelecimento),''), coalesce(max(cd_pessoa_fisica),''), coalesce(max(cd_plano),''), 
      coalesce(max(cd_usuario_convenio),''), coalesce(max(ds_observacao),''), coalesce(max(nm_paciente),''), coalesce(max(nr_seq_tipo_classif_pac),'') 
      into STRICT cd_categoria_w, cd_convenio_w, cd_estabelecimento_w, cd_pessoa_fisica_w, cd_plano_w, 
      cd_usuario_convenio_w, ds_observacao_w, nm_pessoa_lista_w, nr_seq_tipo_classif_pac_w 
      from agenda_integrada 
      where nr_sequencia = nr_seq_agenda_int_p;
   
      select coalesce(max(ie_inserir_fila), 'N'), max(ie_prioridade) 
      into STRICT ie_inserir_fila_w, ie_prioridade_w 
      from tipo_classificao_paciente     
      where nr_sequencia = nr_seq_tipo_classif_pac_w 
      and ie_situacao = 'A';
   
      select max(cd_agenda) 
      into STRICT cd_agenda_w 
      from ageint_marcacao_usuario 
      where nr_seq_ageint = nr_seq_agenda_int_p;
 
      If ((Ie_Inserir_Fila_W = 'S') And (coalesce(Ie_Prioridade_W,0) > 0)) Then 
        Select Max(Nr_Seq_Proc_Interno), Max(Ie_Lado), Max(Cd_Especialidade), Max(Ie_Classif_Agenda), Max(Cd_Procedimento), Max(Ie_Origem_Proced) 
        into STRICT nr_seq_proc_interno_w, ie_lado_w, cd_especialidade_w, ie_classif_agenda_w, cd_procedimento_w, ie_origem_proced_w 
        from agenda_integrada_item 
        where nr_sequencia = nr_seq_agenda_int_item_p  LIMIT 1;
 
        select max(substr(obter_nome_pf(cd_pessoa_fisica), 0, 60)) 
        into STRICT nm_paciente_w 
        from pessoa_fisica 
        where cd_pessoa_fisica = cd_pessoa_fisica_w;
        nr_telefone_w	:= obter_fone_pac_agenda(cd_pessoa_fisica_w);
 
        if (coalesce(cd_pessoa_fisica_w::text, '') = '')then 
 
          begin		 
 
            select substr(nm_paciente, 1, 60), nr_telefone, nm_contato 
            into STRICT nm_paciente_w, nr_telefone_w, nm_pessoa_contato_w 
            from agenda_integrada 
            where nr_sequencia = nr_seq_agenda_int_p;
 
          end;	
 
        End If;
         
        if (coalesce(nr_seq_lista_espera_w,0)> 0) then 
 
           Update Agenda_Lista_Espera 
           set ie_status_espera = 'C', 
           Nm_Usuario = Nm_Usuario_P, 
           Dt_Atualizacao = clock_timestamp() 
           where nr_seq_agenda_int = nr_seq_agenda_int_p;
           Commit;
            
        end if;
         
        insert into agenda_lista_espera(nr_sequencia, 
                      nm_usuario_nrec, 
                      nm_usuario_agenda, 
                      nm_usuario, 
                      ie_status_espera, 
                      dt_atualizacao_nrec, 
                      dt_atualizacao, 
                      dt_agendamento, 
                      cd_categoria, 
                      cd_convenio, 
                      cd_pessoa_fisica, 
                      cd_plano,       
                      cd_usuario_convenio, 
                      Ds_Observacao, 
                      nm_pessoa_lista, 
                      nr_seq_proc_interno, 
                      ie_lado, 
                      cd_especialidade, 
                      ie_classif_agenda,       
                      ie_prioridade, 
                      cd_agenda, 
                      cd_procedimento, 
                      ie_origem_proced, 
                      nr_telefone, 
                      ie_urgente, 
                      Dt_Desejada, 
                      Nm_Pessoa_Contato, 
                      nr_seq_agenda_int) 
                  values (nextval('agenda_lista_espera_seq'), 
                      nm_usuario_p, 
                      nm_usuario_p, 
                      nm_usuario_p, 
                      'A', 
                      clock_timestamp(), 
                      clock_timestamp(), 
                      clock_timestamp(), 
                      cd_categoria_w, 
                      cd_convenio_w, 
                      cd_pessoa_fisica_w, 
                      cd_plano_w,       
                      cd_usuario_convenio_w, 
                      ds_observacao_w, 
                      nm_pessoa_lista_w,       
                      nr_seq_proc_interno_w, 
                      ie_lado_w, 
                      cd_especialidade_w, 
                      ie_classif_agenda_w,       
                      ie_prioridade_w, 
                      cd_agenda_w, 
                      cd_procedimento_w, 
                      ie_origem_proced_w, 
                      nr_telefone_w, 
                      'N', 
                      clock_timestamp(), 
                      Nm_Pessoa_Contato_W, 
                      nr_seq_agenda_int_p);
                      commit;
                      
                     select max(nr_sequencia) 
                     into STRICT nr_seq_lista_espera_w 
                     From Agenda_Lista_Espera 
                     Where Nr_Seq_Agenda_Int = Nr_Seq_Agenda_Int_P;
 
    end if;
 
 End If;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_ger_list_esp_agend_html (nr_seq_agenda_int_p bigint, nr_seq_agenda_int_item_p bigint, nm_usuario_p text) FROM PUBLIC;

