-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duv_gerar_segmento_tkn (nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_episodio_p episodio_paciente.nr_sequencia%type) AS $body$
DECLARE


  c01 CURSOR FOR
     SELECT
       clock_timestamp()             as ds_acidente,
       lp.ds_laudo         as ds_diag_imagem,
       ddia.ds_diagnostico as ds_diag_outros,
       substr(dd.ds_diagnostico,1,3000) as ds_diagnostico
     FROM laudo_paciente lp, atendimento_paciente ap, diagnostico_doenca dd
LEFT OUTER JOIN diag_doenca_inf_adic ddia ON (dd.nr_seq_interno = ddia.nr_seq_diag_doenca)
WHERE ap.nr_seq_episodio = nr_seq_episodio_p and ap.nr_atendimento  = lp.nr_atendimento and ap.nr_atendimento  = dd.nr_atendimento;

  c01_w c01%rowtype;


BEGIN
/*  c01_w := null;
  open c01;
  fetch c01 into c01_w;
  close c01;

  if c01_w.ds_diag_outros is null then
    c01_w.ds_diag_outros := c01_w.ds_diagnostico;
  end if;

  insert into duv_tkn(nr_sequencia,
                      dt_atualizacao,
                      nm_usuario,
                      dt_atualizacao_nrec,
                      nm_usuario_nrec,
                      nr_seq_mensagem,
                      ds_acidente,
                      ds_diag_imagem,
                      ds_diag_outros) values (duv_tkn_seq.nextval,
                                              sysdate,
                                              nm_usuario_p,
                                              sysdate,
                                              nm_usuario_p,
                                              nr_seq_mensagem_p,
                                              c01_w.ds_acidente,
                                              c01_w.ds_diag_imagem,
                                              c01_w.ds_diag_outros);

Estava gerando erro e a origem dos valores não fazia sentido.
Alterei para de momento gerar o segmento em branco.*/
insert into duv_tkn(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_mensagem,
	ds_acidente,
	ds_diag_imagem,
	ds_diag_outros)
values (nextval('duv_tkn_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_mensagem_p,
	null,
	null,
	null);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duv_gerar_segmento_tkn (nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_episodio_p episodio_paciente.nr_sequencia%type) FROM PUBLIC;

