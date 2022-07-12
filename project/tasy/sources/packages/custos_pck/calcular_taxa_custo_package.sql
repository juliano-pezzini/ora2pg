-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE custos_pck.calcular_taxa_custo ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, nm_usuario_p text, nr_seq_tabela_p bigint) AS $body$
DECLARE




qt_disponibilidade_w           double precision    := 0;
vl_taxa_custo_w                double precision    := 0;
cd_centro_controle_w           integer       := 0;
cd_empresa_w                   bigint;
cd_natureza_gasto_w            numeric(20)      := 0;
cd_tabela_orc_w                integer       := 0;
cd_tabela_cap_w                integer       := 0;
nr_sequencia_w                 taxa_custo_nat.nr_sequencia%type := 0;
ie_natureza_gasto_w            varchar(2);
vl_taxa_origem_w               double precision    := 0;
vl_recebido_w                  double precision    := 0;
nr_sequencia_cc_w              taxa_custo_cc_orig.nr_sequencia%type := 0;
nr_seq_ng_w                    bigint;
ie_capac_calc_ociosidade_w     smallint;
vl_taxa_teorica_w              double precision    := 0;
vl_taxa_pratica_w              double precision    := 0;
vl_taxa_atend_w                double precision    := 0;
qt_contador_w                  bigint      := 0;
nr_seq_tabela_orc_w            bigint;
cd_estabelecimento_w           bigint;
nr_seq_tabela_capac_w          bigint;
nr_posicao_vetor_w             integer;
nr_sequencia_nivel_w           capac_centro_controle.nr_sequencia_nivel%type;
cd_tipo_tabela_custo_w         tabela_custo.cd_tipo_tabela_custo%type;

c01 CURSOR FOR
        SELECT  nextval('taxa_custo_nat_seq') nr_sequencia,
                x.cd_estabelecimento,
                x.cd_centro_controle,
                x.cd_grupo_natureza_gasto,
                x.nr_seq_gng,
                x.cd_natureza_gasto,
                x.nr_seq_ng,
                x.vl_orcado,
                x.vl_recebido,
                x.ie_natureza_gasto,
                x.qt_disponibilidade
        from (  SELECT  a.cd_estabelecimento,
                        a.cd_centro_controle,
                        c.cd_grupo_natureza_gasto,
                        c.nr_sequencia nr_seq_gng,
                        b.cd_natureza_gasto,
                        b.nr_sequencia nr_seq_ng,
                        sum(coalesce(a.vl_avista,0) + coalesce(a.vl_receb_distrib,0)) vl_orcado,
                        sum(coalesce(a.vl_receb_distrib,0)) vl_recebido,
                        b.ie_natureza_gasto,
                        (   select  sum(qt_disponibilidade)
                            from    capac_centro_controle
                            where   nr_seq_tabela      = nr_seq_tabela_capac_w
                            and     nr_sequencia_nivel = 4
                            and     cd_estabelecimento = a.cd_estabelecimento
                            and     cd_centro_controle = a.cd_centro_controle)
                        qt_disponibilidade
                from    grupo_natureza_gasto c,
                        natureza_gasto b,
                        orcamento_custo a
                where   a.nr_seq_tabela         = nr_seq_tabela_orc_w
                and     a.nr_seq_ng             = b.nr_sequencia
                and     a.cd_estabelecimento    = coalesce(b.cd_estabelecimento, a.cd_estabelecimento)
                and     b.nr_seq_gng            = c.nr_sequencia
                and     c.nr_sequencia          = b.nr_seq_gng
                and     a.cd_estabelecimento    = coalesce(c.cd_estabelecimento,a.cd_estabelecimento)
                and     b.cd_empresa            = c.cd_empresa
                and     substr(cus_obter_se_gng_taxa(a.cd_estabelecimento, c.nr_sequencia, a.cd_centro_controle),1,1) = 'S'
                and     substr(cus_obter_se_ng_taxa(a.cd_estabelecimento, c.nr_sequencia, b.nr_sequencia, a.cd_centro_controle),1,1) = 'S'
                and     exists ( select  1
                                from    tabela_custo_acesso_v tca
                                where   tca.nr_sequencia        = nr_seq_tabela_p
                                and     tca.cd_empresa          = c.cd_empresa
                                and     tca.cd_estabelecimento  = a.cd_estabelecimento)
                group by
                         a.cd_estabelecimento,
                         a.cd_centro_controle,
                         c.nr_sequencia,
                         c.cd_grupo_natureza_gasto,
                         b.cd_natureza_gasto,
                         b.nr_sequencia,
                         b.ie_natureza_gasto) 
        x;

