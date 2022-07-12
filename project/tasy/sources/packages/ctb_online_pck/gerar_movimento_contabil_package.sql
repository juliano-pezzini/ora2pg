-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ctb_online_pck.gerar_movimento_contabil (cd_tipo_lote_contabil_p bigint, cd_estabelecimento_p bigint, dt_referencia_p timestamp, nm_usuario_p text, nr_seq_nota_fiscal_p nota_fiscal.nr_sequencia%type default null) AS $body$
DECLARE


  nr_lote_contabil_w      lote_contabil.nr_lote_contabil%type;
  dt_referencia_w         ctb_mes_ref.dt_referencia%type := dt_referencia_p;
  current_setting('ctb_online_pck.cd_tipo_lote_contabil_w')::ctb_regra_estab_dif.cd_tipo_lote_contabil%type tipo_lote_contabil.cd_tipo_lote_contabil%type := cd_tipo_lote_contabil_p;
  cd_estab_exclusivo_w    ctb_param_lote_nf.cd_estab_exclusivo%type := cd_estabelecimento_p;
  nr_seq_movimento_w      ctb_movimento.nr_sequencia%type;
  dt_movimento_dd_w       ctb_movimento.dt_movimento%type;
  nr_seq_mes_ref_w        ctb_mes_ref.nr_sequencia%type;
  cd_classificacao_w      conta_contabil.cd_classificacao%type;
  nr_seq_movto_partida_w  ctb_movimento.nr_seq_movto_partida%type;
  nr_agrup_sequencial_w   ctb_movimento.nr_agrup_sequencial%type;
  nr_seq_ctb_doc_w        ctb_documento.nr_sequencia%type;
  nr_documento_w          nota_fiscal.nr_sequencia%type;
  nr_seq_centro_custo_w   ctb_movto_centro_custo.nr_sequencia%type;

