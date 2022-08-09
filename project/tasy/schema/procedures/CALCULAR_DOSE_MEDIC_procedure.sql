-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_dose_medic ( cd_material_p bigint, qt_altura_p bigint, qt_peso_p bigint, qt_sc_p bigint, qt_imc_p bigint, qt_dose_terap_p INOUT bigint, nr_unid_med_terap_p bigint, qt_diluente_p bigint, qt_periodo_hora_p bigint, qt_periodo_min_p bigint, cd_intervalo_p text, qt_dose_p INOUT bigint, cd_unidade_medida_p INOUT text, qt_vel_infusao_p INOUT bigint, ie_unidade_vel_p INOUT text, qt_fator_correcao_p bigint, qt_dose_total_p INOUT bigint, qt_dose_interv_p INOUT bigint, qt_dose_medic_p INOUT bigint, ie_primeiro_principal_p text default 'N', qt_daily_dose_p INOUT bigint DEFAULT NULL) AS $body$
DECLARE



qt_vol_total_w				double precision;
qt_concent_med_w			double precision;
qt_concent_med_mg_w			double precision;
qt_concent_med_ml_w			double precision := 1;
qt_concent_dose_total_w		double precision;
qt_velocidade_w				double precision;
qt_dose_w					double precision;
qt_dose_peso_w				double precision;
qt_dose_mg_w				double precision;
qt_dose_direta_w			double precision;
qt_dose_ml_w				double precision;
cd_unid_med_concetracao_w	varchar(30);
cd_unid_med_base_conc_w		varchar(30);
ie_unidade_w				varchar(15);
ie_tempo_w					varchar(15);
ie_peso_w					varchar(15);
nr_ocorrencia_w				double precision;
nr_ocorrencia_dia_w			double precision;
qt_horas_w					double precision;
qt_dose_unid_cons_w			double precision;
qt_conversao_w				double precision;
qt_peso_w					double precision;
qt_dose_terap_w				double precision;
ie_solucao_w				varchar(1);
ds_abreviacao_w				varchar(255);
qt_casas_retorno_w			integer;
existe_conversao_w			double precision;
cd_uni_cons_w               material.cd_unidade_medida_consumo%type;
sql_w 						varchar(32000);
qt_conversao_meq_w			double precision;
qt_conversao_ui_w			double precision;
qt_conversao_gts_w			double precision;
qt_conversao_ww				double precision;
qt_conversao_mg_w			double precision;
qt_conversao_ml_w			double precision;
cd_unid_med_mg_w 			varchar(40);
cd_unid_med_kg_w 			varchar(40);
cd_unid_med_g_w 			varchar(40);
cd_unid_med_mcg_w 			varchar(40);
cd_unid_med_ml_w 			varchar(40);
cd_unid_med_l_w 			varchar(40);
cd_uni_med_ue_w 			varchar(40);
ds_erro_w                   varchar(4000);
ds_parametros_w             varchar(4000);

BEGIN

if (cd_material_p > 0) then
	begin

	select	coalesce(max(qt_casas),0)
	into STRICT	qt_casas_retorno_w
	from	rep_regra_arredond_dose
	where	qt_peso_p between qt_peso_inicial and qt_peso_final;

	if (qt_casas_retorno_w = 0) then
		qt_casas_retorno_w := obter_param_usuario(1903, 2, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, 0, qt_casas_retorno_w);
	end if;

	if (qt_casas_retorno_w = 0) then
		qt_casas_retorno_w	:= 4;
	end if;

	select	max(ie_unidade),
			max(ie_tempo),
			max(ie_peso),
			max(ie_solucao),
			coalesce(max(obter_desc_expressao(cd_exp_abreviacao,ds_abreviacao)),'XPTO')
	into STRICT	ie_unidade_w,
			ie_tempo_w,
			ie_peso_w,
			ie_solucao_w,
			ds_abreviacao_w
	from	regra_dose_terap
	where	nr_sequencia	= nr_unid_med_terap_p;
---- Inicio MD1       
  begin
      sql_w := 'CALL dose_medic_md_pck.converter_peso_md(:1, :2) INTO :qt_peso_w';
      EXECUTE sql_w USING IN qt_peso_p,
                                    IN ie_peso_w,                                  
                                    OUT qt_peso_w;
  exception
    when others then
	ds_erro_w := sqlerrm;
			  ds_parametros_w := ('qt_peso_p: '||qt_peso_p
						   ||'-'||'ie_peso_w: '||ie_peso_w
						   ||'-'||'qt_peso_w: '||qt_peso_w);
			  CALL gravar_log_medical_device('CALCULAR_DOSE_MEDIC','dose_medic_md_pck.converter_peso_md'
										 ,ds_parametros_w,ds_erro_w,wheb_usuario_pck.get_nm_usuario,'S');
      qt_peso_w := null;
  end;

      sql_w := null;
