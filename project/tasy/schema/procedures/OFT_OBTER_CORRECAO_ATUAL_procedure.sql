-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE oft_obter_correcao_atual ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text, vListaCorrecaoAtual INOUT strRecTypeFormOft) AS $body$
DECLARE


ds_observacao_w			oft_correcao_atual.ds_observacao%type;
dt_exame_w					oft_correcao_atual.dt_registro%type;
nr_seq_tipo_lente_w		oft_correcao_atual.nr_seq_tipo_lente%type;
ie_unidade_tempo_w		oft_correcao_atual.ie_unidade_tempo%type;
qt_tempo_uso_w				oft_correcao_atual.qt_tempo_uso%type;
vl_od_pl_dio_esf_w		oft_correcao_atual.vl_od_pl_dio_esf%type;
vl_od_pl_dio_cil_w		oft_correcao_atual.vl_od_pl_dio_cil%type;
vl_od_pl_eixo_w			oft_correcao_atual.vl_od_pl_eixo%type;
vl_od_pl_adicao_w			oft_correcao_atual.vl_od_pl_adicao%type;
vl_oe_pl_dio_esf_w		oft_correcao_atual.vl_oe_pl_dio_esf%type;
vl_oe_pl_dio_cil_w		oft_correcao_atual.vl_oe_pl_dio_cil%type;
vl_oe_pl_eixo_w			oft_correcao_atual.vl_oe_pl_eixo%type;	
vl_oe_pl_adicao_w			oft_correcao_atual.vl_oe_pl_adicao%type;
vl_od_pp_dio_esf_w		oft_correcao_atual.vl_od_pp_dio_esf%type;
vl_od_pp_dio_cil_w		oft_correcao_atual.vl_od_pp_dio_cil%type;
vl_od_pp_eixo_w			oft_correcao_atual.vl_od_pp_eixo%type;	
vl_od_pp_adicao_w			oft_correcao_atual.vl_od_pp_adicao%type;	
vl_oe_pp_dio_esf_w		oft_correcao_atual.vl_oe_pp_dio_esf%type;
vl_oe_pp_dio_cil_w		oft_correcao_atual.vl_oe_pp_dio_cil%type;	
vl_oe_pp_eixo_w			oft_correcao_atual.vl_oe_pp_eixo%type;
vl_oe_pp_adicao_w			oft_correcao_atual.vl_oe_pp_adicao%type;
ie_tipo_w					oft_correcao_atual.ie_tipo%type := null;
vl_od_pl_av_sc_w			oft_correcao_atual.vl_od_pl_av_sc%type;
vl_od_pl_av_cc_w			oft_correcao_atual.vl_od_pl_av_cc%type;
vl_oe_pl_av_sc_w			oft_correcao_atual.vl_oe_pl_av_sc%type;
vl_oe_pl_av_cc_w			oft_correcao_atual.vl_oe_pl_av_cc%type;
vl_od_pl_cor_sc_w			oft_correcao_atual.vl_od_pl_cor_sc%type;
vl_od_pl_con_sc_w			oft_correcao_atual.vl_od_pl_con_sc%type;
vl_od_pl_con_cc_w			oft_correcao_atual.vl_od_pl_con_cc%type;
vl_oe_pl_cor_sc_w			oft_correcao_atual.vl_oe_pl_cor_sc%type;
vl_oe_pl_con_sc_w			oft_correcao_atual.vl_oe_pl_con_sc%type;
vl_od_pp_con_sc_w			oft_correcao_atual.vl_od_pp_con_sc%type;	
vl_od_pp_cor_sc_w			oft_correcao_atual.vl_od_pp_cor_sc%type;
vl_od_pp_con_cc_w			oft_correcao_atual.vl_od_pp_con_cc%type;
vl_oe_pl_con_cc_w			oft_correcao_atual.vl_oe_pl_con_cc%type;
vl_od_pp_av_cc_w			oft_correcao_atual.vl_od_pp_av_cc%type;
vl_oe_pp_av_sc_w			oft_correcao_atual.vl_oe_pp_av_sc%type;
vl_oe_pp_cor_sc_w			oft_correcao_atual.vl_oe_pp_cor_sc%type;
vl_oe_pp_con_sc_w			oft_correcao_atual.vl_oe_pp_con_sc%type;
vl_oe_pp_av_cc_w			oft_correcao_atual.vl_oe_pp_av_cc%type;
vl_oe_pp_con_cc_w			oft_correcao_atual.vl_oe_pp_con_cc%type;
vl_od_pp_av_sc_w			oft_correcao_atual.vl_od_pp_av_sc%type;
nr_seq_lente_w				oft_correcao_atual.nr_seq_lente%type;
qt_grau_w					oft_correcao_atual.qt_grau%type;
qt_grau_esferico_w		oft_correcao_atual.qt_grau_esferico%type;	
qt_grau_cilindrico_w		oft_correcao_atual.qt_grau_cilindrico%type;
qt_grau_longe_w			oft_correcao_atual.qt_grau_longe%type;
qt_eixo_w					oft_correcao_atual.qt_eixo%type;
qt_adicao_w					oft_correcao_atual.qt_adicao%type;
vl_av_w						oft_correcao_atual.vl_av%type;
qt_curva_base_w			oft_correcao_atual.qt_curva_base%type;
qt_curva_base_um_w		oft_correcao_atual.qt_curva_base_um%type;
qt_curva_base_dois_w		oft_correcao_atual.qt_curva_base_dois%type;
qt_diametro_w				oft_correcao_atual.qt_diametro%type;
nr_seq_lente_oe_w			oft_correcao_atual.nr_seq_lente_oe%type;
qt_diametro_oe_w			oft_correcao_atual.qt_diametro_oe%type;
qt_grau_cilindrico_oe_w	oft_correcao_atual.qt_grau_cilindrico_oe%type;
qt_grau_oe_w				oft_correcao_atual.qt_grau_oe%type;
qt_eixo_oe_w				oft_correcao_atual.qt_eixo_oe%type;
qt_adicao_oe_w				oft_correcao_atual.qt_adicao_oe%type;
qt_grau_longe_oe_w		oft_correcao_atual.qt_grau_longe_oe%type;	
qt_curva_base_oe_w		oft_correcao_atual.qt_curva_base_oe%type;	
qt_curva_base_dois_oe_w	oft_correcao_atual.qt_curva_base_dois_oe%type;
qt_curva_base_um_oe_w	oft_correcao_atual.qt_curva_base_um_oe%type;
qt_grau_esferico_oe_w	oft_correcao_atual.qt_grau_esferico_oe%type;
vl_av_oe_w					oft_correcao_atual.vl_av_oe%type;
cd_profissional_w			oft_correcao_atual.cd_profissional%TYPE;
vl_od_lent_pl_adic_w	oft_correcao_atual.vl_od_lent_pl_adic%type;
vl_oe_lent_pl_adic_w	oft_correcao_atual.vl_oe_lent_pl_adic%type;
vl_od_av_cc_w			oft_correcao_atual.vl_od_av_cc%type;
vl_oe_av_cc_w			oft_correcao_atual.vl_oe_av_cc%type;
dt_liberacao_w				timestamp;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type := wheb_usuario_pck.get_cd_estabelecimento;
nm_usuario_w				usuario.nm_usuario%type := wheb_usuario_pck.get_nm_usuario;
ds_erro_w					varchar(4000);

