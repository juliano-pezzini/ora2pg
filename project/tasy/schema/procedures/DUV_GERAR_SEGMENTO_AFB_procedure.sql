-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duv_gerar_segmento_afb (nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_episodio_p episodio_paciente.nr_sequencia%type) AS $body$
DECLARE


  c01 CURSOR FOR
   SELECT
      null ie_pode_trabalhar,
      null dt_inicio_afastamento,
      null dt_prev_retorno,
      null ie_mais_3_meses
;

  c01_w c01%rowtype;


BEGIN
  c01_w := null;
  open c01;
  fetch c01 into c01_w;
  close c01;

  insert into duv_afb(nr_sequencia,
                      dt_atualizacao,
                      nm_usuario,
                      dt_atualizacao_nrec,
                      nm_usuario_nrec,
                      nr_seq_mensagem,
                      ie_pode_trabalhar,
                      dt_inicio_afastamento,
                      dt_prev_retorno,
                      ie_mais_3_meses) values (nextval('duv_afb_seq'),
                                               clock_timestamp(),
                                               nm_usuario_p,
                                               clock_timestamp(),
                                               nm_usuario_p,
                                               nr_seq_mensagem_p,
                                               c01_w.ie_pode_trabalhar,
                                               c01_w.dt_inicio_afastamento,
                                               c01_w.dt_prev_retorno,
                                               c01_w.ie_mais_3_meses);


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duv_gerar_segmento_afb (nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_episodio_p episodio_paciente.nr_sequencia%type) FROM PUBLIC;
