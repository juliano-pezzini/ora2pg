-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_doacao_beforepost_hemotera ( ie_cadastro_doacao_p text, ie_modo_edicao_ou_novo_p text, ie_novo_registro_p text, ie_tipo_coleta_p text, ie_gravar_log_p text, cd_pessoa_fisica_p text, nr_seq_doacao_p bigint, nr_seq_derivado_p bigint, nr_sec_saude_p text, nr_sangue_p text, pr_hematocrito_p bigint, qt_peso_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, qt_peso_out_p INOUT bigint, nr_seq_doacao_amostra_p INOUT bigint, ds_atributo_focus_p INOUT text, ds_msg_hemat_p INOUT text, ds_msg_peso_p INOUT text, ds_erro_p INOUT text) AS $body$
DECLARE


ie_imped_sangue_dup_doacao_w	varchar(1);
ie_duplic_sangue_w		varchar(1);
ie_bloquear_pr_hematocrito_w	varchar(1);
qt_peso_minimo_doacao_w		smallint;
ie_consistir_peso_paciente_w	varchar(1);
ie_atualizar_campo_peso_w	varchar(1);
ie_cons_se_houver_amostra_w	varchar(1);
cd_pessoa_fisica_w		varchar(10);
ds_inconsistencia_soro_w	varchar(255);
ds_comando_w			varchar(2000);
ds_parametros_w			varchar(2000);
ds_sep_bv_w			varchar(10);
qt_san_producao_w		bigint;
ie_sus_w			varchar(1);
ie_sexo_w			varchar(1);
pr_hemat_min_fem_w		double precision;
pr_hemat_max_fem_w		double precision;
pr_hemat_min_mas_w		double precision;
pr_hemat_max_mas_w		double precision;
ie_gerar_sangue_w		varchar(1);
nr_seq_doacao_w			bigint;
qt_dias_inaptidao_w		san_regra_sinal_vital.qt_dias_inapto%type;


BEGIN

if (ie_cadastro_doacao_p = 'S') then
	begin
	if (ie_gravar_log_p = 'S') then
		begin
		CALL gravar_log_tasy(99876,
			obter_texto_dic_objeto(84907, wheb_usuario_pck.get_nr_seq_idioma,
				'NR_SEQ_DOACAO=' || nr_seq_doacao_p || ';'
				|| 'CD_PESSOA_FISICA=' || cd_pessoa_fisica_p),
			nm_usuario_p);
		end;
	end if;

	ds_erro_p	:=  san_obter_consistencia_soro(cd_pessoa_fisica_p, nr_seq_doacao_p, ie_tipo_coleta_p);

	if (coalesce(ds_erro_p::text, '') = '') and (ie_novo_registro_p = 'S') then
		begin
		/* Hemoterapia - Parametro [325] - Ao gerar uma nova doacao identificar se o doador possui uma nova amostra pendente */

		ie_cons_se_houver_amostra_w := obter_param_usuario(450, 325, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_cons_se_houver_amostra_w);

		if (ie_cons_se_houver_amostra_w = 'S') then
			begin
			select	coalesce(max(nr_sequencia), 0)
			into STRICT	nr_seq_doacao_amostra_p
			from	san_doacao
			where	cd_pessoa_fisica	= cd_pessoa_fisica_p
			and	ie_status		= 4;

			if (nr_seq_doacao_amostra_p <> 0) then
				ds_erro_p	:= obter_texto_tasy(93526, wheb_usuario_pck.get_nr_seq_idioma);
			end if;
			end;
		end if;
		end;
	end if;

	if (coalesce(ds_erro_p::text, '') = '') then
		begin
		/* Hemoterapia - Parametro [134] - Impedir o lancamento de sangues com o mesmo numero na pasta Doacao */

		ie_imped_sangue_dup_doacao_w := obter_param_usuario(450, 134, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_imped_sangue_dup_doacao_w);
		ie_gerar_sangue_w := obter_param_usuario(450, 252, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gerar_sangue_w);
		if (ie_imped_sangue_dup_doacao_w = 'S') and (ie_gerar_sangue_w = 'N')then
			begin
			ds_comando_w	:=
				' select	count(*) ' ||
				' from	san_producao ' ||
				' where	nr_sangue	= :nr_sangue_p ' ||
				' and	nr_seq_doacao <> :nr_sequencia_p ';
			ds_sep_bv_w	:= obter_separador_bv;
			ds_parametros_w	:= 'nr_sangue_p=' || nr_sangue_p || ds_sep_bv_w
					|| 'nr_sequencia_p=' || nr_seq_doacao_p || ds_sep_bv_w;

			/* Hemoterapia - Parametro [24] - Forma de tratar a duplicidade de hemocomponente */

			ie_duplic_sangue_w := obter_param_usuario(450, 24, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_duplic_sangue_w);

			if (ie_duplic_sangue_w = 'SH') then
				begin
				ds_comando_w	:= ds_comando_w || ' and nr_seq_derivado = :nr_seq_derivado_p ';
				ds_parametros_w	:= ds_parametros_w || 'nr_seq_derivado_p=' || nr_seq_derivado_p || ds_sep_bv_w;
				end;
			end if;

			qt_san_producao_w	:= obter_select_concatenado_bv(ds_comando_w, ds_parametros_w, ds_sep_bv_w);

			if (qt_san_producao_w > 0) then
				ds_erro_p	:= obter_texto_tasy(75481, wheb_usuario_pck.get_nr_seq_idioma);
			else
				ds_comando_w	:=
					' select	count(*) ' ||
					' from		san_doacao ' ||
					' where		nr_sangue	= :nr_sangue_p ' ||
					' and		nr_sequencia	<> :nr_sequencia_p ';
				ds_sep_bv_w	:= obter_separador_bv;
				ds_parametros_w	:= 'nr_sangue_p=' || nr_sangue_p || ds_sep_bv_w
						|| 'nr_sequencia_p=' || nr_seq_doacao_p || ds_sep_bv_w;
						
				qt_san_producao_w	:= obter_select_concatenado_bv(ds_comando_w, ds_parametros_w, ds_sep_bv_w);
				
				if (qt_san_producao_w > 0) then
					ds_erro_p	:= obter_texto_tasy(75481, wheb_usuario_pck.get_nr_seq_idioma);
				end if;
			end if;
			end;
		end if;
		end;
	end if;
	end;
