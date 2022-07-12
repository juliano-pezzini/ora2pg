-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_diluicao_medic_dose ( nr_sequencia_p bigint, nr_prescricao_p bigint, qt_dose_p bigint) RETURNS varchar AS $body$
DECLARE


cd_material_w      integer;
cd_medic_w      integer;
qt_dose_w      double precision;
qt_dose_ml_w      double precision;
cd_unid_med_dose_w    varchar(30) := '';
ds_material_w      varchar(100);
ds_material_ww      varchar(100);
ds_reduzida_w      varchar(100);
ds_diluir_w      varchar(255) := '';
ds_rediluir_w      varchar(255) := '';
ds_retorno_w      varchar(2000) := '';
ds_reconstituir_w    varchar(2000) := '';
ie_agrupador_w      smallint;
qt_dose_mat_w      double precision;
qt_dose_mat_str_w    varchar(20) := '';
cd_unid_med_dose_mat_w    varchar(30) := '';
qt_solucao_w      double precision := 0;
qt_solucao_str_w    varchar(10) :='';
ds_dose_diferenciada_w    varchar(50);
qt_solucao_ww      double precision := 0;
qt_min_aplicacao_w    smallint  := 0;
qt_min_aplicacao_ant_w    smallint  := 0;
qt_hora_aplicacao_ant_w    smallint  := 0;
qt_hora_aplicacao_w    smallint  := 0;
ds_min_aplicacao_w    varchar(255) := '';

cd_volume_final_w    double precision := 0;
mascara_w      smallint := 0;
qt_dose_str_w      varchar(20) := '';
cd_volume_final_str_w    varchar(20) := '';
qt_diluicao_w      double precision := 0;
cd_diluente_w      integer  := 0;
ds_diluente_w      varchar(100) := '';
qt_diluicao_str_w    varchar(20) := '';
ds_intervalo_w      varchar(50) := '';
cd_unidade_medida_w    varchar(30);
ds_conv_ml_w      varchar(20) := '';
qt_conv_ml_w      double precision;
cd_estabelecimento_w    smallint;
ie_descr_redu_dil_w    varchar(1);

ds_aux_diluir_w      varchar(30);
ie_via_aplicacao_w    varchar(5);
cd_intervalo_w      varchar(7);
qt_ml_diluente_w    double precision;
ds_volume_w      varchar(100);
ds_tempo_w      varchar(100);
qt_dose_medic_ml_w    double precision;
ds_aplicar_w      varchar(200);
ds_diluicao_edit_w    varchar(2000);
ie_aplicar_w      varchar(1);
ds_dose_diluicao_w    varchar(100);
qt_dose_unid_med_cons_w    double precision;
qt_vol_adic_reconst_w    double precision;
sql_w                    varchar(4000);
ds_unid_med_ml_w      varchar(50);
qt_conv_unid_w       double precision;

c01 CURSOR FOR
  SELECT  a.cd_material,
    a.qt_dose,
    coalesce(a.qt_vol_adic_reconst,0),
    a.qt_min_aplicacao,
    a.qt_hora_aplicacao,
    a.cd_unidade_medida_dose,
    a.ie_agrupador,
    a.qt_solucao,
    obter_conversao_ml(a.cd_material,a.qt_dose,a.cd_unidade_medida_dose),
    substr(b.ds_material,1,100),
    substr(b.ds_reduzida,1,100)
  from   material b,
    prescr_material a
  where   ((a.nr_sequencia_diluicao = nr_sequencia_p) or (a.nr_sequencia = nr_sequencia_p))
    and   a.nr_prescricao = nr_prescricao_p
    and  a.cd_material = b.cd_material
    and  a.ie_agrupador IN (3,7,9)
  order by a.ie_agrupador desc;


BEGIN

select  max(ds_diluicao_edit)
into STRICT  ds_diluicao_edit_w
from  prescr_material
where  nr_prescricao  = nr_prescricao_p
and  nr_sequencia  = nr_sequencia_p;

if (coalesce(ds_diluicao_edit_w::text, '') = '') then

  select  b.qt_dose,
    b.qt_min_aplicacao,
    b.qt_hora_aplicacao,
    b.cd_unidade_medida_dose,
    b.qt_solucao,
    b.cd_unidade_medida,
    b.cd_material,
    a.cd_estabelecimento,
    b.cd_intervalo,
    b.ie_via_aplicacao,
    b.ds_dose_diferenciada
  into STRICT  qt_dose_mat_w,
    qt_min_aplicacao_w,
    qt_hora_aplicacao_w,
    cd_unid_med_dose_mat_w,
    qt_solucao_ww,
    cd_unidade_medida_w,
    cd_medic_w,
    cd_estabelecimento_w,
    cd_intervalo_w,
    ie_via_aplicacao_w,
    ds_dose_diferenciada_w
  from   prescr_material b,
    prescr_medica a
  where   a.nr_prescricao  = b.nr_prescricao
  and  b.nr_sequencia  = nr_sequencia_p
  and  a.nr_prescricao  = nr_prescricao_p
  and  b.ie_agrupador  in (1,8, 14);

  select  coalesce(max(ie_aplicar),'N')
  into STRICT  ie_aplicar_w
  from  parametro_medico
  where  cd_estabelecimento  = cd_estabelecimento_w;

  if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then
    select  max(ds_prescricao)
    into STRICT  ds_intervalo_w
    from  intervalo_prescricao
    where  cd_intervalo  = cd_intervalo_w;

    if (ie_via_aplicacao_w IS NOT NULL AND ie_via_aplicacao_w::text <> '') then
      ds_intervalo_w  := ds_intervalo_w ||' '||ie_via_aplicacao_w;
    end if;
  end if;

  select  coalesce(max(ie_descr_redu_dil),'N')
  into STRICT  ie_descr_redu_dil_w
  from  parametro_medico
  where  cd_estabelecimento  = cd_estabelecimento_w;

  select  obter_conversao_ml(cd_medic_w,qt_dose_mat_w,cd_unid_med_dose_mat_w)
  into STRICT  qt_conv_ml_w
