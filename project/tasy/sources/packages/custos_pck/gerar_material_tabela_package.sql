-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE custos_pck.gerar_material_tabela ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, nr_seq_tabela_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_mantem_conversao_w       varchar(1);
ie_somente_itens_cp_w       varchar(1);
nr_posicao_vetor_w          integer;
cd_estabelecimento_w        tabela_custo.cd_estabelecimento%type;
i				            integer	:= 0;

type tabela is table of custo_material%RowType index by integer;
custo_material_w        tabela;

c00 CURSOR FOR
    SELECT  distinct cd_estabelecimento
    from    tabela_custo_acesso_v tca
    where   tca.nr_sequencia = nr_seq_tabela_p;

c01 CURSOR(
        cd_estabelecimento_pc    ficha_tecnica_componente.cd_estabelecimento%type,
        ie_somente_itens_cp_pc   text,
        nr_seq_tabela_pc         custo_material.nr_seq_tabela%type,
        ie_mantem_conversao_pc   text
        )FOR
       SELECT  a.cd_material,
                CASE WHEN ie_mantem_conversao_pc='S' THEN coalesce(b.nr_fator_conversao,0)  ELSE 0 END  nr_fator_conversao
        FROM material a
LEFT OUTER JOIN custo_material b ON (a.cd_material = b.cd_material AND nr_seq_tabela_pc = b.nr_seq_tabela AND cd_estabelecimento_pc = b.cd_estabelecimento)
WHERE a.ie_situacao = 'A' and ((ie_somente_itens_cp_pc = 'S' and exists (  SELECT  1
                                                            from    material_atend_paciente y
                                                            where   y.cd_material   = a.cd_material
                                                            
union

                                                            select  1
                                                            from    ficha_tecnica_componente x
                                                            where   x.cd_material = a.cd_material
                                                            and     x.cd_estabelecimento = cd_estabelecimento_pc LIMIT 1))
                                                            or      ie_somente_itens_cp_pc = 'N');

type  t_cd_material is table of custo_material.cd_material%type index by integer;
vetor_cd_material_w   t_cd_material;

type t_c01 is table of c01%rowtype index by integer;
l_c01 t_c01;

C02 CURSOR FOR
SELECT	nr_fator_conversao
from	custo_material
where	nr_seq_tabela		= nr_seq_tabela_p
and	cd_estabelecimento	= cd_estabelecimento_w
and	cd_material		= l_c01[i].cd_material;


BEGIN

open c00;
loop
fetch c00 into
      cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on c00 */
     begin
     obter_param_usuario(927,78,Obter_perfil_Ativo,nm_usuario_p,cd_estabelecimento_w,ie_somente_itens_cp_w);
     ie_mantem_conversao_w   := coalesce(obter_valor_param_usuario(927,75,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_w),'N');

     open c01(
              cd_estabelecimento_w,
              ie_somente_itens_cp_w,
              nr_seq_tabela_p,
              ie_mantem_conversao_w
             );
             loop fetch c01 bulk collect into l_c01 limit 1000;
             exit when l_c01.count = 0;
                  for i in 1..l_c01.count loop
                  begin
                  nr_posicao_vetor_w := custo_material_w.count + 1;
                  custo_material_w[nr_posicao_vetor_w].cd_estabelecimento   := cd_estabelecimento_w;
                  custo_material_w[nr_posicao_vetor_w].cd_tabela_custo      := cd_tabela_custo_p;
                  custo_material_w[nr_posicao_vetor_w].cd_material          := l_c01[i].cd_material;
                  custo_material_w[nr_posicao_vetor_w].nm_usuario           := nm_usuario_p;
                  custo_material_w[nr_posicao_vetor_w].dt_atualizacao       := clock_timestamp();
                  custo_material_w[nr_posicao_vetor_w].ie_origem_custo      := 'C';
                  custo_material_w[nr_posicao_vetor_w].qt_dias_prazo        := 0;
                  custo_material_w[nr_posicao_vetor_w].vl_cotado_consumo    := 0;
                  custo_material_w[nr_posicao_vetor_w].vl_cotado_compra     := null;
                  custo_material_w[nr_posicao_vetor_w].pr_frete             := null;
                  custo_material_w[nr_posicao_vetor_w].vl_presente          := 0;
                  custo_material_w[nr_posicao_vetor_w].nr_seq_tabela        := nr_seq_tabela_p;
                  custo_material_w[nr_posicao_vetor_w].nr_fator_conversao   := l_c01[i].nr_fator_conversao;
                  custo_material_w[nr_posicao_vetor_w].dt_atualizacao_nrec  := clock_timestamp();
                  custo_material_w[nr_posicao_vetor_w].nm_usuario_nrec      := nm_usuario_p;

                  vetor_cd_material_w(nr_posicao_vetor_w) := l_c01[i].cd_material;
                  end;
                  end loop;
                  begin
                  forall a in vetor_cd_material_w.first .. vetor_cd_material_w.last
                  delete  from custo_material  a
                  where   a.cd_material        = vetor_cd_material_w(a)
                  and     a.cd_estabelecimento = cd_estabelecimento_w
                  and     a.nr_seq_tabela      = nr_seq_tabela_p
                  and     a.cd_tabela_custo    = cd_tabela_custo_p;
                  commit;

                  vetor_cd_material_w.delete;

                  forall a in custo_material_w.first .. custo_material_w.last
                  insert into custo_material values custo_material_w(a);

                  commit;
                  custo_material_w.delete;
                  end;
             end loop;
     close c01;
     end;
end loop;
close c00;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE custos_pck.gerar_material_tabela ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, nr_seq_tabela_p bigint, nm_usuario_p text) FROM PUBLIC;
