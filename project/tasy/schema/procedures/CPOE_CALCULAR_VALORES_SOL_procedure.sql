-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_calcular_valores_sol ( ie_tipo_solucao_p text, qt_volume_p bigint, qt_tempo_aplicacao_p bigint, ie_ref_calculo_p cpoe_material.ie_ref_calculo%type, cd_intervalo_p intervalo_prescricao.cd_intervalo%type, nr_etapas_p bigint, qt_dosagem_p bigint, qt_solucao_total_p bigint, qt_hora_fase_p text, ie_tipo_dosagem_p text, cd_intervalo_out INOUT intervalo_prescricao.cd_intervalo%type, nr_etapas_out INOUT bigint, qt_dosagem_out INOUT bigint, qt_solucao_total_out INOUT bigint, qt_hora_fase_out INOUT text, qt_hora_fase2_out INOUT text, ds_diluicao_out INOUT text, qt_dosagem_diferenciada_p INOUT text, qt_hora_fase_diferenciada_p text default null, ds_horarios_p text default null, cd_material_p material.cd_material%type default null, ds_dose_diferenciada_p cpoe_material.ds_dose_diferenciada%type default null, cd_unidade_medida_p unidade_medida.cd_unidade_medida%type default null, cd_material_comp1_p material.cd_material%type default null, ds_dose_diferenciada_comp1_p cpoe_material.ds_dose_diferenciada%type default null, cd_unid_med_dose_comp1_p unidade_medida.cd_unidade_medida%type default null, cd_material_comp2_p material.cd_material%type default null, ds_dose_diferenciada_comp2_p cpoe_material.ds_dose_diferenciada%type default null, cd_unid_med_dose_comp2_p unidade_medida.cd_unidade_medida%type default null, cd_material_comp3_p material.cd_material%type default null, ds_dose_diferenciada_comp3_p cpoe_material.ds_dose_diferenciada%type default null, cd_unid_med_dose_comp3_p unidade_medida.cd_unidade_medida%type default null, cd_material_dil_p material.cd_material%type default null, ds_dose_diferenciada_dil_p cpoe_material.ds_dose_diferenciada%type default null, cd_unid_med_dose_dil_p unidade_medida.cd_unidade_medida%type default null, cd_material_rec_p material.cd_material%type default null, ds_dose_diferenciada_rec_p cpoe_material.ds_dose_diferenciada%type default null, cd_unid_med_dose_recons_p unidade_medida.cd_unidade_medida%type default null, cd_material_red_p material.cd_material%type default null, ds_dose_diferenciada_red_p cpoe_material.ds_dose_diferenciada%type default null, cd_unid_med_dose_red_p unidade_medida.cd_unidade_medida%type default null, cd_material_comp4_p material.cd_material%type default null, ds_dose_diferenciada_comp4_p cpoe_material.ds_dose_diferenciada%type default null, cd_unid_med_dose_comp4_p unidade_medida.cd_unidade_medida%type default null, cd_material_comp5_p material.cd_material%type default null, ds_dose_diferenciada_comp5_p cpoe_material.ds_dose_diferenciada%type default null, cd_unid_med_dose_comp5_p unidade_medida.cd_unidade_medida%type default null, cd_material_comp6_p material.cd_material%type default null, ds_dose_diferenciada_comp6_p cpoe_material.ds_dose_diferenciada%type default null, cd_unid_med_dose_comp6_p unidade_medida.cd_unidade_medida%type default null) AS $body$
DECLARE


--QT_VOLUME  = Volume etapa (ml)

--QT_TEMPO_APLICACAO = Tempo total (h)

--IE_REF_CALCULO = Referencia para calculo

--CD_INTERVALO = Intervalo

--NR_ETAPAS = No etapas

--QT_DOSAGEM = Velocidade de infusao

--QT_SOLUCAO_TOTAL = Volume total

