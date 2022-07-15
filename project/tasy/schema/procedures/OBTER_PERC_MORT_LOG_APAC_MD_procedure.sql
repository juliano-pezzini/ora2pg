-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_perc_mort_log_apac_md (qt_idade_p bigint, qt_pt_idade1_p bigint, qt_pt_idade2_p bigint, qt_pt_idade3_p bigint, qt_pt_idade4_p bigint, qt_pt_idade5_p bigint, qt_pontos_aps_p bigint, qt_pt_aps1_p bigint, qt_pt_aps2_p bigint, qt_pt_aps3_p bigint, qt_pt_aps4_p bigint, qt_pt_aps5_p bigint, ie_ventilacao_p text, qt_po2_p bigint, qt_fio2_p bigint, ie_origem_paciente_p bigint, ie_emergencia_p text, qt_dias_antes_uti_p bigint, ie_aids_p text, ie_hepatica_p text, ie_linfoma_p text, ie_cancer_metastatico_p text, ie_leuc_mileoma_mult_p text, ie_imunosupressao_p text, ie_cirrose_p text, ie_glasgow_indis_p text, qt_escala_glasgow_p bigint, qt_pt_diag_p bigint, ie_terapia_trombo_p text, pr_mortalidade_p INOUT bigint, qt_logit_p INOUT bigint ) AS $body$
DECLARE


	qt_los_w	     bigint := 0;
	qt_los1_w	     bigint := 0;
	qt_los2_w	     bigint := 0;
	qt_los3_w	     bigint := 0;
	qt_los4_w	     bigint := 0;

	pr_mortalidade_w real;
	qt_logit_w	     bigint;

