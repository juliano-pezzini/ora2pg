-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_just_item ( ie_tipo_retorno text default 'M', ie_duplicado_p cpoe_justificativa_item.ie_duplicado%type default null, ds_just_duplicado_p cpoe_justificativa_item.ds_just_duplicado%type default null, ie_interacao_medic_p cpoe_justificativa_item.ie_interacao_medic%type default null, ds_just_interacao_medic_p cpoe_justificativa_item.ds_just_interacao_medic%type default null, ie_nao_padronizado_p cpoe_justificativa_item.ie_nao_padronizado%type default null, ds_just_nao_padronizado_p cpoe_justificativa_item.ds_just_nao_padronizado%type default null, ie_alergia_p cpoe_justificativa_item.ie_alergia%type default null, ds_just_alergia_p cpoe_justificativa_item.ds_just_alergia%type default null, ie_dose_limite_p cpoe_justificativa_item.ie_dose_limite%type default null, ds_just_dose_limite_p cpoe_justificativa_item.ds_just_dose_limite%type default null, ie_via_nao_recomendada_p cpoe_justificativa_item.ie_via_nao_recomendada%type default null, ds_just_via_nao_recom_p cpoe_justificativa_item.ds_just_via_nao_recom%type default null, ie_interacao_dieta_p cpoe_justificativa_item.ie_interacao_dieta%type default null, ds_just_interacao_dieta_p cpoe_justificativa_item.ds_just_interacao_dieta%type default null, ie_permite_lactante_p cpoe_justificativa_item.ie_permite_lactante%type default null, ds_justificativa_lactante_p cpoe_justificativa_item.ds_justificativa_lactante%type default null, ie_dose_minima_p cpoe_justificativa_item.ie_dose_minima%type default null, ds_just_dose_minima_p cpoe_justificativa_item.ds_just_dose_minima%type default null, ie_exame_lab_p cpoe_justificativa_item.ie_exame_lab%type default null, ds_exame_lab_p cpoe_justificativa_item.ds_exame_lab%type default null, ie_especialidade_medica_p cpoe_justificativa_item.ie_especialidade_medica%type default null, ds_just_especialidade_med_p cpoe_justificativa_item.ds_just_especialidade_med%type default null, ie_permite_dil_p cpoe_justificativa_item.ie_permite_dil%type default null, ds_justificativa_dil_p cpoe_justificativa_item.ds_justificativa_dil%type default null, ie_latex_p cpoe_justificativa_item.ie_latex%type default null, ds_just_latex_p cpoe_justificativa_item.ds_just_latex%type default null, ie_criar_html text default null, ie_intolerancia_p cpoe_justificativa_item.ie_intolerancia%type default null, ds_just_intolerancia_p cpoe_justificativa_item.ds_just_intolerancia%type default null) RETURNS varchar AS $body$
DECLARE

/*
ie_tipo_retorno
E = retorna a descricao da expressao
J = retorna a descricao da justificativa
M = retorna a descricao da expressao e da justificativa
*/
	function getDuplicado return text is
		retorno varchar(2000);
	