--QT_HORA_FASE = Tempo etapa (h)
gotas_w        double precision;
tempo_w        double precision;
EXEC_w         varchar(300);

	procedure CPOE_Calculo_normal(	ie_tipo_solucao_p				char,
									qt_volume_p						bigint,
									qt_tempo_aplicacao_p			bigint,
									ie_ref_calculo_p				cpoe_material.ie_ref_calculo%type,
									cd_intervalo_p					intervalo_prescricao.cd_intervalo%type,
									nr_etapas_p						bigint,
									qt_dosagem_p					bigint,
									qt_solucao_total_p				bigint,
									qt_hora_fase_p					text,
									ie_tipo_dosagem_p				text,
									cd_intervalo_out			out	intervalo_prescricao.cd_intervalo%type,
									nr_etapas_out				out	bigint,
									qt_dosagem_out				out	bigint,
									qt_solucao_total_out		out	bigint,
									qt_hora_fase_out			out	text,
									ds_diluicao_out				out	text
									 ) is

		qt_tempo_aplicacao_w	double precision;
		nr_etapas_w				double precision := nr_etapas_p;
		qt_dosagem_w			double precision;
		qt_solucao_total_w		double precision;
		qt_hora_fase_w			double precision;
		
		ie_ref_calculo_w		cpoe_material.ie_ref_calculo%type;

		cd_intervalo_w			intervalo_prescricao.cd_intervalo%type;
		ie_operacao_w			intervalo_prescricao.ie_operacao%type;
		qt_operacao_w			intervalo_prescricao.qt_operacao%type;
		ie_continuo_w			intervalo_prescricao.ie_continuo%type;

		resultado_w				double precision;

		ds_retorno_w			varchar(4000);
		ie_infusion_cal_w		varchar(1);
		
		-- Procedure que gera os valores, conforme o intervalo
		procedure gerar_valores_intervalo is