type vetor_orcamento_custo is table of c01%rowtype index by integer;
vetor_orcamento_custo_w    vetor_orcamento_custo;

type vetor_taxa_custo_cc_orig is table of taxa_custo_cc_orig%rowtype index by integer;
vetor_taxa_custo_cc_orig_w  vetor_taxa_custo_cc_orig;

c02 CURSOR(
          cd_estabelecimento_pc         orcamento_distribuido.cd_estabelecimento%type,
          nr_seq_tabela_pc              orcamento_distribuido.nr_seq_tabela%type,
          nr_seq_ng_dest_pc             orcamento_distribuido.nr_seq_ng_dest%type,
          cd_centro_controle_dest_pc    orcamento_distribuido.cd_centro_controle_dest%type
          ) FOR
          SELECT   x.cd_centro_controle,
                   x.vl_distribuido,
                   nextval('taxa_custo_cc_orig_seq') nr_sequencia
          from (   SELECT  cd_centro_controle,
                           sum(vl_distribuido) vl_distribuido
                   from    orcamento_distribuido a
                   where   a.cd_estabelecimento       = cd_estabelecimento_pc
                   and     a.nr_seq_tabela            = nr_seq_tabela_pc
                   and     a.nr_seq_ng_dest           = nr_seq_ng_dest_pc
                   and     a.cd_centro_controle_dest  = cd_centro_controle_dest_pc
                   group by cd_centro_controle)
    x;

type vetor_orcamento_distribuido is table of c02%rowtype index by integer;
vetor_orcamento_distribuido_w    vetor_orcamento_distribuido;

type vetor_taxa_custo_nat is table of taxa_custo_nat%rowtype index by integer;
vetor_taxa_custo_nat_w  vetor_taxa_custo_nat;

BEGIN
CALL gravar_processo_longo(wheb_mensagem_pck.get_texto(299128) || qt_contador_w,'CALCULAR_TAXA_CUSTO',qt_contador_w);
cd_empresa_w    := obter_empresa_estab(cd_estabelecimento_p);

begin
select  (max(ie_capac_calc_ociosidade))::numeric
into STRICT    ie_capac_calc_ociosidade_w
from    parametro_custo
where   cd_estabelecimento = cd_estabelecimento_p;
exception when others then
        ie_capac_calc_ociosidade_w:= 1;
end;

begin
select  cd_tabela_parametro,
        nr_seq_tabela_param
into STRICT    cd_tabela_orc_w,
        nr_seq_tabela_orc_w
from    tabela_parametro
where   nr_seq_tabela    = nr_seq_tabela_p
and     nr_seq_parametro = 1;
exception when no_data_found then
        /*'Falta informar a tabela de Orcamento do mes no Parametro 1 do Cadastro da Tabela de Taxa de custo!*/


        CALL wheb_mensagem_pck.exibir_mensagem_abort(184213);
end;
qt_contador_w   := qt_contador_w + 1;

CALL gravar_processo_longo(wheb_mensagem_pck.get_texto(299128) || qt_contador_w,'CALCULAR_TAXA_CUSTO',qt_contador_w);
CALL atualizar_util_tabela(  cd_estabelecimento_p,
                        cd_tabela_custo_p,
                        cd_tabela_orc_w,
                        nm_usuario_p);

begin

select  cd_tabela_parametro,
        nr_seq_tabela_param
into STRICT    cd_tabela_cap_w,
        nr_seq_tabela_capac_w
from    tabela_parametro
where   nr_seq_tabela    = nr_seq_tabela_p
and     nr_seq_parametro = 2;
exception when no_data_found then
        /*'Falta informar a tabela de Capacidade de producao do mes no Parametro 2 do Cadastro da Tabela de Taxa de custo!*/


        CALL wheb_mensagem_pck.exibir_mensagem_abort(184214);