;


  ds_unid_med_ml_w:= obter_unid_med_usua('ml');

  begin
    sql_w := 'BEGIN obter_descricao_conversao_md(:1, :2, :3, :4, :5, :6); END;';

    EXECUTE sql_w USING IN qt_conv_ml_w,
                                  IN cd_unid_med_dose_mat_w,
                                  IN qt_dose_mat_w,
                                  OUT qt_dose_mat_str_w,
                                  OUT ds_conv_ml_w,
                                  IN ds_unid_med_ml_w;
  exception
    when others then
      qt_dose_mat_str_w    := null;
      ds_conv_ml_w     := null;
  end;
      sql_w := null;


  open  c01;
  loop
  fetch  c01 into
    cd_material_w,
    qt_dose_w,
    qt_vol_adic_reconst_w,
    qt_min_aplicacao_ant_w,
    qt_hora_aplicacao_ant_w,
    cd_unid_med_dose_w,
    ie_agrupador_w,
    qt_solucao_w,
    qt_dose_ml_w,
    ds_material_ww,
    ds_reduzida_w;
  EXIT WHEN NOT FOUND; /* apply on c01 */
    begin

    qt_dose_ml_w  := qt_dose_p;

    if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') and (qt_dose_w IS NOT NULL AND qt_dose_w::text <> '') and (cd_unid_med_dose_w IS NOT NULL AND cd_unid_med_dose_w::text <> '') and (ie_agrupador_w = 9) then
      begin
      select  obter_conversao_ml(cd_material_w,qt_dose_w + qt_vol_adic_reconst_w,cd_unid_med_dose_w)
      into STRICT  qt_conv_ml_w
;



        select   CASE WHEN ie_descr_redu_dil_w='S' THEN ds_reduzida_w  ELSE ds_material_ww END
         into STRICT  ds_material_w
;


       begin

      sql_w := 'CALL obter_mascara_md(:1) INTO :mascara_w';
      EXECUTE sql_w USING IN qt_dose_w,
                                    OUT mascara_w;
        exception
          when others then
            mascara_w := null;
        end;


      Select   CASE WHEN mascara_w=0 THEN  campo_mascara(qt_dose_w, 2)  ELSE campo_mascara(qt_dose_w, 0) END
      into STRICT  qt_dose_str_w
;

      ds_unid_med_ml_w := upper(obter_unid_med_usua('ML'));
      qt_conv_unid_w := obter_conversao_unid_med_cons(cd_medic_w, cd_unid_med_dose_mat_w, qt_dose_mat_w);

      begin
        sql_w := 'BEGIN obter_conv_ds_reconstituir_md(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12); END;';

        EXECUTE sql_w USING IN cd_unid_med_dose_mat_w,
                                      IN OUT qt_conv_ml_w,
                                      OUT qt_dose_unid_med_cons_w,
                                      IN qt_dose_mat_w,
                                      OUT ds_conv_ml_w,
                                      OUT ds_reconstituir_w,
                                      IN cd_unidade_medida_w,
                                      IN qt_dose_str_w,
                                      IN cd_unid_med_dose_w,
                                      IN ds_material_w,
                                      IN ds_unid_med_ml_w,
                                      IN qt_conv_unid_w;
      exception
        when others then
          qt_conv_ml_w    := null;
          qt_dose_unid_med_cons_w     := null;
          ds_conv_ml_w     := null;
          ds_reconstituir_w     := null;
      end;
          sql_w := null;


      end;
    end if;

    if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') and (qt_dose_w IS NOT NULL AND qt_dose_w::text <> '') and (cd_unid_med_dose_w IS NOT NULL AND cd_unid_med_dose_w::text <> '') and (ie_agrupador_w = 3) then
         begin

                qt_ml_diluente_w  := qt_dose_ml_w;
                select   CASE WHEN ie_descr_redu_dil_w='S' THEN ds_reduzida_w  ELSE ds_material_ww END
                into STRICT  ds_material_w