BEGIN
		if (coalesce(ie_duplicado_p,'N') = 'S') then
			case ie_tipo_retorno
				when 'E' then retorno := substr(obter_desc_expressao(330826), 1, 1999) || chr(13);
				when 'J' then retorno := substr(ds_just_duplicado_p, 1, 1999) || chr(13);
				when 'M' then retorno := substr(obter_desc_expressao(330826) || ': ' || ds_just_duplicado_p, 1, 1999) || chr(13);
			end case;
		end if;
		return retorno;
	end;

	function getInteracaoMedic return varchar2 is
		retorno varchar2(2000);
	begin
		if (coalesce(ie_interacao_medic_p,'N') = 'S') then
			case ie_tipo_retorno
				when 'E' then retorno := substr(obter_desc_expressao(307566), 1, 1999) || chr(13);
				when 'J' then retorno := substr(ds_just_interacao_medic_p, 1, 1999) || chr(13);
				when 'M' then retorno := substr(obter_desc_expressao(307566) || ': ' || ds_just_interacao_medic_p, 1, 1999) || chr(13);
			end case;
		end if;
		return retorno;
	end;

	function getNaoPadronizado return varchar2 is
		retorno varchar2(2000);
	begin
		if (coalesce(ie_nao_padronizado_p,'N') = 'S') then
			case ie_tipo_retorno
				when 'E' then retorno := substr(obter_desc_expressao(331237), 1, 1999) || chr(13);
				when 'J' then retorno := substr(ds_just_nao_padronizado_p, 1, 1999) || chr(13);
				when 'M' then retorno := substr(obter_desc_expressao(331237) || ': ' || ds_just_nao_padronizado_p, 1, 1999) || chr(13);
			end case;
		end if;
		return retorno;		
	end;

	function getAlergia return varchar2 is
		retorno varchar2(2000);
	begin
		if (coalesce(ie_alergia_p,'N') = 'S') then
			case ie_tipo_retorno
				when 'E' then retorno := substr(obter_desc_expressao(283343), 1, 1999) || chr(13);
				when 'J' then retorno := substr(ds_just_alergia_p, 1, 1999) || chr(13);
				when 'M' then retorno := substr(obter_desc_expressao(283343) || ': ' || ds_just_alergia_p, 1, 1999) || chr(13);
			end case;
		end if;
		return retorno;
	end;

	function getDoseLimite return varchar2 is
		retorno varchar2(2000);
	begin
		if (coalesce(ie_dose_limite_p,'N') = 'S') then
			case ie_tipo_retorno
				when 'E' then retorno := substr(obter_desc_expressao(288246), 1, 1999) || chr(13);
				when 'J' then retorno := substr(ds_just_dose_limite_p, 1, 1999) || chr(13);
				when 'M' then retorno := substr(obter_desc_expressao(288246) || ': ' || ds_just_dose_limite_p, 1, 1999) || chr(13);
			end case;
		end if;
		return retorno;
	end;

	function getViaNaoRecomendada return varchar2 is
		retorno varchar2(2000);
	begin
		if (coalesce(ie_via_nao_recomendada_p,'N') = 'S') then
			case ie_tipo_retorno
				when 'E' then retorno := substr(obter_desc_expressao(654404), 1, 1999) || chr(13);
				when 'J' then retorno := substr(ds_just_via_nao_recom_p, 1, 1999) || chr(13);
				when 'M' then retorno := substr(obter_desc_expressao(654404) || ': ' || ds_just_via_nao_recom_p, 1, 1999) || chr(13);
			end case;
		end if;
		return retorno;
	end;

	function getInteracaoDieta return varchar2 is
		retorno varchar2(2000);
	begin
		if (coalesce(ie_interacao_dieta_p,'N') = 'S') then
			case ie_tipo_retorno
				when 'E' then retorno := substr(obter_desc_expressao(703190), 1, 1999) || chr(13);
				when 'J' then retorno := substr(ds_just_interacao_dieta_p, 1, 1999) || chr(13);
				when 'M' then retorno := substr(obter_desc_expressao(703190) || ': ' || ds_just_interacao_dieta_p, 1, 1999) || chr(13);
			end case;
		end if;
		return retorno;
	end;

	function getJustificativaLactante return varchar2 is
		retorno varchar2(2000);
	begin
		if (coalesce(ie_permite_lactante_p,'N') = 'S') then
			case ie_tipo_retorno
				when 'E' then retorno := substr(obter_desc_expressao(594952), 1, 1999) || chr(13);
				when 'J' then retorno := substr(ds_justificativa_lactante_p, 1, 1999) || chr(13);
				when 'M' then retorno := substr(obter_desc_expressao(594952) || ': ' || ds_justificativa_lactante_p, 1, 1999) || chr(13);
			end case;
		end if;
		return retorno;
	end;

	function getDoseMinima return varchar2 is
		retorno varchar2(2000);
	begin
		if (coalesce(ie_dose_minima_p,'N') = 'S') then
			case ie_tipo_retorno
				when 'E' then retorno := substr(obter_desc_expressao(288254), 1, 1999) || chr(13);
				when 'J' then retorno := substr(ds_just_dose_minima_p, 1, 1999) || chr(13);
				when 'M' then retorno := substr(obter_desc_expressao(288254) || ': ' || ds_just_dose_minima_p, 1, 1999) || chr(13);
			end case;			
		end if;

		return retorno;
	end;

	function getExameLab return varchar2 is
		retorno varchar2(2000);
	begin
		if (coalesce(ie_exame_lab_p,'N') = 'S') then
			case ie_tipo_retorno
				when 'E' then retorno := substr(obter_desc_expressao(297828), 1, 1999) || chr(13);
				when 'J' then retorno := substr(ds_exame_lab_p, 1, 1999) || chr(13);
				when 'M' then retorno := substr(obter_desc_expressao(297828) || ': ' || ds_exame_lab_p, 1, 1999) || chr(13);
			end case;
		end if;
		return retorno;
	end;

	function getEspecialidadeMedica return varchar2 is
		retorno varchar2(2000);
	begin
		if (coalesce(ie_especialidade_medica_p,'N') = 'S') then
			case ie_tipo_retorno
				when 'E' then retorno := substr(obter_desc_expressao(289437), 1, 1999) || chr(13);
				when 'J' then retorno := substr(ds_just_especialidade_med_p, 1, 1999) || chr(13);
				when 'M' then retorno := substr(obter_desc_expressao(289437) || ': ' || ds_just_especialidade_med_p, 1, 1999) || chr(13);
			end case;
		end if;
		return retorno;
	end;

	function getJustificativaDil return varchar2 is
		retorno varchar2(2000);
	begin
		if (coalesce(ie_permite_dil_p,'N') = 'S') then
			case ie_tipo_retorno
				when 'E' then retorno := substr(obter_desc_expressao(287942), 1, 1999) || chr(13);
				when 'J' then retorno := substr(ds_justificativa_dil_p, 1, 1999) || chr(13);
				when 'M' then retorno := substr(obter_desc_expressao(287942) || ': ' || ds_justificativa_dil_p, 1, 1999) || chr(13);
			end case;
		end if;
		return retorno;
	end;

	function getLatex return varchar2 is
		retorno varchar2(2000);
	begin
		if (coalesce(ie_latex_p,'N') = 'S') then
			case ie_tipo_retorno
				when 'E' then retorno := substr(obter_desc_expressao(630709), 1, 1999) || chr(13);
				when 'J' then retorno := substr(ds_just_latex_p, 1, 1999) || chr(13);
				when 'M' then retorno := substr(obter_desc_expressao(630709) || ': ' || ds_just_latex_p, 1, 1999) || chr(13);
			end case;
		end if;
		return retorno;
	end;

	function getIntolerancia return varchar2 is
		retorno varchar2(2000);
	begin
		if (coalesce(ie_intolerancia_p,'N') = 'S') then
			case ie_tipo_retorno
				when 'E' then retorno := substr(obter_desc_expressao(1068383), 1, 1999) || chr(13);
				when 'J' then retorno := substr(ds_just_intolerancia_p, 1, 1999) || chr(13);
				when 'M' then retorno := substr(obter_desc_expressao(1068383) || ': ' || ds_just_intolerancia_p, 1, 1999) || chr(13);
			end case;
		end if;
		return retorno;
	end;

