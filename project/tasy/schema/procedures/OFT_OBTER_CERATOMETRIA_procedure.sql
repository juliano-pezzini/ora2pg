-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE oft_obter_ceratometria ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text, vListaCeratometria INOUT strRecTypeFormOft) AS $body$
DECLARE


dt_exame_w							oft_cerastocopia.dt_registro%type;
ds_comentario_w					oft_cerastocopia.ds_comentario%type;
vl_od_eixo_ceratometria_w		oft_cerastocopia.vl_od_eixo_ceratometria%type;
vl_od_eixo_ceratometria_k2_w	oft_cerastocopia.vl_od_eixo_ceratometria_k2%type;
vl_od_ma_cu_ceratometria_w		oft_cerastocopia.vl_od_ma_cu_ceratometria%type;
vl_od_me_cu_ceratometria_w		oft_cerastocopia.vl_od_me_cu_ceratometria%type;
vl_oe_eixo_ceratometria_w		oft_cerastocopia.vl_oe_eixo_ceratometria%type;
vl_oe_eixo_ceratometria_k2_w	oft_cerastocopia.vl_oe_eixo_ceratometria_k2%type;
vl_oe_ma_cu_ceratometria_w		oft_cerastocopia.vl_oe_ma_cu_ceratometria%type;
vl_oe_me_cu_ceratometria_w		oft_cerastocopia.vl_oe_me_cu_ceratometria%type;
cd_profissional_w					oft_cerastocopia.cd_profissional%TYPE;
dt_liberacao_w						timestamp;
cd_estabelecimento_w				estabelecimento.cd_estabelecimento%type := wheb_usuario_pck.get_cd_estabelecimento;
nm_usuario_w						usuario.nm_usuario%type := wheb_usuario_pck.get_nm_usuario;
ds_erro_w							varchar(4000);

ceratometria_form CURSOR FOR
	SELECT	a.*
	from		oft_cerastocopia a,
				oft_consulta_formulario b
	where		a.nr_seq_consulta_form 	=	b.nr_sequencia
	and		a.nr_seq_consulta_form 	=	nr_seq_consulta_form_p
	and		a.nr_seq_consulta			=	nr_seq_consulta_p
	and		((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.nm_usuario = nm_usuario_w))
	and		((coalesce(a.dt_inativacao::text, '') = '') or (b.dt_inativacao IS NOT NULL AND b.dt_inativacao::text <> ''))
	order by dt_registro;

ceratometria_paciente CURSOR FOR
	SELECT	a.*
	from		oft_cerastocopia a,
				oft_consulta b
	where		a.nr_seq_consulta		=	b.nr_sequencia
	and		b.cd_pessoa_fisica	=	cd_pessoa_fisica_p
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and		coalesce(a.dt_inativacao::text, '') = ''
	and		b.nr_sequencia 		<> nr_seq_consulta_p
	order by dt_registro;

BEGIN
begin

