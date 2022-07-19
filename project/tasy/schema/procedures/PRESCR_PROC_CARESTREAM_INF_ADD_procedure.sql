-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE prescr_proc_carestream_inf_add (nr_acesso_dicon_p text, ie_achado_critico_p text, cd_medico_p text, dt_laudo_p timestamp, ds_inf_adicional_p text) AS $body$
DECLARE


  --  Variáveis que serão utilizadas para recuperar informações da prescrição e laudo.
  nr_seq_laudo_w      bigint;
  nr_atendimento_w    bigint;
  nr_precricao_w      bigint;
  nr_seq_prescricao_w integer;
  cd_pessoa_fisica_w  varchar(10);
  nm_usuario_w        varchar(15);

  -- Variável que será utilizada para recuperar a sequencia da informação add.
  nr_sequencia_w bigint;

BEGIN

  -- Recupero o código do laudo que
  select max(a.nr_sequencia),
         d.nr_atendimento,
         b.nr_prescricao,
         b.nr_sequencia,
         d.cd_pessoa_fisica
  into STRICT   nr_seq_laudo_w,
         nr_atendimento_w,
         nr_precricao_w,
         nr_seq_prescricao_w,
         cd_pessoa_fisica_w
  from   laudo_paciente a
  inner  join prescr_procedimento b
  on     a.nr_prescricao = b.nr_prescricao
  and    a.nr_seq_prescricao = b.nr_sequencia
  inner  join prescr_medica c
  on     b.nr_prescricao = c.nr_prescricao
  inner  join atendimento_paciente d
  on     c.nr_atendimento = d.nr_atendimento
  where  b.nr_acesso_dicom = nr_acesso_dicon_p
  group  by d.nr_atendimento,
            b.nr_prescricao,
            b.nr_sequencia,
            d.cd_pessoa_fisica;

  -- recupero o código que será utilizado como sequencia da tabela de inf_adic
  select nextval('prescr_proced_inf_adic_seq')
  into STRICT   nr_sequencia_w
;

  -- A partir dos dados do médico, recupero o código do usuario
  select b.nm_usuario
  into STRICT   nm_usuario_w
  from   medico a
  inner  join usuario b
  on     a.cd_pessoa_fisica = b.cd_pessoa_fisica
  where  a.cd_pessoa_fisica = cd_medico_p
  and    b.ie_situacao = 'A'  LIMIT 1;

  -- realizo o insert na tabela de dados adicionais
  insert into prescr_proced_inf_adic(nr_sequencia,
     dt_atualizacao,
     nm_usuario,
     dt_atualizacao_nrec,
     nm_usuario_nrec,
     dt_registro,
     nr_prescricao,
     nr_seq_prescricao,
     ds_informacao,
     cd_pessoa_fisica,
     ie_situacao,
     dt_liberacao,
     nr_seq_laudo,
     ie_achado_critico)
  values ( nr_sequencia_w,
      dt_laudo_p,
      nm_usuario_w,
      dt_laudo_p,
      nm_usuario_w,
      dt_laudo_p,
      nr_precricao_w,
      nr_seq_prescricao_w,
      ds_inf_adicional_p,
      cd_medico_p,
      'A',
      clock_timestamp(),
      nr_seq_laudo_w,
      ie_achado_critico_p
    );

  commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE prescr_proc_carestream_inf_add (nr_acesso_dicon_p text, ie_achado_critico_p text, cd_medico_p text, dt_laudo_p timestamp, ds_inf_adicional_p text) FROM PUBLIC;

