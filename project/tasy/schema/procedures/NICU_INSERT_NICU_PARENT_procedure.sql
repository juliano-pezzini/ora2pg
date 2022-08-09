-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nicu_insert_nicu_parent (nr_seq_parent_p nicu_parent.nr_sequencia%type, nr_seq_patient_p nicu_patient.nr_sequencia%type, nm_usuario_p text, nm_parent_p text, ds_address_p text, ie_show_wmessage_p text, nr_telephone_number_p nicu_telecom.nr_telephone_number%type, mensagem_erro_o INOUT text) AS $body$
DECLARE


  nr_sequencia_nicu_parent_w  nicu_parent.nr_sequencia%type;
  ds_country_w                nicu_parent.ds_country%type;

  nr_sequencia_person_name_w  person_name.nr_sequencia%type;
  ds_given_name_w             person_name.ds_given_name%type;
  ds_family_name_w            person_name.ds_family_name%type;
  ds_component_name_1_w       person_name.ds_component_name_1%type;

  nr_sequencia_nicu_telecom_w nicu_telecom.nr_sequencia%type;

  nr_sequencia_parent_pati_w  nicu_parent_patient.nr_sequencia%type;

  exeption_w                  exception;

BEGIN

  if (coalesce(nr_seq_parent_p::text, '') = '') then
    --BUSCA NOVO SEQUENCIAL PARA NICU_PARENT
    begin
        select nextval('nicu_parent_seq') 
          into STRICT nr_sequencia_nicu_parent_w
;
    exception
      when others then
        null;
    end;

  else
    nr_sequencia_nicu_parent_w := nr_seq_parent_p;

    begin
        select nr_seq_person_name, ds_country
          into STRICT nr_sequencia_person_name_w, ds_country_w
          from nicu_parent
         where nr_sequencia = nr_sequencia_nicu_parent_w;
    exception
      when others then
        null;
    end;

  end if;

  
  if (coalesce(nr_sequencia_person_name_w::text, '') = '') then  
    --BUSCA NOVO SEQUENCIAL PARA PERSON_NAME
    begin
      select nextval('person_name_seq') 
        into STRICT nr_sequencia_person_name_w
;
    exception
      when others then
        null;
    end;
  end if;
  
  --EXTRAI O NOME PELA STRING QUEBRANDO NOS ESPACOS PARA BUSCAR PRIMEIRO NOME, NOME DO MEIO (se existir) E NOME DA FAMILIA
  begin
      select substr(nm_parent_p, 1, position(' ' in nm_parent_p)-1) as col_one, --Busca primeiro nome
             substr(nm_parent_p, 
               position(' '  in nm_parent_p) + 1,
               (instr(nm_parent_p, ' ', -1 ) - position(' ' in nm_parent_p)) - 1)
             as col_two, --busca a string entre primeiro espaco ate ultimo espaco       
             substr(nm_parent_p, instr(nm_parent_p, ' ', -1, 1)+1) as col_tree --Busca ultimo nome
        into STRICT ds_given_name_w,
             ds_component_name_1_w,
             ds_family_name_w
;
  exception
    when others then
      null;
  end;

      
  begin
    insert into person_name(nr_sequencia,
         dt_atualizacao,
         nm_usuario,
         dt_atualizacao_nrec,
         nm_usuario_nrec,
         ds_type,
         ds_given_name,
         ds_family_name,
         ds_component_name_1)
    values (nr_sequencia_person_name_w,
         clock_timestamp(),
         nm_usuario_p,
         clock_timestamp(),
         nm_usuario_p,
         'main',
         ds_given_name_w,
         ds_family_name_w,
         ds_component_name_1_w);
  exception
    when unique_violation then
      begin
        update person_name
           set dt_atualizacao       = clock_timestamp(),
               nm_usuario           = nm_usuario_p,
               dt_atualizacao_nrec  = clock_timestamp(),
               nm_usuario_nrec      = nm_usuario_p,
               ds_type              = 'main',
               ds_given_name        = ds_given_name_w,
               ds_family_name       = ds_family_name_w,
               ds_component_name_1  = ds_component_name_1_w
         where nr_sequencia         = nr_sequencia_person_name_w;
      exception
        when others then
          mensagem_erro_o := expressao_pck.obter_desc_expressao(776218)||' Error: '||sqlerrm;
          raise exeption_w;
      end;
    when others then
      mensagem_erro_o := expressao_pck.obter_desc_expressao(776218)||' Error: '||sqlerrm;
      raise exeption_w;
  end;
  
  begin   
    insert into nicu_parent(nr_sequencia,
        dt_atualizacao,
        nm_usuario,
        dt_atualizacao_nrec,
        nm_usuario_nrec,
        nr_seq_person_name,
        ds_address,
        ie_show_wmessage)
    values (nr_sequencia_nicu_parent_w,
        clock_timestamp(),
        nm_usuario_p,
        clock_timestamp(),
        nm_usuario_p,
        nr_sequencia_person_name_w,
        ds_address_p,
        ie_show_wmessage_p);
  exception
    when unique_violation then
      begin
        update nicu_parent
           set dt_atualizacao      = clock_timestamp(),
               nm_usuario          = nm_usuario_p,
               dt_atualizacao_nrec = clock_timestamp(),
               nm_usuario_nrec     = nm_usuario_p,
               nr_seq_person_name  = nr_sequencia_person_name_w,
               ds_address          = ds_address_p,
               ie_show_wmessage    = ie_show_wmessage_p
         where nr_sequencia        = nr_sequencia_nicu_parent_w;
      exception
        when others then
          mensagem_erro_o := expressao_pck.obter_desc_expressao(776218)||' Error: '||sqlerrm;
          raise exeption_w;
      end;
    when others then
      mensagem_erro_o := expressao_pck.obter_desc_expressao(776218)||' Error: '||sqlerrm;
      raise exeption_w;
  end;
  
  --VERIFICA SE O PAI INSERIDO JA TEM VINCULO COM O PACIENTE NICU_PARENT_PATIENT
  begin
      select nr_sequencia
        into STRICT nr_sequencia_parent_pati_w
        from nicu_parent_patient
       where nicu_parent_patient.nr_seq_patient = nr_seq_patient_p
         and nicu_parent_patient.nr_seq_parent  = nr_sequencia_nicu_parent_w;
  exception
    when others then
      null;
  end;

  if (coalesce(nr_sequencia_parent_pati_w::text, '') = '') then  
      --INSERE NICU_PARENT_PATIENT
      begin
        select nextval('nicu_parent_patient_seq') 
          into STRICT nr_sequencia_parent_pati_w