if (coalesce(nr_seq_consulta_p,0) > 0) and (vListaCeratometria.count > 0) then
	if (ie_opcao_p = 'F') then
		FOR c_ceratometria IN ceratometria_form LOOP
			begin
			dt_exame_w							:=	c_ceratometria.dt_registro;
			ds_comentario_w					:=	c_ceratometria.ds_comentario;
			vl_od_eixo_ceratometria_w		:=	c_ceratometria.vl_od_eixo_ceratometria;
			vl_od_eixo_ceratometria_k2_w	:=	c_ceratometria.vl_od_eixo_ceratometria_k2;
			vl_od_ma_cu_ceratometria_w		:=	c_ceratometria.vl_od_ma_cu_ceratometria;
			vl_od_me_cu_ceratometria_w		:=	c_ceratometria.vl_od_me_cu_ceratometria;
			vl_oe_eixo_ceratometria_w		:=	c_ceratometria.vl_oe_eixo_ceratometria;
			vl_oe_eixo_ceratometria_k2_w	:=	c_ceratometria.vl_oe_eixo_ceratometria_k2;
			vl_oe_ma_cu_ceratometria_w		:=	c_ceratometria.vl_oe_ma_cu_ceratometria;
			vl_oe_me_cu_ceratometria_w		:=	c_ceratometria.vl_oe_me_cu_ceratometria;
			dt_liberacao_w						:=	c_ceratometria.dt_liberacao;
			cd_profissional_w					:=	c_ceratometria.cd_profissional;
			end;
		end loop;
	else
		FOR c_ceratometria IN ceratometria_paciente LOOP
			begin
			ds_comentario_w					:=	c_ceratometria.ds_comentario;
			vl_od_eixo_ceratometria_w		:=	c_ceratometria.vl_od_eixo_ceratometria;
			vl_od_eixo_ceratometria_k2_w	:=	c_ceratometria.vl_od_eixo_ceratometria_k2;
			vl_od_ma_cu_ceratometria_w		:=	c_ceratometria.vl_od_ma_cu_ceratometria;
			vl_od_me_cu_ceratometria_w		:=	c_ceratometria.vl_od_me_cu_ceratometria;
			vl_oe_eixo_ceratometria_w		:=	c_ceratometria.vl_oe_eixo_ceratometria;
			vl_oe_eixo_ceratometria_k2_w	:=	c_ceratometria.vl_oe_eixo_ceratometria_k2;
			vl_oe_ma_cu_ceratometria_w		:=	c_ceratometria.vl_oe_ma_cu_ceratometria;
			vl_oe_me_cu_ceratometria_w		:=	c_ceratometria.vl_oe_me_cu_ceratometria;
			cd_profissional_w					:=	obter_pf_usuario(nm_usuario_w,'C');
			dt_exame_w							:= clock_timestamp();
			end;
		end loop;
	end if;

	for i in 1..vListaCeratometria.count loop
		begin
		if (ie_opcao_p = 'F') or (vListaCeratometria[i].ie_obter_resultado = 'S') then
			vListaCeratometria[i].dt_liberacao	:= dt_liberacao_w;
			case upper(vListaCeratometria[i].nm_campo)
				WHEN 'CD_PROFISSIONAL' THEN
					vListaCeratometria[i].ds_valor	:= cd_profissional_w;
				when 'DT_REGISTRO' then
					vListaCeratometria[i].dt_valor	:= dt_exame_w;
				when 'DS_COMENTARIO' then
					vListaCeratometria[i].ds_valor	:=	ds_comentario_w;
				when 'VL_OD_EIXO_CERATOMETRIA' then
					vListaCeratometria[i].nr_valor	:=	vl_od_eixo_ceratometria_w;
				when 'VL_OD_EIXO_CERATOMETRIA_K2' then
					vListaCeratometria[i].nr_valor	:=	vl_od_eixo_ceratometria_k2_w;
				when 'VL_OD_MA_CU_CERATOMETRIA' then
					vListaCeratometria[i].nr_valor	:=	vl_od_ma_cu_ceratometria_w;
				when 'VL_OD_ME_CU_CERATOMETRIA' then
					vListaCeratometria[i].nr_valor	:=	vl_od_me_cu_ceratometria_w;
				when 'VL_OE_EIXO_CERATOMETRIA' then
					vListaCeratometria[i].nr_valor	:=	vl_oe_eixo_ceratometria_w;
				when 'VL_OE_EIXO_CERATOMETRIA_K2' then
					vListaCeratometria[i].nr_valor	:=	vl_oe_eixo_ceratometria_k2_w;
				when 'VL_OE_MA_CU_CERATOMETRIA' then
					vListaCeratometria[i].nr_valor	:=	vl_oe_ma_cu_ceratometria_w;
				when 'VL_OE_ME_CU_CERATOMETRIA' then
					vListaCeratometria[i].nr_valor	:=	vl_oe_me_cu_ceratometria_w;
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
-- REVOKE ALL ON PROCEDURE oft_obter_ceratometria ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text, vListaCeratometria INOUT strRecTypeFormOft) FROM PUBLIC;

