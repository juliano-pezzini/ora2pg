-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE oft_obter_valores ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text, vLista INOUT strRecTypeFormOft) AS $body$
DECLARE


vOftAnamnese_w						strRecTypeFormOft := strRecTypeFormOft();
vOftAutoRefracao_w				strRecTypeFormOft := strRecTypeFormOft();
xOftTonometriaAplanacao_w		strRecTypeFormOft := strRecTypeFormOft();
xOftTonometriaPneumatica_w		strRecTypeFormOft := strRecTypeFormOft();
vOftRefracao_w						strRecTypeFormOft := strRecTypeFormOft();
vOftBiomicroscopia_w				strRecTypeFormOft := strRecTypeFormOft();
vOftFundoscopia_w					strRecTypeFormOft := strRecTypeFormOft();
vOftConduta_w						strRecTypeFormOft := strRecTypeFormOft();
vOftAngiofluorsceinografia_w	strRecTypeFormOft := strRecTypeFormOft();
vOftRetinografia_w				strRecTypeFormOft := strRecTypeFormOft();
vOftBiometria_w					strRecTypeFormOft := strRecTypeFormOft();
vOftCampimetria_w					strRecTypeFormOft := strRecTypeFormOft();
vOftCapsulotomia_w				strRecTypeFormOft := strRecTypeFormOft();
vOftCerastocopia_w				strRecTypeFormOft := strRecTypeFormOft();
vOftConsultaLente_w				strRecTypeFormOft := strRecTypeFormOft();
vOftCurvaTencional_w				strRecTypeFormOft := strRecTypeFormOft();
vOftDaltonismo_w					strRecTypeFormOft := strRecTypeFormOft();
vOftDnp_w							strRecTypeFormOft := strRecTypeFormOft();
vOftExameExterno_w				strRecTypeFormOft := strRecTypeFormOft();
vOftFotocoagulacaoLaser_w		strRecTypeFormOft := strRecTypeFormOft();
vOftGonioscopia_w					strRecTypeFormOft := strRecTypeFormOft();
vOftIridectomia_w					strRecTypeFormOft := strRecTypeFormOft();
vOftMapeamentoRetina_w			strRecTypeFormOft := strRecTypeFormOft();
vOftMicroscopiaEspecular_w		strRecTypeFormOft := strRecTypeFormOft();
vOftMotilidadeOcular_w			strRecTypeFormOft := strRecTypeFormOft();
vOftOct_w							strRecTypeFormOft := strRecTypeFormOft();
vOftOculos_w						strRecTypeFormOft := strRecTypeFormOft();
vOftOlhoSeco_w						strRecTypeFormOft := strRecTypeFormOft();
vOftPaquimetria_w					strRecTypeFormOft := strRecTypeFormOft();
vOftPaquimetriaUltra_w			strRecTypeFormOft := strRecTypeFormOft();
vOftPotencialAcuidade_w			strRecTypeFormOft := strRecTypeFormOft();
vOftPupilometria_w				strRecTypeFormOft := strRecTypeFormOft();
vOftSobrecargaHidrica_w			strRecTypeFormOft := strRecTypeFormOft();
vOftTomografiaOlho_w				strRecTypeFormOft := strRecTypeFormOft();
vOftUltrassonografia_w			strRecTypeFormOft := strRecTypeFormOft();
vOftCorrecaoAmbos_w				strRecTypeFormOft := strRecTypeFormOft();
vOftCorrecaoContato_w			strRecTypeFormOft := strRecTypeFormOft();
vOftCorrecaoSem_w					strRecTypeFormOft := strRecTypeFormOft();
vOftCorrecaoOculos_w				strRecTypeFormOft := strRecTypeFormOft();
vListaAtual_w						strRecTypeFormOft := strRecTypeFormOft();
vOftDiagnosticoPaciente_w1		strRecTypeFormOft := strRecTypeFormOft();
vOftDiagnosticoPaciente_w2		strRecTypeFormOft := strRecTypeFormOft();
vOftDiagnosticoPaciente_w3		strRecTypeFormOft := strRecTypeFormOft();
vOftDiagnosticoPaciente_w4		strRecTypeFormOft := strRecTypeFormOft();
vOftDiagnosticoPaciente_w5		strRecTypeFormOft := strRecTypeFormOft();
vOftDiagnosticoPaciente_w6		strRecTypeFormOft := strRecTypeFormOft();
vOftDiagnosticoPaciente_w7		strRecTypeFormOft := strRecTypeFormOft();
vOftDiagnosticoFamiliar_w		strRecTypeFormOft := strRecTypeFormOft();
vOftDiagDoenca_w					strRecTypeFormOft := strRecTypeFormOft();
vOftAcuidade_w						strRecTypeFormOft := strRecTypeFormOft();
vOftAcuidadeCorrecao_w        strRecTypeFormOft := strRecTypeFormOft();
vOftAberrometria_w            strRecTypeFormOft := strRecTypeFormOft();
vOftPatientComplaints_w strRecTypeFormOft       := strRecTypeFormOft();
vOftRedDotTest_w              strRecTypeFormOft := strRecTypeFormOft();
vOftAmslerGrid_w              strRecTypeFormOft := strRecTypeFormOft();
nr_seq_regra_form_w				bigint;
nr_encounter_w bigint;

