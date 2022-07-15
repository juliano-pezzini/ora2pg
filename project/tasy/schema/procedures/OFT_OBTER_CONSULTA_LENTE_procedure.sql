-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE oft_obter_consulta_lente ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text, vListaConsultaLente INOUT strRecTypeFormOft) AS $body$
DECLARE


dt_exame_w					oft_consulta_lente.dt_registro%type;
ds_observacao_w			oft_consulta_lente.ds_observacao%type;
qt_grau_esferico_w		oft_consulta_lente.qt_grau_esferico%type;
qt_eixo_w					oft_consulta_lente.qt_eixo%type;
qt_grau_cilindrico_w		oft_consulta_lente.qt_grau_cilindrico%type;
qt_adicao_w					oft_consulta_lente.qt_adicao%type;
nr_seq_lente_w				oft_consulta_lente.nr_seq_lente%type;
qt_grau_longe_w			oft_consulta_lente.qt_grau_longe%type;
ie_lado_w					oft_consulta_lente.ie_lado%type;
qt_grau_w					oft_consulta_lente.qt_grau%type;
cd_profissional_w			oft_consulta_lente.cd_profissional%TYPE;
dt_liberacao_w				timestamp;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type := wheb_usuario_pck.get_cd_estabelecimento;
nm_usuario_w				usuario.nm_usuario%type := wheb_usuario_pck.get_nm_usuario;
ds_erro_w					varchar(4000);

consulta_lente_form CURSOR FOR
	SELECT	a.*
	from		oft_consulta_lente a,
				oft_consulta_formulario b
	where		a.nr_seq_consulta_form 	=	b.nr_sequencia
	and		a.nr_seq_consulta_form 	=	nr_seq_consulta_form_p
	and		a.nr_seq_consulta			=	nr_seq_consulta_p
	and		((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.nm_usuario = nm_usuario_w))
	and		((coalesce(a.dt_inativacao::text, '') = '') or (b.dt_inativacao IS NOT NULL AND b.dt_inativacao::text <> ''))
	order by dt_registro;

consulta_lente_paciente CURSOR FOR
	SELECT	a.*
	from		oft_consulta_lente a,
				oft_consulta b
	where		a.nr_seq_consulta		=	b.nr_sequencia
	and		b.cd_pessoa_fisica	=	cd_pessoa_fisica_p
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and		coalesce(a.dt_inativacao::text, '') = ''
	and		b.nr_sequencia 		<> nr_seq_consulta_p
	order by dt_registro;
BEGIN
begin

if (coalesce(nr_seq_consulta_p,0) > 0) and (vListaConsultaLente.count > 0) then
	if (ie_opcao_p = 'F') then
		FOR c_consulta_lente IN consulta_lente_form LOOP
			begin
			dt_exame_w					:= c_consulta_lente.dt_registro;
			ds_observacao_w			:= c_consulta_lente.ds_observacao;
			qt_grau_esferico_w		:= c_consulta_lente.qt_grau_esferico;
			qt_eixo_w					:= c_consulta_lente.qt_eixo;
			qt_grau_cilindrico_w		:= c_consulta_lente.qt_grau_cilindrico;
			qt_adicao_w					:= c_consulta_lente.qt_adicao;
			nr_seq_lente_w				:= c_consulta_lente.nr_seq_lente;
			qt_grau_longe_w			:= c_consulta_lente.qt_grau_longe;
			ie_lado_w					:= c_consulta_lente.ie_lado;
			qt_grau_w					:= c_consulta_lente.qt_grau;
			dt_liberacao_w				:=	c_consulta_lente.dt_liberacao;
			cd_profissional_w			:=	c_consulta_lente.cd_profissional;
			end;
		end loop;
	else
		FOR c_consulta_lente IN consulta_lente_paciente LOOP
			begin
			ds_observacao_w			:= c_consulta_lente.ds_observacao;
			qt_grau_esferico_w		:= c_consulta_lente.qt_grau_esferico;
			qt_eixo_w					:= c_consulta_lente.qt_eixo;
			qt_grau_cilindrico_w		:= c_consulta_lente.qt_grau_cilindrico;
			qt_adicao_w					:= c_consulta_lente.qt_adicao;
			nr_seq_lente_w				:= c_consulta_lente.nr_seq_lente;
			qt_grau_longe_w			:= c_consulta_lente.qt_grau_longe;
			ie_lado_w					:= c_consulta_lente.ie_lado;
			qt_grau_w					:= c_consulta_lente.qt_grau;
			cd_profissional_w			:=	obter_pf_usuario(nm_usuario_w,'C');
			dt_exame_w					:= clock_timestamp();
			end;
		end loop;
	end if;

	for i in 1..vListaConsultaLente.count loop
		begin
		if (ie_opcao_p = 'F') or (vListaConsultaLente[i].ie_obter_resultado = 'S') then
			vListaConsultaLente[i].dt_liberacao	:= dt_liberacao_w;
			case upper(vListaConsultaLente[i].nm_campo)
				WHEN 'CD_PROFISSIONAL' THEN
					vListaConsultaLente[i].ds_valor	:= cd_profissional_w;
				when 'DT_REGISTRO' then
					vListaConsultaLente[i].dt_valor	:= dt_exame_w;
				when 'DS_OBSERVACAO' then
					vListaConsultaLente[i].ds_valor	:=	ds_observacao_w;
				when 'QT_GRAU_ESFERICO' then
					vListaConsultaLente[i].nr_valor	:=	qt_grau_esferico_w;
				when 'QT_EIXO' then
					vListaConsultaLente[i].nr_valor	:=	qt_eixo_w;
				when 'QT_GRAU_CILINDRICO' then
					vListaConsultaLente[i].nr_valor	:=	qt_grau_cilindrico_w;
				when 'QT_ADICAO' then
					vListaConsultaLente[i].nr_valor	:=	qt_adicao_w;
				when 'NR_SEQ_LENTE' then
					vListaConsultaLente[i].nr_valor	:=	nr_seq_lente_w;
				when 'QT_GRAU_LONGE' then
					vListaConsultaLente[i].nr_valor	:=	qt_grau_longe_w;
				when 'IE_LADO' then
					vListaConsultaLente[i].ds_valor	:=	ie_lado_w;
				when 'QT_GRAU' then
					vListaConsultaLente[i].nr_valor	:=	qt_grau_w;
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
-- REVOKE ALL ON PROCEDURE oft_obter_consulta_lente ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text, vListaConsultaLente INOUT strRecTypeFormOft) FROM PUBLIC;