end;


CALL atualizar_util_tabela(  cd_estabelecimento_p,
                        cd_tabela_custo_p,
                        cd_tabela_cap_w,
                        nm_usuario_p);

delete  from taxa_custo
where   nr_seq_tabela  = nr_seq_tabela_p;

delete  from taxa_custo_nat
where   nr_seq_tabela  = nr_seq_tabela_p;

delete  from taxa_custo_ocio
where   nr_seq_tabela  = nr_seq_tabela_p;

select  max(nr_sequencia_nivel)
into STRICT    nr_sequencia_nivel_w
from    capac_centro_controle
where   nr_seq_tabela = nr_seq_tabela_capac_w;

select  cd_tipo_tabela_custo
into STRICT    cd_tipo_tabela_custo_w
from    tabela_custo
where   nr_sequencia    = nr_seq_tabela_p;


open c01;
     loop fetch c01 bulk collect into vetor_orcamento_custo_w limit 1000;
          exit when vetor_orcamento_custo_w.count = 0;
          for i in vetor_orcamento_custo_w.first .. vetor_orcamento_custo_w.last loop

          qt_contador_w   := qt_contador_w + 1;
          CALL gravar_processo_longo(wheb_mensagem_pck.get_texto(299130) || qt_contador_w,'CALCULAR_TAXA_CUSTO',qt_contador_w);
          qt_disponibilidade_w := vetor_orcamento_custo_w[i].qt_disponibilidade;

          qt_disponibilidade_w := coalesce(qt_disponibilidade_w,0);

          if (qt_disponibilidade_w > 0) then
                 vl_taxa_custo_w     := dividir(vetor_orcamento_custo_w[i].vl_orcado, qt_disponibilidade_w);

                 select   round((coalesce(sum(case nr_sequencia_nivel  
                              when 1 then 
                                      dividir(vetor_orcamento_custo_w[i].vl_orcado, qt_disponibilidade)
                                  else 0 
                              end),0))::numeric, 4) vl_taxa_teorica,
                          round((coalesce(sum(case nr_sequencia_nivel  
                              when 2 then 
                                  dividir(vetor_orcamento_custo_w[i].vl_orcado, qt_disponibilidade)
                                  else 0 
                              end),0))::numeric, 4) vl_taxa_pratica, 
                          round((coalesce(sum(case nr_sequencia_nivel  
                              when 3 then 
                                  dividir(vetor_orcamento_custo_w[i].vl_orcado, qt_disponibilidade)
                              else 0 
                              end),0))::numeric, 4) vl_taxa_atend
                  into STRICT    vl_taxa_teorica_w,
                          vl_taxa_pratica_w,
                          vl_taxa_atend_w
                  from    capac_centro_controle
                  where   nr_seq_tabela       = nr_seq_tabela_capac_w
                  and     nr_sequencia_nivel  in (1,2,3)
                  and     cd_estabelecimento  = vetor_orcamento_custo_w[i].cd_estabelecimento
                  and     cd_centro_controle  = vetor_orcamento_custo_w[i].cd_centro_controle;

                  nr_sequencia_w:= vetor_orcamento_custo_w[i].nr_sequencia;

                  nr_posicao_vetor_w:= vetor_taxa_custo_nat_w.count + 1;

                  vetor_taxa_custo_nat_w[nr_posicao_vetor_w].nr_sequencia             := nr_sequencia_w;
                  vetor_taxa_custo_nat_w[nr_posicao_vetor_w].cd_estabelecimento       := vetor_orcamento_custo_w[i].cd_estabelecimento;
                  vetor_taxa_custo_nat_w[nr_posicao_vetor_w].cd_tabela_custo          := cd_tabela_custo_p;
                  vetor_taxa_custo_nat_w[nr_posicao_vetor_w].cd_centro_controle       := vetor_orcamento_custo_w[i].cd_centro_controle;
                  vetor_taxa_custo_nat_w[nr_posicao_vetor_w].cd_grupo_natureza_gasto  := vetor_orcamento_custo_w[i].cd_grupo_natureza_gasto;
                  vetor_taxa_custo_nat_w[nr_posicao_vetor_w].nr_seq_gng               := vetor_orcamento_custo_w[i].nr_seq_gng;
                  vetor_taxa_custo_nat_w[nr_posicao_vetor_w].cd_natureza_gasto        := vetor_orcamento_custo_w[i].cd_natureza_gasto;
                  vetor_taxa_custo_nat_w[nr_posicao_vetor_w].nr_seq_ng                := vetor_orcamento_custo_w[i].nr_seq_ng;
                  vetor_taxa_custo_nat_w[nr_posicao_vetor_w].nm_usuario               := nm_usuario_p;
                  vetor_taxa_custo_nat_w[nr_posicao_vetor_w].dt_atualizacao           := clock_timestamp();
                  vetor_taxa_custo_nat_w[nr_posicao_vetor_w].vl_taxa_custo            := vl_taxa_custo_w;
                  vetor_taxa_custo_nat_w[nr_posicao_vetor_w].qt_disponibilidade       := qt_disponibilidade_w;
                  vetor_taxa_custo_nat_w[nr_posicao_vetor_w].vl_custo                 := vetor_orcamento_custo_w[i].vl_orcado;
                  vetor_taxa_custo_nat_w[nr_posicao_vetor_w].vl_taxa_teorica          := vl_taxa_teorica_w;
                  vetor_taxa_custo_nat_w[nr_posicao_vetor_w].vl_taxa_pratica          := vl_taxa_pratica_w;
                  vetor_taxa_custo_nat_w[nr_posicao_vetor_w].vl_taxa_atend            := vl_taxa_atend_w;
                  vetor_taxa_custo_nat_w[nr_posicao_vetor_w].nr_seq_tabela            := nr_seq_tabela_p;

                  if ( ie_natureza_gasto_w = 'T') and ( vl_recebido_w <> 0 ) then
                        open c02(
                                vetor_orcamento_custo_w[i].cd_estabelecimento,
                                nr_seq_tabela_orc_w,
                                vetor_orcamento_custo_w[i].nr_seq_ng,
                                vetor_orcamento_custo_w[i].cd_centro_controle
                                );
                                loop fetch c02 bulk collect into vetor_orcamento_distribuido_w limit 1000;
                                EXIT WHEN NOT FOUND; /* apply on c02 */
                                     for y in vetor_orcamento_distribuido_w.first .. vetor_orcamento_distribuido_w.last loop
                                     vl_taxa_origem_w    := dividir(vetor_orcamento_distribuido_w[y].vl_distribuido, qt_disponibilidade_w);
                                     nr_sequencia_cc_w := vetor_orcamento_distribuido_w[y].nr_sequencia;

                                     vetor_taxa_custo_cc_orig_w[y].nr_sequencia              := nr_sequencia_cc_w;
                                     vetor_taxa_custo_cc_orig_w[y].nr_seq_taxa               := nr_sequencia_w;
                                     vetor_taxa_custo_cc_orig_w[y].dt_atualizacao            := clock_timestamp();
                                     vetor_taxa_custo_cc_orig_w[y].nm_usuario                := nm_usuario_p;
                                     vetor_taxa_custo_cc_orig_w[y].dt_atualizacao_nrec       := clock_timestamp();
                                     vetor_taxa_custo_cc_orig_w[y].nm_usuario_nrec           := nm_usuario_p;
                                     vetor_taxa_custo_cc_orig_w[y].cd_centro_controle        := vetor_orcamento_distribuido_w[y].cd_centro_controle;
                                     vetor_taxa_custo_cc_orig_w[y].vl_taxa_custo             := vl_taxa_origem_w;
                                     vetor_taxa_custo_cc_orig_w[y].vl_custo                  := vetor_orcamento_distribuido_w[y].vl_distribuido;
                                     end loop;
                               end loop;
                        close c02;
                  end if;
          end if;
          end loop;

          forall i in vetor_taxa_custo_nat_w.first ..vetor_taxa_custo_nat_w.last
          insert into taxa_custo_nat values vetor_taxa_custo_nat_w(i); --1 
          commit;
          
          forall i in vetor_taxa_custo_cc_orig_w.first .. vetor_taxa_custo_cc_orig_w.last
          insert into taxa_custo_cc_orig values vetor_taxa_custo_cc_orig_w(i);
          commit;
          
          vetor_taxa_custo_nat_w.delete;
          vetor_orcamento_custo_w.delete;
          vetor_taxa_custo_cc_orig_w.delete;
    end loop;