correcao_atual_form CURSOR FOR
	SELECT	a.*
	from		oft_correcao_atual a,
				oft_consulta_formulario b
	where		a.nr_seq_consulta_form 	=	b.nr_sequencia
	and		a.nr_seq_consulta_form 	=	nr_seq_consulta_form_p
	and		a.nr_seq_consulta			=	nr_seq_consulta_p
	and		coalesce(ie_tipo,'X')			=	coalesce(ie_tipo_w,'X')
	and		((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.nm_usuario = nm_usuario_w))
	and		((coalesce(a.dt_inativacao::text, '') = '') or (b.dt_inativacao IS NOT NULL AND b.dt_inativacao::text <> ''))
	order by dt_registro;
	
correcao_atual_paciente CURSOR FOR
	SELECT	a.*
	from		oft_correcao_atual a,
				oft_consulta b
	where		a.nr_seq_consulta		=	b.nr_sequencia
	and		b.cd_pessoa_fisica	=	cd_pessoa_fisica_p
	and		coalesce(ie_tipo,'X')			=	coalesce(ie_tipo_w,'X')
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and		coalesce(a.dt_inativacao::text, '') = ''
	and		b.nr_sequencia 		<> nr_seq_consulta_p
	order by dt_registro;
	
	
											
BEGIN
begin

