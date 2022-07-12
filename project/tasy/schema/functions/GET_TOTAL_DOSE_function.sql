-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_total_dose ( nr_sequencia_p bigint, ie_tipo_dosegem_p text ) RETURNS bigint AS $body$
DECLARE


    qt_total_dose_w               cirurgia_agente_anest_ocor.qt_total_dose%type;
    qt_dose_w                     cirurgia_agente_anest_ocor.qt_dose%type;
    ie_aplic_bolus_w              cirurgia_agente_anest_ocor.ie_aplic_bolus%type;
    qt_velocidade_inf_w           cirurgia_agente_anest_ocor.qt_velocidade_inf%type;
    qt_halog_ins_w                cirurgia_agente_anest_ocor.qt_halog_ins%type;
    qt_dose_total_w               cirurgia_agente_anest_ocor.qt_dose_total%type;
    ie_modo_registro_w            cirurgia_agente_anest_ocor.ie_modo_registro%type;
    qt_dose_ataque_w              cirurgia_agente_anest_ocor.qt_dose_ataque%type;
    dt_inicio_adm_w               cirurgia_agente_anest_ocor.dt_inicio_adm%type;
    dt_final_adm_w                cirurgia_agente_anest_ocor.dt_final_adm%type;
    calculated_total_dose_w       double precision;
    cd_material_w                 integer;
    cd_unid_medida_adm_w          varchar(30);
    cd_unidade_medida_w           varchar(30);
    cd_unidade_medida_consumo_w   varchar(30);
    ie_consolidacao_generico_w    varchar(1);
    ie_modo_adm_w                 varchar(5);
    ie_tipo_dosagem_w             varchar(30);
    nr_atendimento_w              bigint;
    nr_cirurgia_w                 bigint;
    nr_seq_agente_w               bigint;
    nr_seq_pepo_w                 bigint;
    nr_sequencia_w                bigint;
    qt_velocidade_www             double precision;
    qt_peso_paciente_w            double precision;
    qt_dose_medic_w               double precision;
    c01 CURSOR FOR
    SELECT
        qt_dose,
        ie_aplic_bolus,
        qt_velocidade_inf,
        qt_halog_ins,
        qt_dose_total,
        qt_total_dose,
        ie_modo_registro,
        qt_dose_ataque,
        dt_inicio_adm,
        coalesce(dt_final_adm, clock_timestamp())
    from
        cirurgia_agente_anest_ocor
    where
        nr_seq_cirur_agente = nr_sequencia_p
        and ie_situacao = 'A';