;
BEGIN
      -- Consultar informacoes do cadastro
      select	max(a.ie_operacao),
          max(a.qt_operacao),
          coalesce(max(a.ie_continuo),'N')
      into STRICT 	ie_operacao_w,
          qt_operacao_w,
          ie_continuo_w
      from	intervalo_prescricao a
      where	a.cd_intervalo = cd_intervalo_p;

      -- Calcula tempo da etapa, baseado no intervalo e no tempo total da fase ( Calcular_etapas_interv_solucao )

      --INICIO MD 1
      begin
        EXEC_w := 'BEGIN CPOE_CALC_VALORES_SOL_MD_PCK.CALCULA_HORA_FASE_ETAPAS_MD(:1,:2,:3,:4,:5,:6,:7,:8,:9); END;';

        EXECUTE EXEC_w USING IN ie_operacao_w,
                                       IN qt_operacao_w,
                                       IN ie_continuo_w,
                                       IN qt_solucao_total_p, 
                                       IN qt_dosagem_p, 
                                       IN qt_tempo_aplicacao_p, 
                                       OUT qt_hora_fase_w,
                                       OUT nr_etapas_w,
                                       OUT nr_etapas_out;
      exception
          when others then
            qt_hora_fase_w := null;
            nr_etapas_w    := null;
            nr_etapas_out  := null;
      end;
    end;

	begin
		ie_infusion_cal_w := obter_param_usuario(2314, 32, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, ie_infusion_cal_w);

    if (ie_tipo_solucao_p = 'C') then
      if (ie_ref_calculo_p = 'I') then
        if (cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '') then
            gerar_valores_intervalo;
        end if;
      end if;

    elsif (ie_tipo_solucao_p = 'I') then
      if (ie_ref_calculo_p = 'I') then
        if (cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '') then
          gerar_valores_intervalo;
        end if;
      end if;
    end if;

    --INICIO MD 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7
    begin
      EXEC_w := 'BEGIN CPOE_CALC_VALORES_SOL_MD_PCK.CALCULAR_TIPO_SOLUCAO_MD(:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13,:14,:15,:16,:17,:18); END;';

      EXECUTE EXEC_w USING IN ie_tipo_solucao_p,
                                     IN ie_ref_calculo_p,
                                     IN cd_intervalo_p,
                                     IN OUT qt_hora_fase_w,      
                                     IN nr_etapas_p,      
                                     IN qt_volume_p,       
                                     IN Gotas_w,      
                                     IN qt_tempo_aplicacao_p,       
                                     IN Tempo_w,     
                                     IN OUT nr_etapas_w,
                                     IN qt_hora_fase_p,     
                                     IN qt_dosagem_p,
                                     IN qt_solucao_total_p,
                                     IN ie_infusion_cal_w,
                                     OUT qt_hora_fase_out,
                                     OUT qt_solucao_total_out,
                                     OUT qt_dosagem_out,
                                     IN OUT nr_etapas_out;
    exception
        when others then
          qt_hora_fase_w       := null;
          nr_etapas_w          := null;
          qt_hora_fase_out     := null;
          qt_solucao_total_out := null;
          qt_dosagem_out       := null;
          nr_etapas_out        := null;
    end;
    --FIM MD 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7


		-- Ajuste de formacao do tempo de cada etapa
		if (qt_hora_fase_out IS NOT NULL AND qt_hora_fase_out::text <> '') then
			qt_hora_fase2_out := trunc(qt_hora_fase_w);
			qt_hora_fase_out	:= formata_hora(qt_hora_fase_out);
		end if;

		ds_diluicao_out := substr(ds_diluicao_out || CPOE_obter_diluicao( ie_tipo_solucao_p, qt_volume_p, qt_tempo_aplicacao_p, cd_intervalo_out, nr_etapas_out, trim(both to_char(round((qt_dosagem_out)::numeric,2), '9990D99')), qt_solucao_total_out, qt_hora_fase_out, trunc(qt_hora_fase_w), ie_tipo_dosagem_p, ie_ref_calculo_p ),1,4000);
	end;
	
	procedure CPOE_Calculo_diferenciado(	ie_tipo_solucao_p				varchar2,
											qt_volume_p						number,
											qt_tempo_aplicacao_p			number,
											ie_ref_calculo_p				cpoe_material.ie_ref_calculo%type,
											cd_intervalo_p					intervalo_prescricao.cd_intervalo%type,
											nr_etapas_p						number,
											qt_dosagem_p					number,
											qt_solucao_total_p				number,
											qt_hora_fase_p					varchar2,
											ie_tipo_dosagem_p				varchar2,
											cd_intervalo_out			out	intervalo_prescricao.cd_intervalo%type,
											nr_etapas_out				out	number,
											qt_dosagem_out				out	number,
											qt_solucao_total_out		out	number,
											qt_hora_fase_out			out	varchar2,
											qt_hora_fase2_out			out	varchar2,
											ds_diluicao_out				out	varchar2,
											qt_dosagem_diferenciada_p	out	varchar2,
											qt_hora_fase_diferenciada_p		varchar2 ,
											ds_horarios_p					varchar2 ,
											cd_material_p					material.cd_material%type ,
											ds_dose_diferenciada_p			cpoe_material.ds_dose_diferenciada%type ,
											cd_unidade_medida_p				unidade_medida.cd_unidade_medida%type ,
											cd_material_comp1_p				material.cd_material%type ,
											ds_dose_diferenciada_comp1_p	cpoe_material.ds_dose_diferenciada%type ,
											cd_unid_med_dose_comp1_p		unidade_medida.cd_unidade_medida%type ,
											cd_material_comp2_p				material.cd_material%type ,
											ds_dose_diferenciada_comp2_p	cpoe_material.ds_dose_diferenciada%type ,
											cd_unid_med_dose_comp2_p		unidade_medida.cd_unidade_medida%type ,
											cd_material_comp3_p				material.cd_material%type ,
											ds_dose_diferenciada_comp3_p	cpoe_material.ds_dose_diferenciada%type ,
											cd_unid_med_dose_comp3_p		unidade_medida.cd_unidade_medida%type ,
											cd_material_comp4_p				material.cd_material%type ,
											ds_dose_diferenciada_comp4_p	cpoe_material.ds_dose_diferenciada%type ,
											cd_unid_med_dose_comp4_p		unidade_medida.cd_unidade_medida%type ,
											cd_material_comp5_p				material.cd_material%type ,
											ds_dose_diferenciada_comp5_p	cpoe_material.ds_dose_diferenciada%type ,
											cd_unid_med_dose_comp5_p		unidade_medida.cd_unidade_medida%type ,
											cd_material_comp6_p				material.cd_material%type ,
											ds_dose_diferenciada_comp6_p	cpoe_material.ds_dose_diferenciada%type ,
											cd_unid_med_dose_comp6_p		unidade_medida.cd_unidade_medida%type ,
											cd_material_dil_p				material.cd_material%type ,
											ds_dose_diferenciada_dil_p		cpoe_material.ds_dose_diferenciada%type ,
											cd_unid_med_dose_dil_p			unidade_medida.cd_unidade_medida%type ,
											cd_material_rec_p				material.cd_material%type ,
											ds_dose_diferenciada_rec_p		cpoe_material.ds_dose_diferenciada%type ,
											cd_unid_med_dose_recons_p		unidade_medida.cd_unidade_medida%type ,
											cd_material_red_p				material.cd_material%type ,
											ds_dose_diferenciada_red_p		cpoe_material.ds_dose_diferenciada%type ,
											cd_unid_med_dose_red_p			unidade_medida.cd_unidade_medida%type  ) is

		type v_base_qt_duracao_etapa is record(valor		number(18,6));
		type v_qt_duracao_etapa is table of v_base_qt_duracao_etapa index by binary_integer;

		type v_base_ds_dose_dif is record(valor	number(18,6));
		type v_ds_dose_diferenciada is table of v_base_ds_dose_dif index by binary_integer;

		type v_base_ds_horarios is record(valor	varchar2(4000));
		type v_ds_horarios is table of v_base_ds_horarios index by binary_integer;

		type v_base_solucao is record(		qt_duracao_etapa	v_qt_duracao_etapa,
											qt_volume_etapa		v_ds_dose_diferenciada,
											horarios			v_ds_horarios,
											qt_dosagem			number(18,6),
											qt_volume_total		number(18,6));
		type solucao is table of v_base_solucao index by binary_integer;
		inf_solucao	solucao;

		i						Integer := 0;
		posicao					Integer := 0;
		posicao2				Integer := 3;

		nr_etapas_w				number(18,6) := nr_etapas_p;
		vl_etapa_w				prescr_solucao_esquema.qt_volume%type;
		ie_tipo_dosagem_w		prescr_solucao.ie_tipo_dosagem%type;
		qt_solucao_total_w		prescr_solucao.qt_solucao_total%type;
		qt_dosagem_w			prescr_solucao.qt_dosagem%type;

		ds_totalizar_w			varchar2(4000);
		
		ds_dose_dif_w			prescr_material.ds_dose_diferenciada%type;
		cd_mat_w				prescr_material.cd_material%type;
		cd_unid_med_dose_w		unidade_medida.cd_unidade_medida%type;
		
		ds_dose_diferenciada_w			cpoe_material.ds_dose_diferenciada%type := ds_dose_diferenciada_p;
		ds_dose_diferenciada_comp1_w	cpoe_material.ds_dose_diferenciada%type := ds_dose_diferenciada_comp1_p;
		ds_dose_diferenciada_comp2_w	cpoe_material.ds_dose_diferenciada%type := ds_dose_diferenciada_comp2_p;
		ds_dose_diferenciada_comp3_w	cpoe_material.ds_dose_diferenciada%type := ds_dose_diferenciada_comp3_p;
		ds_dose_diferenciada_comp4_w	cpoe_material.ds_dose_diferenciada%type := ds_dose_diferenciada_comp4_p;
		ds_dose_diferenciada_comp5_w	cpoe_material.ds_dose_diferenciada%type := ds_dose_diferenciada_comp5_p;
		ds_dose_diferenciada_comp6_w	cpoe_material.ds_dose_diferenciada%type := ds_dose_diferenciada_comp6_p;
		ds_dose_diferenciada_rec_w		cpoe_material.ds_dose_diferenciada%type := ds_dose_diferenciada_rec_p;
		ds_dose_diferenciada_dil_w		cpoe_material.ds_dose_diferenciada%type := ds_dose_diferenciada_dil_p;
		ds_dose_diferenciada_red_w		cpoe_material.ds_dose_diferenciada%type := ds_dose_diferenciada_red_p;
		
		qt_hora_fase_w					number(18,6);

		ds_valor_horario_w		varchar2(30) := '';
		vl_retorno_w			number(18,6);
		ds_horarios_w			varchar2(4000);
		ds_diluicao_aux_w		varchar2(4000);
		nr_etapa_w				number(3);
		ie_div_padrao_w			char(1) := '-';
		ie_div_horario_w		char(1) := ' ';

		ds_duracao_w					cpoe_material.qt_hora_fase%type;

		qt_duracao_diferenciada_w		cpoe_material.qt_hora_fase_diferenciada%type	:= replace(qt_hora_fase_diferenciada_p || ie_div_padrao_w, ie_div_padrao_w || ie_div_padrao_w, ie_div_padrao_w);
			

		-- Procedure que gera os valores, conforme o intervalo
		procedure gerar_valores_intervalo is
		
				cd_intervalo_w			intervalo_prescricao.cd_intervalo%type;
				ie_operacao_w			intervalo_prescricao.ie_operacao%type;
				qt_operacao_w			intervalo_prescricao.qt_operacao%type;
				ie_continuo_w			intervalo_prescricao.ie_continuo%type;
			begin
          -- Consultar informacoes do cadastro
          select	max(a.ie_operacao),
              max(a.qt_operacao),
              coalesce(max(a.ie_continuo),'N')
          into STRICT 	ie_operacao_w,
              qt_operacao_w,
              ie_continuo_w
          from	intervalo_prescricao a
          where	a.cd_intervalo = cd_intervalo_p;

          -- Calcula tempo da etapa, baseado no intervalo e no tempo total da fase ( Calcular_etapas_interv_solucao)

          --INICIO MD 4
          begin
            EXEC_w := 'BEGIN CPOE_CALC_VALORES_SOL_MD_PCK.CALCULA_TEMPO_ETAPAS_MD(:1,:2,:3,:4,:5,:6,:7,:8,:9); END;';

            EXECUTE EXEC_w USING IN ie_operacao_w,
                                          IN qt_operacao_w,
                                          IN ie_continuo_w,
                                          IN qt_solucao_total_p, 
                                          IN qt_dosagem_p, 
                                          IN qt_tempo_aplicacao_p, 
                                          OUT qt_hora_fase_w,
                                          OUT nr_etapas_w,
                                          OUT nr_etapas_out;
          exception
              when others then
                qt_hora_fase_w := null;
                nr_etapas_w    := null;
                nr_etapas_out  := null;
          end;
          --FIM MD 4
			end;

		-- Procedure que soma as doses em cada etapa, e define o volume total da solucao
		procedure Totalizar_valores_dif(	cd_material_p				material.cd_material%type,
											ds_dose_dif_p		in	out	cpoe_material.ds_dose_diferenciada%type,
											cd_unidade_medida_p			unidade_medida.cd_unidade_medida%type ) is 
			posicao		Integer := 0;
			qt_valor_w	number(18,6);	
		begin
			if (ds_dose_dif_p IS NOT NULL AND ds_dose_dif_p::text <> '') then
        --INICIO MD 5
        begin
          EXEC_w := 'BEGIN CPOE_CALC_VALORES_SOL_MD_PCK.CALCULA_DOSE_DIF_MD(:1,:2,:3,:4); END;';

          EXECUTE EXEC_w USING IN OUT ds_dose_dif_p,
                                         IN ie_div_padrao_w,
                                         OUT posicao,
                                         OUT qt_valor_w;
        exception
            when others then
              ds_dose_dif_p  := null;
              posicao        := null;
              qt_valor_w     := null;
        end;

				--FIM MD 5
				
        qt_valor_w	:= coalesce(obter_conversao_ml(cd_material_p, qt_valor_w, cd_unidade_medida_p),0);
				
        --INICIO MD 6
        begin
          EXEC_w := 'BEGIN CPOE_CALC_VALORES_SOL_MD_PCK.CALCULA_VOLUME_DS_DOSE_DIF_MD(:1,:2,:3,:4,:5); END;';

          EXECUTE EXEC_w USING IN OUT inf_solucao[1].qt_volume_etapa(i).valor,
                                         IN OUT inf_solucao[1].qt_volume_total,
                                         IN qt_valor_w,
                                         OUT posicao,
                                         IN OUT ds_dose_dif_p;
        exception
            when others then
              posicao        := null;
              ds_dose_dif_p  := null;
        end;
        --FIM MD 6
			end if;
			
			ds_dose_dif_p	:= trim(both ds_dose_dif_p);
		end;

	begin
		ds_diluicao_out	:= '';


		if (ie_ref_calculo_p = 'I') then
			gerar_valores_intervalo;
		end if;
		
		-- Substituicao de espacamento dos horarios
		ds_horarios_w	:= replace(replace(replace(replace(padroniza_horario_prescr(ds_horarios_p, null),'  ',' '),'  ',' '),'  ',' '),'  ',' ');
		
    --INICIO MD 7
    begin
      EXEC_w := 'CALL CPOE_CALC_VALORES_SOL_MD_PCK.CALCULA_DS_HORARIOS_MD(:1,:2) INTO :RESULT';

      EXECUTE EXEC_w USING IN ds_horarios_w,
                                     IN ie_div_horario_w,
                                     OUT ds_horarios_w;
    exception
        when others then
          ds_horarios_w := null;
    end;
    --FIM MD 7

            
		-- Popular valores (duracao, horario, e dose) para cada etapa
		i := 0;
		while(i < nr_etapas_w) loop
      begin
        --INICIO MD 8
        begin
          EXEC_w := 'BEGIN CPOE_CALC_VALORES_SOL_MD_PCK.CALCULA_DURACAO_ETAPA_MD(:1,:2,:3,:4,:5,:6,:7,:8); END;';

          EXECUTE EXEC_w USING IN OUT qt_duracao_diferenciada_w,
                                          IN ie_div_padrao_w,
                                          IN qt_dosagem_w,
                                          IN ie_div_horario_w,
                                          OUT inf_solucao[1].qt_duracao_etapa(i).valor,
                                          OUT inf_solucao[1].horarios(i).valor,
                                          IN OUT ds_horarios_w,
                                          OUT inf_solucao[1].qt_volume_etapa(i).valor;

        exception
            when others then
              qt_duracao_diferenciada_w := null;
              ds_horarios_w             := null;
        end;
        --FIM MD 8
        i := i+1;
			end;
		end loop;
		
		inf_solucao[1].qt_volume_total	:= 0;
		
		-- Somar as doses de cada etapa e totalizar
		i := 0;
		while(i < nr_etapas_w) loop
			begin
			Totalizar_valores_dif(	cd_material_p,			ds_dose_diferenciada_w,			cd_unidade_medida_p );
			Totalizar_valores_dif(	cd_material_comp1_p,	ds_dose_diferenciada_comp1_w,	cd_unid_med_dose_comp1_p );
			Totalizar_valores_dif(	cd_material_comp2_p,	ds_dose_diferenciada_comp2_w,	cd_unid_med_dose_comp2_p );
			Totalizar_valores_dif(	cd_material_comp3_p,	ds_dose_diferenciada_comp3_w,	cd_unid_med_dose_comp3_p );
			Totalizar_valores_dif(	cd_material_comp4_p,	ds_dose_diferenciada_comp4_w,	cd_unid_med_dose_comp4_p );
			Totalizar_valores_dif(	cd_material_comp5_p,	ds_dose_diferenciada_comp5_w,	cd_unid_med_dose_comp5_p );
			Totalizar_valores_dif(	cd_material_comp6_p,	ds_dose_diferenciada_comp6_w,	cd_unid_med_dose_comp6_p );
			Totalizar_valores_dif(	cd_material_rec_p,		ds_dose_diferenciada_rec_w,		cd_unid_med_dose_recons_p );
			Totalizar_valores_dif(	cd_material_dil_p,		ds_dose_diferenciada_dil_w,		cd_unid_med_dose_dil_p );
			Totalizar_valores_dif(	cd_material_red_p,		ds_dose_diferenciada_red_w,		cd_unid_med_dose_red_p );
			i := i+1;
			end;
		end loop;

		qt_dosagem_diferenciada_p	:= '';
		
		-- Calcular velocidade de infusao
		i := 0;
		while(i < nr_etapas_w) loop
			begin
			-- Continuo
			if (ie_tipo_solucao_p = 'C') then
				begin
				if (ie_ref_calculo_p = 'I') then
					if (cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '') then
						gerar_valores_intervalo;
					end if;
				elsif (ie_ref_calculo_p = 'NE') then
					if (nr_etapas_p IS NOT NULL AND nr_etapas_p::text <> '') then
						begin
						nr_etapas_out := nr_etapas_p;

						--Calcula tempo da etapa, baseado no  Calcular_etapas_interv_solucao
						qt_hora_fase_w		:= dividir( qt_tempo_aplicacao_p, nr_etapas_p );
						end;
					end if;
				end if;
				end;
			-- Intermitente
			elsif (ie_tipo_solucao_p = 'I') then
				begin
				if (ie_ref_calculo_p = 'I') then
					if (cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '') then
						begin
						gerar_valores_intervalo;
						end;
					end if;
				elsif (ie_ref_calculo_p = 'NE') then
					if (nr_etapas_p IS NOT NULL AND nr_etapas_p::text <> '') then
						begin
						nr_etapas_out := nr_etapas_p;
						end;
					end if;
				end if;
				
				qt_hora_fase_w	:= inf_solucao[1].qt_duracao_etapa(i).valor;

				end;
			end if;
			
			if (qt_hora_fase_w = 0) then
				ds_diluicao_out	:= '';
				goto texto_incompleto;
			end if;
			--INICIO MD -

			--Calculo da velocidade de infusao
      begin
        EXEC_w := 'BEGIN CPOE_CALC_VALORES_SOL_MD_PCK.CALCULA_VELOCIDADE_INFUSAO_MD(:1,:2,:3,:4,:5,:6,:7,:8); END;';

        EXECUTE EXEC_w USING IN inf_solucao[1].qt_volume_etapa(i).valor,
                                       IN Gotas_w,
                                       IN qt_hora_fase_w,
                                       IN Tempo_w,
                                       IN ie_div_padrao_w,
                                       OUT qt_dosagem_w,
                                       OUT qt_hora_fase_out,
                                       OUT qt_dosagem_diferenciada_p;

      exception
          when others then
            qt_duracao_diferenciada_w := null;
            ds_horarios_w             := null;
      end;
      --FIM MD 9


			-- Gera texto de orientacao de preparo
			if (ie_tipo_solucao_p = 'C') then
				ds_diluicao_aux_w := substr(CPOE_obter_diluicao(
												ie_tipo_solucao_p,
												inf_solucao[1].qt_volume_etapa(i).valor,
												qt_tempo_aplicacao_p,
												null,--cd_intervalo_p,
												null,--nr_etapas_out, 
												Campo_mascara_virgula(qt_dosagem_w), 
												null, 
												null, 
												null,--round(qt_hora_fase_w,2), 
												ie_tipo_dosagem_p,
												ie_ref_calculo_p) 
									,1,4000);
			else
				ds_diluicao_aux_w := substr(CPOE_obter_diluicao(
												ie_tipo_solucao_p,
												inf_solucao[1].qt_volume_etapa(i).valor,
												qt_tempo_aplicacao_p,
												null,--cd_intervalo_p,
												null,--nr_etapas_out, 
												Campo_mascara_virgula(qt_dosagem_w), 
												null, 
												qt_hora_fase_out, 
												null, 
												ie_tipo_dosagem_p,
												ie_ref_calculo_p) 
									,1,4000);
			end if;
			
			if (ds_diluicao_aux_w IS NOT NULL AND ds_diluicao_aux_w::text <> '') then
        --INICIO MD 10
        begin
          EXEC_w := 'CALL CPOE_CALC_VALORES_SOL_MD_PCK.CALCULA_DS_DILUICAO_MD(:1,:2,:3) INTO :RESULT';

          EXECUTE EXEC_w USING IN ds_diluicao_out,
                                         IN ds_diluicao_aux_w,
                                         IN inf_solucao[1].horarios(i).valor,
                                         OUT ds_diluicao_out;
        exception
            when others then
              ds_diluicao_out := null;
        end;
        --FIM MD 10
			end if;
			
			i := i+1;
			end;
		end loop;
		
		if (qt_dosagem_diferenciada_p IS NOT NULL AND qt_dosagem_diferenciada_p::text <> '') then
			posicao	:= length(qt_dosagem_diferenciada_p)-1;
			if (substr(qt_dosagem_diferenciada_p,posicao) = ie_div_padrao_w) then
				qt_dosagem_diferenciada_p	:= substr(qt_dosagem_diferenciada_p,1,posicao);
			end if;
		end if;
		
		<<texto_incompleto>>
		
		qt_hora_fase_out		:= '';
		qt_hora_fase2_out		:= '';
		qt_solucao_total_out	:= inf_solucao[1].qt_volume_total;
	end;
	