if (coalesce(nr_seq_consulta_p,0) > 0) and (vListaCorrecaoAtual.count > 0) then
	for i in 1..vListaCorrecaoAtual.count loop
		begin
		if (vListaCorrecaoAtual[i].nr_seq_visao = 90600) then
			ie_tipo_w := 'A';
		elsif (vListaCorrecaoAtual[i].nr_seq_visao = 90638) then
			ie_tipo_w := 'C';
		elsif (vListaCorrecaoAtual[i].nr_seq_visao = 90593) then	
			ie_tipo_w := 'S';
		elsif (vListaCorrecaoAtual[i].nr_seq_visao = 90637) then		
			ie_tipo_w := 'O';
		end if;	
		end;
	end loop;	
	if (ie_opcao_p = 'F') then
		FOR c_correcao_atual IN correcao_atual_form LOOP
			begin
			ds_observacao_w			:= c_correcao_atual.ds_observacao;
			dt_exame_w					:= c_correcao_atual.dt_registro;
			nr_seq_tipo_lente_w		:= c_correcao_atual.nr_seq_tipo_lente;
			ie_unidade_tempo_w		:= c_correcao_atual.ie_unidade_tempo;
			qt_tempo_uso_w				:= c_correcao_atual.qt_tempo_uso;
			vl_od_pl_dio_esf_w		:= c_correcao_atual.vl_od_pl_dio_esf;
			vl_od_pl_dio_cil_w		:= c_correcao_atual.vl_od_pl_dio_cil;
			vl_od_pl_eixo_w			:= c_correcao_atual.vl_od_pl_eixo;
			vl_od_pl_adicao_w			:= c_correcao_atual.vl_od_pl_adicao;
			vl_oe_pl_dio_esf_w		:= c_correcao_atual.vl_oe_pl_dio_esf;
			vl_oe_pl_dio_cil_w		:= c_correcao_atual.vl_oe_pl_dio_cil;
			vl_oe_pl_eixo_w			:= c_correcao_atual.vl_oe_pl_eixo;	
			vl_oe_pl_adicao_w			:= c_correcao_atual.vl_oe_pl_adicao;
			vl_od_pp_dio_esf_w		:= c_correcao_atual.vl_od_pp_dio_esf;
			vl_od_pp_dio_cil_w		:= c_correcao_atual.vl_od_pp_dio_cil;
			vl_od_pp_eixo_w			:= c_correcao_atual.vl_od_pp_eixo;	
			vl_od_pp_adicao_w			:= c_correcao_atual.vl_od_pp_adicao;	
			vl_oe_pp_dio_esf_w		:= c_correcao_atual.vl_oe_pp_dio_esf;
			vl_oe_pp_dio_cil_w		:= c_correcao_atual.vl_oe_pp_dio_cil;	
			vl_oe_pp_eixo_w			:= c_correcao_atual.vl_oe_pp_eixo;
			vl_oe_pp_adicao_w			:= c_correcao_atual.vl_oe_pp_adicao;
			ie_tipo_w					:= c_correcao_atual.ie_tipo;
			vl_od_pl_av_sc_w			:= c_correcao_atual.vl_od_pl_av_sc;
			vl_od_pl_av_cc_w			:= c_correcao_atual.vl_od_pl_av_cc;
			vl_oe_pl_av_sc_w			:= c_correcao_atual.vl_oe_pl_av_sc;
			vl_oe_pl_av_cc_w			:= c_correcao_atual.vl_oe_pl_av_cc;
			vl_od_pl_cor_sc_w			:= c_correcao_atual.vl_od_pl_cor_sc;
			vl_od_pl_con_sc_w			:= c_correcao_atual.vl_od_pl_con_sc;
			vl_od_pl_con_cc_w			:= c_correcao_atual.vl_od_pl_con_cc;
			vl_oe_pl_cor_sc_w			:= c_correcao_atual.vl_oe_pl_cor_sc;
			vl_oe_pl_con_sc_w			:= c_correcao_atual.vl_oe_pl_con_sc;
			vl_od_pp_con_sc_w			:= c_correcao_atual.vl_od_pp_con_sc;	
			vl_od_pp_cor_sc_w			:= c_correcao_atual.vl_od_pp_cor_sc;
			vl_od_pp_con_cc_w			:= c_correcao_atual.vl_od_pp_con_cc;
			vl_oe_pl_con_cc_w			:= c_correcao_atual.vl_oe_pl_con_cc;
			vl_od_pp_av_cc_w			:= c_correcao_atual.vl_od_pp_av_cc;
			vl_oe_pp_av_sc_w			:= c_correcao_atual.vl_oe_pp_av_sc;
			vl_oe_pp_cor_sc_w			:= c_correcao_atual.vl_oe_pp_cor_sc;
			vl_oe_pp_con_sc_w			:= c_correcao_atual.vl_oe_pp_con_sc;
			vl_oe_pp_av_cc_w			:= c_correcao_atual.vl_oe_pp_av_cc;
			vl_oe_pp_con_cc_w			:= c_correcao_atual.vl_oe_pp_con_cc;
			vl_od_pp_av_sc_w			:= c_correcao_atual.vl_od_pp_av_sc;
			nr_seq_lente_w				:= c_correcao_atual.nr_seq_lente;
			qt_grau_w					:= c_correcao_atual.qt_grau;
			qt_grau_esferico_w		:= c_correcao_atual.qt_grau_esferico;	
			qt_grau_cilindrico_w		:= c_correcao_atual.qt_grau_cilindrico;
			qt_grau_longe_w			:= c_correcao_atual.qt_grau_longe;
			qt_eixo_w					:= c_correcao_atual.qt_eixo;
			qt_adicao_w					:= c_correcao_atual.qt_adicao;
			vl_av_w						:= c_correcao_atual.vl_av;
			qt_curva_base_w			:= c_correcao_atual.qt_curva_base;
			qt_curva_base_um_w		:= c_correcao_atual.qt_curva_base_um;
			qt_curva_base_dois_w		:= c_correcao_atual.qt_curva_base_dois;
			qt_diametro_w				:= c_correcao_atual.qt_diametro;
			nr_seq_lente_oe_w			:= c_correcao_atual.nr_seq_lente_oe;
			qt_diametro_oe_w			:= c_correcao_atual.qt_diametro_oe;
			qt_grau_cilindrico_oe_w	:= c_correcao_atual.qt_grau_cilindrico_oe;
			qt_grau_oe_w				:= c_correcao_atual.qt_grau_oe;
			qt_eixo_oe_w				:= c_correcao_atual.qt_eixo_oe;
			qt_adicao_oe_w				:= c_correcao_atual.qt_adicao_oe;
			qt_grau_longe_oe_w		:= c_correcao_atual.qt_grau_longe_oe;	
			qt_curva_base_oe_w		:= c_correcao_atual.qt_curva_base_oe;	
			qt_curva_base_dois_oe_w	:= c_correcao_atual.qt_curva_base_dois_oe;
			qt_curva_base_um_oe_w	:= c_correcao_atual.qt_curva_base_um_oe;
			qt_grau_esferico_oe_w	:= c_correcao_atual.qt_grau_esferico_oe;
			vl_av_oe_w					:= c_correcao_atual.vl_av_oe;
			cd_profissional_w			:=	c_correcao_atual.cd_profissional;
			dt_liberacao_w				:=	c_correcao_atual.dt_liberacao;
			vl_od_lent_pl_adic_w		:=	c_correcao_atual.vl_od_lent_pl_adic;
			vl_oe_lent_pl_adic_w		:=	c_correcao_atual.vl_oe_lent_pl_adic;
			vl_od_av_cc_w				:=	c_correcao_atual.vl_od_av_cc;
			vl_oe_av_cc_w				:=	c_correcao_atual.vl_oe_av_cc;
			end;
		end loop;	
	else
		FOR c_correcao_atual IN correcao_atual_paciente LOOP
			begin
			ds_observacao_w			:= c_correcao_atual.ds_observacao;
			nr_seq_tipo_lente_w		:= c_correcao_atual.nr_seq_tipo_lente;
			ie_unidade_tempo_w		:= c_correcao_atual.ie_unidade_tempo;
			qt_tempo_uso_w				:= c_correcao_atual.qt_tempo_uso;
			vl_od_pl_dio_esf_w		:= c_correcao_atual.vl_od_pl_dio_esf;
			vl_od_pl_dio_cil_w		:= c_correcao_atual.vl_od_pl_dio_cil;
			vl_od_pl_eixo_w			:= c_correcao_atual.vl_od_pl_eixo;
			vl_od_pl_adicao_w			:= c_correcao_atual.vl_od_pl_adicao;
			vl_oe_pl_dio_esf_w		:= c_correcao_atual.vl_oe_pl_dio_esf;
			vl_oe_pl_dio_cil_w		:= c_correcao_atual.vl_oe_pl_dio_cil;
			vl_oe_pl_eixo_w			:= c_correcao_atual.vl_oe_pl_eixo;	
			vl_oe_pl_adicao_w			:= c_correcao_atual.vl_oe_pl_adicao;
			vl_od_pp_dio_esf_w		:= c_correcao_atual.vl_od_pp_dio_esf;
			vl_od_pp_dio_cil_w		:= c_correcao_atual.vl_od_pp_dio_cil;
			vl_od_pp_eixo_w			:= c_correcao_atual.vl_od_pp_eixo;	
			vl_od_pp_adicao_w			:= c_correcao_atual.vl_od_pp_adicao;	
			vl_oe_pp_dio_esf_w		:= c_correcao_atual.vl_oe_pp_dio_esf;
			vl_oe_pp_dio_cil_w		:= c_correcao_atual.vl_oe_pp_dio_cil;	
			vl_oe_pp_eixo_w			:= c_correcao_atual.vl_oe_pp_eixo;
			vl_oe_pp_adicao_w			:= c_correcao_atual.vl_oe_pp_adicao;
			ie_tipo_w					:= c_correcao_atual.ie_tipo;
			vl_od_pl_av_sc_w			:= c_correcao_atual.vl_od_pl_av_sc;
			vl_od_pl_av_cc_w			:= c_correcao_atual.vl_od_pl_av_cc;
			vl_oe_pl_av_sc_w			:= c_correcao_atual.vl_oe_pl_av_sc;
			vl_oe_pl_av_cc_w			:= c_correcao_atual.vl_oe_pl_av_cc;
			vl_od_pl_cor_sc_w			:= c_correcao_atual.vl_od_pl_cor_sc;
			vl_od_pl_con_sc_w			:= c_correcao_atual.vl_od_pl_con_sc;
			vl_od_pl_con_cc_w			:= c_correcao_atual.vl_od_pl_con_cc;
			vl_oe_pl_cor_sc_w			:= c_correcao_atual.vl_oe_pl_cor_sc;
			vl_oe_pl_con_sc_w			:= c_correcao_atual.vl_oe_pl_con_sc;
			vl_od_pp_con_sc_w			:= c_correcao_atual.vl_od_pp_con_sc;	
			vl_od_pp_cor_sc_w			:= c_correcao_atual.vl_od_pp_cor_sc;
			vl_od_pp_con_cc_w			:= c_correcao_atual.vl_od_pp_con_cc;
			vl_oe_pl_con_cc_w			:= c_correcao_atual.vl_oe_pl_con_cc;
			vl_od_pp_av_cc_w			:= c_correcao_atual.vl_od_pp_av_cc;
			vl_oe_pp_av_sc_w			:= c_correcao_atual.vl_oe_pp_av_sc;
			vl_oe_pp_cor_sc_w			:= c_correcao_atual.vl_oe_pp_cor_sc;
			vl_oe_pp_con_sc_w			:= c_correcao_atual.vl_oe_pp_con_sc;
			vl_oe_pp_av_cc_w			:= c_correcao_atual.vl_oe_pp_av_cc;
			vl_oe_pp_con_cc_w			:= c_correcao_atual.vl_oe_pp_con_cc;
			vl_od_pp_av_sc_w			:= c_correcao_atual.vl_od_pp_av_sc;
			nr_seq_lente_w				:= c_correcao_atual.nr_seq_lente;
			qt_grau_w					:= c_correcao_atual.qt_grau;
			qt_grau_esferico_w		:= c_correcao_atual.qt_grau_esferico;	
			qt_grau_cilindrico_w		:= c_correcao_atual.qt_grau_cilindrico;
			qt_grau_longe_w			:= c_correcao_atual.qt_grau_longe;
			qt_eixo_w					:= c_correcao_atual.qt_eixo;
			qt_adicao_w					:= c_correcao_atual.qt_adicao;
			vl_av_w						:= c_correcao_atual.vl_av;
			qt_curva_base_w			:= c_correcao_atual.qt_curva_base;
			qt_curva_base_um_w		:= c_correcao_atual.qt_curva_base_um;
			qt_curva_base_dois_w		:= c_correcao_atual.qt_curva_base_dois;
			qt_diametro_w				:= c_correcao_atual.qt_diametro;
			nr_seq_lente_oe_w			:= c_correcao_atual.nr_seq_lente_oe;
			qt_diametro_oe_w			:= c_correcao_atual.qt_diametro_oe;
			qt_grau_cilindrico_oe_w	:= c_correcao_atual.qt_grau_cilindrico_oe;
			qt_grau_oe_w				:= c_correcao_atual.qt_grau_oe;
			qt_eixo_oe_w				:= c_correcao_atual.qt_eixo_oe;
			qt_adicao_oe_w				:= c_correcao_atual.qt_adicao_oe;
			qt_grau_longe_oe_w		:= c_correcao_atual.qt_grau_longe_oe;	
			qt_curva_base_oe_w		:= c_correcao_atual.qt_curva_base_oe;	
			qt_curva_base_dois_oe_w	:= c_correcao_atual.qt_curva_base_dois_oe;
			qt_curva_base_um_oe_w	:= c_correcao_atual.qt_curva_base_um_oe;
			qt_grau_esferico_oe_w	:= c_correcao_atual.qt_grau_esferico_oe;
			vl_av_oe_w					:= c_correcao_atual.vl_av_oe;
			cd_profissional_w			:=	obter_pf_usuario(nm_usuario_w,'C');
			dt_exame_w					:= clock_timestamp();
			vl_od_lent_pl_adic_w		:=	c_correcao_atual.vl_od_lent_pl_adic;
			vl_oe_lent_pl_adic_w		:=	c_correcao_atual.vl_oe_lent_pl_adic;
			vl_od_av_cc_w				:=	c_correcao_atual.vl_od_av_cc;
			vl_oe_av_cc_w				:=	c_correcao_atual.vl_oe_av_cc;
			end;
		end loop;
	end if;	
	for i in 1..vListaCorrecaoAtual.count loop
		begin
		if (ie_opcao_p = 'F') or (vListaCorrecaoAtual[i].ie_obter_resultado = 'S') then
			vListaCorrecaoAtual[i].dt_liberacao	:= dt_liberacao_w;
			case upper(vListaCorrecaoAtual[i].nm_campo)
				WHEN 'CD_PROFISSIONAL' THEN
					vListaCorrecaoAtual[i].ds_valor	:= cd_profissional_w;
				when 'DT_EXAME' then
					vListaCorrecaoAtual[i].dt_valor	:= dt_exame_w;
				when 'DS_OBSERVACAO' then
					vListaCorrecaoAtual[i].ds_valor 	:= ds_observacao_w;
				when 'NR_SEQ_TIPO_LENTE' then
					vListaCorrecaoAtual[i].nr_valor 	:= nr_seq_tipo_lente_w;					
				when 'IE_UNIDADE_TEMPO' then
					vListaCorrecaoAtual[i].nr_valor 	:= ie_unidade_tempo_w;					
				when 'QT_TEMPO_USO' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_tempo_uso_w;					
				when 'VL_OD_PL_DIO_ESF' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_pl_dio_esf_w;					
				when 'VL_OD_PL_DIO_CIL' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_pl_dio_cil_w;					
				when 'VL_OD_PL_EIXO' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_pl_eixo_w;					
				when 'VL_OD_PL_ADICAO' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_pl_adicao_w;					
				when 'VL_OE_PL_DIO_ESF' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_pl_dio_esf_w;					
				when 'VL_OE_PL_DIO_CIL' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_pl_dio_cil_w;					
				when 'VL_OE_PL_EIXO' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_pl_eixo_w;					
				when 'VL_OE_PL_ADICAO' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_pl_adicao_w;					
				when 'VL_OD_PP_DIO_ESF' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_pp_dio_esf_w;					
				when 'VL_OD_PP_DIO_CIL' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_pp_dio_cil_w;					
				when 'VL_OD_PP_EIXO' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_pp_eixo_w;					
				when 'VL_OD_PP_ADICAO' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_pp_adicao_w;					
				when 'VL_OE_PP_DIO_ESF' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_pp_dio_esf_w;					
				when 'VL_OE_PP_DIO_CIL' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_pp_dio_cil_w;					
				when 'VL_OE_PP_EIXO' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_pp_eixo_w;					
				when 'VL_OE_PP_ADICAO' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_pp_adicao_w;					
				when 'VL_OD_PL_AV_SC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_pl_av_sc_w;					
				when 'VL_OD_PL_AV_CC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_pl_av_cc_w;					
				when 'VL_OE_PL_AV_SC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_pl_av_sc_w;					
				when 'VL_OE_PL_AV_CC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_pl_av_cc_w;					
				when 'VL_OD_PL_COR_SC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_pl_cor_sc_w;					
				when 'VL_OD_PL_CON_SC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_pl_con_sc_w;					
				when 'VL_OD_PL_CON_CC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_pl_con_cc_w;					
				when 'VL_OE_PL_COR_SC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_pl_cor_sc_w;					
				when 'VL_OE_PL_CON_SC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_pl_con_sc_w;					
				when 'VL_OD_PP_CON_SC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_pp_con_sc_w;					
				when 'VL_OD_PP_COR_SC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_pp_cor_sc_w;					
				when 'VL_OD_PP_CON_CC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_pp_con_cc_w;					
				when 'VL_OE_PL_CON_CC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_pl_con_cc_w;					
				when 'VL_OD_PP_AV_CC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_pp_av_cc_w;					
				when 'VL_OE_PP_AV_SC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_pp_av_sc_w;					
				when 'VL_OE_PP_COR_SC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_pp_cor_sc_w;					
				when 'VL_OE_PP_CON_SC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_pp_con_sc_w;					
				when 'VL_OE_PP_AV_CC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_pp_av_cc_w;					
				when 'VL_OE_PP_CON_CC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_pp_con_cc_w;					
				when 'VL_OD_PP_AV_SC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_pp_av_sc_w;					
				when 'NR_SEQ_LENTE' then
					vListaCorrecaoAtual[i].nr_valor 	:= nr_seq_lente_w;					
				when 'QT_GRAU' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_grau_w;					
				when 'QT_GRAU_ESFERICO' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_grau_esferico_w;					
				when 'QT_GRAU_CILINDRICO' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_grau_cilindrico_w;					
				when 'QT_GRAU_LONGE' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_grau_longe_w;					
				when 'QT_EIXO' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_eixo_w;					
				when 'QT_ADICAO' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_adicao_w;					
				when 'VL_AV' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_av_w;					
				when 'QT_CURVA_BASE' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_curva_base_w;					
				when 'QT_CURVA_BASE_UM' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_curva_base_um_w;					
				when 'QT_CURVA_BASE_DOIS' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_curva_base_dois_w;					
				when 'QT_DIAMETRO' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_diametro_w;					
				when 'NR_SEQ_LENTE_OE' then
					vListaCorrecaoAtual[i].nr_valor 	:= nr_seq_lente_oe_w;					
				when 'QT_DIAMETRO_OE' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_diametro_oe_w;					
				when 'QT_GRAU_CILINDRICO_OE' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_grau_cilindrico_oe_w;					
				when 'QT_GRAU_OE' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_grau_oe_w;					
				when 'QT_EIXO_OE' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_eixo_oe_w;					
				when 'QT_ADICAO_OE' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_adicao_oe_w;					
				when 'QT_GRAU_LONGE_OE' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_grau_longe_oe_w;					
				when 'QT_CURVA_BASE_OE' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_curva_base_oe_w;					
				when 'QT_CURVA_BASE_DOIS_OE' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_curva_base_dois_oe_w;					
				when 'QT_CURVA_BASE_UM_OE' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_curva_base_um_oe_w;					
				when 'QT_GRAU_ESFERICO_OE' then
					vListaCorrecaoAtual[i].nr_valor 	:= qt_grau_esferico_oe_w;					
				when 'VL_AV_OE' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_av_oe_w;	
				when 'VL_OD_LENT_PL_ADIC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_lent_pl_adic_w;					
				when 'VL_OE_LENT_PL_ADIC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_lent_pl_adic_w;
				when 'VL_OD_AV_CC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_od_av_cc_w;
				when 'VL_OE_AV_CC' then
					vListaCorrecaoAtual[i].nr_valor 	:= vl_oe_av_cc_w;
				else
					null;	
			end case;	
		end if;	
	end;
	end loop;
end if;	

exception
when others then
	ds_erro_w	:= substr(sqlerrm,1,4000);
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE oft_obter_correcao_atual ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text, vListaCorrecaoAtual INOUT strRecTypeFormOft) FROM PUBLIC;
