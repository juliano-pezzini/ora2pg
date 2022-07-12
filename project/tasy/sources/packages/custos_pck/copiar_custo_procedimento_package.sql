-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE custos_pck.copiar_custo_procedimento ( cd_estabelecimento_p bigint, cd_tabela_origem_p bigint, cd_tabela_destino_p bigint, nm_usuario_p text, nr_seq_tabela_p bigint, nr_seq_tabela_origem_p bigint) AS $body$
DECLARE

                    
cd_tipo_tabela_w    tabela_custo.cd_tipo_tabela_custo%type;


BEGIN

select  cd_tipo_tabela_custo
into STRICT    cd_tipo_tabela_w
from    tabela_custo a
where   nr_sequencia = nr_seq_tabela_p;

if (cd_tipo_tabela_w = 3) then
       CALL custos_pck.cus_copiar_proc_mes_ant( cd_estabelecimento_p   => cd_estabelecimento_p,
                                           cd_tabela_origem_p     => cd_tabela_origem_p,
                                           cd_tabela_destino_p    => cd_tabela_destino_p,
                                           nm_usuario_p           => nm_usuario_p,
                                           nr_seq_tabela_p        => nr_seq_tabela_p,
                                           nr_seq_tabela_origem_p => nr_seq_tabela_origem_p);

elsif (cd_tipo_tabela_w = 4) then
         delete   from custo_material
         where    nr_seq_tabela = nr_seq_tabela_p;

         insert into custo_material(
                cd_estabelecimento,
                cd_tabela_custo,
                cd_material,
                nm_usuario,
                dt_atualizacao,
                ie_origem_custo,
                qt_dias_prazo,
                vl_cotado_compra,
                vl_cotado_consumo,
                pr_frete,
                vl_presente,
                ds_observacao,
                nr_seq_tabela,
                nr_fator_conversao,
                dt_atualizacao_nrec,
                nm_usuario_nrec)
                SELECT    a.cd_estabelecimento,
                          cd_tabela_destino_p,
                          a.cd_material,
                          nm_usuario_p,
                          clock_timestamp(),
                          a.ie_origem_custo,
                          a.qt_dias_prazo,
                          a.vl_cotado_compra,
                          a.vl_cotado_consumo,
                          a.pr_frete,
                          a.vl_presente,
                          a.ds_observacao,
                          nr_seq_tabela_p,
                          a.nr_fator_conversao,
                          clock_timestamp(),
                          nm_usuario_p
                from      custo_material a,
                          tabela_custo b
                where     a.nr_seq_tabela =  b.nr_sequencia
                and       b.nr_sequencia  =  nr_seq_tabela_origem_p;

end if;
commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE custos_pck.copiar_custo_procedimento ( cd_estabelecimento_p bigint, cd_tabela_origem_p bigint, cd_tabela_destino_p bigint, nm_usuario_p text, nr_seq_tabela_p bigint, nr_seq_tabela_origem_p bigint) FROM PUBLIC;