end if;

if (coalesce(ds_erro_p::text, '') = '') then
	begin
	SELECT * FROM consistir_hematocritos_hemot(
		pr_hematocrito_p, cd_pessoa_fisica_p, cd_estabelecimento_p, nm_usuario_p, ds_atributo_focus_p, ds_msg_hemat_p, ds_erro_p, qt_dias_inaptidao_w) INTO STRICT ds_atributo_focus_p, ds_msg_hemat_p, ds_erro_p, qt_dias_inaptidao_w;
	end;
end if;

if (coalesce(ds_erro_p::text, '') = '') and (ie_modo_edicao_ou_novo_p = 'S') and (qt_peso_p > 0) then
	begin
	/* Hemoterapia - Parametro [145] - Peso minimo para a doacao */

	qt_peso_minimo_doacao_w := obter_param_usuario(450, 145, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, qt_peso_minimo_doacao_w);

	if (qt_peso_minimo_doacao_w > 0) then
		begin
		if (qt_peso_p < qt_peso_minimo_doacao_w) then
			begin
			/* Hemoterapia - Parametro [146] - Permite a doacao de paciente com peso inferior ao minimo */

			ie_consistir_peso_paciente_w := obter_param_usuario(450, 146, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consistir_peso_paciente_w);

			if (ie_consistir_peso_paciente_w = 'N') then
				ds_erro_p		:= obter_texto_dic_objeto(75501, wheb_usuario_pck.get_nr_seq_idioma, 'PESO_MINIMO_DOACAO=' || qt_peso_minimo_doacao_w);
			elsif (ie_consistir_peso_paciente_w = 'A') then
				ds_msg_peso_p	:= obter_texto_dic_objeto(75501, wheb_usuario_pck.get_nr_seq_idioma, 'PESO_MINIMO_DOACAO=' || qt_peso_minimo_doacao_w);
			end if;
			end;
		end if;
		end;
	end if;
	end;
end if;

if (coalesce(ds_erro_p::text, '') = '') then
	begin
	if (ie_cadastro_doacao_p = 'S') and (ie_novo_registro_p = 'S') then
		begin
		/* Hemoterapia - Parametro [186] - Atualizar o campo peso do paciente conforme a ultima doacao */

		ie_atualizar_campo_peso_w := obter_param_usuario(450, 186, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_atualizar_campo_peso_w);

		if (ie_atualizar_campo_peso_w = 'S') then
			begin
			
			select	max(nr_sequencia)
			into STRICT	nr_seq_doacao_w
			from	san_doacao
			where	cd_pessoa_fisica = cd_pessoa_fisica_p
			and	nr_sequencia	<> nr_seq_doacao_p;
			
			if (coalesce(nr_seq_doacao_w,0) > 0) then
				
				select	coalesce(qt_peso,0)
				into STRICT	qt_peso_out_p
				from	san_doacao
				where	nr_sequencia = nr_seq_doacao_w;
				
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
-- REVOKE ALL ON PROCEDURE san_doacao_beforepost_hemotera ( ie_cadastro_doacao_p text, ie_modo_edicao_ou_novo_p text, ie_novo_registro_p text, ie_tipo_coleta_p text, ie_gravar_log_p text, cd_pessoa_fisica_p text, nr_seq_doacao_p bigint, nr_seq_derivado_p bigint, nr_sec_saude_p text, nr_sangue_p text, pr_hematocrito_p bigint, qt_peso_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, qt_peso_out_p INOUT bigint, nr_seq_doacao_amostra_p INOUT bigint, ds_atributo_focus_p INOUT text, ds_msg_hemat_p INOUT text, ds_msg_peso_p INOUT text, ds_erro_p INOUT text) FROM PUBLIC;

