-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_enf_sumario ( nr_sequencia_p sumario_enf_conf_list.nr_sequencia%type, nm_usuario_p sumario_enf_conf_list.nm_usuario%type, cd_pessoa_fisica_p sumario_enf_conf_list.cd_pessoa_fisica%type, dt_entrada_p sumario_enf_conf_list.dt_entrada%type, dt_alta_p sumario_enf_conf_list.dt_alta%type, nm_enfermeira_p sumario_enf_conf_list.nm_enfermeira%type, nm_tipo_sumario_p sumario_enf_conf_list.nm_tipo_sumario%type, nr_atendimento_p sumario_enf_conf_list.nr_atendimento%type) AS $body$
DECLARE


nr_seq_enf_conf_w bigint := null;


BEGIN

    update  sumario_enfermagem
    set     nm_usuario_lib = nm_usuario_p
    where   nr_sequencia = nr_sequencia_p;

  select max(nr_sequencia)
  into STRICT nr_seq_enf_conf_w
  from sumario_enf_conf_list
  where nr_seq_sum_enf = nr_sequencia_p;

  if nr_seq_enf_conf_w > 0 then
  
    update sumario_enf_conf_list
    set ie_remand = 'N',
        ds_remand  = NULL
    where nr_sequencia = nr_seq_enf_conf_w;

    update sumario_enfermagem
    set dt_liberacao = clock_timestamp(),
        nm_usuario_lib = nm_usuario_p,
        ie_remand = 'N',
        ds_remand  = NULL
    where nr_sequencia = nr_sequencia_p;

  else
    select nextval('sumario_enf_conf_list_seq') 
    into STRICT nr_seq_enf_conf_w 
;

    insert into sumario_enf_conf_list(
      nr_sequencia,
      nr_seq_sum_enf,
      dt_atualizacao,
      nm_usuario,
      dt_atualizacao_nrec,
      nm_usuario_nrec,
      cd_pessoa_fisica,
      dt_entrada,
      dt_alta,
      nm_enfermeira,
      nm_tipo_sumario,
      nr_atendimento)
    values (
      nr_seq_enf_conf_w,
      nr_sequencia_p,
      clock_timestamp(),
      nm_usuario_p,
      clock_timestamp(),
      nm_usuario_p,
      cd_pessoa_fisica_p,
      dt_entrada_p,
      dt_alta_p,
      obter_nome_pf(nm_enfermeira_p),
      obter_valor_dominio(10187, nm_tipo_sumario_p),
      nr_atendimento_p);

     update sumario_enfermagem
     set ie_remand = 'N',
        ds_remand  = NULL
     where nr_sequencia = nr_sequencia_p;
  end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_enf_sumario ( nr_sequencia_p sumario_enf_conf_list.nr_sequencia%type, nm_usuario_p sumario_enf_conf_list.nm_usuario%type, cd_pessoa_fisica_p sumario_enf_conf_list.cd_pessoa_fisica%type, dt_entrada_p sumario_enf_conf_list.dt_entrada%type, dt_alta_p sumario_enf_conf_list.dt_alta%type, nm_enfermeira_p sumario_enf_conf_list.nm_enfermeira%type, nm_tipo_sumario_p sumario_enf_conf_list.nm_tipo_sumario%type, nr_atendimento_p sumario_enf_conf_list.nr_atendimento%type) FROM PUBLIC;

