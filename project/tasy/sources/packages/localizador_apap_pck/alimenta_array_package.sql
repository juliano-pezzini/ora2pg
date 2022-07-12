-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE localizador_apap_pck.alimenta_array () AS $body$
DECLARE

   indice_w bigint;
   c_linked_data CURSOR FOR
      SELECT   a.nr_sequencia,
               a.nm_table,
               a.cd_exp_title,
               a.nr_seq_vision,
               b.ie_informacao,
               b.nr_seq_linked_data,
               b.ie_grupo,
               c.nm_atributo,
               c.cd_exp_label
      from     linked_data a,
               linked_data_ativacao b,
               tabela_visao_atributo c
      where    a.nr_sequencia    = b.nr_seq_linked_data
      and      a.nr_seq_vision   = c.nr_sequencia
      and      (c.nr_seq_apresent IS NOT NULL AND c.nr_seq_apresent::text <> '')
      and      (c.cd_exp_label IS NOT NULL AND c.cd_exp_label::text <> '')
      and      (a.nm_table IS NOT NULL AND a.nm_table::text <> '')
      and      not exists (SELECT   1
                           from     documento_atributo_ref x 
                           where    x.nr_seq_linked_data = a.nr_sequencia 
                           and      x.nm_atributo        = c.nm_atributo
                           and      (x.ie_referencia IS NOT NULL AND x.ie_referencia::text <> ''));

   c_materiais CURSOR FOR   
      SELECT  a.cd_grupo_material,
              a.ds_grupo_material,
              a.cd_subgrupo_material,
              a.ds_subgrupo_material,
              a.cd_classe_material,
              a.ds_classe_material,
              a.cd_material,
              a.ds_material,
              a.nr_seq_ficha_tecnica,
              b.ds_substancia
      from    estrutura_material_v a,
              medic_ficha_tecnica b,
              table(lista_pck.obter_lista('6,8,9,0,2,3')) c,
              material_estab d
      where   a.nr_seq_ficha_tecnica   = b.nr_sequencia  
      and     a.cd_material            = d.cd_material
      and     d.cd_estabelecimento     = cd_estabelecimento_w
      and     coalesce(d.IE_PRESCRICAO,'S') = 'S'
      and     a.ie_tipo_material       = c.nr_registro
      and     coalesce(a.ie_situacao,'A')   = 'A';

   c_ganhos_perdas CURSOR FOR
      SELECT  a.nr_sequencia nr_seq_grupo_pg,
              a.ds_grupo,
              a.ie_perda_ganho,
              b.ds_tipo,
              b.nr_sequencia nr_seq_tipo_pg
      from    grupo_perda_ganho a,
              tipo_perda_ganho b
      where   a.nr_sequencia = b.nr_seq_grupo        
      and     coalesce(a.ie_situacao,'A')  = 'A'
      and     coalesce(b.ie_situacao,'A')  = 'A';


   
