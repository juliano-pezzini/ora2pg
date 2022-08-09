-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duv_gerar_segmento_wbe (nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_episodio_p episodio_paciente.nr_sequencia%type) AS $body$
DECLARE


  c01 CURSOR FOR
    SELECT
      NULL IE_DESTRO_CANHOTO,
      NULL IE_LESAO_CABECA_ANEXO,
      NULL IE_LESAO_JOELHO_ANEXO,
      NULL IE_LESAO_OMBRO_ANEXO,
      NULL IE_LESAO_QUEIMADURA_ANEXO,
      NULL NR_ISS
;
  c01_w c01%rowtype;


BEGIN
  c01_w := null;
  open c01;
  fetch c01 into c01_w;
  close c01;
  insert into DUV_WBE(NR_SEQUENCIA,
                      DT_ATUALIZACAO,
                      NM_USUARIO,
                      DT_ATUALIZACAO_NREC,
                      NM_USUARIO_NREC,
                      NR_SEQ_MENSAGEM,
                      IE_DESTRO_CANHOTO,
                      IE_LESAO_CABECA_ANEXO,
                      IE_LESAO_JOELHO_ANEXO,
                      IE_LESAO_OMBRO_ANEXO,
                      IE_LESAO_QUEIMADURA_ANEXO,
                      NR_ISS) values (nextval('duv_vav_seq'),
                                      clock_timestamp(),
                                      nm_usuario_p,
                                      clock_timestamp(),
                                      nm_usuario_p,
                                      nr_seq_mensagem_p,
                                      c01_w.IE_DESTRO_CANHOTO,
                                      c01_w.IE_LESAO_CABECA_ANEXO,
                                      c01_w.IE_LESAO_JOELHO_ANEXO,
                                      c01_w.IE_LESAO_OMBRO_ANEXO,
                                      c01_w.IE_LESAO_QUEIMADURA_ANEXO,
                                      c01_w.NR_ISS);


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duv_gerar_segmento_wbe (nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_episodio_p episodio_paciente.nr_sequencia%type) FROM PUBLIC;