c_record CURSOR FOR
	SELECT	ie_obrigatorio,
				ie_result_anterior,
				nm_atributo,
				nr_seq_visao,
				ie_obrigatorio_salvar
	from		oft_formulario_item
	where		nr_seq_regra_form = nr_seq_regra_form_w
	and		((coalesce(ie_result_anterior,'N') = 'S') or (coalesce(ie_obrigatorio,'N') = 'S') or (coalesce(ie_obrigatorio_salvar,'N') = 'S'));
	
type		fetch_array is table of c_record%ROWTYPE;
s_properties	fetch_array;
i		integer := 1;
type Vetor is table of fetch_array index by integer;
v_record_w			Vetor;
	
BEGIN

select	max(oft_obter_formulario(nr_seq_tipo_consulta))
into STRICT		nr_seq_regra_form_w
from		oft_consulta
where		nr_sequencia = nr_seq_consulta_p;


open c_record;
loop
fetch c_record bulk collect into s_properties limit 2000;
	v_record_w(i)	:= s_properties;
	i					:= i + 1;
EXIT WHEN NOT FOUND; /* apply on c_record */
end loop;
close c_record;



FOR i IN 1..vLista.COUNT LOOP
	BEGIN
	CASE UPPER(vLista[i].nm_tabela)
		WHEN 'GRADE_AMSLER' THEN
	  	BEGIN
	    	vOftAmslerGrid_w.EXTEND;
	    	vOftAmslerGrid_w(vOftAmslerGrid_w.last) := vLista(i);
	    	nr_encounter_w                          := vLista[i].nr_aux_2;
	    END;
    	WHEN 'EXAME_PONTOS_VERMELHOS' THEN
      	BEGIN
        	vOftRedDotTest_w.EXTEND;
        	vOftRedDotTest_w(vOftRedDotTest_w.last) := vLista(i);
        	nr_encounter_w                          := vLista[i].nr_aux_2;
      	END;
    	WHEN 'ATEND_QUEIXA_PACIENTE' THEN
      	BEGIN
        	vOftPatientComplaints_w.EXTEND;
        	vOftPatientComplaints_w(vOftPatientComplaints_w.last) := vLista(i);
        	nr_encounter_w                                        := vLista[i].nr_aux_2;
      	END;
		WHEN 'OFT_ANAMNESE' THEN
			BEGIN
			vOftAnamnese_w.EXTEND;
			vOftAnamnese_w(vOftAnamnese_w.last) := vLista(i);
			END;
		WHEN 'DIAGNOSTICO_DOENCA' THEN
			BEGIN
			vOftDiagDoenca_w.EXTEND;
			vOftDiagDoenca_w(vOftDiagDoenca_w.last) := vLista(i);
			END;			
		WHEN 'OFT_AUTO_REFRACAO' THEN
			BEGIN
			vOftAutoRefracao_w.EXTEND;
			vOftAutoRefracao_w(vOftAutoRefracao_w.last) := vLista(i);
			END;
		WHEN 'OFT_TONOMETRIA' THEN
			BEGIN
			IF (vLista[i].nr_seq_visao IN (21953,88268)) THEN
				xOftTonometriaAplanacao_w.EXTEND;
				xOftTonometriaAplanacao_w(xOftTonometriaAplanacao_w.last) := vLista(i);
			ELSIF (vLista[i].nr_seq_visao = 86159) THEN
				xOftTonometriaPneumatica_w.EXTEND;
				xOftTonometriaPneumatica_w(xOftTonometriaPneumatica_w.last) := vLista(i);
			END IF;
			END;
		WHEN 'OFT_REFRACAO' THEN
			BEGIN
			vOftRefracao_w.EXTEND;
			vOftRefracao_w(vOftRefracao_w.last) := vLista(i);
			END;
		WHEN 'OFT_CORRECAO_ATUAL' THEN
			BEGIN
			IF (vLista[i].nr_seq_visao = 90600) THEN
				vOftCorrecaoAmbos_w.EXTEND;
				vOftCorrecaoAmbos_w(vOftCorrecaoAmbos_w.last) := vLista(i);
			ELSIF (vLista[i].nr_seq_visao = 90638) THEN
				vOftCorrecaoContato_w.EXTEND;
				vOftCorrecaoContato_w(vOftCorrecaoContato_w.last) := vLista(i);
			ELSIF (vLista[i].nr_seq_visao = 90593) THEN
				vOftCorrecaoSem_w.EXTEND;
				vOftCorrecaoSem_w(vOftCorrecaoSem_w.last) := vLista(i);
			ELSIF (vLista[i].nr_seq_visao = 90637) THEN
				vOftCorrecaoOculos_w.EXTEND;
				vOftCorrecaoOculos_w(vOftCorrecaoOculos_w.last) := vLista(i);
			ELSIF (vLista[i].nr_seq_visao = 86090) THEN
				vOftAcuidadeCorrecao_w.EXTEND;
				vOftAcuidadeCorrecao_w(vOftAcuidadeCorrecao_w.last) := vLista(i);
			END IF;
			END;
		WHEN 'OFT_BIOMICROSCOPIA' THEN
			BEGIN
			vOftBiomicroscopia_w.EXTEND;
			vOftBiomicroscopia_w(vOftBiomicroscopia_w.last) := vLista(i);
			END;
		WHEN 'OFT_FUNDOSCOPIA' THEN
			BEGIN
			vOftFundoscopia_w.EXTEND;
			vOftFundoscopia_w(vOftFundoscopia_w.last) := vLista(i);
			END;
		WHEN 'OFT_CONDUTA' THEN
			BEGIN
			vOftConduta_w.EXTEND;
			vOftConduta_w(vOftConduta_w.last) := vLista(i);
			END;
		WHEN 'OFT_ANGIO_RETINO' THEN
			BEGIN
         IF (vLista[i].nr_seq_visao = 86068) THEN
				vOftAngiofluorsceinografia_w.EXTEND;
            vOftAngiofluorsceinografia_w(vOftAngiofluorsceinografia_w.last) := vLista(i);
			ELSIF (vLista[i].nr_seq_visao = 101309) THEN
				vOftRetinografia_w.EXTEND;
            vOftRetinografia_w(vOftRetinografia_w.last) := vLista(i);
         end if;
			END;
		WHEN 'OFT_BIOMETRIA' THEN
			BEGIN
			vOftBiometria_w.EXTEND;
			vOftBiometria_w(vOftBiometria_w.last) := vLista(i);
			END;
		WHEN 'OFT_CAMPIMETRIA' THEN
			BEGIN
			vOftCampimetria_w.EXTEND;
			vOftCampimetria_w(vOftCampimetria_w.last) := vLista(i);
			END;
		WHEN 'OFT_CAPSULOTOMIA' THEN
			BEGIN
			vOftCapsulotomia_w.EXTEND;
			vOftCapsulotomia_w(vOftCapsulotomia_w.last) := vLista(i);
			END;
		WHEN 'OFT_CERASTOCOPIA' THEN
			BEGIN
			vOftCerastocopia_w.EXTEND;
			vOftCerastocopia_w(vOftCerastocopia_w.last) := vLista(i);
			END;
		WHEN 'OFT_CONSULTA_LENTE' THEN
			BEGIN
			vOftConsultaLente_w.EXTEND;
			vOftConsultaLente_w(vOftConsultaLente_w.last) := vLista(i);
			END;
		WHEN 'OFT_CURVA_TENCIONAL' THEN
			BEGIN
			vOftCurvaTencional_w.EXTEND;
			vOftCurvaTencional_w(vOftCurvaTencional_w.last) := vLista(i);
			END;
		WHEN 'OFT_DALTONISMO' THEN
			BEGIN
			vOftDaltonismo_w.EXTEND;
			vOftDaltonismo_w(vOftDaltonismo_w.last) := vLista(i);
			END;
		WHEN 'OFT_DIAGNOSTICO' THEN
			BEGIN
			IF (vLista[i].nr_seq_visao = 86093) THEN
				IF (vLista[i].nr_aux_1 = 1) THEN
					vOftDiagnosticoPaciente_w1.EXTEND;
					vOftDiagnosticoPaciente_w1(vOftDiagnosticoPaciente_w1.last) := vLista(i);
				ELSIF (vLista[i].nr_aux_1 = 2) THEN
					vOftDiagnosticoPaciente_w2.EXTEND;
					vOftDiagnosticoPaciente_w2(vOftDiagnosticoPaciente_w2.last) := vLista(i);
				ELSIF (vLista[i].nr_aux_1 = 3) THEN
					vOftDiagnosticoPaciente_w3.EXTEND;
					vOftDiagnosticoPaciente_w3(vOftDiagnosticoPaciente_w3.last) := vLista(i);
				ELSIF (vLista[i].nr_aux_1 = 4) THEN
					vOftDiagnosticoPaciente_w4.EXTEND;
					vOftDiagnosticoPaciente_w4(vOftDiagnosticoPaciente_w4.last) := vLista(i);
				ELSIF (vLista[i].nr_aux_1 = 5) THEN
					vOftDiagnosticoPaciente_w5.EXTEND;
					vOftDiagnosticoPaciente_w5(vOftDiagnosticoPaciente_w5.last) := vLista(i);
				ELSIF (vLista[i].nr_aux_1 = 6) THEN
					vOftDiagnosticoPaciente_w6.EXTEND;
					vOftDiagnosticoPaciente_w6(vOftDiagnosticoPaciente_w6.last) := vLista(i);
				ELSIF (vLista[i].nr_aux_1 = 7) THEN
					vOftDiagnosticoPaciente_w7.EXTEND;
					vOftDiagnosticoPaciente_w7(vOftDiagnosticoPaciente_w7.last) := vLista(i);
				END IF;
			ELSIF (vLista[i].nr_seq_visao = 86094) THEN
				vOftDiagnosticoFamiliar_w.EXTEND;
				vOftDiagnosticoFamiliar_w(vOftDiagnosticoFamiliar_w.last) := vLista(i);
			end if;	
			END;
		WHEN 'OFT_DNP' THEN
			BEGIN
			vOftDnp_w.EXTEND;
			vOftDnp_w(vOftDnp_w.last) := vLista(i);
			END;
		WHEN 'OFT_EXAME_EXTERNO' THEN
			BEGIN
			vOftExameExterno_w.EXTEND;
			vOftExameExterno_w(vOftExameExterno_w.last) := vLista(i);
			END;
		WHEN 'OFT_FOTOCOAGULACAO_LASER' THEN
			BEGIN
			vOftFotocoagulacaoLaser_w.EXTEND;
			vOftFotocoagulacaoLaser_w(vOftFotocoagulacaoLaser_w.last) := vLista(i);
			END;
		WHEN 'OFT_GONIOSCOPIA' THEN
			BEGIN
			vOftGonioscopia_w.EXTEND;
			vOftGonioscopia_w(vOftGonioscopia_w.last) := vLista(i);
			END;
		WHEN 'OFT_IRIDECTOMIA' THEN
			BEGIN
			vOftIridectomia_w.EXTEND;
			vOftIridectomia_w(vOftIridectomia_w.last) := vLista(i);
			END;
		WHEN 'OFT_MAPEAMENTO_RETINA' THEN
			BEGIN
			vOftMapeamentoRetina_w.EXTEND;
			vOftMapeamentoRetina_w(vOftMapeamentoRetina_w.last) := vLista(i);
			END;
		WHEN 'OFT_MICROSCOPIA_ESPECULAR' THEN
			BEGIN
			vOftMicroscopiaEspecular_w.EXTEND;
			vOftMicroscopiaEspecular_w(vOftMicroscopiaEspecular_w.last) := vLista(i);
			END;
		WHEN 'OFT_MOTILIDADE_OCULAR' THEN
			BEGIN
			vOftMotilidadeOcular_w.EXTEND;
			vOftMotilidadeOcular_w(vOftMotilidadeOcular_w.last) := vLista(i);
			END;
		WHEN 'OFT_OCT' THEN
			BEGIN
			vOftOct_w.EXTEND;
			vOftOct_w(vOftOct_w.last) := vLista(i);
			END;
		WHEN 'OFT_OCULOS' THEN
			BEGIN
			vOftOculos_w.EXTEND;
			vOftOculos_w(vOftOculos_w.last) := vLista(i);
			END;
		WHEN 'OFT_OLHO_SECO' THEN
			BEGIN
			vOftOlhoSeco_w.EXTEND;
			vOftOlhoSeco_w(vOftOlhoSeco_w.last) := vLista(i);
			END;
		WHEN 'OFT_PAQUIMETRIA' THEN
			BEGIN
			IF (vLista[i].nr_seq_visao = 86143) THEN
				vOftPaquimetria_w.EXTEND;
				vOftPaquimetria_w(vOftPaquimetria_w.last) := vLista(i);
			ELSIF (vLista[i].nr_seq_visao = 86144) THEN
				vOftPaquimetriaUltra_w.EXTEND;
				vOftPaquimetriaUltra_w(vOftPaquimetriaUltra_w.last) := vLista(i);
			END IF;
			END;
		WHEN 'OFT_POTENCIAL_ACUIDADE' THEN
			BEGIN
			vOftPotencialAcuidade_w.EXTEND;
			vOftPotencialAcuidade_w(vOftPotencialAcuidade_w.last) := vLista(i);
			END;
		WHEN 'OFT_PUPILOMETRIA' THEN
			BEGIN
			vOftPupilometria_w.EXTEND;
			vOftPupilometria_w(vOftPupilometria_w.last) := vLista(i);
			END;
		WHEN 'OFT_SOBRECARGA_HIDRICA' THEN
			BEGIN
			vOftSobrecargaHidrica_w.EXTEND;
			vOftSobrecargaHidrica_w(vOftSobrecargaHidrica_w.last) := vLista(i);
			END;
		WHEN 'OFT_TOMOGRAFIA_OLHO' THEN
			BEGIN
			vOftTomografiaOlho_w.EXTEND;
			vOftTomografiaOlho_w(vOftTomografiaOlho_w.last) := vLista(i);
			END;
		WHEN 'OFT_ULTRASSONOGRAFIA' THEN
			BEGIN
			vOftUltrassonografia_w.EXTEND;
			vOftUltrassonografia_w(vOftUltrassonografia_w.last) := vLista(i);
			END;
		WHEN 'OFT_ACUIDADE_VISUAL' THEN
			BEGIN
			vOftAcuidade_w.EXTEND;
			vOftAcuidade_w(vOftAcuidade_w.last) := vLista(i);
			END;
		WHEN 'OFT_ABERROMETRIA' THEN
			BEGIN
			vOftAberrometria_w.EXTEND;
			vOftAberrometria_w(vOftAberrometria_w.last) := vLista(i);
			END;
		else
			null;	
	END CASE;
	END;