BEGIN
   if (current_setting('localizador_apap_pck.linked_data_w')::linked_data_t.count = 0) then
      <<read_linked_data>>
      for r_linked_data in c_linked_data
         loop
         current_setting('localizador_apap_pck.linked_data_w')::linked_data_t.extend(1);
         indice_w := current_setting('localizador_apap_pck.linked_data_w')::linked_data_t.count;
         current_setting('localizador_apap_pck.linked_data_w')::linked_data_t[indice_w].nr_sequencia         := r_linked_data.nr_sequencia;
         current_setting('localizador_apap_pck.linked_data_w')::linked_data_t[indice_w].nm_table             := r_linked_data.nm_table;
         current_setting('localizador_apap_pck.linked_data_w')::linked_data_t[indice_w].cd_exp_title         := r_linked_data.cd_exp_title;
         current_setting('localizador_apap_pck.linked_data_w')::linked_data_t[indice_w].nr_seq_vision        := r_linked_data.nr_seq_vision;
         current_setting('localizador_apap_pck.linked_data_w')::linked_data_t[indice_w].ie_informacao        := r_linked_data.ie_informacao;
         current_setting('localizador_apap_pck.linked_data_w')::linked_data_t[indice_w].nr_seq_linked_data   := r_linked_data.nr_seq_linked_data;
         current_setting('localizador_apap_pck.linked_data_w')::linked_data_t[indice_w].ie_grupo             := r_linked_data.ie_grupo;
         current_setting('localizador_apap_pck.linked_data_w')::linked_data_t[indice_w].nm_atributo          := r_linked_data.nm_atributo;
         current_setting('localizador_apap_pck.linked_data_w')::linked_data_t[indice_w].cd_exp_label         := r_linked_data.cd_exp_label;
         end loop read_linked_data;
   end if;
   if (current_setting('localizador_apap_pck.materiais_w')::materiais_t.count = 0) then
      <<read_materiais>>
      for r_materiais in c_materiais
         loop
         current_setting('localizador_apap_pck.materiais_w')::materiais_t.extend(1);
         indice_w := current_setting('localizador_apap_pck.materiais_w')::materiais_t.count;
         current_setting('localizador_apap_pck.materiais_w')::materiais_t[indice_w].cd_grupo_material      := r_materiais.cd_grupo_material;
         current_setting('localizador_apap_pck.materiais_w')::materiais_t[indice_w].ds_grupo_material      := r_materiais.ds_grupo_material;
         current_setting('localizador_apap_pck.materiais_w')::materiais_t[indice_w].cd_subgrupo_material   := r_materiais.cd_subgrupo_material;
         current_setting('localizador_apap_pck.materiais_w')::materiais_t[indice_w].ds_subgrupo_material   := r_materiais.ds_subgrupo_material;
         current_setting('localizador_apap_pck.materiais_w')::materiais_t[indice_w].cd_classe_material     := r_materiais.cd_classe_material;
         current_setting('localizador_apap_pck.materiais_w')::materiais_t[indice_w].ds_classe_material     := r_materiais.ds_classe_material;
         current_setting('localizador_apap_pck.materiais_w')::materiais_t[indice_w].cd_material            := r_materiais.cd_material;
         current_setting('localizador_apap_pck.materiais_w')::materiais_t[indice_w].ds_material            := r_materiais.ds_material;
         current_setting('localizador_apap_pck.materiais_w')::materiais_t[indice_w].nr_seq_ficha_tecnica   := r_materiais.nr_seq_ficha_tecnica;
         current_setting('localizador_apap_pck.materiais_w')::materiais_t[indice_w].ds_substancia          := r_materiais.ds_substancia;
         end loop read_materiais;
   end if;
   if (current_setting('localizador_apap_pck.ganhos_perdas_w')::ganhos_perdas_t.count = 0) then
      <<read_ganhos_perdas>>
      for r_ganhos_perdas in c_ganhos_perdas
         loop
         current_setting('localizador_apap_pck.ganhos_perdas_w')::ganhos_perdas_t.extend(1);
         indice_w := current_setting('localizador_apap_pck.ganhos_perdas_w')::ganhos_perdas_t.count;
         current_setting('localizador_apap_pck.ganhos_perdas_w')::ganhos_perdas_t[indice_w].nr_seq_grupo_pg := r_ganhos_perdas.nr_seq_grupo_pg;
         current_setting('localizador_apap_pck.ganhos_perdas_w')::ganhos_perdas_t[indice_w].ds_grupo        := r_ganhos_perdas.ds_grupo;
         current_setting('localizador_apap_pck.ganhos_perdas_w')::ganhos_perdas_t[indice_w].ie_perda_ganho  := r_ganhos_perdas.ie_perda_ganho;
         current_setting('localizador_apap_pck.ganhos_perdas_w')::ganhos_perdas_t[indice_w].ds_tipo         := r_ganhos_perdas.ds_tipo;
         current_setting('localizador_apap_pck.ganhos_perdas_w')::ganhos_perdas_t[indice_w].nr_seq_tipo_pg  := r_ganhos_perdas.nr_seq_tipo_pg;
         end loop read_ganhos_perdas;
   end if;
   END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE localizador_apap_pck.alimenta_array () FROM PUBLIC;