begin

--Definir qual a unidade de medida padrao para calcular na CPOE.

--INICIO MD 10
begin
  EXEC_w := 'BEGIN CPOE_CALC_VALORES_SOL_MD_PCK.CALCULA_UNID_MEDIDA_PADRAO_MD(:1,:2,:3); END;';

  EXECUTE EXEC_w USING IN ie_tipo_dosagem_p,
                                 OUT Gotas_w,
                                 OUT Tempo_w;

exception
    when others then
      Gotas_w  := null;
      Tempo_w  := null;
end;
--FIM MD 10


-- Verifica se solucao com dose diferenciada
if (ds_dose_diferenciada_p IS NOT NULL AND ds_dose_diferenciada_p::text <> '') then
	CPOE_Calculo_diferenciado(	ie_tipo_solucao_p,				qt_volume_p,					qt_tempo_aplicacao_p,
								ie_ref_calculo_p,				cd_intervalo_p,					nr_etapas_p,
								qt_dosagem_p,					qt_solucao_total_p,				qt_hora_fase_p,
								ie_tipo_dosagem_p,				cd_intervalo_out,				nr_etapas_out,
								qt_dosagem_out,					qt_solucao_total_out,			qt_hora_fase_out,
								qt_hora_fase2_out,				ds_diluicao_out,				qt_dosagem_diferenciada_p,
								qt_hora_fase_diferenciada_p,	ds_horarios_p,				
								cd_material_p,					ds_dose_diferenciada_p,			cd_unidade_medida_p,
								cd_material_comp1_p,			ds_dose_diferenciada_comp1_p,	cd_unid_med_dose_comp1_p,
								cd_material_comp2_p,			ds_dose_diferenciada_comp2_p,	cd_unid_med_dose_comp2_p,
								cd_material_comp3_p,			ds_dose_diferenciada_comp3_p,	cd_unid_med_dose_comp3_p,
								cd_material_comp4_p,			ds_dose_diferenciada_comp4_p,	cd_unid_med_dose_comp4_p,
								cd_material_comp5_p,			ds_dose_diferenciada_comp5_p,	cd_unid_med_dose_comp5_p,
								cd_material_comp6_p,			ds_dose_diferenciada_comp6_p,	cd_unid_med_dose_comp6_p,
								cd_material_dil_p,				ds_dose_diferenciada_dil_p,		cd_unid_med_dose_dil_p,
								cd_material_rec_p,				ds_dose_diferenciada_rec_p,		cd_unid_med_dose_recons_p,
								cd_material_red_p,				ds_dose_diferenciada_red_p,		cd_unid_med_dose_red_p);

