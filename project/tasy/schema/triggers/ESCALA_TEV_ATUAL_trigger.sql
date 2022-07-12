-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_tev_atual ON escala_tev CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_tev_atual() RETURNS trigger AS $BODY$
declare

qt_reg_w		        bigint := 0;
quebra_w		        varchar(20) := Chr(13)||chr(10);
qt_imc_w		        double precision;
ie_padrao_tev_w		    varchar(10) := 'D';
qt_contra_prof_mec_w	bigint := 0;
qt_Nadroparina_w	    bigint;
qt_dose_enoxa_w		    double precision;
ds_intervalo_enoxa_w	varchar(255);
ds_fonda_w				varchar(255);
ds_dose_heparina_w		varchar(255);
ds_intervalo_heparina_w	varchar(255);
qt_absoluta_w			bigint := 0;
qt_absoluta_cursor_w	bigint := 0;
qt_relativa_w			bigint := 0;
qt_relativa_cursor_w	bigint := 0;
nr_seq_resposta_w		bigint := 0;
cd_estabelecimento_w	bigint := 0;
ds_resposta_w			varchar(4000);
qt_contra_indicacao_w	bigint;
ie_contra_ind_w			varchar(1);
qt_resp_cad_w		    bigint;
ds_resp_cad_w		    varchar(2000);
qt_cuidado_espec_w	    bigint;
ds_motivo_w				varchar(255);
qt_reg_tev_w			bigint;

/*Medical Device*/


sql_w                   varchar(3000);
ie_insuf_renal_w        varchar(1);
ie_idade_maior_w        varchar(1);
peso_parte_w            double precision;
ie_obesidade_w          varchar(1);
qt_pontuacao_w          bigint;
ie_condicao_w			escala_tev.ie_condicao%type;
ds_resultado_w			escala_tev.ds_resultado%type;

pragma autonomous_transaction;


	procedure	contagem_Contraindicacao is

		qt_reg_cad_w	bigint;
		nr_seq_cad_w	bigint;

		C01 CURSOR FOR
			SELECT	nr_sequencia
			from	tev_contraindicacao
			where	coalesce(ie_exibir_estab,ie_exibir) = 'S'
			and	coalesce(ie_tipo_contraindicacao_estab,ie_tipo_contraindicacao)  = 'A';

		C02 CURSOR FOR
			SELECT	nr_sequencia
			from	tev_contraindicacao
			where	coalesce(ie_exibir_estab,ie_exibir) = 'S'
			and	coalesce(ie_tipo_contraindicacao_estab,ie_tipo_contraindicacao)  = 'R';