END LOOP;

IF (vOftAmslerGrid_w.COUNT > 0) THEN
  vOftAmslerGrid_w := oft_get_amsler_grid(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, nr_encounter_w, ie_opcao_p, vOftAmslerGrid_w);
  FOR i IN 1..vOftAmslerGrid_w.COUNT LOOP
    BEGIN
      vListaAtual_w.extend;
      vListaAtual_w(vListaAtual_w.last) := vOftAmslerGrid_w(i);
    END;
  END LOOP;
END IF;

IF (vOftRedDotTest_w.COUNT > 0) THEN
  vOftRedDotTest_w := oft_get_red_dot_test(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, nr_encounter_w, ie_opcao_p, vOftRedDotTest_w);
  FOR i IN 1..vOftRedDotTest_w.COUNT LOOP
    BEGIN
      vListaAtual_w.extend;
      vListaAtual_w(vListaAtual_w.last) := vOftRedDotTest_w(i);
    END;
  END LOOP;
END IF;

IF (vOftPatientComplaints_w.COUNT > 0) THEN
  vOftPatientComplaints_w := oft_get_patient_complaints(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, nr_encounter_w, ie_opcao_p, vOftPatientComplaints_w);
  FOR i IN 1..vOftPatientComplaints_w.COUNT LOOP
    BEGIN
      vListaAtual_w.extend;
      vListaAtual_w(vListaAtual_w.last) := vOftPatientComplaints_w(i);
    END;
  END LOOP;