close c01;

qt_contador_w   := qt_contador_w + 1;
CALL gravar_processo_longo(wheb_mensagem_pck.get_texto(299130) || qt_contador_w,'CALCULAR_TAXA_CUSTO',qt_contador_w);


insert into taxa_custo(cd_estabelecimento,
       cd_tabela_custo,
       cd_centro_controle,
       cd_grupo_natureza_gasto,
       nr_seq_gng,
       nm_usuario,
       dt_atualizacao,
       vl_taxa_custo,
       qt_disponibilidade,
       vl_custo,
       vl_taxa_teorica,
       vl_taxa_pratica,
       vl_taxa_atend,
       nr_seq_tabela)
       SELECT  cd_estabelecimento,
               cd_tabela_custo,
               cd_centro_controle,
               cd_grupo_natureza_gasto,
               nr_seq_gng,
               nm_usuario_p,
               clock_timestamp(),
               sum(vl_taxa_custo),
               avg(qt_disponibilidade),
               sum(vl_custo),
               sum(vl_taxa_teorica),
               sum(vl_taxa_pratica),
               sum(vl_taxa_atend),
               nr_seq_tabela_p
       from    taxa_custo_nat
       where   nr_seq_tabela = nr_seq_tabela_p
       group by
                cd_estabelecimento,
                cd_tabela_custo,
                cd_centro_controle,
                nr_seq_gng,
                cd_grupo_natureza_gasto;
