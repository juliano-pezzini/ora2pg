-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mprev_enviar_email_sms ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nr_seq_envio_mens_p mprev_regra_cubo.nr_seq_envio_mens%type, nm_regra_p mprev_regra_cubo.nm_regra%type, cd_funcao_p hdm_log.cd_funcao%type, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Enviar sms ou e-mail da medicina preventiva
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[  ]  Objetos do dicionario [ X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
id_sms_w			              bigint;
qt_registros_w              bigint;
ds_erro_w                   hdm_log.ds_log%type;
ds_email_w                  compl_pessoa_fisica.ds_email%type;
ds_texto_w                  mprev_regra_envio_mensagem.ds_texto%type;
ds_titulo_w                 mprev_regra_envio_mensagem.ds_titulo%type;
ie_sms_mprev_w              pessoa_fisica_aux.ie_sms_mprev%type;
nr_ddd_celular_w            pessoa_fisica.nr_ddd_celular%type;
ie_email_mprev_w            pessoa_fisica_aux.ie_email_mprev%type;
nm_pessoa_fisica_w          pessoa_fisica.nm_pessoa_fisica%type;
ie_tipo_mensagem_w          mprev_regra_envio_mensagem.ie_tipo_mensagem%type;
ds_remetente_sms_w          varchar(80);
nr_telefone_celular_w       pessoa_fisica.nr_telefone_celular%type;


BEGIN

select count(*)
into STRICT   qt_registros_w
from   pessoa_fisica_aux
where  cd_pessoa_fisica = cd_pessoa_fisica_p;

if (qt_registros_w > 0) then
  select coalesce(ie_email_mprev, ''), coalesce(ie_sms_mprev, '')
  into STRICT   ie_email_mprev_w, ie_sms_mprev_w
  from   pessoa_fisica_aux
  where  cd_pessoa_fisica = cd_pessoa_fisica_p;

  select coalesce(nm_pessoa_fisica, ''), coalesce(nr_ddd_celular,0), coalesce(nr_telefone_celular, 0)
  into STRICT   nm_pessoa_fisica_w, nr_ddd_celular_w, nr_telefone_celular_w
  from   pessoa_fisica
  where  cd_pessoa_fisica = cd_pessoa_fisica_p;

  select ie_tipo_mensagem, coalesce(ds_titulo,''), coalesce(ds_texto, '')
  into STRICT   ie_tipo_mensagem_w, ds_titulo_w, ds_texto_w
  from   mprev_regra_envio_mensagem
  where  nr_sequencia = nr_seq_envio_mens_p;

  if (ie_tipo_mensagem_w = 'E' and ie_email_mprev_w = 'S') then --Tipo e-mail
      select coalesce(ds_email, '')
      into STRICT   ds_email_w
      from   compl_pessoa_fisica 
      where  cd_pessoa_fisica = cd_pessoa_fisica_p
      and    ie_tipo_complemento = 1; --Residencial
      ds_texto_w := replace_macro(ds_texto_w, '@dt_atual', clock_timestamp());
      ds_texto_w := replace_macro(ds_texto_w, '@nm_pessoa_fisica', nm_pessoa_fisica_w);
      ds_texto_w := substr(replace(ds_texto_w, '@ds_prog_camp_regra', nm_regra_p),1,2000);

      begin
          CALL Enviar_Email(ds_titulo_w, ds_texto_w, null, ds_email_w, nm_usuario_p, 'M');
      exception
      when others then
          ds_erro_w := SUBSTR('ds_assunto_p: ' || ds_titulo_w || '. ds_mensagem_p: ' || ds_texto_w || ' . ds_email_origem_p: ' || null 
                              || ' . ds_email_destino_p: ' || ds_email_w  || ' . nm_usuario_p: ' || nm_usuario_p || ' . ie_prioridade_p: ' || 'M' || ': ' || sqlerrm(SQLSTATE), 1, 2000);

          insert into hdm_log(
              nr_sequencia,
              dt_atualizacao,
              nm_usuario, 
              cd_funcao,
              ds_log)
          values (
              nextval('hdm_log_seq'),
              clock_timestamp(),
              nm_usuario_p,
              cd_funcao_p,
              ds_erro_w);
      end;

  elsif (ie_tipo_mensagem_w = 'S' and ie_sms_mprev_w = 'S' and nr_telefone_celular_w > 0) then --Tipo sms
      
      ds_texto_w := replace_macro(ds_texto_w, '@dt_atual', clock_timestamp());
      ds_texto_w := replace_macro(ds_texto_w, '@nm_pessoa_fisica', nm_pessoa_fisica_w);
      ds_texto_w := substr(replace(ds_texto_w, '@ds_prog_camp_regra', nm_regra_p),1,2000);

      begin
          ds_remetente_sms_w := obter_nome_estabelecimento(obter_estabelecimento_ativo());
          id_sms_w := wheb_sms.enviar_sms(ds_remetente_sms_w, concat(nr_ddd_celular_w, nr_telefone_celular_w), ds_texto_w, nm_usuario_p, id_sms_w);
      exception
      when others then
          ds_erro_w := SUBSTR('DS_REMETENTE_P: ' || ds_titulo_w || '. DS_DESTINATARIO_P: ' || nr_telefone_celular_w || ' . DS_MENSAGEM_p: ' || ds_texto_w
                              || ' . NM_USUARIO_P: ' || nm_usuario_p  || ' . ID_SMS_P: ' || nm_usuario_p || ': ' || sqlerrm(SQLSTATE), 1, 2000);
          INSERT INTO log_envio_sms(
              nr_sequencia,
              dt_atualizacao_nrec,
              nm_usuario_nrec,
              dt_atualizacao,
              nm_usuario,
              dt_envio,
              cd_agenda,
              nr_seq_agenda,
              nr_telefone,
              ds_mensagem,
              nr_atendimento,
              cd_pessoa_fisica,
              id_sms,
              nr_seq_evento,
              cd_pessoa_destino)
          VALUES (
              nextval('log_envio_sms_seq'),
              clock_timestamp(),
              nm_usuario_p,
              clock_timestamp(),
              nm_usuario_p,
              clock_timestamp(),
              NULL,
              NULL,
              nr_telefone_celular_w,
              SUBSTR(ds_texto_w,1,2000),
              NULL,
              cd_pessoa_fisica_p,
              id_sms_w,
              NULL,
              cd_pessoa_fisica_p);
      end;

  end if;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_enviar_email_sms ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nr_seq_envio_mens_p mprev_regra_cubo.nr_seq_envio_mens%type, nm_regra_p mprev_regra_cubo.nm_regra%type, cd_funcao_p hdm_log.cd_funcao%type, nm_usuario_p text) FROM PUBLIC;