END IF;

IF (vOftAcuidade_w.COUNT > 0) THEN
	vOftAcuidade_w := oft_obter_acuidade(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftAcuidade_w);
	FOR i IN 1..vOftAcuidade_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftAcuidade_w(i);
		END;
	END LOOP;
END IF;


IF (vOftAnamnese_w.COUNT > 0) THEN
	vOftAnamnese_w := oft_obter_anamnese(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftAnamnese_w);
	FOR i IN 1..vOftAnamnese_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftAnamnese_w(i);
		END;
	END LOOP;
END IF;

IF (vOftAutoRefracao_w.COUNT > 0) THEN
	vOftAutoRefracao_w := oft_obter_auto_refracao(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftAutoRefracao_w);
	FOR i IN 1..vOftAutoRefracao_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftAutoRefracao_w(i);
		END;
	END LOOP;
END IF;

IF (xOftTonometriaAplanacao_w.COUNT > 0) THEN
	xOftTonometriaAplanacao_w := oft_obter_tonometria(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, xOftTonometriaAplanacao_w);
	FOR i IN 1..xOftTonometriaAplanacao_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := xOftTonometriaAplanacao_w(i);
		END;
	END LOOP;
END IF;

IF (xOftTonometriaPneumatica_w.COUNT > 0) THEN
	xOftTonometriaPneumatica_w := oft_obter_tonometria(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, xOftTonometriaPneumatica_w);
	FOR i IN 1..xOftTonometriaPneumatica_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := xOftTonometriaPneumatica_w(i);
		END;
	END LOOP;