begin

if (ie_criar_html IS NOT NULL AND ie_criar_html::text <> '') then
	return replace(substr(getDuplicado() || getInteracaoMedic() || getNaoPadronizado() || getAlergia() || getIntolerancia() || getDoseLimite() || getViaNaoRecomendada() || getInteracaoDieta() || getJustificativaLactante() || getDoseMinima() || getExameLab() || getEspecialidadeMedica() || getJustificativaDil() || getLatex(),1,2000), chr(13),  chr(13) || '<br>');
end if;

return substr(getDuplicado() || getInteracaoMedic() || getNaoPadronizado() || getAlergia() || getIntolerancia() || getDoseLimite() || getViaNaoRecomendada() || getInteracaoDieta() || getJustificativaLactante() || getDoseMinima() || getExameLab() || getEspecialidadeMedica() || getJustificativaDil() || getLatex(),1,2000);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_just_item ( ie_tipo_retorno text default 'M', ie_duplicado_p cpoe_justificativa_item.ie_duplicado%type default null, ds_just_duplicado_p cpoe_justificativa_item.ds_just_duplicado%type default null, ie_interacao_medic_p cpoe_justificativa_item.ie_interacao_medic%type default null, ds_just_interacao_medic_p cpoe_justificativa_item.ds_just_interacao_medic%type default null, ie_nao_padronizado_p cpoe_justificativa_item.ie_nao_padronizado%type default null, ds_just_nao_padronizado_p cpoe_justificativa_item.ds_just_nao_padronizado%type default null, ie_alergia_p cpoe_justificativa_item.ie_alergia%type default null, ds_just_alergia_p cpoe_justificativa_item.ds_just_alergia%type default null, ie_dose_limite_p cpoe_justificativa_item.ie_dose_limite%type default null, ds_just_dose_limite_p cpoe_justificativa_item.ds_just_dose_limite%type default null, ie_via_nao_recomendada_p cpoe_justificativa_item.ie_via_nao_recomendada%type default null, ds_just_via_nao_recom_p cpoe_justificativa_item.ds_just_via_nao_recom%type default null, ie_interacao_dieta_p cpoe_justificativa_item.ie_interacao_dieta%type default null, ds_just_interacao_dieta_p cpoe_justificativa_item.ds_just_interacao_dieta%type default null, ie_permite_lactante_p cpoe_justificativa_item.ie_permite_lactante%type default null, ds_justificativa_lactante_p cpoe_justificativa_item.ds_justificativa_lactante%type default null, ie_dose_minima_p cpoe_justificativa_item.ie_dose_minima%type default null, ds_just_dose_minima_p cpoe_justificativa_item.ds_just_dose_minima%type default null, ie_exame_lab_p cpoe_justificativa_item.ie_exame_lab%type default null, ds_exame_lab_p cpoe_justificativa_item.ds_exame_lab%type default null, ie_especialidade_medica_p cpoe_justificativa_item.ie_especialidade_medica%type default null, ds_just_especialidade_med_p cpoe_justificativa_item.ds_just_especialidade_med%type default null, ie_permite_dil_p cpoe_justificativa_item.ie_permite_dil%type default null, ds_justificativa_dil_p cpoe_justificativa_item.ds_justificativa_dil%type default null, ie_latex_p cpoe_justificativa_item.ie_latex%type default null, ds_just_latex_p cpoe_justificativa_item.ds_just_latex%type default null, ie_criar_html text default null, ie_intolerancia_p cpoe_justificativa_item.ie_intolerancia%type default null, ds_just_intolerancia_p cpoe_justificativa_item.ds_just_intolerancia%type default null) FROM PUBLIC;