BEGIN

  nr_lote_contabil_w := ctb_online_pck.get_lote_contabil(  current_setting('ctb_online_pck.cd_tipo_lote_contabil_w')::ctb_regra_estab_dif.cd_tipo_lote_contabil%type,
                                            cd_estab_exclusivo_w,
                                            dt_referencia_w,
                                            nm_usuario_p,
                                            null,
                                            null,
                                            nr_seq_nota_fiscal_p);

  dt_movimento_dd_w      := trunc(clock_timestamp(),'dd');
  nr_seq_movto_partida_w := null;

  /* Removido pois esta informacao sera gerada posteriormente na reatualizacao do saldo */


  -- nr_agrup_sequencial_w   := ctb_online_pck.get_agrup_sequencial(obter_empresa_estab(cd_estab_exclusivo_w), dt_referencia_p);


  select b.nr_sequencia
  into STRICT   nr_seq_mes_ref_w
  from   lote_contabil a,
          ctb_mes_ref   b
  where  a.nr_Seq_mes_ref = b.nr_sequencia
  and    a.nr_lote_contabil = nr_lote_contabil_w;

  for idx_movimento in 1 .. current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil.count loop
      begin

          nr_documento_w := current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].nr_documento;

          if (current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].vl_movimento < 0) then
              begin
                  if (current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ie_debito_credito = 'C') then
                      begin
                          current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ie_debito_credito := 'D';
                      end;
                  else
                      begin
                          current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ie_debito_credito := 'C';
                      end;
                  end if;
              end;
          end if;

          select  max(a.cd_classificacao)
          into STRICT    cd_classificacao_w
          from    conta_contabil a
          where   a.cd_conta_contabil = current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_conta_contabil;

          select max(c.nr_sequencia)
          into STRICT   nr_seq_movimento_w
          from   ctb_movimento c
          where  c.dt_movimento = coalesce(current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].dt_movimento,dt_movimento_dd_w)
          and    c.nr_lote_contabil = nr_lote_contabil_w
          and    coalesce(c.cd_estabelecimento,0) = coalesce(current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_estabelecimento,0)
          and    coalesce(c.cd_historico,0) = coalesce(current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_historico,0)
          and    coalesce(c.nr_seq_agrupamento,0) = coalesce(current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].nr_seq_agrupamento,0)
          and    coalesce(c.ds_compl_historico,'X') = coalesce(current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ds_compl_historico,'X')
          and    (((coalesce(c.cd_conta_credito,'X') = coalesce(current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_conta_contabil,'X'))
                  and (current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ie_debito_credito = 'C'))
                  or ((coalesce(c.cd_conta_debito,'X') = coalesce(current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_conta_contabil,'X'))
                  and (current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ie_debito_credito = 'D')))
          and    coalesce(c.nr_documento,'X') = coalesce(current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].nr_documento,'X')
          and    coalesce(c.ie_origem_documento,0) = coalesce(current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ie_origem_documento,0);

          if (coalesce(nr_seq_movimento_w,0) <> 0) then

              if (coalesce(nr_seq_movto_partida_w,0) = 0) then
                  begin
                      nr_seq_movto_partida_w := nr_seq_movimento_w;
                  end;
              end if;

              update ctb_movimento
              set    vl_movimento    = vl_movimento + current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].vl_movimento,
                      ds_consistencia = coalesce(current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ds_consistencia,ds_consistencia),
                      ie_validacao    = current_setting('ctb_online_pck.ie_validacao_w')::ctb_movimento.ie_validacao%type,
                      dt_atualizacao  = clock_timestamp(),
                      nm_usuario      = nm_usuario_p
              where  nr_sequencia = nr_seq_movimento_w;
          else

              /* Seleciona PROXIMO numero de sequencia do MOVIMENTO */


              select nextval('ctb_movimento_seq') into STRICT nr_seq_movimento_w;

              insert into ctb_movimento(nr_sequencia,
                    nr_lote_contabil,
                    nr_seq_mes_ref,
                    dt_movimento,
                    vl_movimento,
                    dt_atualizacao,
                    nm_usuario,
                    cd_historico,
                    cd_conta_debito,
                    cd_conta_credito,
                    ds_compl_historico,
                    nr_seq_agrupamento,
                    ie_revisado,
                    cd_estabelecimento,
                    ds_consistencia,
                    dt_atualizacao_nrec,
                    nm_usuario_nrec,
                    cd_classif_debito,
                    cd_classif_credito,
                    dt_revisao,
                    nm_usuario_revisao,
                    nr_agrup_sequencial,
                    nr_documento,
                    ie_origem_documento,
                    nr_seq_movto_partida,
                    ie_status_concil,
                    ie_status_origem,
                    nr_seq_classif_movto,
                    ie_intercompany,
                    cd_estab_intercompany,
                    nr_seq_proj_rec,
                    ie_validacao)
              values (nr_seq_movimento_w,
                    nr_lote_contabil_w,
                    nr_seq_mes_ref_w,
                    current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].dt_movimento,
                    current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].vl_movimento,
                    clock_timestamp(),
                    nm_usuario_p,
                    current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_historico,
                    CASE WHEN current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ie_debito_credito='D' THEN                          current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_conta_contabil  ELSE null END ,
                    CASE WHEN current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ie_debito_credito='C' THEN                           current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_conta_contabil  ELSE null END ,
                    current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ds_compl_historico,
                    current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].nr_seq_agrupamento,
                    'N',
                    current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_estabelecimento,
                    current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ds_consistencia,
                    clock_timestamp(),
                    nm_usuario_p,
                    CASE WHEN current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ie_debito_credito='D' THEN                           cd_classificacao_w  ELSE 0 END ,
                    CASE WHEN current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ie_debito_credito='C' THEN                           cd_classificacao_w  ELSE 0 END ,
                    clock_timestamp(),
                    nm_usuario_p,
                    nr_agrup_sequencial_w,
                    current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].nr_documento,
                    current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ie_origem_documento,
                    nr_seq_movto_partida_w,
                    'NC',
                    'SO',
                    current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].nr_seq_classif_movto,
                    current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ie_intercompany,
                    current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_estab_intercompany,
                    current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].nr_seq_proj_rec,
                    current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ie_validacao);
          end if;

          /* INSERE CENTRO DE CUSTO se tiver */


          if (coalesce(current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_centro_custo,0) <> 0) then

              begin
                  select nr_sequencia
                  into STRICT   nr_seq_centro_custo_w
                  from   ctb_movto_centro_custo
                  where  nr_seq_movimento = nr_seq_movimento_w
                  and    cd_centro_custo = current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_centro_custo;
              exception
                  when others then
                      nr_seq_centro_custo_w := 0;
              end;

              if (nr_seq_centro_custo_w != 0) then

                  update ctb_movto_centro_custo
                  set    vl_movimento   = vl_movimento + current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].vl_movimento,
                          dt_atualizacao = clock_timestamp(),
                          nm_usuario     = nm_usuario_p
                  where  nr_sequencia = nr_seq_centro_custo_w;

              else
                  begin
                      insert into ctb_movto_centro_custo(nr_sequencia,
                            nr_seq_movimento,
                            cd_centro_custo,
                            dt_atualizacao,
                            nm_usuario,
                            vl_movimento,
                            pr_rateio)
                      values (nextval('ctb_movto_centro_custo_seq'),
                            nr_seq_movimento_w,
                            current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_centro_custo,
                            clock_timestamp(),
                            nm_usuario_p,
                            abs(current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].vl_movimento),
                            0);
                  end;
              end if;
              CALL ctb_atualizar_rateio_movto(nr_seq_movimento_w,nm_usuario_p);
          end if;

          -- BUSCA CTB_DOCUMENTO

          select max(nr_sequencia)
          into STRICT   nr_seq_ctb_doc_w
          from   ctb_documento
          where  nr_documento = current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].nr_documento
          and    cd_estabelecimento = current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_estabelecimento
          and    nm_tabela = current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].nm_tabela
          and    nm_atributo = current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].nm_atributo
          and    nr_seq_info = current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].nr_seq_info
          and    vl_movimento = current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].vl_movimento
          and    cd_tipo_lote_contabil = cd_tipo_lote_contabil_p;

          PERFORM set_config('ctb_online_pck.cd_sequencia_parametro_ww', current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_sequencia_parametro, false);

          if (coalesce(nr_seq_ctb_doc_w,0) <> 0) then
              CALL ctb_online_pck.vincular_ctb_movto_doc(nr_seq_movimento_w,nr_seq_ctb_doc_w,'V',nm_usuario_p);
          end if;

          CALL ctb_online_pck.ctb_atualizar_saldo_movto(nr_seq_movimento_w,'S',nm_usuario_p, 'N');

      end;
  end loop;

  -- Seta os documentos da nota fiscal para contabilizados

  update  ctb_documento
  set     ie_situacao_ctb  = 'C',
          nr_lote_contabil = nr_lote_contabil_w
  where   nr_documento = nr_documento_w
  and     cd_estabelecimento = cd_estabelecimento_p
  and     cd_tipo_lote_contabil = cd_tipo_lote_contabil_p;

  current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil.delete;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_online_pck.gerar_movimento_contabil (cd_tipo_lote_contabil_p bigint, cd_estabelecimento_p bigint, dt_referencia_p timestamp, nm_usuario_p text, nr_seq_nota_fiscal_p nota_fiscal.nr_sequencia%type default null) FROM PUBLIC;