END IF;

IF (vOftRefracao_w.COUNT > 0) THEN
	vOftRefracao_w := oft_obter_refracao(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftRefracao_w);
	FOR i IN 1..vOftRefracao_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftRefracao_w(i);
		END;
	END LOOP;
END IF;

IF (vOftBiomicroscopia_w.COUNT > 0) THEN
	vOftBiomicroscopia_w := oft_obter_biomicroscopia(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftBiomicroscopia_w);
	FOR i IN 1..vOftBiomicroscopia_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftBiomicroscopia_w(i);
		END;
	END LOOP;
END IF;

IF (vOftCorrecaoAmbos_w.COUNT > 0) THEN
	vOftCorrecaoAmbos_w := oft_obter_correcao_atual(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftCorrecaoAmbos_w);
	FOR i IN 1..vOftCorrecaoAmbos_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftCorrecaoAmbos_w(i);
		END;
	END LOOP;
END IF;

IF (vOftCorrecaoContato_w.COUNT > 0) THEN
	vOftCorrecaoContato_w := oft_obter_correcao_atual(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftCorrecaoContato_w);
	FOR i IN 1..vOftCorrecaoContato_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftCorrecaoContato_w(i);
		END;
	END LOOP;
END IF;

IF (vOftCorrecaoSem_w.COUNT > 0) THEN
	vOftCorrecaoSem_w := oft_obter_correcao_atual(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftCorrecaoSem_w);
	FOR i IN 1..vOftCorrecaoSem_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftCorrecaoSem_w(i);
		END;
	END LOOP;
