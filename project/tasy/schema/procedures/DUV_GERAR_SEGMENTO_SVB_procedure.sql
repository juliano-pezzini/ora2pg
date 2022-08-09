-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duv_gerar_segmento_svb (nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_episodio_p episodio_paciente.nr_sequencia%type) AS $body$
DECLARE


  c01 CURSOR FOR
    SELECT null pr_2grau_a,
           null pr_2grau_b,
           null pr_3grau,
           null pr_4grau,
           null pr_total
;


  c01_w c01%rowtype;


BEGIN
  c01_w := null;
  open c01;
  fetch c01 into c01_w;
  close c01;
   insert into duv_svb(nr_sequencia,
                                  dt_atualizacao,
                                  nm_usuario,
                                  dt_atualizacao_nrec,
                                  nm_usuario_nrec,
                                  nr_seq_mensagem,
                                  pr_2grau_a,
                                  pr_2grau_b,
                                  pr_3grau,
                                  pr_4grau,
                                  pr_total) values (nextval('duv_svb_seq'),
                                                           clock_timestamp(),
                                                           nm_usuario_p,
                                                           clock_timestamp(),
                                                           nm_usuario_p,
                                                           nr_seq_mensagem_p,
                                                           c01_w.pr_2grau_a,
                                                           c01_w.pr_2grau_b,
                                                           c01_w.pr_3grau,
                                                           c01_w.pr_4grau,
                                                           c01_w.pr_total);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duv_gerar_segmento_svb (nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_episodio_p episodio_paciente.nr_sequencia%type) FROM PUBLIC;
