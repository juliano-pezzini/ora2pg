-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gqa_gerar_protocolo_pac ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, nr_seq_protocolo_p gqa_pendencia.nr_sequencia%type, liberar_protocolo text, nr_seq_pac_acao_p gqa_protocolo_pac.nr_seq_pac_acao%type, nr_sequencia_currval INOUT gqa_protocolo_pac.nr_sequencia%type ) AS $body$
DECLARE


ds_nome_protocolo_w       gqa_pendencia.ds_pendencia%type;
cd_profissional_w         pessoa_fisica.cd_pessoa_fisica%type;
nr_seq_w                  gqa_protocolo_pac.nr_sequencia%type;
nm_usuario_w              usuario.nm_usuario%type;


BEGIN
  select obter_usuario_ativo into STRICT nm_usuario_w;

  select (obter_pf_usuario(nm_usuario_w, 'C'))::numeric  into STRICT cd_profissional_w;

  select ds_pendencia into STRICT ds_nome_protocolo_w from gqa_pendencia where nr_sequencia = nr_seq_protocolo_p;

  select nextval('gqa_protocolo_pac_seq') into STRICT nr_seq_w;

  insert into gqa_protocolo_pac(
    cd_pessoa_fisica,
    cd_profissional,
    ds_justificativa,
    ds_nome_protocolo,
    dt_atualizacao,
    dt_atualizacao_nrec,
    dt_inativacao,
    dt_inclusao,
    dt_liberacao,
    dt_termino,
    ie_situacao,
    nm_usuario,
    nm_usuario_inativacao,
    nm_usuario_liberacao,
    nm_usuario_nrec,
    nm_usuario_termino,
    nr_atendimento,
    nr_seq_motivo,
    nr_seq_pac_etapa,
    nr_seq_pac_etapa_termino,
    nr_seq_pac_acao,
    nr_seq_protocolo,
    nr_sequencia
  ) values (
    cd_pessoa_fisica_p,
    cd_profissional_w,
    null,
    ds_nome_protocolo_w,
    clock_timestamp(),
    clock_timestamp(),
    null,
    clock_timestamp(),
    null,
    null,
    'A',
    nm_usuario_w,
    null,
    null,
    nm_usuario_w,
    null,
    nr_atendimento_p,
    null,
    null,
    null,
    nr_seq_pac_acao_p,
    nr_seq_protocolo_p,
    nr_seq_w
  );

  CALL gqa_gerar_protocolo_etapa_pac(nr_seq_protocolo_p, nr_seq_w);

  if ((liberar_protocolo IS NOT NULL AND liberar_protocolo::text <> '') and liberar_protocolo = 'S') then
    CALL gqa_liberar_protocolo(nr_seq_w);
  end if;

  nr_sequencia_currval := nr_seq_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gqa_gerar_protocolo_pac ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, nr_seq_protocolo_p gqa_pendencia.nr_sequencia%type, liberar_protocolo text, nr_seq_pac_acao_p gqa_protocolo_pac.nr_seq_pac_acao%type, nr_sequencia_currval INOUT gqa_protocolo_pac.nr_sequencia%type ) FROM PUBLIC;

