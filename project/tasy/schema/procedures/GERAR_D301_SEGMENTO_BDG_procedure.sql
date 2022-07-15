-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_d301_segmento_bdg (nr_seq_dataset_p bigint, nm_usuario_p text) AS $body$
DECLARE


  c01 CURSOR FOR
     SELECT ap.nr_atendimento,
              null   cd_tipo_diagnostico
      from d301_dataset_envio   d3,
      atendimento_paciente        ap
      where d3.nr_atendimento      = ap.nr_atendimento
      and   d3.nr_sequencia          = nr_seq_dataset_p;

  c01_w c01%rowtype;

  c02 CURSOR(nr_atendimento_p  diagnostico_doenca.nr_atendimento%type) FOR
     SELECT  dd.cd_doenca cd_cid_trat_1,
             dd.ie_lado,
             dd.ie_tipo_diagnostico,
             dd.cd_doenca
     from diagnostico_doenca        dd,
          medic_diagnostico_doenca  mdd,
          classificacao_diagnostico cd
     where dd.nr_atendimento           = nr_atendimento_p
     and   mdd.nr_atendimento          = nr_atendimento_p
     and   dd.cd_doenca                = mdd.cd_doenca
     and   cd.nr_sequencia             = mdd.nr_seq_classificacao
      and   coalesce(dd.dt_inativacao::text, '') = ''
      and   (dd.dt_liberacao IS NOT NULL AND dd.dt_liberacao::text <> '')
     and   'S'			       = OBTER_SE_CLASSIF_DIAG_301(cd.nr_sequencia,'BEH',dd.DT_DIAGNOSTICO)
     --and   upper(cd.ds_classificacao)  = 'BEHANDLUNGSDIAGNOSE'
     and   coalesce(dd.cd_doenca_superior::text, '') = '';

  c02_w c02%rowtype;


  c03 CURSOR(nr_atendimento_p  diagnostico_doenca.nr_atendimento%type,
                    cd_doenca_p       diagnostico_doenca.cd_doenca%type) FOR
      SELECT null         cd_cid_trat_2, -- sem definição
             null         cd_tipo_diagnostico, -- sem definição
             (SELECT mc.cd_medico_convenio
             from medico_convenio mc
             where mc.cd_pessoa_fisica = dd.cd_medico) cd_membro_equipe
      from diagnostico_doenca        dd,
           medic_diagnostico_doenca  mdd,
           classificacao_diagnostico cd
      where dd.nr_atendimento           = nr_atendimento_p
      and   mdd.nr_atendimento          = nr_atendimento_p
      and   dd.cd_doenca                = mdd.cd_doenca
      and   cd.nr_sequencia             = mdd.nr_seq_classificacao
      and   coalesce(dd.dt_inativacao::text, '') = ''
      and   (dd.dt_liberacao IS NOT NULL AND dd.dt_liberacao::text <> '')
      and   'S'			        = OBTER_SE_CLASSIF_DIAG_301(cd.nr_sequencia,'BEH',dd.DT_DIAGNOSTICO)
      --and   upper(cd.ds_classificacao)  = 'BEHANDLUNGSDIAGNOSE'
      and   dd.cd_doenca_superior = cd_doenca_p;

  c03_w c03%rowtype;

  nr_seq_301_loc_trat_1_w        c301_conversao_dados.ds_valor_tasy%type;
  nr_seq_301_confdiag_trat_1_w   c301_conversao_dados.ds_valor_tasy%type;
  nr_seq_301_local_trat_2_w      c301_conversao_dados.ds_valor_tasy%type;
  nr_seq_301_confdiag_trat_2_w   c301_conversao_dados.ds_valor_tasy%type;


BEGIN
  open c01;
  fetch c01 into c01_w;
  close c01;
    --Pegar doença primária
    for c02_w in c02(c01_w.nr_atendimento) loop
        nr_seq_301_loc_trat_1_w       :=obter_conversao_301('C301_16_LOCALIZACAO',null,1372,c02_w.ie_lado,'I');
        nr_seq_301_confdiag_trat_1_w  :=obter_conversao_301('C301_17_CONFIANCA_DIAG',null,1372,c02_w.ie_tipo_diagnostico,'I');

        --Pegar doença secundaria
        open c03(c01_w.nr_atendimento,c02_w.cd_doenca);
        fetch c03 into c03_w;
        loop
           nr_seq_301_local_trat_2_w    :=null;--obter_conversao_301('C301_16_LOCALIZACAO',null,1372,c03_w.ie_lado,'I');
           nr_seq_301_confdiag_trat_2_w :=null;--obter_conversao_301('C301_17_CONFIANCA_DIAG',null,1372,c03_w.ie_tipo_diagnostico,'I');
          insert into d301_segmento_bdg(nr_sequencia,
                                        dt_atualizacao,
                                        nm_usuario,
                                        dt_atualizacao_nrec,
                                        nm_usuario_nrec,
                                        nr_seq_dataset,
                                        cd_cid_trat_1,
                                        nr_seq_301_loc_trat_1,
                                        nr_seq_301_confdiag_trat_1,
                                        cd_cid_trat_2,
                                        nr_seq_301_loc_trat_2,
                                        nr_seq_301_confdiag_trat_2,
                                        cd_tipo_diagnostico,
                                        cd_membro_equipe) values (nextval('d301_segmento_bdg_seq'),
                                                                  clock_timestamp(),
                                                                  nm_usuario_p,
                                                                  clock_timestamp(),
                                                                  nm_usuario_p,
                                                                  nr_seq_dataset_p,
                                                                  c02_w.cd_cid_trat_1,
                                                                  nr_seq_301_loc_trat_1_w,
                                                                  nr_seq_301_confdiag_trat_1_w,
                                                                  c03_w.cd_cid_trat_2,
                                                                  nr_seq_301_local_trat_2_w,
                                                                  nr_seq_301_confdiag_trat_2_w,
                                                                  c01_w.cd_tipo_diagnostico,
                                                                  c03_w.cd_membro_equipe  );

        fetch c03 into c03_w;
        EXIT WHEN NOT FOUND; /* apply on c03 */
        end loop;
        close c03;

    end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_d301_segmento_bdg (nr_seq_dataset_p bigint, nm_usuario_p text) FROM PUBLIC;