END IF;

IF (vOftAcuidadeCorrecao_w.COUNT > 0) THEN
	vOftAcuidadeCorrecao_w := oft_obter_correcao_atual(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftAcuidadeCorrecao_w);
	FOR i IN 1..vOftAcuidadeCorrecao_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftAcuidadeCorrecao_w(i);
		END;
	END LOOP;
END IF;

IF (vOftCorrecaoOculos_w.COUNT > 0) THEN
	vOftCorrecaoOculos_w := oft_obter_correcao_atual(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftCorrecaoOculos_w);
	FOR i IN 1..vOftCorrecaoOculos_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftCorrecaoOculos_w(i);
		END;
	END LOOP;
END IF;

IF (vOftFundoscopia_w.COUNT > 0) THEN
	vOftFundoscopia_w := oft_obter_fundoscopia(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftFundoscopia_w);
	FOR i IN 1..vOftFundoscopia_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftFundoscopia_w(i);
		END;
	END LOOP;
END IF;

IF (vOftConduta_w.COUNT > 0) THEN
	vOftConduta_w := oft_obter_conduta(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftConduta_w);
	FOR i IN 1..vOftConduta_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftConduta_w(i);
		END;
	END LOOP;
END IF;

IF (vOftAngiofluorsceinografia_w.COUNT > 0) THEN
	vOftAngiofluorsceinografia_w := oft_obter_angio_retino(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftAngiofluorsceinografia_w);
	FOR i IN 1..vOftAngiofluorsceinografia_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftAngiofluorsceinografia_w(i);
		END;
	END LOOP;
END IF;

IF (vOftRetinografia_w.COUNT > 0) THEN
	vOftRetinografia_w := oft_obter_angio_retino(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftRetinografia_w);
	FOR i IN 1..vOftRetinografia_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftRetinografia_w(i);
		END;
	END LOOP;
END IF;


IF (vOftBiometria_w.COUNT > 0) THEN
	vOftBiometria_w := oft_obter_biometria(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftBiometria_w);
	FOR i IN 1..vOftBiometria_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftBiometria_w(i);
		END;
	END LOOP;
END IF;

IF (vOftCampimetria_w.COUNT > 0) THEN
	vOftCampimetria_w := oft_obter_campimetria(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftCampimetria_w);
	FOR i IN 1..vOftCampimetria_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftCampimetria_w(i);
		END;
	END LOOP;
END IF;

IF (vOftCapsulotomia_w.COUNT > 0) THEN
	vOftCapsulotomia_w := oft_obter_capsulotomia(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftCapsulotomia_w);
	FOR i IN 1..vOftCapsulotomia_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftCapsulotomia_w(i);
		END;
	END LOOP;
END IF;

IF (vOftCerastocopia_w.COUNT > 0) THEN
	vOftCerastocopia_w := oft_obter_ceratometria(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftCerastocopia_w);
	FOR i IN 1..vOftCerastocopia_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftCerastocopia_w(i);
		END;
	END LOOP;
END IF;

IF (vOftConsultaLente_w.COUNT > 0) THEN
	vOftConsultaLente_w := oft_obter_consulta_lente(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftConsultaLente_w);
	FOR i IN 1..vOftConsultaLente_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftConsultaLente_w(i);
		END;
	END LOOP;
END IF;

IF (vOftCurvaTencional_w.COUNT > 0) THEN
	vOftCurvaTencional_w := oft_obter_curva_tencional(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftCurvaTencional_w);
	FOR i IN 1..vOftCurvaTencional_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftCurvaTencional_w(i);
		END;
	END LOOP;
END IF;

IF (vOftDaltonismo_w.COUNT > 0) THEN
	vOftDaltonismo_w := oft_obter_daltonismo(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftDaltonismo_w);
	FOR i IN 1..vOftDaltonismo_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftDaltonismo_w(i);
		END;
	END LOOP;
END IF;

IF (vOftDiagnosticoPaciente_w1.COUNT > 0) THEN
	vOftDiagnosticoPaciente_w1 := oft_obter_diagnostico(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftDiagnosticoPaciente_w1);
	FOR i IN 1..vOftDiagnosticoPaciente_w1.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftDiagnosticoPaciente_w1(i);
		END;
	END LOOP;
END IF;

IF (vOftDiagnosticoPaciente_w2.COUNT > 0) THEN
	vOftDiagnosticoPaciente_w2 := oft_obter_diagnostico(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftDiagnosticoPaciente_w2);
	FOR i IN 1..vOftDiagnosticoPaciente_w2.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftDiagnosticoPaciente_w2(i);
		END;
	END LOOP;
END IF;

