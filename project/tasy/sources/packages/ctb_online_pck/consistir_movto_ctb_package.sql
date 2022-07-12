-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ctb_online_pck.consistir_movto_ctb (nr_lote_contabil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


  ie_centro_situacao_w       centro_custo.ie_situacao%type;
  cd_estab_centro_w          centro_custo.cd_estabelecimento%type;
  cd_estab_lote_w            lote_contabil.cd_estabelecimento%type;
  dt_ref_lote_w              lote_contabil.dt_referencia%type;
  vl_total_centro_w          ctb_movto_centro_custo.vl_movimento%type;
  vl_total_debito_w          ctb_movimento.vl_movimento%type;
  vl_total_credito_w         ctb_movimento.vl_movimento%type;
  ie_tipo_conta_w            conta_contabil.ie_tipo%type;
  cd_estab_conta_w           conta_contabil_estab.cd_estabelecimento%type;
  ie_situacao_conta_w        conta_contabil.ie_situacao%type;
  cd_grupo_conta_w           conta_contabil.cd_grupo%type;
  cd_empresa_conta_w         conta_contabil.cd_empresa%type;
  cd_empresa_mes_ref_w       ctb_mes_ref.cd_empresa%type;
  cd_empresa_historico_w     conta_contabil.cd_empresa%type;
  ie_situacao_historico_w    historico_padrao.ie_situacao%type;
  ie_tipo_centro_w           centro_custo.ie_tipo%type;
  cd_empresa_centro_w        conta_contabil.cd_empresa%type;
  dt_inicio_vigencia_conta_w conta_contabil.dt_inicio_vigencia%type;
  dt_fim_vigencia_conta_w    conta_contabil.dt_fim_vigencia%type;
  ds_consistencia_movto_w    ctb_movimento.ds_consistencia%type;
  ie_movto_centro_estab_w    varchar(1);
  ie_consistir_data_movto_w  varchar(1);
  qt_movto_sem_centro_w      bigint;
  qt_movto_com_centro_w      bigint;

BEGIN

  ie_movto_centro_estab_w   := coalesce(obter_valor_param_usuario(923,68,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p),'S');
  ie_consistir_data_movto_w := coalesce(obter_valor_param_usuario(923,70,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p),'N');
  vl_total_debito_w         := 0;
  vl_total_credito_w        := 0;
  ds_consistencia_movto_w   := null;

  select max(a.cd_estabelecimento),
          max(a.dt_referencia),
          max(b.cd_empresa)
  into STRICT   cd_estab_lote_w,
          dt_ref_lote_w,
          cd_empresa_mes_ref_w
  from   lote_contabil a,
          ctb_mes_ref   b
  where  a.nr_seq_mes_ref = b.nr_sequencia
  and    a.nr_lote_contabil = nr_lote_contabil_p;

  for idx_movimento in 1 .. current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil.count loop
      begin

          vl_total_centro_w := 0;

          if (coalesce(current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_centro_custo,
                  0) <> 0) then
              begin
                  select max(a.ie_situacao),
                          max(a.cd_estabelecimento),
                          max(a.ie_tipo),
                          obter_empresa_estab(max(a.cd_estabelecimento))
                  into STRICT   ie_centro_situacao_w,
                          cd_estab_centro_w,
                          ie_tipo_centro_w,
                          cd_empresa_centro_w
                  from   centro_custo a
                  where  a.cd_centro_custo = current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_centro_custo;

                  /*centro de custo inativo*/


                  if (ie_centro_situacao_w = 'I') then
                      begin
                          /*Mensagem - Movimento com centro de resultado inativo.*/


                          ds_consistencia_movto_w := substr(wheb_mensagem_pck.get_texto(280992),1,255);
                          PERFORM set_config('ctb_online_pck.ie_validacao_w', '17', false);
                      end;
                  end if;

                  /*Centro de custo de estabelecimento diferente do lote*/


                  if (cd_estab_lote_w <> cd_estab_centro_w) and (ie_movto_centro_estab_w = 'S') then
                      begin
                          /* Mensagem - Movimento com centro de resultado de estabelecimento diferente.*/


                          ds_consistencia_movto_w := substr(wheb_mensagem_pck.get_texto(280993),1,255);
                          PERFORM set_config('ctb_online_pck.ie_validacao_w', '18', false);
                      end;
                  end if;

                  /*Centro de custo do tipo titulo*/


                  if (ie_tipo_centro_w = 'T') then
                      begin
                          /* Mensagem - Movimento com centro de resultado totalizador.*/


                          ds_consistencia_movto_w := substr(wheb_mensagem_pck.get_texto(280991),1,255);
                          PERFORM set_config('ctb_online_pck.ie_validacao_w', '16', false);
                      end;
                  end if;

                  /*Centro de custo de outra empresa*/


                  if (cd_empresa_mes_ref_w <> cd_empresa_centro_w) then
                      begin
                          /*Mensagem - Centro de custo nao permitido, pertence a outra empresa.*/


                          ds_consistencia_movto_w := substr(wheb_mensagem_pck.get_texto(351249),1,255);
                          PERFORM set_config('ctb_online_pck.ie_validacao_w', '22', false);
                      end;
                  end if;

                  vl_total_centro_w := vl_total_centro_w + current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].vl_movimento;

              end;
          end if;

          /*Dia do movimento e maior que o dia do lote*/


          if (current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].dt_movimento > dt_ref_lote_w) and (ie_consistir_data_movto_w = 'S') then
              begin
                  /*Mensagem - Dia do movimento e maior que o dia do lote*/


                  ds_consistencia_movto_w := substr(wheb_mensagem_pck.get_texto(280973),1,255);
                  PERFORM set_config('ctb_online_pck.ie_validacao_w', '8', false);
              end;
          end if;

          /*Lancamento com valor diferente da somatoria dos centros de custo*/


          if (vl_total_centro_w <> current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].vl_movimento) then
              begin
                  /*Mensagem - Lancamento com valor diferente da somatoria dos centros de custo.*/


                  ds_consistencia_movto_w := substr(wheb_mensagem_pck.get_texto(280947),1,255);
                  PERFORM set_config('ctb_online_pck.ie_validacao_w', '5', false);
              end;
          end if;

          select count(1)
          into STRICT   qt_movto_sem_centro_w
          from   conta_contabil a
          where  a.cd_conta_contabil = current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_conta_contabil
          and    a.ie_centro_custo = 'S'
          and    not exists (SELECT 1 from ctb_movto_centro_custo b where b.nr_seq_movimento = current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].nr_sequencia);

          /*Lancamento sem centro de custo. A conta contabil exige informacao do centro de custo.*/


          if (qt_movto_sem_centro_w <> 0) then
              begin
                  /*Mensagem - Lancamento sem a apropriacao por centro de resultado. Esta conta contabil exige informacao do centro de custo.*/


                  ds_consistencia_movto_w := substr(wheb_mensagem_pck.get_texto(280945),1,255);
                  PERFORM set_config('ctb_online_pck.ie_validacao_w', '3', false);
              end;
          end if;

          select count(1)
          into STRICT   qt_movto_com_centro_w
          from   conta_contabil a
          where  a.cd_conta_contabil = current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_conta_contabil
          and    a.ie_centro_custo = 'N'
          and    exists (SELECT 1 from ctb_movto_centro_custo b where b.nr_seq_movimento = current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].nr_sequencia);

          /*Lancamento com centro de custo. A conta contabil nao permite centro de custo*/


          if (qt_movto_com_centro_w <> 0) then
              begin
                  /*Mensagem - Lancamento com a apropriacao indevida por centro de resultado. Esta conta contabil nao requer informacao do centro de custo.*/


                  ds_consistencia_movto_w := substr(wheb_mensagem_pck.get_texto(280946),1,255);
                  PERFORM set_config('ctb_online_pck.ie_validacao_w', '4', false);
              end;
          end if;

          /*if    (nvl(movimento_contabil_w(idx_movimento).cd_conta_debito, 'X') <> 'X') then
                  begin
                  cd_conta_contabil_movto_w:= movimento_contabil_w(idx_movimento).cd_conta_debito;
                  end;
          elsif (nvl(movimento_contabil_w(idx_movimento).cd_conta_credito, 'X') <> 'X') then
                  begin
                  cd_conta_contabil_movto_w:= movimento_contabil_w(idx_movimento).cd_conta_credito;
                  end;
          end if;*/


          select a.ie_tipo,
                  b.cd_estabelecimento,
                  a.ie_situacao,
                  a.cd_grupo,
                  a.cd_empresa,
                  a.dt_inicio_vigencia,
                  a.dt_fim_vigencia
          into STRICT   ie_tipo_conta_w,
                  cd_estab_conta_w,
                  ie_situacao_conta_w,
                  cd_grupo_conta_w,
                  cd_empresa_conta_w,
                  dt_inicio_vigencia_conta_w,
                  dt_fim_vigencia_conta_w
          FROM conta_contabil a