BEGIN
  BEGIN
		select	count(*)
		into STRICT	qt_reg_cad_w
		from	tev_contraindicacao
		where	coalesce(ie_exibir_estab,ie_exibir) = 'S';
		--and	ie_tipo_contraindicacao_estab is not null;


		if (qt_reg_cad_w = 0) then -- Cadastro SHIFT+F11  Contraindicacoes TEV

			/*Contra indicacoes absolutas: */



			BEGIN
			  sql_w := 'call calcula_contra_ind_absoluta_md(:1, :2, :3, :4) into :qt_absoluta_w';
			  EXECUTE sql_w using in NEW.ie_hipersensibilidade_heparina,
											in NEW.ie_plaquetopenia_heparina,
											in NEW.ie_sangramento_ulcera,
											in NEW.ie_ulcera_ativa,
											out qt_absoluta_w;
			exception
			  when others then
				qt_absoluta_w := null;
			end;

			/*Contra indicacoes relativas */



			BEGIN
			  sql_w := 'call calcula_contra_ind_relativa_md(:1, :2, :3, :4, :5, :6, :7, :8) into :qt_relativa_w';
			  EXECUTE sql_w using in ie_contra_ind_w,
											in NEW.ie_cirurgia_intracraniana,
											in NEW.ie_coagulopatia,
											in NEW.ie_puncao_liquorica,
											in NEW.ie_hipertensao,
											in NEW.ie_insuf_renal,
											in NEW.ie_cont_politrauma,
											in NEW.ie_trauma_craniano,
											out qt_relativa_w;
			exception
			  when others then
				qt_relativa_w := null;
			end;
			
			if (ie_contra_ind_w = 'S') then		
				
				qt_absoluta_w := qt_absoluta_w + qt_relativa_w;

				qt_relativa_w := 0;		
			
			end if;			
			
			

		else		
			nr_seq_cad_w := 0;

			open C01;	/*  Absolutas */

			loop
				fetch C01 into nr_seq_cad_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */

			BEGIN

				BEGIN
				  sql_w := 'call calcula_contra_ind_absol_md(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, :14, :15) into :qt_absoluta_w';
				  EXECUTE sql_w using in nr_seq_cad_w,
												in NEW.ie_plaquetopenia_heparina,
												in NEW.ie_sangramento_ulcera,
												in NEW.ie_ulcera_ativa,
												in NEW.ie_hipersensibilidade_heparina,
												in NEW.ie_cirurgia_intracraniana,
												in NEW.ie_puncao_liquorica,
												in NEW.ie_coagulopatia,
												in NEW.ie_hipertensao,
												in NEW.qt_clearence,
												in NEW.ie_cont_politrauma,
												in NEW.ie_trauma_craniano,
												in NEW.ie_ci_inesp_1,
												in NEW.ie_ci_inesp_2,
												in NEW.ie_ci_inesp_3,
												out qt_absoluta_cursor_w;
				exception
				  when others then
					qt_absoluta_cursor_w := null;
				end;
				
				qt_absoluta_w := qt_absoluta_w + coalesce(qt_absoluta_cursor_w,0);				

			end;
			end loop;
			close C01;

			nr_seq_cad_w := 0;

			open C02;	/*  Relativas */

			loop
			  fetch C02 into nr_seq_cad_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
			BEGIN

				BEGIN
				  sql_w := 'call calcula_contra_ind_relat_md(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, :14, :15) into :qt_relativa_w';
				  EXECUTE sql_w using in nr_seq_cad_w,
												in NEW.ie_plaquetopenia_heparina,
												in NEW.ie_sangramento_ulcera,
												in NEW.ie_ulcera_ativa,
												in NEW.ie_hipersensibilidade_heparina,
												in NEW.ie_cirurgia_intracraniana,
												in NEW.ie_puncao_liquorica,
												in NEW.ie_coagulopatia,
												in NEW.ie_hipertensao,
												in NEW.qt_clearence,
												in NEW.ie_cont_politrauma,
												in NEW.ie_trauma_craniano,
												in NEW.ie_ci_inesp_1,
												in NEW.ie_ci_inesp_2,
												in NEW.ie_ci_inesp_3,
												out qt_relativa_cursor_w;
				exception
				  when others then
					qt_relativa_cursor_w := null;
				end;
				
				qt_relativa_w := qt_relativa_w + coalesce(qt_relativa_cursor_w,0);	
				
		end;
		end loop;
		close C02;

	  end if;

	end;


	procedure contagem_prof_Mecanica is
	BEGIN

		BEGIN
		  sql_w := 'call calcular_cont_prof_mecanica_md(:1, :2, :3, :4, :5) into :qt_contra_prof_mec_W';
		  EXECUTE sql_w using in NEW.ie_escara,
										in NEW.ie_fratura_exposta,
										in NEW.ie_infeccao_mmii,
										in NEW.ie_insuf_art_mmii,
										in NEW.ie_insuf_card_grave,
										out qt_contra_prof_mec_w;
		  exception
			when others then
			  qt_contra_prof_mec_w := null;
		  end;

	end;

	function obter_resp_tev_cad return varchar2 is

		ds_resp_w	varchar2(255);
		ds_desc_w	varchar2(255);
		ds_retorno_w	varchar2(2000);
		nr_seq_w	number(10);
		ie_concatena_w	varchar2(1);

		C01 CURSOR FOR
			SELECT	coalesce(ds_contraindicacao_estab,ds_contraindicacao),
				ds_resposta,
				nr_sequencia
			from	tev_contraindicacao
			where	coalesce(ie_exibir_estab,ie_exibir) = 'S'
			--and	ie_tipo_contraindicacao_estab is not null

			order by nr_sequencia;

	BEGIN
		select	count(*)
		into STRICT	qt_reg_w
		from	tev_contraindicacao
		where	coalesce(ie_exibir_estab,ie_exibir) = 'S'
		and	ie_tipo_contraindicacao_estab is not null
		and	trim(both ds_resposta) is not null;

		if (qt_reg_w > 0) then

			open C01;
			loop
			fetch C01 into	
				ds_desc_w,
				ds_resp_w,
				nr_seq_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				BEGIN
				-- VERIFICA SE O CAMPO(CHECKBOX) FOI MARCADO

				ie_concatena_w := 'N';
				if (nr_seq_w = 12) and (NEW.IE_HIPERSENSIBILIDADE_HEPARINA = 'S') then
					ie_concatena_w := 'S';
				elsif (nr_seq_w = 13) and (NEW.IE_PLAQUETOPENIA_HEPARINA = 'S') then
					ie_concatena_w := 'S';
				elsif (nr_seq_w = 14) and (NEW.IE_SANGRAMENTO_ULCERA = 'S') then
					ie_concatena_w := 'S';
				elsif (nr_seq_w = 15) and (NEW.IE_ULCERA_ATIVA = 'S') then
					ie_concatena_w := 'S';
				elsif (nr_seq_w = 16) and (NEW.IE_CIRURGIA_INTRACRANIANA = 'S') then
					ie_concatena_w := 'S';
				elsif (nr_seq_w = 17) and (NEW.IE_COAGULOPATIA = 'S') then
					ie_concatena_w := 'S';
				elsif (nr_seq_w = 18) and (NEW.IE_PUNCAO_LIQUORICA = 'S') then
					ie_concatena_w := 'S';
				elsif (nr_seq_w = 19) and (NEW.IE_HIPERTENSAO = 'S') then
					ie_concatena_w := 'S';
				/*elsif	(nr_seq_w = 20) and
					(:new.IE_INSUF_RENAL = 'S') then
					ie_concatena_w := 'S';*/

				elsif (nr_seq_w = 24) and (NEW.IE_CONT_POLITRAUMA = 'S') then
					ie_concatena_w := 'S';
				elsif (nr_seq_w = 25) and (NEW.IE_TRAUMA_CRANIANO = 'S') then
					ie_concatena_w := 'S';
				elsif (nr_seq_w = 27) and (NEW.IE_CI_INESP_1 = 'S') then
					ie_concatena_w := 'S';
				elsif (nr_seq_w = 28) and (NEW.IE_CI_INESP_2 = 'S') then
					ie_concatena_w := 'S';
				elsif (nr_seq_w = 29) and (NEW.IE_CI_INESP_3 = 'S') then
					ie_concatena_w := 'S';
				end if;

				if (ie_concatena_w = 'S') then
					ds_retorno_w := ds_retorno_w || chr(13) ||
							ds_desc_w || chr(13) ||
							ds_resp_w;
				end if;
				end;
			end loop;
			close C01;
		end if;

		return	ds_retorno_w;

	end;

	function Concatena_cuidados_especiais return varchar2 is

		ds_cuidados_espec_w	varchar2(2000);
		ds_retorno_w		varchar2(2000);

		C01 CURSOR FOR
			SELECT	ds_cuidados
			from	tev_cuidados_especiais
			order by nr_sequencia;

		BEGIN
		open C01;
		loop
		fetch C01 into	
			ds_cuidados_espec_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			BEGIN
			if (trim(both ds_retorno_w) is null) then
				ds_retorno_w := substr(ds_cuidados_espec_w,1,2000);
			else
				ds_retorno_w := substr(ds_retorno_w || chr(13) || ds_cuidados_espec_w,1,2000);
			end if;
			end;
		end loop;
		close C01;

		return ds_retorno_w;

	end;