else
	CPOE_Calculo_normal(		ie_tipo_solucao_p,				qt_volume_p,				qt_tempo_aplicacao_p,
								ie_ref_calculo_p,				cd_intervalo_p,				nr_etapas_p,
								qt_dosagem_p,				qt_solucao_total_p,			qt_hora_fase_p,
								ie_tipo_dosagem_p,				cd_intervalo_out,			nr_etapas_out,
								qt_dosagem_out,			qt_solucao_total_out,		qt_hora_fase_out,
								ds_diluicao_out);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_calcular_valores_sol ( ie_tipo_solucao_p text, qt_volume_p bigint, qt_tempo_aplicacao_p bigint, ie_ref_calculo_p cpoe_material.ie_ref_calculo%type, cd_intervalo_p intervalo_prescricao.cd_intervalo%type, nr_etapas_p bigint, qt_dosagem_p bigint, qt_solucao_total_p bigint, qt_hora_fase_p text, ie_tipo_dosagem_p text, cd_intervalo_out INOUT intervalo_prescricao.cd_intervalo%type, nr_etapas_out INOUT bigint, qt_dosagem_out INOUT bigint, qt_solucao_total_out INOUT bigint, qt_hora_fase_out INOUT text, qt_hora_fase2_out INOUT text, ds_diluicao_out INOUT text, qt_dosagem_diferenciada_p INOUT text, qt_hora_fase_diferenciada_p text default null, ds_horarios_p text default null, cd_material_p material.cd_material%type default null, ds_dose_diferenciada_p cpoe_material.ds_dose_diferenciada%type default null, cd_unidade_medida_p unidade_medida.cd_unidade_medida%type default null, cd_material_comp1_p material.cd_material%type default null, ds_dose_diferenciada_comp1_p cpoe_material.ds_dose_diferenciada%type default null, cd_unid_med_dose_comp1_p unidade_medida.cd_unidade_medida%type default null, cd_material_comp2_p material.cd_material%type default null, ds_dose_diferenciada_comp2_p cpoe_material.ds_dose_diferenciada%type default null, cd_unid_med_dose_comp2_p unidade_medida.cd_unidade_medida%type default null, cd_material_comp3_p material.cd_material%type default null, ds_dose_diferenciada_comp3_p cpoe_material.ds_dose_diferenciada%type default null, cd_unid_med_dose_comp3_p unidade_medida.cd_unidade_medida%type default null, cd_material_dil_p material.cd_material%type default null, ds_dose_diferenciada_dil_p cpoe_material.ds_dose_diferenciada%type default null, cd_unid_med_dose_dil_p unidade_medida.cd_unidade_medida%type default null, cd_material_rec_p material.cd_material%type default null, ds_dose_diferenciada_rec_p cpoe_material.ds_dose_diferenciada%type default null, cd_unid_med_dose_recons_p unidade_medida.cd_unidade_medida%type default null, cd_material_red_p material.cd_material%type default null, ds_dose_diferenciada_red_p cpoe_material.ds_dose_diferenciada%type default null, cd_unid_med_dose_red_p unidade_medida.cd_unidade_medida%type default null, cd_material_comp4_p material.cd_material%type default null, ds_dose_diferenciada_comp4_p cpoe_material.ds_dose_diferenciada%type default null, cd_unid_med_dose_comp4_p unidade_medida.cd_unidade_medida%type default null, cd_material_comp5_p material.cd_material%type default null, ds_dose_diferenciada_comp5_p cpoe_material.ds_dose_diferenciada%type default null, cd_unid_med_dose_comp5_p unidade_medida.cd_unidade_medida%type default null, cd_material_comp6_p material.cd_material%type default null, ds_dose_diferenciada_comp6_p cpoe_material.ds_dose_diferenciada%type default null, cd_unid_med_dose_comp6_p unidade_medida.cd_unidade_medida%type default null) FROM PUBLIC;