--- Fim MD1
	select max(CD_UNIDADE_MEDIDA_CONSUMO)
	into STRICT cd_uni_cons_w
	from material
	where cd_material = cd_material_p;
	--- Inicio MD2

	-- Conversao da dose terapeutica para mg ou ml
   select	coalesce(max(qt_conversao),1)
              into STRICT	qt_conversao_w
              from	material_conversao_unidade
              where	cd_material = cd_material_p
                and	upper(cd_unidade_medida) = upper('GTS');

  qt_conversao_meq_w := obter_conversao_unid_med_cons(cd_material_p,upper(obter_unid_med_usua('MEQ')), qt_dose_terap_p);
  qt_conversao_ui_w := obter_conversao_unid_med_cons(cd_material_p,upper(obter_unid_med_usua('UI')), qt_dose_terap_p);
  qt_conversao_gts_w:= obter_conversao_unid_med_cons(cd_material_p,upper(obter_unid_med_usua('GTS')),qt_dose_terap_p);

  begin
    sql_w := 'BEGIN dose_medic_md_pck.converter_dose_terapeutica_md(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10); END;';

    EXECUTE sql_w USING IN ie_unidade_w,
                                  IN OUT cd_unidade_medida_p,
                                  IN cd_uni_cons_w,
                                  IN OUT qt_dose_terap_p,
                                  OUT qt_dose_terap_w,
                                  OUT qt_dose_unid_cons_w,
                                  IN qt_conversao_w,
                                  IN qt_conversao_meq_w,
                                  IN qt_conversao_ui_w,
                                  IN qt_conversao_gts_w;
  exception
    when others then
	ds_erro_w := sqlerrm;
      ds_parametros_w := ('ie_unidade_w: '||ie_unidade_w
				   ||'-'||'cd_unidade_medida_p: '||cd_unidade_medida_p
				   ||'-'||'cd_uni_cons_w: '||cd_uni_cons_w
				   ||'-'||'qt_dose_terap_p: '||qt_dose_terap_p
				   ||'-'||'qt_dose_terap_w: '||qt_dose_terap_w
				   ||'-'||'qt_dose_unid_cons_w: '||qt_dose_unid_cons_w
				   ||'-'||'qt_conversao_w: '||qt_conversao_w
				   ||'-'||'qt_conversao_meq_w: '||qt_conversao_meq_w
				   ||'-'||'qt_conversao_ui_w: '||qt_conversao_ui_w
				   ||'-'||'qt_conversao_gts_w: '||qt_conversao_gts_w);
      CALL gravar_log_medical_device('CALCULAR_DOSE_MEDIC','dose_medic_md_pck.converter_dose_terapeutica_md'
                                 ,ds_parametros_w,ds_erro_w,wheb_usuario_pck.get_nm_usuario,'S');
      qt_dose_terap_w     := null;
      qt_dose_unid_cons_w     := null;
  end;

      sql_w := null;
	--- Fim MD2


	-- verifica se existe unidade de medida cadastrada na conversao de unidade do material, caso sim usa esta para calcular a dose com base na conversao
	SELECT	coalesce(MAX(qt_conversao),0)
	into STRICT	existe_conversao_w
	from	material_conversao_unidade
	where	cd_material		= cd_material_p
	and	upper(cd_unidade_medida)= upper(ie_unidade_w);
	--- Inicio MD3
		qt_conversao_ww	:= obter_conversao_unid_med_cons(cd_material_p, ie_unidade_w, qt_dose_terap_p);	
		qt_conversao_mg_w	:= obter_conversao_unid_med_cons(cd_material_p,upper(obter_unid_med_usua('MG')), qt_dose_terap_w);	
		qt_conversao_ml_w	:= obter_conversao_unid_med_cons(cd_material_p,upper(obter_unid_med_usua('ML')), qt_dose_terap_w);

  begin
      sql_w := 'CALL dose_medic_md_pck.converter_dose_unidade_md (:1, :2, :3, :4, :5, :6) INTO :qt_dose_unid_cons_w';
      EXECUTE sql_w USING IN existe_conversao_w,
                                    IN ie_unidade_w,
                                    IN qt_conversao_ww,
                                    IN qt_conversao_mg_w,
                                    IN qt_conversao_ml_w,
									IN qt_conversao_ui_w,                                    
                                    OUT qt_dose_unid_cons_w;
  exception
    when others then
	 ds_erro_w := sqlerrm;
      ds_parametros_w := ('existe_conversao_w: '||existe_conversao_w
				   ||'-'||'ie_unidade_w: '||ie_unidade_w
				   ||'-'||'qt_conversao_ww: '||qt_conversao_ww
				   ||'-'||'qt_conversao_mg_w: '||qt_conversao_mg_w
				   ||'-'||'qt_conversao_ml_w: '||qt_conversao_ml_w
				   ||'-'||'qt_conversao_ui_w: '||qt_conversao_ui_w
				   ||'-'||'qt_dose_unid_cons_w: '||qt_dose_unid_cons_w);
      CALL gravar_log_medical_device('CALCULAR_DOSE_MEDIC','dose_medic_md_pck.converter_dose_unidade_md'
                                 ,ds_parametros_w,ds_erro_w,wheb_usuario_pck.get_nm_usuario,'S');
      qt_dose_unid_cons_w := null;
  end;

      sql_w := null;
	--- Fim MD3
	select	max(coalesce(qt_conversao_mg,1)),
			max(upper(cd_unid_med_concetracao)),
			max(upper(cd_unid_med_base_conc))
	into STRICT	qt_concent_med_w,
			cd_unid_med_concetracao_w,
			cd_unid_med_base_conc_w
	from	material
	where	cd_material	= cd_material_p;

	nr_ocorrencia_w		:= Obter_ocorrencia_intervalo(cd_intervalo_p,qt_periodo_hora_p,'O');
	nr_ocorrencia_dia_w	:= Obter_ocorrencia_intervalo(cd_intervalo_p,24,'O');
	qt_horas_w			:= Obter_ocorrencia_intervalo(cd_intervalo_p,qt_periodo_hora_p,'H');

  --- Inicio MD4

	-- Converter concentracao para mg/ml
    cd_unid_med_mg_w:= upper(obter_unid_med_usua('MG'));
    cd_unid_med_kg_w:= upper(obter_unid_med_usua('KG'));
    cd_unid_med_g_w:= upper(obter_unid_med_usua('G'));
    cd_unid_med_mcg_w:=  upper(obter_unid_med_usua('MCG'));
    cd_unid_med_ml_w:=   upper(obter_unid_med_usua('ML'));
    cd_unid_med_l_w:= upper(obter_unid_med_usua('L'));
    cd_uni_med_ue_w:= upper(obter_unid_med_usua('UE100'));

  begin

    sql_w := 'BEGIN dose_medic_md_pck.converter_concentracao_md(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12); END;';

 EXECUTE sql_w USING IN cd_unid_med_concetracao_w,
                                  OUT qt_concent_med_mg_w,
                                  IN  qt_concent_med_w,
                                  IN cd_unid_med_base_conc_w,
                                  IN OUT qt_concent_med_ml_w,
                                  IN cd_unid_med_mg_w,
                                  IN cd_unid_med_kg_w,     
                                  IN cd_unid_med_g_w,      
                                  IN cd_unid_med_mcg_w,      
                                  IN cd_unid_med_ml_w,      
                                  IN cd_unid_med_l_w,      
                                  IN cd_uni_med_ue_w;
  exception
    when others then      
	ds_erro_w := sqlerrm;
      ds_parametros_w := ('cd_unid_med_concetracao_w: '||cd_unid_med_concetracao_w
				   ||'-'||'qt_concent_med_mg_w: '||qt_concent_med_mg_w
				   ||'-'||'cd_unid_med_mg_w: '||qt_concent_med_w
				   ||'-'||'cd_unid_med_base_conc_w: '||cd_unid_med_base_conc_w
				   ||'-'||'qt_concent_med_ml_w: '||qt_concent_med_ml_w
				   ||'-'||'cd_unid_med_mg_w: '||cd_unid_med_mg_w
				   ||'-'||'cd_unid_med_kg_w: '||cd_unid_med_kg_w
				   ||'-'||'cd_unid_med_g_w: '||cd_unid_med_g_w
				   ||'-'||'cd_unid_med_mcg_w: '||cd_unid_med_mcg_w
				   ||'-'||'cd_unid_med_ml_w: '||cd_unid_med_ml_w
				   ||'-'||'cd_unid_med_l_w: '||cd_unid_med_l_w
				   ||'-'||'cd_uni_med_ue_w: '||cd_uni_med_ue_w);
      CALL gravar_log_medical_device('CALCULAR_DOSE_MEDIC','dose_medic_md_pck.converter_concentracao_md'
                                 ,ds_parametros_w,ds_erro_w,wheb_usuario_pck.get_nm_usuario,'S');
      qt_concent_med_mg_w     := null;
      qt_concent_med_ml_w     := null;
  end;
      sql_w := null;
  --- Fim MD4
	if (ie_solucao_w = 'N') then
		begin
		--- Inicio MD5   
    begin
    sql_w := 'BEGIN dose_medic_md_pck.calcular_dose_intervalo_md(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11); END;';

    EXECUTE sql_w USING IN ie_tempo_w,
                                  IN qt_casas_retorno_w,
                                  IN ds_abreviacao_w,
                                  OUT qt_dose_interv_p,
                                  IN  qt_peso_w,
                                  IN OUT qt_dose_terap_p,
                                  IN  qt_sc_p,
                                  OUT qt_dose_total_p,
                                  IN  qt_periodo_hora_p,
                                  IN  nr_ocorrencia_w,
                                  IN OUT qt_dose_unid_cons_w;
    exception
      when others then
	  ds_erro_w := sqlerrm;
      ds_parametros_w := ('ie_tempo_w: '||ie_tempo_w
	               ||'-'||'qt_casas_retorno_w: '||qt_casas_retorno_w
				   ||'-'||'ds_abreviacao_w: '||ds_abreviacao_w
				   ||'-'||'qt_dose_interv_p: '||qt_dose_interv_p
				   ||'-'||'qt_peso_w: '||qt_peso_w
				   ||'-'||'qt_dose_terap_p: '||qt_dose_terap_p
				   ||'-'||'qt_sc_p: '||qt_sc_p
				   ||'-'||'qt_dose_total_p: '||qt_dose_total_p
				   ||'-'||'qt_periodo_hora_p: '||qt_periodo_hora_p
				   ||'-'||'nr_ocorrencia_w: '||nr_ocorrencia_w
				   ||'-'||'qt_dose_unid_cons_w: '||qt_dose_unid_cons_w);
      CALL gravar_log_medical_device('CALCULAR_DOSE_MEDIC','dose_medic_md_pck.calcular_dose_intervalo_md'
                                 ,ds_parametros_w,ds_erro_w,wheb_usuario_pck.get_nm_usuario,'S');
        qt_dose_interv_p    := null;
        qt_dose_total_p     := null;
    end;
        sql_w := null;
    --- Fim MD5
		qt_conversao_w	:= obter_conversao_unid_med(cd_material_p,cd_unidade_medida_p);
		if (ds_abreviacao_w = obter_desc_expressao(881462)) or (ds_abreviacao_w = obter_desc_expressao(881464)) then
			qt_peso_w	:= qt_sc_p;
		end if;
    --- Inicio MD6
    if (nr_unid_med_terap_p not in (80, 82)) then
      begin
      sql_w := 'CALL dose_medic_md_pck.calcular_dose_peso_conv_md (:1, :2, :3, :4) INTO :qt_dose_p';
      EXECUTE sql_w USING IN qt_casas_retorno_w,
                                    IN qt_dose_unid_cons_w,
                                    IN qt_conversao_w,
                                    IN qt_peso_w,                                 
                                    OUT qt_dose_p;
      exception
        when others then
  	   ds_erro_w := sqlerrm;
        ds_parametros_w := ('qt_casas_retorno_w: '||qt_casas_retorno_w
  	               ||'-'||'qt_dose_unid_cons_w: '||qt_dose_unid_cons_w
  				   ||'-'||'qt_conversao_w: '||qt_conversao_w
  				   ||'-'||'qt_peso_w: '||qt_peso_w
  				   ||'-'||'qt_dose_p: '||qt_dose_p);
        CALL gravar_log_medical_device('CALCULAR_DOSE_MEDIC','dose_medic_md_pck.calcular_dose_peso_conv_md'
                                   ,ds_parametros_w,ds_erro_w,wheb_usuario_pck.get_nm_usuario,'S');
          qt_dose_p := null;
      end;

    end if;
    sql_w := null;
		--- Inicio MD6

		--- Inicio MD7
    begin
    sql_w := 'CALL dose_medic_md_pck.calcular_dose_diaria_md (:1, :2) INTO :qt_daily_dose_p';
    EXECUTE sql_w USING IN qt_dose_p,
                                  IN nr_ocorrencia_dia_w,                               
                                  OUT qt_daily_dose_p;
    exception
      when others then
	  ds_erro_w := sqlerrm;
      ds_parametros_w := ('qt_dose_p: '||qt_dose_p
		           ||'-'||'nr_ocorrencia_dia_w: '||nr_ocorrencia_dia_w
				   ||'-'||'qt_daily_dose_p: '||qt_daily_dose_p);
      CALL gravar_log_medical_device('CALCULAR_DOSE_MEDIC','dose_medic_md_pck.calcular_dose_diaria_md'
                                 ,ds_parametros_w,ds_erro_w,wheb_usuario_pck.get_nm_usuario,'S');
        qt_daily_dose_p := null;
    end;
    sql_w := null;
		--- Fim MD7
		end;
	elsif (ie_solucao_w = 'S') then
		begin
    --- Inicio MD8
    qt_dose_w		:= obter_conversao_ml(cd_material_p,qt_dose_p,cd_unidade_medida_p);
    begin
    sql_w := 'BEGIN dose_medic_md_pck.converter_dose_calcular_vol_md(:1, :2, :3, :4); END;';

    EXECUTE sql_w USING IN qt_dose_w,
                                  IN  ie_primeiro_principal_p,
                                  IN  qt_diluente_p,
                                  OUT qt_vol_total_w;
    exception
      when others then