BEGIN

  if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then

    select count(*)
	  into STRICT qt_cuidado_espec_w
      from tev_cuidados_especiais;

    if (qt_cuidado_espec_w > 0) then
	  NEW.ds_cuidados := Concatena_cuidados_especiais;
    end if;

    ie_padrao_tev_w := coalesce(NEW.ie_padrao,'D');

    ie_contra_ind_w := obter_param_usuario(697, 2, obter_perfil_ativo, NEW.nm_usuario, obter_estabelecimento_ativo, ie_contra_ind_w);

	/** Inicio Medical Device **/



	BEGIN
	  sql_w := 'call obter_insuf_renal_md(:1) into :ie_insuf_renal_w';
	  EXECUTE sql_w using in NEW.qt_clearence, out ie_insuf_renal_w;
	exception
	  when others then
	    ie_insuf_renal_w := null;
	end;
	NEW.ie_insuf_renal := ie_insuf_renal_w;

    if (ie_padrao_tev_w	= 'D') then

		BEGIN
		  sql_w := 'call obter_idade_maior_md(:1) into :ie_idade_maior_w';
		  EXECUTE sql_w using in NEW.qt_idade, out ie_idade_maior_w;
		exception
		  when others then
			ie_idade_maior_w := null;
		end;
		NEW.ie_idade_maior := ie_idade_maior_w;

		BEGIN
	      peso_parte_w := null;
	      sql_w := 'call obter_valor_imc_md(:1, :2, :3) into :qt_imc_w';
	      EXECUTE sql_w using in NEW.qt_peso, in peso_parte_w, in NEW.qt_altura_cm, out qt_imc_w;
	    exception
	      when others then
	        qt_imc_w := null;
	    end;

		BEGIN
		  sql_w := 'call obter_obesidade_md(:1) into :ie_obesidade_w';
		  EXECUTE sql_w using in qt_imc_w, out ie_obesidade_w;
		exception
		  when others then
			ie_obesidade_w := null;
		end;
		NEW.ie_obesidade := ie_obesidade_w;

		BEGIN
		  sql_w := 'begin obter_condicao_escala_tev_md(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12); end;';
		  EXECUTE sql_w using in NEW.ie_sangramento_ulcera,
		                                in NEW.ie_plaquetopenia_heparina,
										in NEW.ie_coagulopatia,
										in NEW.ie_ulcera_ativa,
										in NEW.ie_hipertensao,
										in NEW.ie_insuf_renal,
										in NEW.ie_cirurgia_intracraniana,
										in NEW.ie_hipersensibilidade_heparina,
										in NEW.ie_anticoagulacao,
		                                out ie_condicao_w,
										out ds_resultado_w,
										out qt_reg_tev_w;
		exception
		  when others then
			ie_condicao_w := null;
			ds_resultado_w := null;
			qt_reg_tev_w := 0;
		end;
		
		NEW.ie_condicao  := ie_condicao_w;
		NEW.ds_resultado := ds_resultado_w;
		
		qt_reg_tev_w	:= 0;
		contagem_Contraindicacao;

		contagem_prof_Mecanica;

		BEGIN
		  sql_w := 'call calcular_pontua_contra_ind_md(:1, :2) into :qt_contra_indicacao_w';
		  EXECUTE sql_w using in qt_absoluta_w, in qt_relativa_w, out qt_contra_indicacao_w;
		exception
		  when others then
			qt_contra_indicacao_w := null;
		end;

		BEGIN
		  sql_w := 'begin obter_fat_risco_escala_tev_md(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10,
		                                               :11, :12, :13, :14, :15, :16, :17, :18, :19, :20,
													   :21, :22, :23, :24, :25, :26, :27, :28, :29, :30,
													   :31, :32, :33, :34, :35, :36, :37, :38, :39, :40,
													   :41, :42, :43, :44, :45, :46, :47, :48, :49, :50,
													   :51, :52, :53, :54, :55, :56, :57, :58, :59, :60,
													   :61, :62, :63); end;';
		  EXECUTE sql_w using in NEW.ie_clinico_cirurgico,
		                                in qt_reg_tev_w,
										in NEW.ie_trombofilia,
										in NEW.ie_idade_maior,
										in NEW.ie_eclampsia,
										in NEW.ie_avci,
										in NEW.ie_tvp_ep_previa,
										in NEW.ie_doenca_reumatol,
										in NEW.ie_hist_familiar_tev,
										in NEW.ie_anticoncepcionais,
										in NEW.ie_puerperio,
										in NEW.ie_obesidade,
										in NEW.ie_internacao_uti,
										in NEW.ie_cat_venoso_central,
										in NEW.ie_paralisia_inf,
										in NEW.ie_cancer,
										in NEW.ie_gravidez,
										in NEW.ie_insuf_resp,
										in NEW.ie_insuf_arterial,
										in NEW.ie_trh,
										in NEW.ie_icc,
										in NEW.ie_dpoc,
										in NEW.ie_pneumonia,
										in NEW.ie_infla_intestinal,
										in NEW.ie_varizes,
										in NEW.ie_infecsao_grave,
										in NEW.ie_quimioterapia,
										in NEW.ie_sindrome_nefrotica,
										in NEW.ie_doenca_autoimune,
										in NEW.ie_abortamento,
										in NEW.ie_trauma,
										in NEW.ie_iam,
										in NEW.ie_queimado,
										in NEW.ie_outros,
										in NEW.ie_mobilidade_reduzida,
										in NEW.ie_tabagismo,
										in NEW.qt_idade,
										in ie_condicao_w,										
										in NEW.ie_artroplastia_joelho,
										in NEW.ie_artroplastia_quadril,
										in NEW.ie_fratura_quadril,
										in NEW.ie_oncol_curativa,
										in NEW.ie_trauma_medular,
										in NEW.ie_politrauma,
										in NEW.ie_bariatrica,
										in NEW.ie_demais_cirurgias,
										in NEW.ie_cir_pequeno_porte,
										in NEW.ie_risco_reclassif,
										in NEW.qt_peso,
										in NEW.qt_clearence,
										in qt_contra_indicacao_w,
										in qt_imc_w,
										in qt_contra_prof_mec_w,
										in qt_absoluta_w,
										in qt_relativa_w,
                                        in OLD.ie_cir_alto_risco,
                                        in NEW.ie_nao_se_aplica,
										out NEW.ie_fator_risco,
										out NEW.ie_risco,
										out ds_resultado_w,
										out NEW.ie_cir_alto_risco,
										out NEW.ie_cir_grande_medio_porte,
										out nr_seq_resposta_w;
		exception
		  when others then
			NEW.ie_fator_risco := null;
			NEW.ie_risco := null;
			ds_resultado_w := null;
			NEW.ie_cir_alto_risco := null;
            NEW.ie_cir_grande_medio_porte := null;			
			nr_seq_resposta_w := null;
		end;
		
		NEW.ds_resultado := ds_resultado_w;

		/** Fim Medical Device **/




    end if;

	if (nr_seq_resposta_w > 0) then

		select max(cd_estabelecimento)
		  into STRICT cd_estabelecimento_w
		  from atendimento_paciente
		 where nr_atendimento = NEW.nr_atendimento;		

		select max(ds_resposta)
		  into STRICT ds_resposta_w
		  from tev_resposta_estab
		 where nr_seq_resposta = nr_seq_resposta_w
		   and cd_estabelecimento = cd_estabelecimento_w;

		if (trim(both ds_resposta_w) is null) then
			select max(ds_resposta)
			  into STRICT ds_resposta_w
			  from tev_resposta
			 where nr_sequencia = nr_seq_resposta_w;
		end if;

		select count(*)
		  into STRICT qt_resp_cad_w
		  from tev_contraindicacao
		 where coalesce(ie_exibir_estab,ie_exibir) = 'S';

		if (qt_resp_cad_w > 0) then
		  ds_resposta_w := substr(ds_resposta_w || obter_resp_tev_cad, 1, 2000);
		end if;

		NEW.ds_resultado := ds_resposta_w;
		NEW.nr_seq_resposta := nr_seq_resposta_w;

	end if;
	
	if (coalesce(NEW.ie_nao_se_aplica, 'N') = 'S') then
		NEW.nr_seq_resposta := null;
		
		NEW.ds_resultado	:= obter_desc_expressao(347196);
		if (NEW.nr_seq_motivo_tev	is not null) then
			select	max(ds_motivo)
			into STRICT	ds_motivo_w
			from	tev_motivo
			where	nr_sequencia	= NEW.nr_seq_motivo_tev;
			
			if (ds_motivo_w	is not null) then
				NEW.ds_resultado	:= substr(NEW.ds_resultado||chr(13) ||'    '|| obter_desc_expressao(293478) || ': ' || ds_motivo_w, 1, 2000);
			end if;
		end if;
		
	end if;

	/** Medical Device **/



	BEGIN
	  sql_w := 'call obter_scrore_escala_tev_md(:1, :2) into :qt_pontuacao_w';
	  EXECUTE sql_w using in NEW.ie_clinico_cirurgico, in NEW.ie_risco, out qt_pontuacao_w;
	exception
	  when others then
		qt_pontuacao_w := null;
	end;
	NEW.qt_pontuacao := qt_pontuacao_w;

	/** Fim Medical Device **/



    BEGIN
      NEW.cd_setor_atendimento := obter_Setor_atendimento(NEW.nr_atendimento);
    exception
      when others then
        null;	
    end;
  end if; /*if (wheb_usuario_pck.get_ie_executar_trigger = 'S')*/

  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_tev_atual() FROM PUBLIC;

CREATE TRIGGER escala_tev_atual
	BEFORE INSERT OR UPDATE ON escala_tev FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_tev_atual();
