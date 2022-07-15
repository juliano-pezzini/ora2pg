-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_d301_segmento_rbg (nr_seq_dataset_p bigint, nm_usuario_p text) AS $body$
DECLARE


  c01 CURSOR FOR
    SELECT
      null nr_seq_301_medida_reab,
      0 nr_seq_301_sugest_trat,
      null nr_seq_301_sugest_instit,
      nr_seq_dataset_p nr_seq_dataset,
      null cd_ik_hosp_sugestao
;

  c01_w c01%rowtype;


BEGIN
  open c01;
  fetch c01 into c01_w;
  close c01;

  insert into d301_segmento_rbg(nr_sequencia,
                                dt_atualizacao,
                                nm_usuario,
                                dt_atualizacao_nrec,
                                nm_usuario_nrec,
                                nr_seq_301_medida_reab,
                                nr_seq_301_sugest_trat,
                                nr_seq_301_sugest_instit,
                                nr_seq_dataset,
                                cd_ik_hosp_sugestao) values (nextval('d301_segmento_rbg_seq'),
                                                             clock_timestamp(),
                                                             nm_usuario_p,
                                                             clock_timestamp(),
                                                             nm_usuario_p,
                                                             c01_w.nr_seq_301_medida_reab,
                                                             c01_w.nr_seq_301_sugest_trat,
                                                             c01_w.nr_seq_301_sugest_instit,
                                                             c01_w.nr_seq_dataset,
                                                             c01_w.cd_ik_hosp_sugestao);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_d301_segmento_rbg (nr_seq_dataset_p bigint, nm_usuario_p text) FROM PUBLIC;