;
      exception
        when others then
          null;
      end;

      begin
        insert into nicu_parent_patient(nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            dt_atualizacao_nrec,
            nm_usuario_nrec,
            nr_seq_parent,
            nr_seq_patient)
        values (nr_sequencia_parent_pati_w,
            clock_timestamp(),
            nm_usuario_p,
            clock_timestamp(),
            nm_usuario_p,
            nr_sequencia_nicu_parent_w,
            nr_seq_patient_p);
      exception
        when unique_violation then
          null;
        when others then
          mensagem_erro_o := expressao_pck.obter_desc_expressao(776218)||' Error: '||sqlerrm;
          raise exeption_w;
      end;
  end if;

  --BUSCA O SEQUENCIAL DA NICU_TELECOM VINCUPADO AO PARENT (Busca a maior devido que a regra e 1:1 mas em tabela a pk e nr_quencia sem vincular o parent)
  begin      
    select max(nr_sequencia)
      into STRICT nr_sequencia_nicu_telecom_w
      from nicu_telecom
     where nr_seq_parent = nr_sequencia_nicu_parent_w;
  exception
    when others then
      null;
  end;

  
  if (coalesce(nr_sequencia_nicu_telecom_w::text, '') = '') then
      begin 
        select nextval('nicu_telecom_seq') 
          into STRICT nr_sequencia_nicu_telecom_w
;
      exception
        when others then
          null;
      end;
  end if;

  begin
    insert into nicu_telecom(nr_sequencia,
         dt_atualizacao,
         nm_usuario,
         dt_atualizacao_nrec,
         nm_usuario_nrec,
         nr_seq_parent,
         nr_seq_patient,
         nr_telephone_number)
    values (nr_sequencia_nicu_telecom_w,
         clock_timestamp(),
         nm_usuario_p,
         clock_timestamp(),
         nm_usuario_p,
         nr_sequencia_nicu_parent_w,
         nr_seq_patient_p,
         nr_telephone_number_p);
  exception
    when unique_violation then
      begin
        update nicu_telecom
           set nr_sequencia        = nr_sequencia_nicu_telecom_w,
               dt_atualizacao      = clock_timestamp(),
               nm_usuario          = nm_usuario_p,
               dt_atualizacao_nrec = clock_timestamp(),
               nm_usuario_nrec     = nm_usuario_p,
               nr_seq_parent       = nr_sequencia_nicu_parent_w,
               nr_seq_patient      = nr_seq_patient_p,
               nr_telephone_number = nr_telephone_number_p
         where nr_sequencia = nr_sequencia_nicu_telecom_w;
      exception
        when others then
          mensagem_erro_o := expressao_pck.obter_desc_expressao(776218)||' Error: '||sqlerrm;
          raise exeption_w;
      end;
    when others then
      mensagem_erro_o := expressao_pck.obter_desc_expressao(776218)||' Error: '||sqlerrm;
      raise exeption_w;
  end;

  commit;

exception
  when exeption_w then
   rollback;
 when others then
   mensagem_erro_o := expressao_pck.obter_desc_expressao(776218)||' Error: '||sqlerrm;
   rollback;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nicu_insert_nicu_parent (nr_seq_parent_p nicu_parent.nr_sequencia%type, nr_seq_patient_p nicu_patient.nr_sequencia%type, nm_usuario_p text, nm_parent_p text, ds_address_p text, ie_show_wmessage_p text, nr_telephone_number_p nicu_telecom.nr_telephone_number%type, mensagem_erro_o INOUT text) FROM PUBLIC;