;

                ds_unid_med_ml_w:= obter_unid_med_usua('ml');

                 begin
                    sql_w := 'BEGIN obter_dose_aux_diluir_md(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, :14, :15); END;';

                    EXECUTE sql_w USING OUT ds_aux_diluir_w,
                                                  IN  ds_reconstituir_w,
                                                  OUT ds_dose_diluicao_w,
                                                  IN qt_dose_ml_w,
                                                  IN qt_dose_w,
                                                  IN cd_unid_med_dose_w,
                                                  IN qt_solucao_w,
                                                  OUT ds_conv_ml_w,
                                                  OUT qt_conv_ml_w,
                                                  IN ds_diluir_w,
                                                  IN ds_dose_diferenciada_w,
                                                  IN ds_material_w,
                                                  IN qt_dose_mat_str_w,
                                                  IN cd_unid_med_dose_mat_w,
                                                  IN ds_unid_med_ml_w;
                  exception
                    when others then
                      ds_aux_diluir_w    := null;
                      ds_dose_diluicao_w     := null;
                      ds_conv_ml_w     := null;
                      qt_conv_ml_w     := null;
                  end;
                      sql_w := null;


         end;
    end if;

    if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') and (qt_dose_w IS NOT NULL AND qt_dose_w::text <> '') and (cd_unid_med_dose_w IS NOT NULL AND cd_unid_med_dose_w::text <> '') and (ie_agrupador_w = 7) then
         begin
      select   CASE WHEN ie_descr_redu_dil_w='S' THEN ds_reduzida_w  ELSE ds_material_ww END
         into STRICT  ds_material_w
;




      begin

        sql_w := 'CALL obter_mascara_md(:1) INTO :mascara_w';
        EXECUTE sql_w
          USING IN qt_solucao_w, OUT mascara_w;
      exception
        when others then
          mascara_w := null;
      end;


      Select   CASE WHEN mascara_w=0 THEN  campo_mascara(qt_solucao_w, 2)  ELSE campo_mascara(qt_solucao_w, 0) END 
      into STRICT  qt_solucao_str_w
;


        ds_unid_med_ml_w:= obter_unid_med_usua('ml');
        begin
          sql_w := 'BEGIN obter_vol_dose_diluicao_md(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10); END;';

          EXECUTE sql_w
            USING OUT cd_volume_final_w,
                  IN qt_dose_ml_w,
                  IN qt_solucao_w,
                  OUT ds_dose_diluicao_w,
                  IN qt_dose_w,
                  IN cd_unid_med_dose_w,
                  OUT ds_rediluir_w,
                  IN qt_solucao_str_w,
                  IN ds_material_w,
                  IN ds_unid_med_ml_w;
        exception
          when others then
            cd_volume_final_w    := null;
            ds_dose_diluicao_w := null;
            ds_rediluir_w       := null;
        end;
        sql_w := null;

            end;
    end if;
    end;
  end loop;
  close c01;

      begin

        sql_w := 'CALL obter_mascara_md(:1) INTO :mascara_w';
        EXECUTE sql_w
          USING IN cd_volume_final_w, OUT mascara_w;
      exception
        when others then
          mascara_w := null;
      end;

  Select   CASE WHEN mascara_w=0 THEN  campo_mascara(cd_volume_final_w, 2)  ELSE campo_mascara(cd_volume_final_w, 0) END
  into STRICT  cd_volume_final_str_w
;


      begin

        sql_w := 'CALL obter_ds_tempo_md(:1, :2) INTO :ds_tempo_w';
        EXECUTE sql_w
          USING IN qt_min_aplicacao_w, IN qt_hora_aplicacao_w, OUT ds_tempo_w;
      exception
        when others then
          ds_tempo_w := null;
      end;


          ds_unid_med_ml_w:= obter_unid_med_usua('ml');
          begin
            sql_w := 'BEGIN obter_ds_aplicar_md(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13); END;';

            EXECUTE sql_w
              USING IN qt_solucao_ww,
                    OUT ds_volume_w,
                    IN ie_aplicar_w,
                    IN ds_rediluir_w,
                    IN cd_volume_final_str_w,
                    IN ds_diluir_w,
                    IN qt_conv_ml_w,
                    IN qt_ml_diluente_w,
                    IN ds_conv_ml_w,
                    OUT ds_aplicar_w,
                    IN ds_intervalo_w,
                    IN ds_tempo_w,
                    IN ds_unid_med_ml_w;
          exception
            when others then
              ds_volume_w    := null;
              ds_aplicar_w := null;
          end;
          sql_w := null;


  begin
    sql_w := 'CALL obter_ds_reconstituir_md(:1, :2, :3, :4) INTO :ds_retorno_w';
    EXECUTE sql_w
      USING IN ds_reconstituir_w, IN ds_diluir_w, IN ds_rediluir_w, IN ds_aplicar_w, OUT ds_retorno_w;
  exception
    when others then
      ds_retorno_w := null;
  end;

else
  ds_retorno_w  := ds_diluicao_edit_w;
end if;

RETURN substr(ds_retorno_w,1,2000);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_diluicao_medic_dose ( nr_sequencia_p bigint, nr_prescricao_p bigint, qt_dose_p bigint) FROM PUBLIC;

