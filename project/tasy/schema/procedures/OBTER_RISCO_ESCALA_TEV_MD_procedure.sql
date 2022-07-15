-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_risco_escala_tev_md ( ie_clinico_cirurgico_p text, qt_reg_p bigint, qt_idade_p bigint, ie_mobilidade_reduzida_p text, ie_fator_risco_p text, ie_condicao_p text, ie_artroplastia_joelho_p text, ie_artroplastia_quadril_p text, ie_fratura_quadril_p text, ie_oncol_curativa_p text, ie_trauma_medular_p text, ie_politrauma_p text, ie_bariatrica_p text, ie_demais_cirurgias_p text, ie_cir_pequeno_porte_p text, ie_nao_se_aplica_p text, ie_risco_p INOUT text, ds_resultado_p INOUT text, ie_cir_alto_risco_p INOUT text, ie_cir_grande_medio_porte_p INOUT text ) AS $body$
BEGIN
	if (ie_clinico_cirurgico_p = 'C') then
		
		if (ie_nao_se_aplica_p = 'S') then
		  ie_risco_p := 'N';
		elsif (qt_idade_p < 40) and (ie_mobilidade_reduzida_p = 'S') and (ie_fator_risco_p = 'S') then
		  ie_risco_p := 'N';
		elsif (ie_fator_risco_p = 'N') then
		  ie_risco_p := 'B';
		elsif (ie_fator_risco_p = 'S') then
		  ie_risco_p := 'A';
		  if (qt_idade_p < 40) and (ie_condicao_p = 'N') then
		    ie_risco_p := 'B';
		  end if;
		end if;
		
		ds_resultado_p := null;
		
	elsif (ie_clinico_cirurgico_p = 'I') then
	
		if (ie_artroplastia_joelho_p = 'S' or ie_artroplastia_quadril_p = 'S' or ie_fratura_quadril_p = 'S' or ie_oncol_curativa_p = 'S' or ie_trauma_medular_p = 'S' or ie_politrauma_p = 'S') then
			ie_cir_alto_risco_p := 'S';
		end if;
		
		if (ie_bariatrica_p = 'S') or (ie_demais_cirurgias_p = 'S') then
			ie_cir_grande_medio_porte_p := 'S';
		end if;		
		
		ie_risco_p := 'B';
				
		if (ie_cir_pequeno_porte_p = 'S') then
			ie_risco_p := 'B';
		elsif ((ie_cir_alto_risco_p = 'S') or ((ie_cir_grande_medio_porte_p = 'S') and ((qt_idade_p > 60) or (qt_idade_p between 40 and 60 AND qt_reg_p > 0)))) then
			ie_risco_p := 'A';
		elsif (ie_cir_grande_medio_porte_p = 'S') and (qt_idade_p between 40 and 60 AND qt_reg_p = 0) or ((qt_idade_p < 40) and (qt_reg_p > 0) or (ie_bariatrica_p = 'S')) then
			ie_risco_p := 'M';
		elsif (qt_idade_p < 40 AND qt_reg_p = 0) or (ie_cir_pequeno_porte_p in ('S')) then
			ie_risco_p := 'B';
		end if;
		
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_risco_escala_tev_md ( ie_clinico_cirurgico_p text, qt_reg_p bigint, qt_idade_p bigint, ie_mobilidade_reduzida_p text, ie_fator_risco_p text, ie_condicao_p text, ie_artroplastia_joelho_p text, ie_artroplastia_quadril_p text, ie_fratura_quadril_p text, ie_oncol_curativa_p text, ie_trauma_medular_p text, ie_politrauma_p text, ie_bariatrica_p text, ie_demais_cirurgias_p text, ie_cir_pequeno_porte_p text, ie_nao_se_aplica_p text, ie_risco_p INOUT text, ds_resultado_p INOUT text, ie_cir_alto_risco_p INOUT text, ie_cir_grande_medio_porte_p INOUT text ) FROM PUBLIC;