LEFT OUTER JOIN conta_contabil_estab b ON (a.cd_conta_contabil = b.cd_conta_contabil)
WHERE ((b.cd_estabelecimento = cd_estab_lote_w) or (b.cd_estabelecimento IS NOT NULL AND b.cd_estabelecimento::text <> '')) and a.cd_conta_contabil = current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_conta_contabil   LIMIT 1;

          /*A conta contabil e do tipo totalizadora*/


          if (ie_tipo_conta_w = 'T') then
              begin
                  /*Mensagem - A conta contabil e do tipo totalizadora*/


                  ds_consistencia_movto_w := substr(wheb_mensagem_pck.get_texto(280983),1,255);
                  PERFORM set_config('ctb_online_pck.ie_validacao_w', '9', false);
              end;
          end if;

          /*A conta contabil e de outro estabelecimento*/


          if (cd_estab_conta_w <> cd_estab_lote_w) and (cd_estab_conta_w IS NOT NULL AND cd_estab_conta_w::text <> '') then
              begin
                  /*Mensagem - A conta contabil e de outro estabelecimento*/


                  ds_consistencia_movto_w := substr(wheb_mensagem_pck.get_texto(280984),1,255);
                  PERFORM set_config('ctb_online_pck.ie_validacao_w', '10', false);
              end;
          end if;

          /*Conta contabil inativa*/


          if (ie_situacao_conta_w = 'I') then
              begin
                  /*Mensagem - A conta contabil esta inativa.*/


                  ds_consistencia_movto_w := substr(wheb_mensagem_pck.get_texto(280985),1,255);
                  PERFORM set_config('ctb_online_pck.ie_validacao_w', '11', false);
              end;
          end if;

          /*Conta contabil sem grupo*/


          if (coalesce(cd_grupo_conta_w::text, '') = '') then
              begin
                  /*Mensagem - Falta informar o grupo no cadastro da conta.*/


                  ds_consistencia_movto_w := substr(wheb_mensagem_pck.get_texto(280986),1,255);
                  PERFORM set_config('ctb_online_pck.ie_validacao_w', '12', false);
              end;
          end if;

          /*Conta contabil de outra empresa*/


          if (cd_empresa_mes_ref_w <> cd_empresa_conta_w) then
              begin
                  /*Mensagem - A conta contabil e de outra empresa.*/


                  ds_consistencia_movto_w := substr(wheb_mensagem_pck.get_texto(280987),1,255);
                  PERFORM set_config('ctb_online_pck.ie_validacao_w', '13', false);
              end;
          end if;

          select a.cd_empresa,
                  a.ie_situacao
          into STRICT   cd_empresa_historico_w,
                  ie_situacao_historico_w
          from   historico_padrao a
          where  a.cd_historico = current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].cd_historico;

          /*Historico padrao de outra empresa*/


          if (cd_empresa_mes_ref_w <> cd_empresa_historico_w) then
              begin
                  /*Mensagem - Este historico e de outra empresa.*/


                  ds_consistencia_movto_w := substr(wheb_mensagem_pck.get_texto(280988),1,255);
                  PERFORM set_config('ctb_online_pck.ie_validacao_w', '14', false);
              end;
          end if;

          /*Historico padrao inativo*/


          if (ie_situacao_historico_w = 'I') then
              begin
                  /*Mensagem - Este historico esta inativo.*/


                  ds_consistencia_movto_w := substr(wheb_mensagem_pck.get_texto(280989),1,255);
                  PERFORM set_config('ctb_online_pck.ie_validacao_w', '15', false);
              end;
          end if;

          /*Conta contabil nao esta vigente*/


          if (dt_inicio_vigencia_conta_w > current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].dt_movimento or
              coalesce(dt_fim_vigencia_conta_w,clock_timestamp()) < current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].dt_movimento) then
              begin
                  /*Mensagem - A conta contabil esta fora da data de vigencia.*/


                  ds_consistencia_movto_w := substr(wheb_mensagem_pck.get_texto(455973),1,255);
                  PERFORM set_config('ctb_online_pck.ie_validacao_w', '27', false);
              end;
          end if;

          if (current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ie_debito_credito = 'D') then
              begin
                  vl_total_debito_w := vl_total_debito_w + current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].vl_movimento;
              end;
          else
              begin
                  vl_total_credito_w := vl_total_credito_w + current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].vl_movimento;
              end;
          end if;

          if (coalesce(ds_consistencia_movto_w,'X') <> 'X') then
              begin
                  current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ds_consistencia := ds_consistencia_movto_w;
              end;
          end if;

      end;
  end loop;

  /*Lancamento com diferenca de debito e credito*/


  if (vl_total_credito_w <> vl_total_debito_w) then
      begin
          /*Mensagem - Total do debito e diferente do total do credito. Debito: valor Credito: valor*/


          ds_consistencia_movto_w := substr(wheb_mensagem_pck.get_texto(280940) ||
                                            wheb_mensagem_pck.get_texto(280941) ||
                                            vl_total_debito_w ||
                                            wheb_mensagem_pck.get_texto(280942) ||
                                            vl_total_credito_w ||
                                            chr(13) ||
                                            chr(10),
                                            1,255);
      end;
  end if;

  for idx_movimento in 1 .. current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil.count loop
      begin

          if (coalesce(ds_consistencia_movto_w,'X') <> 'X') then
              begin
                  current_setting('ctb_online_pck.movimento_contabil_w')::vetor_w_movimento_contabil[idx_movimento].ds_consistencia := ds_consistencia_movto_w;
              end;
          end if;

      end;
  end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_online_pck.consistir_movto_ctb (nr_lote_contabil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;