BEGIN
    calculated_total_dose_w := 0;
    open c01;
    loop
        fetch c01 into
            qt_dose_w,
            ie_aplic_bolus_w,
            qt_velocidade_inf_w,
            qt_halog_ins_w,
            qt_dose_total_w,
            qt_total_dose_w,
            ie_modo_registro_w,
            qt_dose_ataque_w,
            dt_inicio_adm_w,
            dt_final_adm_w;

        EXIT WHEN NOT FOUND; /* apply on c01 */
        begin
            ie_consolidacao_generico_w := obter_param_usuario(872, 152, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_consolidacao_generico_w);

            ie_tipo_dosagem_w := ie_tipo_dosegem_p;
            if ( (ie_aplic_bolus_w IS NOT NULL AND ie_aplic_bolus_w::text <> '') and ie_aplic_bolus_w = 'S' and (qt_dose_w IS NOT NULL AND qt_dose_w::text <> '') ) then
                calculated_total_dose_w := calculated_total_dose_w + qt_dose_w;
            elsif ( ie_modo_registro_w = 'T' and (qt_total_dose_w IS NOT NULL AND qt_total_dose_w::text <> '') and qt_total_dose_w > 0 ) then
                calculated_total_dose_w := calculated_total_dose_w + qt_total_dose_w;
            elsif ( ie_modo_registro_w = 'V' and (qt_dose_ataque_w IS NOT NULL AND qt_dose_ataque_w::text <> '') ) then
                calculated_total_dose_w := calculated_total_dose_w + qt_dose_ataque_w;
            elsif ( ie_modo_registro_w = 'V' and (qt_velocidade_inf_w IS NOT NULL AND qt_velocidade_inf_w::text <> '') ) then
                if ( upper(ie_tipo_dosagem_w) in (
                    'MCG/H',
                    'MCG/MIN',
                    'MG/H',
                    'MG/KG/H',
                    'MCG/KG/H',
                    'MCG/KG/MIN',
                    'MG/KG/MIN'
                ) ) then
                    select
                        CASE WHEN ie_consolidacao_generico_w='S' THEN  coalesce(b.cd_material_generico, b.cd_material)  ELSE a.cd_material END  cd_material
                        ,
                        a.ie_modo_adm,
                        a.cd_unidade_medida,
                        a.cd_unid_medida_adm,
                        substr(obter_dados_material_estab(b.cd_material, wheb_usuario_pck.get_cd_estabelecimento, 'UMS'), 1, 30) cd_unidade_medida_consumo
                        ,
                        a.qt_dose,
                        a.nr_seq_agente
                    into STRICT
                        cd_material_w,
                        ie_modo_adm_w,
                        cd_unidade_medida_w,
                        cd_unid_medida_adm_w,
                        cd_unidade_medida_consumo_w,
                        qt_dose_medic_w,
                        nr_seq_agente_w
                    from
                        material                     b,
                        cirurgia_agente_anestesico   a
                    where
                        a.cd_material = b.cd_material
                        and a.nr_sequencia = nr_sequencia_p
                        and a.ie_tipo in (
                            1,
                            2,
                            3
                        )
                        and ( ( obter_se_agente_gas(nr_seq_agente) not in (
                            'G',
                            'LG'
                        ) )
                              or ( obter_dados_agente(a.nr_seq_agente, 'QVML') <> 0 ) )
                        and coalesce(a.ie_situacao, 'A') = 'A';

                    select
                        coalesce(max(qt_peso), 0)
                    into STRICT qt_peso_paciente_w
                    from
                        cirurgia
                    where
                        ( ( nr_cirurgia = nr_cirurgia_w )
                          or ( nr_seq_pepo = nr_seq_pepo_w ) );

                    if ( qt_peso_paciente_w = 0 ) then
                        select
                            coalesce(max(nr_atendimento), 0)
                        into STRICT nr_atendimento_w
                        from
                            cirurgia
                        where
                            ( ( nr_cirurgia = nr_cirurgia_w )
                              or ( nr_seq_pepo = nr_seq_pepo_w ) );

                        if ( nr_atendimento_w = 0 ) then
                            select
                                coalesce(max(nr_atendimento), 0)
                            into STRICT nr_atendimento_w
                            from
                                pepo_cirurgia
                            where
                                nr_sequencia = nr_seq_pepo_w;

                        end if;

                        qt_peso_paciente_w := coalesce(obter_sinal_vital(nr_atendimento_w, 'Peso'), 0);
                    end if;

                    SELECT * FROM calcular_dosagem_med(cd_material_w, qt_dose_medic_w, cd_unidade_medida_consumo_w, 0, qt_peso_paciente_w, qt_velocidade_inf_w, ie_tipo_dosagem_w, qt_velocidade_www, 'mlh') INTO STRICT qt_dose_medic_w, qt_velocidade_inf_w, qt_velocidade_www;

                    qt_velocidade_inf_w := qt_velocidade_www;
                    ie_tipo_dosagem_w := 'mlh';
                end if;

                if ( upper(ie_tipo_dosagem_w) not in (
                    'PPM',
                    'PERC'
                ) ) then
                    calculated_total_dose_w := calculated_total_dose_w + obter_consumo_continuo(1, qt_velocidade_inf_w, ie_tipo_dosagem_w
                    , dt_inicio_adm_w, dt_final_adm_w);
                elsif ( upper(ie_tipo_dosagem_w) = 'PERC' ) then
                    calculated_total_dose_w := calculated_total_dose_w + ( qt_velocidade_inf_w * 10 );
                elsif ( upper(ie_tipo_dosagem_w) = 'PPM' ) then
                    calculated_total_dose_w := calculated_total_dose_w + ( qt_velocidade_inf_w );
                end if;

            elsif (( ie_modo_registro_w = 'M' or ie_modo_registro_w = 'R' ) AND qt_dose_ataque_w IS NOT NULL AND qt_dose_ataque_w::text <> '') then
                calculated_total_dose_w := calculated_total_dose_w + qt_dose_ataque_w;
            elsif (( ie_modo_registro_w = 'M' or ie_modo_registro_w = 'R' ) AND qt_halog_ins_w IS NOT NULL AND qt_halog_ins_w::text <> '') then
                calculated_total_dose_w := calculated_total_dose_w + qt_halog_ins_w;
            elsif (qt_dose_w IS NOT NULL AND qt_dose_w::text <> '') then
                calculated_total_dose_w := calculated_total_dose_w + qt_dose_w;
            end if;

        end;

    end loop;

    close c01;
    return calculated_total_dose_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_total_dose ( nr_sequencia_p bigint, ie_tipo_dosegem_p text ) FROM PUBLIC;