BEGIN
	--- Inicio MD26
	qt_logit_w	:=	-5.950471952;
	qt_logit_w	:=	qt_logit_w + (qt_idade_p		* ( 0.024177455));
	qt_logit_w	:=	qt_logit_w + (qt_pt_idade1_p	* (-0.00000438862));
	qt_logit_w	:=	qt_logit_w + (qt_pt_idade2_p	* ( 0.0000501422));
	qt_logit_w	:=	qt_logit_w + (qt_pt_idade3_p	* (-0.000127787));
	qt_logit_w	:=	qt_logit_w + (qt_pt_idade4_p	* ( 0.000109606));
	qt_logit_w	:=	qt_logit_w + (qt_pt_idade5_p	* (-0.0000275723));

	qt_logit_w	:=	qt_logit_w + (qt_pontos_aps_p	*	( 0.055634916));
	qt_logit_w	:=	qt_logit_w + (qt_pt_aps1_p			*	( 0.00000871852));
	qt_logit_w	:=	qt_logit_w + (qt_pt_aps2_p			*	(-0.0000451101));
	qt_logit_w	:=	qt_logit_w + (qt_pt_aps3_p			*	( 0.00005038));
	qt_logit_w	:=	qt_logit_w + (qt_pt_aps4_p			*	(-0.0000131231));
	qt_logit_w	:=	qt_logit_w + (qt_pt_aps5_p			*	(-8.65349E-07));

	if (ie_ventilacao_p	=	'S') then
		qt_logit_w	:=	qt_logit_w + 0.271760036;
	end if;

	qt_logit_w	:=	qt_logit_w + (dividir_md(qt_po2_p,dividir_md(qt_fio2_p,100))*(-0.000397068));

	if (ie_origem_paciente_p = 1) then
		qt_logit_w	:=	qt_logit_w + (-0.583828121);
	elsif (ie_origem_paciente_p = 2) then
		qt_logit_w	:=	qt_logit_w + 0.022106266;
	elsif (ie_origem_paciente_p = 3) then
		qt_logit_w	:=	qt_logit_w + 0.017149193;
	end if;

	if (ie_emergencia_p = 'S') then
		qt_logit_w	:=	qt_logit_w + 0.249073458;
	end if;

	qt_los_w	:=	sqrt(qt_dias_antes_uti_p);
	if	((qt_los_w - 0.121) > 0) then
		qt_los1_w	:=	power((qt_los_w - 0.121), 3);
	end if;
	if	((qt_los_w - 0.423) > 0) then
		qt_los2_w	:=	power((qt_los_w - 0.423), 3);
	end if;
	if	((qt_los_w - 0.794) > 0) then
		qt_los3_w	:=	power((qt_los_w - 0.794), 3);
	end if;
	if	((qt_los_w - 2.806) > 0) then
		qt_los4_w	:=	power((qt_los_w - 2.806), 3);
	end if;

	qt_logit_w	:=	qt_logit_w + (qt_los_w	*-0.310487496);
	qt_logit_w	:=	qt_logit_w + (qt_los1_w	*1.474672511);
	qt_logit_w	:=	qt_logit_w + (qt_los2_w	*-2.8618857);
	qt_logit_w	:=	qt_logit_w + (qt_los3_w	*1.42165901);
	qt_logit_w	:=	qt_logit_w + (qt_los4_w	*-0.034445822);

	if (ie_aids_p = 'S') then
		qt_logit_w	:=	qt_logit_w + 0.958100516;
	elsif (ie_hepatica_p = 'S') then
		qt_logit_w	:=	qt_logit_w + 1.037379925;
	elsif (ie_linfoma_p = 'S') then
		qt_logit_w	:=	qt_logit_w + 0.743471748;
	elsif (ie_cancer_metastatico_p = 'S') then
		qt_logit_w	:=	qt_logit_w + 1.086423752;
	elsif (ie_leuc_mileoma_mult_p = 'S') then
		qt_logit_w	:=	qt_logit_w + 0.969308299;
	elsif (ie_imunosupressao_p = 'S') then
		qt_logit_w	:=	qt_logit_w + 0.435581083;
	elsif (ie_cirrose_p = 'S') then
		qt_logit_w	:=	qt_logit_w + 0.814665088;
	end if;

	if (ie_glasgow_indis_p = 'S') then
		qt_logit_w	:=	qt_logit_w + 0.785764316;
	else
		qt_logit_w	:=	qt_logit_w + ((15-qt_escala_glasgow_p) * 0.039117532);
	end if;

	if (qt_pt_diag_p IS NOT NULL AND qt_pt_diag_p::text <> '') then
		qt_logit_w := qt_logit_w + qt_pt_diag_p;
	end if;

	if (ie_terapia_trombo_p = 'S') then
		qt_logit_w	:=	qt_logit_w	+	(-0.579874039);
	end if;

	pr_mortalidade_w  := dividir_md(round(dividir_md(exp(qt_logit_w),(1 + exp(qt_logit_w)))*10000,2),100);

	pr_mortalidade_p := pr_mortalidade_w;
	qt_logit_p       := qt_logit_w;
	--FIM MD26
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_perc_mort_log_apac_md (qt_idade_p bigint, qt_pt_idade1_p bigint, qt_pt_idade2_p bigint, qt_pt_idade3_p bigint, qt_pt_idade4_p bigint, qt_pt_idade5_p bigint, qt_pontos_aps_p bigint, qt_pt_aps1_p bigint, qt_pt_aps2_p bigint, qt_pt_aps3_p bigint, qt_pt_aps4_p bigint, qt_pt_aps5_p bigint, ie_ventilacao_p text, qt_po2_p bigint, qt_fio2_p bigint, ie_origem_paciente_p bigint, ie_emergencia_p text, qt_dias_antes_uti_p bigint, ie_aids_p text, ie_hepatica_p text, ie_linfoma_p text, ie_cancer_metastatico_p text, ie_leuc_mileoma_mult_p text, ie_imunosupressao_p text, ie_cirrose_p text, ie_glasgow_indis_p text, qt_escala_glasgow_p bigint, qt_pt_diag_p bigint, ie_terapia_trombo_p text, pr_mortalidade_p INOUT bigint, qt_logit_p INOUT bigint ) FROM PUBLIC;

