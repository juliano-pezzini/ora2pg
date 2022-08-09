-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_d301_segmento_prz (nr_seq_dataset_p bigint, nm_usuario_p text) AS $body$
DECLARE


  c01 CURSOR FOR
      SELECT distinct ap.nr_atendimento,
                      ci.cd_procedimento_princ,
                      ci.ie_origem_proced,
                      ci.ie_lado,
                      to_char(ci.dt_inicio_cirurgia,'yyyymmdd') dt_procedimento
       from d301_dataset_envio        d3,
            atendimento_paciente      ap,
            cirurgia                  ci
       where d3.nr_atendimento     = ap.nr_atendimento
       and   d3.nr_sequencia          = nr_seq_dataset_p   --1728
       and   ci.nr_atendimento        = ap.nr_atendimento;

  c01_w c01%rowtype;

  c02 CURSOR(cd_procedimento_princ_p   cirurgia.cd_procedimento_princ%type,
                     ie_origem_proced_p        cirurgia.ie_origem_proced%type ) FOR

       SELECT pr.cd_procedimento_loc  cd_procedimento_ops
       from procedimento    pr
       where pr.cd_procedimento  = cd_procedimento_princ_p
       and   pr.ie_origem_proced = ie_origem_proced_p;

  c02_w c02%rowtype;


  c03 CURSOR(nr_atendimento_p   atendimento_paciente.nr_atendimento%type) FOR

      SELECT coalesce(to_char(pf.dt_obito,'yyyymmdd'),'J')ie_doacao_orgao_vivo
      from atendimento_paciente ap,
               atend_doacao         ad,
                pessoa_fisica        pf
      where ap.nr_atendimento    = ad.nr_atendimento
      and   ap.cd_pessoa_fisica  = pf.cd_pessoa_fisica
      and   ap.nr_atendimento    = nr_atendimento_p
      and   coalesce(pf.dt_obito::text, '') = '';

  c03_w c03%rowtype;

  nr_seq_301_loc_proc_w          c301_conversao_dados.ds_valor_tasy%type;



BEGIN
  open c01;
  fetch c01 into c01_w;
  loop

    --Procedimentos
    open c02(c01_w.cd_procedimento_princ,c01_w.ie_origem_proced);
    fetch c02 into c02_w;
    loop

        nr_seq_301_loc_proc_w     :=obter_conversao_301('C301_16_LOCALIZACAO',null,1372,c01_w.ie_lado,'I');

        --Pacientes doadores
        open c03(c01_w.nr_atendimento);
        fetch c03 into c03_w;
        loop

          insert into d301_segmento_prz(nr_sequencia,
                                        dt_atualizacao,
                                        nm_usuario,
                                        dt_atualizacao_nrec,
                                        nm_usuario_nrec,
                                        nr_seq_dataset,
                                        cd_procedimento_ops,
                                        nr_seq_301_loc_proc,
                                        dt_procedimento,
                                        ie_doacao_orgao_vivo) values (nextval('d301_segmento_prz_seq'),
                                                                                         clock_timestamp(),
                                                                                         nm_usuario_p,
                                                                                         clock_timestamp(),
                                                                                         nm_usuario_p,
                                                                                         nr_seq_dataset_p,
                                                                                         c02_w.cd_procedimento_ops,
                                                                                         (somente_numero_char(nr_seq_301_loc_proc_w))::numeric ,
                                                                                         c01_w.dt_procedimento,
                                                                                         c03_w.ie_doacao_orgao_vivo);

        fetch c03 into c03_w;
        EXIT WHEN NOT FOUND; /* apply on c03 */
        end loop;
        close c03;

    fetch c02 into c02_w;
    EXIT WHEN NOT FOUND; /* apply on c02 */
    end loop;
    close c02;

  fetch c01 into c01_w;
  EXIT WHEN NOT FOUND; /* apply on c01 */
  end loop;
  close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_d301_segmento_prz (nr_seq_dataset_p bigint, nm_usuario_p text) FROM PUBLIC;