IF (vOftDiagnosticoPaciente_w3.COUNT > 0) THEN
	vOftDiagnosticoPaciente_w3 := oft_obter_diagnostico(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftDiagnosticoPaciente_w3);
	FOR i IN 1..vOftDiagnosticoPaciente_w3.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftDiagnosticoPaciente_w3(i);
		END;
	END LOOP;
END IF;

IF (vOftDiagnosticoPaciente_w4.COUNT > 0) THEN
	vOftDiagnosticoPaciente_w4 := oft_obter_diagnostico(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftDiagnosticoPaciente_w4);
	FOR i IN 1..vOftDiagnosticoPaciente_w4.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftDiagnosticoPaciente_w4(i);
		END;
	END LOOP;
END IF;

IF (vOftDiagnosticoPaciente_w5.COUNT > 0) THEN
	vOftDiagnosticoPaciente_w5 := oft_obter_diagnostico(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftDiagnosticoPaciente_w5);
	FOR i IN 1..vOftDiagnosticoPaciente_w5.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftDiagnosticoPaciente_w5(i);
		END;
	END LOOP;
END IF;

IF (vOftDiagnosticoPaciente_w6.COUNT > 0) THEN
	vOftDiagnosticoPaciente_w6 := oft_obter_diagnostico(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftDiagnosticoPaciente_w6);
	FOR i IN 1..vOftDiagnosticoPaciente_w6.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftDiagnosticoPaciente_w6(i);
		END;
	END LOOP;
END IF;

IF (vOftDiagnosticoPaciente_w7.COUNT > 0) THEN
	vOftDiagnosticoPaciente_w7 := oft_obter_diagnostico(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftDiagnosticoPaciente_w7);
	FOR i IN 1..vOftDiagnosticoPaciente_w7.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftDiagnosticoPaciente_w7(i);
		END;
	END LOOP;
END IF;

IF (vOftDiagnosticoFamiliar_w.COUNT > 0) THEN
	vOftDiagnosticoFamiliar_w := oft_obter_diagnostico(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftDiagnosticoFamiliar_w);
	FOR i IN 1..vOftDiagnosticoFamiliar_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftDiagnosticoFamiliar_w(i);
		END;
	END LOOP;
END IF;


IF (vOftDnp_w.COUNT > 0) THEN
	vOftDnp_w := oft_obter_dnp(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftDnp_w);
	FOR i IN 1..vOftDnp_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftDnp_w(i);
		END;
	END LOOP;
END IF;

IF (vOftExameExterno_w.COUNT > 0) THEN
	vOftExameExterno_w := oft_obter_exame_externo(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftExameExterno_w);
	FOR i IN 1..vOftExameExterno_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftExameExterno_w(i);
		END;
	END LOOP;
END IF;

IF (vOftFotocoagulacaoLaser_w.COUNT > 0) THEN
	vOftFotocoagulacaoLaser_w := oft_obter_fotocoagulacao(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftFotocoagulacaoLaser_w);
	FOR i IN 1..vOftFotocoagulacaoLaser_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftFotocoagulacaoLaser_w(i);
		END;
	END LOOP;
END IF;

IF (vOftGonioscopia_w.COUNT > 0) THEN
	vOftGonioscopia_w := oft_obter_gonioscopia(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftGonioscopia_w);
	FOR i IN 1..vOftGonioscopia_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftGonioscopia_w(i);
		END;
	END LOOP;
END IF;

IF (vOftIridectomia_w.COUNT > 0) THEN
	vOftIridectomia_w := oft_obter_iridectomia(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftIridectomia_w);
	FOR i IN 1..vOftIridectomia_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftIridectomia_w(i);
		END;
	END LOOP;
END IF;

IF (vOftMapeamentoRetina_w.COUNT > 0) THEN
	vOftMapeamentoRetina_w := oft_obter_mapeamento_retina(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftMapeamentoRetina_w);
	FOR i IN 1..vOftMapeamentoRetina_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftMapeamentoRetina_w(i);
		END;
	END LOOP;
END IF;

IF (vOftMicroscopiaEspecular_w.COUNT > 0) THEN
	vOftMicroscopiaEspecular_w := oft_obter_microscopia(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftMicroscopiaEspecular_w);
	FOR i IN 1..vOftMicroscopiaEspecular_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftMicroscopiaEspecular_w(i);
		END;
	END LOOP;

END IF;

IF (vOftMotilidadeOcular_w.COUNT > 0) THEN
	vOftMotilidadeOcular_w := oft_obter_motilidade_ocular(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftMotilidadeOcular_w);
	FOR i IN 1..vOftMotilidadeOcular_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftMotilidadeOcular_w(i);
		END;
	END LOOP;
END IF;

IF (vOftOct_w.COUNT > 0) THEN
	vOftOct_w := oft_obter_oct(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftOct_w);
	FOR i IN 1..vOftOct_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftOct_w(i);
		END;
	END LOOP;
END IF;

