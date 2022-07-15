-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_hemoglobina_hemot ( qt_hemoglobina_p bigint, cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ds_atributo_focus_p INOUT text, ds_mens_hemat_p INOUT text, ds_erro_p INOUT text, qt_dias_inaptidao_p INOUT bigint, vl_questionario_p text default 'N') AS $body$
DECLARE


ie_sexo_w					varchar(1);
qt_hemoglobina_min_fem_w	double precision;
qt_hemoglobina_max_fem_w	double precision;
qt_hemoglobina_min_mas_w	double precision;
qt_hemoglobina_max_mas_w	double precision;
qt_dias_inapto_hemog_f_w	san_parametro.qt_dias_inapto_hemog_f%type;
qt_dias_inapto_hemog_m_w	san_parametro.qt_dias_inapto_hemog_m%type;
ie_bloquear_hemoglobina_w	varchar(1);


BEGIN

if (qt_hemoglobina_p IS NOT NULL AND qt_hemoglobina_p::text <> '') then
	begin
	select	ie_sexo
	into STRICT	ie_sexo_w
	from	pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;

	select	max(qt_hemoglobina_min_fem),
		max(qt_hemoglobina_max_fem),
		max(qt_hemoglobina_min_mas),
		max(qt_hemoglobina_max_mas),
		max(qt_dias_inapto_hemog_f),
		max(qt_dias_inapto_hemog_m)
	into STRICT	qt_hemoglobina_min_fem_w,
		qt_hemoglobina_max_fem_w,
		qt_hemoglobina_min_mas_w,
		qt_hemoglobina_max_mas_w,
		qt_dias_inapto_hemog_f_w,
		qt_dias_inapto_hemog_m_w
	from	san_parametro
	where	cd_estabelecimento = cd_estabelecimento_p;

	ie_bloquear_hemoglobina_w := obter_param_usuario(450, 503, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_bloquear_hemoglobina_w);

	if (ie_sexo_w = 'M') then
		begin
		if (qt_hemoglobina_min_mas_w IS NOT NULL AND qt_hemoglobina_min_mas_w::text <> '') and (qt_hemoglobina_p < qt_hemoglobina_min_mas_w) then
			begin
			qt_dias_inaptidao_p	:= qt_dias_inapto_hemog_m_w;
			if (VL_QUESTIONARIO_P = 'S' or ie_bloquear_hemoglobina_w = 'S') then
				begin
				ds_atributo_focus_p	:= 'QT_HEMOGLOBINA';
				ds_erro_p		:= obter_texto_dic_objeto(74524, wheb_usuario_pck.get_nr_seq_idioma, 'QT_HEMOGLOBINA_MIN_MAS=' || qt_hemoglobina_min_mas_w);
				end;
			elsif (VL_QUESTIONARIO_P = 'S' or ie_bloquear_hemoglobina_w = 'A') then
				begin
					ds_mens_hemat_p	:= obter_texto_dic_objeto(74524, wheb_usuario_pck.get_nr_seq_idioma, 'QT_HEMOGLOBINA_MIN_MAS=' || qt_hemoglobina_min_mas_w);
				end;
			end if;
			end;

		elsif (qt_hemoglobina_max_mas_w IS NOT NULL AND qt_hemoglobina_max_mas_w::text <> '') and (qt_hemoglobina_p > qt_hemoglobina_max_mas_w) then
			begin
			qt_dias_inaptidao_p	:= qt_dias_inapto_hemog_m_w;
			if (VL_QUESTIONARIO_P = 'S' or ie_bloquear_hemoglobina_w = 'S') then
				begin
				ds_atributo_focus_p	:= 'QT_HEMOGLOBINA';
				ds_erro_p		:= obter_texto_dic_objeto(74533, wheb_usuario_pck.get_nr_seq_idioma, 'QT_HEMOGLOBINA_MAX_MAS=' || qt_hemoglobina_max_mas_w);
				end;
			elsif (VL_QUESTIONARIO_P = 'S' or ie_bloquear_hemoglobina_w = 'A') then
				begin
				ds_mens_hemat_p	:= obter_texto_dic_objeto(74533, wheb_usuario_pck.get_nr_seq_idioma, 'QT_HEMOGLOBINA_MAX_MAS=' || qt_hemoglobina_max_mas_w);
				end;
			end if;
			end;
		end if;
		end;

	elsif (ie_sexo_w = 'F') then
		begin
		if (qt_hemoglobina_min_fem_w IS NOT NULL AND qt_hemoglobina_min_fem_w::text <> '') and (qt_hemoglobina_p < qt_hemoglobina_min_fem_w) then
			begin
			qt_dias_inaptidao_p	:= qt_dias_inapto_hemog_f_w;
			if (VL_QUESTIONARIO_P = 'S' or ie_bloquear_hemoglobina_w = 'S') then
				begin
				ds_atributo_focus_p	:= 'QT_HEMOGLOBINA';
				ds_erro_p		:= obter_texto_dic_objeto(74534, wheb_usuario_pck.get_nr_seq_idioma, 'QT_HEMOGLOBINA_MIN_FEM=' || qt_hemoglobina_min_fem_w);
				end;
			elsif (VL_QUESTIONARIO_P = 'S' or ie_bloquear_hemoglobina_w = 'A') then
				begin
				ds_mens_hemat_p	:= obter_texto_dic_objeto(74534, wheb_usuario_pck.get_nr_seq_idioma, 'QT_HEMOGLOBINA_MIN_FEM=' || qt_hemoglobina_min_fem_w);
				end;
			end if;
			end;

		elsif (qt_hemoglobina_max_fem_w IS NOT NULL AND qt_hemoglobina_max_fem_w::text <> '') and (qt_hemoglobina_p > qt_hemoglobina_max_fem_w) then
			begin
			qt_dias_inaptidao_p	:= qt_dias_inapto_hemog_f_w;
			if (VL_QUESTIONARIO_P = 'S' or ie_bloquear_hemoglobina_w = 'S') then
				begin
				ds_atributo_focus_p	:= 'QT_HEMOGLOBINA';
				ds_erro_p		:= obter_texto_dic_objeto(74535, wheb_usuario_pck.get_nr_seq_idioma, 'QT_HEMOGLOBINA_MAX_FEM=' || qt_hemoglobina_max_fem_w);
			end;
			elsif (VL_QUESTIONARIO_P = 'S' or ie_bloquear_hemoglobina_w = 'A') then
				begin
				ds_mens_hemat_p	:= obter_texto_dic_objeto(74535, wheb_usuario_pck.get_nr_seq_idioma, 'QT_HEMOGLOBINA_MAX_FEM=' || qt_hemoglobina_max_fem_w);
				end;
			end if;
			end;
		end if;
		end;
	end if;
	end;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_hemoglobina_hemot ( qt_hemoglobina_p bigint, cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ds_atributo_focus_p INOUT text, ds_mens_hemat_p INOUT text, ds_erro_p INOUT text, qt_dias_inaptidao_p INOUT bigint, vl_questionario_p text default 'N') FROM PUBLIC;

