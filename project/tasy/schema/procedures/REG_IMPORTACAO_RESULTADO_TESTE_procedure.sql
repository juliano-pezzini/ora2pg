-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_importacao_resultado_teste (nr_seq_intencao_uso_p bigint, nm_usuario_p text, ie_result_p text, ds_result_p text, nr_seq_os_p bigint, cd_versao_p text, it_id_p text, dt_execucao_p timestamp) AS $body$
DECLARE


  nr_sequencia_w      reg_integrated_test_result.nr_sequencia%type;
  nr_seq_ciclo_w      reg_integrated_test_result.nr_seq_ciclo%type;
  cd_versao_w         reg_integrated_test_cont.cd_versao%type;
  nr_seq_it_w         reg_integrated_test.nr_sequencia%type;
  nr_seq_step_w       reg_acao_teste.nr_sequencia%type;

  c01 CURSOR(nr_seq_w  bigint) FOR
    SELECT p.nr_sequencia, p.nr_seq_tc
      from reg_integrated_test_pend p,
           reg_integrated_test_cont c
     where p.nr_seq_intencao_uso = nr_seq_intencao_uso_p
       and p.nr_seq_controle = c.nr_sequencia
       and c.cd_versao = coalesce(cd_versao_p, cd_versao_w)
       and coalesce(c.dt_fim::text, '') = ''
       and c.ie_situacao = 'A'
       and p.nr_seq_integrated_test = nr_seq_w;

  r01 c01%rowtype;


BEGIN

  if coalesce(cd_versao_p::text, '') = '' then

    select max(cd_versao)
      into STRICT cd_versao_w
      from reg_integrated_test_cont
     where coalesce(dt_fim::text, '') = ''
       and ie_situacao = 'A'
       and nr_seq_intencao_uso = nr_seq_intencao_uso_p;

  end if;

  select nr_sequencia
    into STRICT nr_seq_it_w
    from reg_integrated_test
   where nr_seq_intencao_uso = nr_seq_intencao_uso_p
     and upper(cd_test_id) = upper(it_id_p);

  for r01 in c01(nr_seq_it_w) loop
  
    select count(1) + 1
      into STRICT nr_seq_ciclo_w
      from reg_integrated_test_result
     where nr_seq_pendencia = r01.nr_sequencia;

    select nextval('reg_integrated_test_result_seq')
      into STRICT nr_sequencia_w
;

    select max(nr_sequencia)
      into STRICT nr_seq_step_w
      from reg_acao_teste
     where nr_seq_caso_teste = r01.nr_seq_tc;

    insert into reg_integrated_test_result(ds_resultado,
       dt_atualizacao,
       dt_atualizacao_nrec,
       dt_execucao,
       ie_resultado,
       nm_usuario,
       nm_usuario_nrec,
       nr_seq_ciclo,
       nr_seq_pendencia,
       nr_seq_acao_teste,
       nr_sequencia)
    values (ds_result_p,
       clock_timestamp(),
       clock_timestamp(),
       coalesce(dt_execucao_p, clock_timestamp()),
       ie_result_p,
       nm_usuario_p,
       nm_usuario_p,
       nr_seq_ciclo_w,
       r01.nr_sequencia,
       nr_seq_step_w,
       nr_sequencia_w);

    if (nr_seq_os_p IS NOT NULL AND nr_seq_os_p::text <> '') then
    
      insert into reg_integrated_test_so(dt_atualizacao,
         dt_atualizacao_nrec,
         nm_usuario,
         nm_usuario_nrec,
         nr_seq_int_test_res,
         nr_seq_service_order,
         nr_sequencia)
      values (clock_timestamp(),
         clock_timestamp(),
         nm_usuario_p,
         nm_usuario_p,
         nr_sequencia_w,
         nr_seq_os_p,
         nextval('reg_integrated_test_so_seq'));

    end if;
  
  end loop;

  commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_importacao_resultado_teste (nr_seq_intencao_uso_p bigint, nm_usuario_p text, ie_result_p text, ds_result_p text, nr_seq_os_p bigint, cd_versao_p text, it_id_p text, dt_execucao_p timestamp) FROM PUBLIC;
