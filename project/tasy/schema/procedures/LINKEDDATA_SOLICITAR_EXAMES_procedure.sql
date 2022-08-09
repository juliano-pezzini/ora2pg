-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE linkeddata_solicitar_exames ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, cd_perfil_ativo_p bigint, nm_usuario_p text, nr_sequencia_out INOUT bigint, nr_seq_template_p bigint, nr_seq_reg_template_p bigint, nr_seq_linked_data_p bigint ) AS $body$
DECLARE


  nm_usuario_w                    pedido_exame_externo.nm_usuario%type;
  cd_perfil_ativo_w               pedido_exame_externo.cd_perfil_ativo%type;
  nr_sequencia_w                  pedido_exame_externo.nr_sequencia%type;
  cd_profissional_w               pedido_exame_externo.cd_profissional%type;

  ds_update_w varchar(1000);

  c_tabela_ehr_linked CURSOR FOR
    SELECT a.nr_seq_template
          ,b.nr_sequencia
      FROM ehr_template_conteudo a
          ,linked_data           b
     WHERE a.nr_seq_linked_data = b.nr_sequencia
       AND b.nr_sequencia = nr_seq_linked_data_p
       AND a.nr_seq_template = nr_seq_template_p

     
UNION
 
          
    SELECT DISTINCT a.nr_seq_template
                   ,b.nr_sequencia
      FROM ehr_template_conteudo a
          ,linked_data           b
     WHERE a.nr_seq_linked_data = b.nr_sequencia
       AND b.nr_sequencia = nr_seq_linked_data_p
       AND a.nr_seq_template IN (SELECT a.nr_seq_template_cluster
                                   FROM ehr_template_conteudo a
                                  WHERE a.nr_seq_template = nr_seq_template_p);

BEGIN

  if (coalesce(nm_usuario_p::text, '') = '' or nm_usuario_p = '') then
    select obter_usuario_ativo 
    into STRICT nm_usuario_w 
;
  else
    nm_usuario_w := nm_usuario_p;
  end if;

  if (coalesce(cd_perfil_ativo_p::text, '') = '' or cd_perfil_ativo_p = '') then
    select obter_perfil_ativo
    into STRICT cd_perfil_ativo_w
;
  else
    cd_perfil_ativo_w := cd_perfil_ativo_p;
  end if;

  select obter_pf_usuario(nm_usuario_w, 'C')
  into STRICT cd_profissional_w
;

  select nextval('pedido_exame_externo_seq')
  into STRICT nr_sequencia_w
;

  insert into pedido_exame_externo(
        nr_sequencia,
        dt_atualizacao,
        nm_usuario, 
        cd_pessoa_fisica, 
        nr_atendimento, 
        cd_profissional, 
        dt_solicitacao, 
        dt_atualizacao_nrec,
        nm_usuario_nrec, 
        cd_perfil_ativo, 
        ie_situacao,
        ie_nivel_atencao,
        ie_ficha_unimed,
        dt_liberacao
  ) values (
        nr_sequencia_w, 
        clock_timestamp(),
        nm_usuario_w, 
        cd_pessoa_fisica_p, 
        nr_atendimento_p, 
        cd_profissional_w, 
        clock_timestamp(), 
        clock_timestamp(),
        nm_usuario_w, 
        cd_perfil_ativo_w, 
        'A',
        'T',
        'N',
        clock_timestamp()
  );

  FOR r_tabela_ehr_linked IN c_tabela_ehr_linked LOOP
    ds_update_w := '  UPDATE ehr_linked_' || r_tabela_ehr_linked.nr_seq_template || '_' || r_tabela_ehr_linked.nr_sequencia || ' t
                         SET t.nr_seq_pedido = ' || nr_sequencia_w  || '
                       WHERE t.nr_seq_reg_template = ' || nr_seq_reg_template_p || '
                         AND t.nm_usuario = ''' || nm_usuario_p || '''';
    EXECUTE ds_update_w;
  END LOOP;

nr_sequencia_out := nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE linkeddata_solicitar_exames ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, cd_perfil_ativo_p bigint, nm_usuario_p text, nr_sequencia_out INOUT bigint, nr_seq_template_p bigint, nr_seq_reg_template_p bigint, nr_seq_linked_data_p bigint ) FROM PUBLIC;