commit;

qt_contador_w   := qt_contador_w + 1;
CALL gravar_processo_longo(wheb_mensagem_pck.get_texto(299132) || qt_contador_w,'CALCULAR_TAXA_CUSTO',qt_contador_w);

insert into taxa_custo_ocio(nr_sequencia,
        nm_usuario,
        dt_atualizacao,
        cd_estabelecimento,
        cd_tabela_custo,
        cd_centro_controle,
        cd_redutor_capacidade,
        vl_ociosidade,
        qt_reducao,
        nr_seq_tabela)
        SELECT  nextval('taxa_custo_ocio_seq') nr_sequencia,
                nm_usuario_p,
                clock_timestamp(),
                x.cd_estabelecimento,                               
                cd_tabela_custo_p,
                x.cd_centro_controle,                             
                x.cd_redutor_capacidade,                          
                case x.ie_tipo_redutor
                when '1' then
                    dividir((x.qt_reducao * x.vl_taxa_custo),100)
                when '2' then
                    x.qt_reducao * x.vl_taxa_custo
                end vl_reducao,                                 
                x.qt_reducao,                                      
                nr_seq_tabela_p
        from (  SELECT  a.cd_centro_controle,
                        a.cd_estabelecimento,
                        c.cd_redutor_capacidade,
                        c.qt_reducao,
                        d.ie_tipo_redutor,
                        dividir(a.vl_custo,b.qt_disponibilidade) vl_taxa_custo 
                from    redutor_capacidade d,
                        reduc_capac_centro_controle c,
                        capac_centro_controle b,
                        taxa_custo a
                where   a.cd_estabelecimento    = b.cd_estabelecimento
                and     a.cd_centro_controle    = b.cd_centro_controle
                and     a.cd_estabelecimento    = c.cd_estabelecimento
                and     a.cd_centro_controle    = c.cd_centro_controle
                and     c.nr_seq_tabela         = b.nr_seq_tabela
                and     c.cd_redutor_capacidade = d.cd_redutor_capacidade
                and     a.nr_seq_tabela         = nr_seq_tabela_p
                and     b.nr_seq_tabela         = nr_seq_tabela_capac_w
                and     b.nr_sequencia_nivel    = ie_capac_calc_ociosidade_w 
        ) x;
commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE custos_pck.calcular_taxa_custo ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, nm_usuario_p text, nr_seq_tabela_p bigint) FROM PUBLIC;