IF (vOftOculos_w.COUNT > 0) THEN
	vOftOculos_w := oft_obter_oculos(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftOculos_w);
	FOR i IN 1..vOftOculos_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftOculos_w(i);
		END;
	END LOOP;
END IF;

IF (vOftOlhoSeco_w.COUNT > 0) THEN
	vOftOlhoSeco_w := oft_obter_olho_seco(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftOlhoSeco_w);
	FOR i IN 1..vOftOlhoSeco_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftOlhoSeco_w(i);
		END;
	END LOOP;
END IF;

IF (vOftPaquimetria_w.COUNT > 0) THEN
	vOftPaquimetria_w := oft_obter_paquimetria(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftPaquimetria_w);
	FOR i IN 1..vOftPaquimetria_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftPaquimetria_w(i);
		END;
	END LOOP;
END IF;

IF (vOftPaquimetriaUltra_w.COUNT > 0) THEN
	vOftPaquimetriaUltra_w := oft_obter_paquimetria(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftPaquimetriaUltra_w);
	FOR i IN 1..vOftPaquimetriaUltra_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftPaquimetriaUltra_w(i);
		END;
	END LOOP;
END IF;

IF (vOftPotencialAcuidade_w.COUNT > 0) THEN
	vOftPotencialAcuidade_w := oft_obter_potencial_acuidade(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftPotencialAcuidade_w);
	FOR i IN 1..vOftPotencialAcuidade_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftPotencialAcuidade_w(i);
		END;
	END LOOP;
END IF;

IF (vOftPupilometria_w.COUNT > 0) THEN
	vOftPupilometria_w := oft_obter_pupilometria(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftPupilometria_w);
	FOR i IN 1..vOftPupilometria_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftPupilometria_w(i);
		END;
	END LOOP;
END IF;

IF (vOftSobrecargaHidrica_w.COUNT > 0) THEN
	vOftSobrecargaHidrica_w := oft_obter_sobrecarga_hidrica(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftSobrecargaHidrica_w);
	FOR i IN 1..vOftSobrecargaHidrica_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftSobrecargaHidrica_w(i);
		END;
	END LOOP;
END IF;

IF (vOftTomografiaOlho_w.COUNT > 0) THEN
	vOftTomografiaOlho_w := oft_obter_tomografia(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftTomografiaOlho_w);
	FOR i IN 1..vOftTomografiaOlho_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftTomografiaOlho_w(i);
		END;
	END LOOP;
END IF;

IF (vOftTomografiaOlho_w.COUNT > 0) THEN
	vOftTomografiaOlho_w := oft_obter_tomografia(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftTomografiaOlho_w);
	FOR i IN 1..vOftTomografiaOlho_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftTomografiaOlho_w(i);
		END;
	END LOOP;
END IF;


IF (vOftUltrassonografia_w.COUNT > 0) THEN
	vOftUltrassonografia_w := oft_obter_ultrassonografia(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftUltrassonografia_w);
	FOR i IN 1..vOftUltrassonografia_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftUltrassonografia_w(i);
		END;
	END LOOP;
END IF;

IF (vOftDiagDoenca_w.COUNT > 0) THEN
	vOftDiagDoenca_w := oft_obter_diag_doenca(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftDiagDoenca_w);
	FOR i IN 1..vOftDiagDoenca_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftDiagDoenca_w(i);
		END;
	END LOOP;
END IF;

IF (vOftAberrometria_w.COUNT > 0) THEN
	vOftAberrometria_w := oft_obter_aberrometria(nr_seq_consulta_p, nr_seq_consulta_form_p, cd_pessoa_fisica_p, ie_opcao_p, vOftAberrometria_w);
	FOR i IN 1..vOftAberrometria_w.COUNT LOOP
		BEGIN
		vListaAtual_w.extend;
		vListaAtual_w(vListaAtual_w.last) := vOftAberrometria_w(i);
		END;
	END LOOP;
END IF;
vLista.DELETE;
FOR lista IN 1..vListaAtual_w.COUNT LOOP
	BEGIN
	for atribute in 1..v_record_w.count loop
		begin
		s_properties := v_record_w(atribute);
		for property in 1..s_properties.count loop
			begin
			if (s_properties[property].nr_seq_visao = vListaAtual_w[lista].nr_seq_visao) and (s_properties[property].nm_atributo = vListaAtual_w[lista].nm_campo) then
				vListaAtual_w[lista].ie_obter_resultado 	:= s_properties[property].ie_result_anterior;
				vListaAtual_w[lista].ie_obrigatorio 		:= s_properties[property].ie_obrigatorio;
				vListaAtual_w[lista].ds_aux_4 		:= s_properties[property].ie_obrigatorio_salvar;
			end if;	
			end;
		end loop;
		end;
	end loop;	
	vLista.extend;
	vLista(vLista.last) := vListaAtual_w(lista);
	END;
END LOOP;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE oft_obter_valores ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text, vLista INOUT strRecTypeFormOft) FROM PUBLIC;
