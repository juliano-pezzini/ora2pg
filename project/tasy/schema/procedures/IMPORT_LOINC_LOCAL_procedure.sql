-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE import_loinc_local (loinc_Num_p text, component_p text, property_p text, time_Aspct_p text, system_p text, scale_Type_p text, method_Type_p text, loinc_Class_p text, long_Common_Name_p text, short_Name_p text, related_Names2_p text, nm_usuario_p text, ie_localizacao_p text) AS $body$
DECLARE


nr_seq_loinc_w       bigint;
nr_seq_idioma_w      bigint;
nr_seq_escala_w      bigint;
nr_seq_metodo_w      bigint;
nr_seq_propriedade_w bigint;
nr_seq_sistema_w     bigint;
nr_seq_tempo_w       bigint;
nr_seq_dados_reg_w   bigint;


BEGIN
  select max(nr_sequencia)
    into STRICT nr_seq_loinc_w
    from lab_loinc_dados
   where cd_loinc = loinc_Num_p;

  if (coalesce(nr_seq_loinc_w::text, '') = '') then
    select nextval('lab_loinc_dados_seq')
      into STRICT nr_seq_loinc_w
;

    insert into lab_loinc_dados(nr_sequencia,
                                 cd_loinc,
                                 dt_atualizacao,
                                 dt_atualizacao_nrec,
                                 nm_usuario,
                                 nm_usuario_nrec)
                         values (nr_seq_loinc_w,
                                 loinc_Num_p,
                                 clock_timestamp(),
                                 clock_timestamp(),
                                 nm_usuario_p,
                                 nm_usuario_p);
    commit;
  end if;

  select max(nr_sequencia)
    into STRICT nr_seq_idioma_w
    from tasy_idioma
   where ds_language_tag = ie_localizacao_p;

   select max(nr_sequencia)
     into STRICT nr_seq_dados_reg_w
     from LAB_LOINC_DADOS_REG
    where nr_seq_loinc_dados = nr_seq_loinc_w and
          nr_seq_idioma = nr_seq_idioma_w;

  if (coalesce(nr_seq_dados_reg_w::text, '') = '') then
    if (scale_Type_p IS NOT NULL AND scale_Type_p::text <> '') then
      nr_seq_escala_w := valida_escala_loinc(scale_Type_p, nm_usuario_p, null, null, 'Localiza', nr_seq_loinc_w, nr_seq_escala_w);
    end if;

    if (method_Type_p IS NOT NULL AND method_Type_p::text <> '') then
      nr_seq_metodo_w := valida_metodo_loinc(method_Type_p, nm_usuario_p, null, null, 'Localiza', nr_seq_loinc_w, nr_seq_metodo_w);
    end if;

    if (property_p IS NOT NULL AND property_p::text <> '') then
      nr_seq_propriedade_w := valida_propriedade_loinc(property_p, nm_usuario_p, null, null, 'Localiza', nr_seq_loinc_w, nr_seq_propriedade_w);
    end if;

    if (system_p IS NOT NULL AND system_p::text <> '') then
      nr_seq_sistema_w := valida_sistema_loinc(system_p, nm_usuario_p, null, null, 'Localiza', nr_seq_loinc_w, nr_seq_sistema_w);
    end if;

    if (time_Aspct_p IS NOT NULL AND time_Aspct_p::text <> '') then
      nr_seq_tempo_w := valida_tempo_loinc(time_Aspct_p, nm_usuario_p, null, null, 'Localiza', nr_seq_loinc_w, nr_seq_tempo_w);
    end if;

    insert into LAB_LOINC_DADOS_REG(nr_sequencia,
                                     nr_seq_loinc_dados,
                                     ds_classe,
                                     ds_componente,
                                     ds_long_name,
                                     ds_short_name,
                                     dt_atualizacao,
                                     dt_atualizacao_nrec,
                                     nm_usuario,
                                     nm_usuario_nrec,
                                     nr_seq_idioma,
                                     nr_seq_escala,
                                     nr_seq_metodo,
                                     nr_seq_propriedade,
                                     nr_seq_sistema,
                                     nr_seq_tempo,
                                     ds_related_name)
                             values (nextval('lab_loinc_dados_reg_seq'),
                                     nr_seq_loinc_w,
                                     loinc_Class_p,
                                     component_p,
                                     long_Common_Name_p,
                                     short_Name_p,
                                     clock_timestamp(),
                                     clock_timestamp(),
                                     nm_usuario_p,
                                     nm_usuario_p,
                                     nr_seq_idioma_w,
                                     nr_seq_escala_w,
                                     nr_seq_metodo_w,
                                     nr_seq_propriedade_w,
                                     nr_seq_sistema_w,
                                     nr_seq_tempo_w,
                                     related_Names2_p);
  else
    if (scale_Type_p IS NOT NULL AND scale_Type_p::text <> '') then
      nr_seq_escala_w := valida_escala_loinc(scale_Type_p, nm_usuario_p, null, null, 'Localiza', nr_seq_loinc_w, nr_seq_escala_w);
    end if;

    if (method_Type_p IS NOT NULL AND method_Type_p::text <> '') then
      nr_seq_metodo_w := valida_metodo_loinc(method_Type_p, nm_usuario_p, null, null, 'Localiza', nr_seq_loinc_w, nr_seq_metodo_w);
    end if;

    if (property_p IS NOT NULL AND property_p::text <> '') then
      nr_seq_propriedade_w := valida_propriedade_loinc(property_p, nm_usuario_p, null, null, 'Localiza', nr_seq_loinc_w, nr_seq_propriedade_w);
    end if;

    if (system_p IS NOT NULL AND system_p::text <> '') then
      nr_seq_sistema_w := valida_sistema_loinc(system_p, nm_usuario_p, null, null, 'Localiza', nr_seq_loinc_w, nr_seq_sistema_w);
    end if;

    if (time_Aspct_p IS NOT NULL AND time_Aspct_p::text <> '') then
      nr_seq_tempo_w := valida_tempo_loinc(time_Aspct_p, nm_usuario_p, null, null, 'Localiza', nr_seq_loinc_w, nr_seq_tempo_w);
    end if;

    update LAB_LOINC_DADOS_REG set ds_classe = loinc_Class_p,
                                   ds_componente = component_p,
                                   ds_long_name = long_Common_Name_p,
                                   ds_short_name = short_Name_p,
                                   dt_atualizacao = clock_timestamp(),
                                   nm_usuario = nm_usuario_p,
                                   nr_seq_idioma = nr_seq_idioma_w,
                                   nr_seq_escala = nr_seq_escala_w,
                                   nr_seq_metodo = nr_seq_metodo_w,
                                   nr_seq_propriedade = nr_seq_propriedade_w,
                                   nr_seq_sistema = nr_seq_sistema_w,
                                   nr_seq_tempo = nr_seq_tempo_w,
                                   ds_related_name = related_Names2_p
     where nr_sequencia = nr_seq_dados_reg_w;
  end if;

  commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE import_loinc_local (loinc_Num_p text, component_p text, property_p text, time_Aspct_p text, system_p text, scale_Type_p text, method_Type_p text, loinc_Class_p text, long_Common_Name_p text, short_Name_p text, related_Names2_p text, nm_usuario_p text, ie_localizacao_p text) FROM PUBLIC;