ds_erro_w := sqlerrm;
      ds_parametros_w := ('qt_dose_w: '||qt_dose_w
	               ||'-'||'ie_primeiro_principal_p: '||ie_primeiro_principal_p
				   ||'-'||'qt_diluente_p: '||qt_diluente_p
				   ||'-'||'qt_vol_total_w: '||qt_vol_total_w);
      CALL gravar_log_medical_device('CALCULAR_DOSE_MEDIC','dose_medic_md_pck.converter_dose_calcular_vol_md'
                                 ,ds_parametros_w,ds_erro_w,wheb_usuario_pck.get_nm_usuario,'S');  	
        qt_vol_total_w    := null;
    end;
        sql_w := null;
    --- Fim MD8

    --- Inicio MD9
    begin
    sql_w := 'BEGIN dose_medic_md_pck.calcular_concentracao_dose_md(:1, :2, :3, :4, :5, :6, :7, :8); END;';

    EXECUTE sql_w USING IN OUT qt_concent_med_w,
                                  IN  qt_concent_med_mg_w,
                                  IN  qt_concent_med_ml_w,
                                  IN  qt_dose_p,
                                  IN  qt_dose_w,
                                  IN  ie_unidade_w,
                                  IN  qt_vol_total_w,
                                  OUT qt_concent_dose_total_w;
    exception
      when others then
		ds_erro_w := sqlerrm;
		ds_parametros_w := ('qt_concent_med_w: '||qt_concent_med_w
					 ||'-'||'qt_concent_med_mg_w: '||qt_concent_med_mg_w
					 ||'-'||'qt_concent_med_ml_w: '||qt_concent_med_ml_w
					 ||'-'||'qt_dose_p: '||qt_dose_p
					 ||'-'||'qt_dose_w: '||qt_dose_w
					 ||'-'||'ie_unidade_w: '||ie_unidade_w
					 ||'-'||'qt_concent_dose_total_w: '||qt_concent_dose_total_w
					 ||'-'||'qt_vol_total_w: '||qt_vol_total_w );	
				CALL gravar_log_medical_device('CALCULAR_DOSE_MEDIC','dose_medic_md_pck.calcular_concentracao_dose_md'
				  ,ds_parametros_w,ds_erro_w,wheb_usuario_pck.get_nm_usuario,'S');  						
        qt_concent_dose_total_w    := null;
    end;
        sql_w := null;	
    --- Fim MD9
		if (qt_dose_terap_p > 0) then
			begin

      --- Inicio MD10
      begin

      sql_w := 'BEGIN dose_medic_md_pck.calcular_dose_unidade_md(:1, :2, :3, :4, :5, :6, :7); END;';

      EXECUTE sql_w USING IN OUT qt_dose_direta_w,
                                    IN OUT qt_dose_terap_p,
                                    IN  ie_peso_w,
                                    IN  ie_primeiro_principal_p,
                                    IN  qt_peso_w,
                                    OUT qt_dose_ml_w,
                                    IN  qt_concent_dose_total_w;
      exception
        when others then
         ds_erro_w := sqlerrm;
      ds_parametros_w := ('qt_dose_direta_w: '||qt_dose_direta_w
		           ||'-'||'qt_dose_terap_p: '||qt_dose_terap_p
				   ||'-'||'ie_peso_w: '||ie_peso_w
				   ||'-'||'ie_primeiro_principal_p: '||ie_primeiro_principal_p
				   ||'-'||'qt_peso_w: '||qt_peso_w
				   ||'-'||'qt_dose_ml_w: '||qt_dose_ml_w
				   ||'-'||'qt_concent_dose_total_w: '||qt_concent_dose_total_w);
      CALL gravar_log_medical_device('CALCULAR_DOSE_MEDIC','dose_medic_md_pck.calcular_dose_unidade_md'
                                 ,ds_parametros_w,ds_erro_w,wheb_usuario_pck.get_nm_usuario,'S');
          qt_dose_ml_w    := null;
      end;
          sql_w := null;	
	    --- Fim MD10

      --- Inicio MD11
      qt_conversao_ml_w:= obter_conversao_ml(cd_material_p,qt_dose_p,cd_unidade_medida_p);

       begin
      
      sql_w := 'BEGIN dose_medic_md_pck.calcular_dose_infusao_md(:1, :2, :3, :4, :5, :6, :7, :8); END;';

      EXECUTE sql_w USING IN      ie_tempo_w,
                                    IN      ie_unidade_vel_p,
                                    IN OUT  qt_dose_ml_w,
                                    OUT     qt_vel_infusao_p,
                                    IN      ie_primeiro_principal_p,
                                    IN      qt_diluente_p,
                                    OUT     qt_dose_medic_p,
                                    IN      qt_conversao_ml_w;
      exception
        when others then
         ds_erro_w := sqlerrm;
      ds_parametros_w := ('ie_tempo_w: '||ie_tempo_w
	               ||'-'||'ie_unidade_vel_p: '||ie_unidade_vel_p
				   ||'-'||'qt_dose_ml_w: '||qt_dose_ml_w
				   ||'-'||'qt_vel_infusao_p: '||qt_vel_infusao_p
				   ||'-'||'ie_primeiro_principal_p: '||ie_primeiro_principal_p
				   ||'-'||'qt_diluente_p: '||qt_diluente_p
				   ||'-'||'qt_dose_medic_p: '||qt_dose_medic_p
				   ||'-'||'qt_conversao_ml_w: '||qt_conversao_ml_w );
      CALL gravar_log_medical_device('CALCULAR_DOSE_MEDIC','dose_medic_md_pck.calcular_dose_infusao_md'
                                 ,ds_parametros_w,ds_erro_w,wheb_usuario_pck.get_nm_usuario,'S');
          qt_vel_infusao_p    := null;
          qt_dose_medic_p     := null;
      end;
          sql_w := null;
      --- Fim MD11
			end;
		else
			begin
			qt_velocidade_w		:= qt_vel_infusao_p;
			if (upper(ie_unidade_vel_p) = 'GTM') then
				qt_velocidade_w	:= dividir(qt_vel_infusao_p,20) * 60;
			end if;

			qt_dose_terap_p	:= qt_concent_dose_total_w * qt_velocidade_w;
			if (ie_peso_w = 'KG') then
				qt_dose_terap_p	:= dividir(qt_dose_terap_p,qt_peso_p);
			end if;
			if (ie_tempo_w = 'M') then
				qt_dose_terap_p	:= dividir(qt_dose_terap_p,60);
			end if;

			end;
		end if;
		end;
	end if;
	end;
	qt_vel_infusao_p := round(qt_vel_infusao_p, qt_casas_retorno_w);
else
	qt_vel_infusao_p	:= null;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_dose_medic ( cd_material_p bigint, qt_altura_p bigint, qt_peso_p bigint, qt_sc_p bigint, qt_imc_p bigint, qt_dose_terap_p INOUT bigint, nr_unid_med_terap_p bigint, qt_diluente_p bigint, qt_periodo_hora_p bigint, qt_periodo_min_p bigint, cd_intervalo_p text, qt_dose_p INOUT bigint, cd_unidade_medida_p INOUT text, qt_vel_infusao_p INOUT bigint, ie_unidade_vel_p INOUT text, qt_fator_correcao_p bigint, qt_dose_total_p INOUT bigint, qt_dose_interv_p INOUT bigint, qt_dose_medic_p INOUT bigint, ie_primeiro_principal_p text default 'N', qt_daily_dose_p INOUT bigint DEFAULT NULL) FROM PUBLIC;
