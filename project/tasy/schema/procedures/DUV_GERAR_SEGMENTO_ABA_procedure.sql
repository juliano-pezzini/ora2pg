-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duv_gerar_segmento_aba (nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_episodio_p episodio_paciente.nr_sequencia%type) AS $body$
DECLARE


  c01 CURSOR FOR
   SELECT
      substr(pf.nm_pessoa_fisica,1,120) as nm_medico_conta,
      substr(cpf.ds_endereco,1,46)      as ds_endereco_med_conta,
      pa.cd_pais_dale_uv     			as cd_pais,
      substr(cpf.ds_municipio,1,30)     as ds_cidade,
      cpf.cd_cep             			as cd_cep_endereco,
      pf.nr_telefone_celular 			as ds_telefone,
      null                   			as nr_instituicao_medico_conta
    FROM pais pa, atendimento_paciente ap
LEFT OUTER JOIN conta_paciente cp ON (ap.nr_atendimento = cp.nr_atendimento)
LEFT OUTER JOIN pessoa_fisica pf ON (cp.cd_medico_conta = pf.cd_pessoa_fisica)
LEFT OUTER JOIN compl_pessoa_fisica cpf ON (pf.cd_pessoa_fisica = cpf.cd_pessoa_fisica)
WHERE ap.nr_seq_episodio  = nr_seq_episodio_p    and cpf.nr_seq_pais     = pa.nr_sequencia order by cp.cd_medico_conta asc nulls last;

  c01_w c01%rowtype;


BEGIN
  c01_w := null;
  open c01;
  fetch c01 into c01_w;
  close c01;

  insert into duv_aba(nr_sequencia,
                      dt_atualizacao,
                      nm_usuario,
                      dt_atualizacao_nrec,
                      nm_usuario_nrec,
                      nr_seq_mensagem,
                      nm_medico_conta,
                      ds_endereco_med_conta,
                      cd_cep_endereco,
                      ds_cidade,
                      cd_pais,
                      nr_instituicao_medico_conta,
                      ds_telefone) values (nextval('duv_aba_seq'),
                                           clock_timestamp(),
                                           nm_usuario_p,
                                           clock_timestamp(),
                                           nm_usuario_p,
                                           nr_seq_mensagem_p,
                                           c01_w.nm_medico_conta,
                                           c01_w.ds_endereco_med_conta,
                                           c01_w.cd_cep_endereco,
                                           c01_w.ds_cidade,
                                           c01_w.cd_pais,
                                           c01_w.nr_instituicao_medico_conta,
                                           c01_w.ds_telefone);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duv_gerar_segmento_aba (nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_episodio_p episodio_paciente.nr_sequencia%type) FROM PUBLIC;
