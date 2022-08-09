-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_insert_prs_test_plan (nm_usuario_p text, nr_seq_intencao_uso_p bigint, cd_versao_p text) AS $body$
DECLARE


  nr_seq_plan_w           bigint;
  qt_items_w              bigint;
  nr_seq_controle_plano_w reg_plano_teste_controle.nr_sequencia%type;

  c01 CURSOR FOR
    SELECT t.nr_sequencia, t.nr_seq_product, rctf.cd_funcao
      FROM reg_product_requirement a, reg_caso_teste t
LEFT OUTER JOIN reg_caso_teste_funcao rctf ON (t.nr_sequencia = rctf.nr_seq_caso_teste)
WHERE t.nr_seq_product = a.nr_sequencia  and t.ie_tipo_execucao = 'A' and t.ie_situacao = 'A' and a.ie_situacao = 'A' and a.nr_sequencia in (SELECT w.nr_seq_product
              from w_test_plan_pending_prs w
             where w.nm_usuario = nm_usuario_p
               and w.nr_seq_intencao_uso = nr_seq_intencao_uso_p) and t.nr_sequencia in (
				select w.nr_seq_tc
				from w_test_plan_pending_prs w
				where w.nm_usuario = nm_usuario_p
				and w.nr_seq_intencao_uso = nr_seq_intencao_uso_p);

  c02 CURSOR FOR
    SELECT t.nr_sequencia, t.nr_seq_product, rctf.cd_funcao
      FROM reg_caso_teste t, reg_product_requirement a
LEFT OUTER JOIN reg_funcao_pr rctf ON (a.nr_sequencia = rctf.nr_seq_product_req)
WHERE t.nr_seq_product = a.nr_sequencia  and t.ie_tipo_execucao = 'M' and rctf.ie_escopo_teste = 'S' and t.ie_situacao = 'A' and a.ie_situacao = 'A' and a.nr_sequencia in (SELECT w.nr_seq_product
              from w_test_plan_pending_prs w
             where w.nm_usuario = nm_usuario_p
               and w.nr_seq_intencao_uso = nr_seq_intencao_uso_p) and t.nr_sequencia in (
				select w.nr_seq_tc
				from w_test_plan_pending_prs w
				where w.nm_usuario = nm_usuario_p
				and w.nr_seq_intencao_uso = nr_seq_intencao_uso_p);

  r01 c01%rowtype;
  r02 c02%rowtype;


BEGIN

  select count(1)
    into STRICT qt_items_w
    from w_test_plan_pending_prs w
   where w.nr_seq_intencao_uso = nr_seq_intencao_uso_p
     and w.nm_usuario = nm_usuario_p;

  if (qt_items_w = 0) then
    CALL wheb_mensagem_pck.exibir_mensagem_abort(1108231);
  end if;

  select nextval('reg_plano_teste_controle_seq')
    into STRICT nr_seq_controle_plano_w
;

  insert into reg_plano_teste_controle(nr_sequencia,
     dt_atualizacao,
     nm_usuario,
     dt_atualizacao_nrec,
     nm_usuario_nrec,
     ie_situacao,
     cd_versao,
     dt_inicio_plano,
     dt_fim_plano,
     nr_seq_intencao_uso)
  values (nr_seq_controle_plano_w,
     clock_timestamp(),
     nm_usuario_p,
     clock_timestamp(),
     nm_usuario_p,
     'A',
     cd_versao_p,
     clock_timestamp(),
     null,
     nr_seq_intencao_uso_p);

  for r01 in c01 loop

    insert into reg_tc_pendencies(cd_funcao,
       ds_motivo_exclusao,
       ds_version,
       dt_atualizacao,
       dt_atualizacao_nrec,
       ie_status,
       ie_tipo_mudanca,
       nm_usuario,
       nm_usuario_nrec,
       nr_seq_controle_plano,
       nr_seq_intencao_uso,
       nr_seq_pr,
       nr_seq_tc,
       nr_sequencia)
    values (r01.cd_funcao,
       null,
       cd_versao_p,
       clock_timestamp(),
       clock_timestamp(),
       'P',
       null,
       nm_usuario_p,
       nm_usuario_p,
       nr_seq_controle_plano_w,
       nr_seq_intencao_uso_p,
       r01.nr_seq_product,
       r01.nr_sequencia,
       nextval('reg_tc_pendencies_seq'));

  end loop;

  for r02 in c02 loop

    insert into reg_tc_pendencies(cd_funcao,
       ds_motivo_exclusao,
       ds_version,
       dt_atualizacao,
       dt_atualizacao_nrec,
       ie_status,
       ie_tipo_mudanca,
       nm_usuario,
       nm_usuario_nrec,
       nr_seq_controle_plano,
       nr_seq_intencao_uso,
       nr_seq_pr,
       nr_seq_tc,
       nr_sequencia)
    values (r02.cd_funcao,
       null,
       cd_versao_p,
       clock_timestamp(),
       clock_timestamp(),
       'P',
       null,
       nm_usuario_p,
       nm_usuario_p,
       nr_seq_controle_plano_w,
       nr_seq_intencao_uso_p,
       r02.nr_seq_product,
       r02.nr_sequencia,
       nextval('reg_tc_pendencies_seq'));

  end loop;

  delete from w_test_plan_pending_prs w
   where w.nm_usuario = nm_usuario_p
     and w.nr_seq_intencao_uso = nr_seq_intencao_uso_p;

  commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_insert_prs_test_plan (nm_usuario_p text, nr_seq_intencao_uso_p bigint, cd_versao_p text) FROM PUBLIC;
