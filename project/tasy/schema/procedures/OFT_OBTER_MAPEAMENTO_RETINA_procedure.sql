-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE oft_obter_mapeamento_retina ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text, vListaMapeamentoRetina INOUT strRecTypeFormOft) AS $body$
DECLARE


dt_exame_w						oft_mapeamento_retina.dt_registro%type;
ds_observacao_w				oft_mapeamento_retina.ds_observacao%type;
ie_normal_od_w					oft_mapeamento_retina.ie_normal_od%type;
ie_normal_oe_w					oft_mapeamento_retina.ie_normal_oe%type;
ds_vitreo_od_w					oft_mapeamento_retina.ds_vitreo_od%type;
ds_vitreo_oe_w					oft_mapeamento_retina.ds_vitreo_oe%type;	
ds_papila_od_w					oft_mapeamento_retina.ds_papila_od%type;
ds_vasos_od_w					oft_mapeamento_retina.ds_vasos_od%type;
ds_papila_oe_w					oft_mapeamento_retina.ds_papila_oe%type;
ds_vasos_oe_w					oft_mapeamento_retina.ds_vasos_oe%type;		
ds_macula_od_w					oft_mapeamento_retina.ds_macula_od%type;
ds_macula_oe_w					oft_mapeamento_retina.ds_macula_oe%type;
ds_retina_posterior_od_w	oft_mapeamento_retina.ds_retina_posterior_od%type;
ds_retina_posterior_oe_w	oft_mapeamento_retina.ds_retina_posterior_oe%type;
ds_retina_periferica_od_w	oft_mapeamento_retina.ds_retina_periferica_od%type;
ds_retina_periferica_oe_w	oft_mapeamento_retina.ds_retina_periferica_oe%type;
ds_observacao_od_w			oft_mapeamento_retina.ds_observacao_od%type;
ds_observacao_oe_w			oft_mapeamento_retina.ds_observacao_oe%type;
cd_profissional_w				oft_mapeamento_retina.cd_profissional%TYPE;
ds_nervo_optico_od_w        oft_mapeamento_retina.ds_nervo_optico_od%type;
ds_nervo_optico_oe_w        oft_mapeamento_retina.ds_nervo_optico_oe%type;
ds_copa_disco_od_w          oft_mapeamento_retina.ds_copa_disco_od%type;
ds_copa_disco_oe_w          oft_mapeamento_retina.ds_copa_disco_oe%type;
dt_liberacao_w					timestamp;
cd_estabelecimento_w			estabelecimento.cd_estabelecimento%type := wheb_usuario_pck.get_cd_estabelecimento;
nm_usuario_w					usuario.nm_usuario%type := wheb_usuario_pck.get_nm_usuario;
ds_erro_w						varchar(4000);

mapeamento_retina_form CURSOR FOR
	SELECT	a.*
	from		oft_mapeamento_retina a,
				oft_consulta_formulario b
	where		a.nr_seq_consulta_form 	=	b.nr_sequencia
	and		a.nr_seq_consulta_form 	=	nr_seq_consulta_form_p
	and		a.nr_seq_consulta			=	nr_seq_consulta_p
	and		((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.nm_usuario = nm_usuario_w))
	and		((coalesce(a.dt_inativacao::text, '') = '') or (b.dt_inativacao IS NOT NULL AND b.dt_inativacao::text <> ''))
	order by dt_registro;

mapeamento_retina_paciente CURSOR FOR
	SELECT	a.*
	from		oft_mapeamento_retina a,
				oft_consulta b
	where		a.nr_seq_consulta		=	b.nr_sequencia
	and		b.cd_pessoa_fisica	=	cd_pessoa_fisica_p
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and		coalesce(a.dt_inativacao::text, '') = ''
	and		b.nr_sequencia 		<> nr_seq_consulta_p
	order by dt_registro;
											
BEGIN
begin

if (coalesce(nr_seq_consulta_p,0) > 0) and (vListaMapeamentoRetina.count > 0) then
	if (ie_opcao_p = 'F') then
		FOR c_mapeamento_retina IN mapeamento_retina_form LOOP
			begin
			dt_exame_w						:= c_mapeamento_retina.dt_registro;
			ds_observacao_w				:= c_mapeamento_retina.ds_observacao;
			ie_normal_od_w					:= c_mapeamento_retina.ie_normal_od;
			ie_normal_oe_w					:= c_mapeamento_retina.ie_normal_oe;
			ds_vitreo_od_w					:= c_mapeamento_retina.ds_vitreo_od;
			ds_vitreo_oe_w					:= c_mapeamento_retina.ds_vitreo_oe;	
			ds_papila_od_w					:= c_mapeamento_retina.ds_papila_od;
			ds_vasos_od_w					:= c_mapeamento_retina.ds_vasos_od;
			ds_papila_oe_w					:= c_mapeamento_retina.ds_papila_oe;
			ds_vasos_oe_w					:= c_mapeamento_retina.ds_vasos_oe;		
			ds_macula_od_w					:= c_mapeamento_retina.ds_macula_od;
			ds_macula_oe_w					:= c_mapeamento_retina.ds_macula_oe;
			ds_retina_posterior_od_w	:= c_mapeamento_retina.ds_retina_posterior_od;
			ds_retina_posterior_oe_w	:= c_mapeamento_retina.ds_retina_posterior_oe;
			ds_retina_periferica_od_w	:= c_mapeamento_retina.ds_retina_periferica_od;
			ds_retina_periferica_oe_w	:= c_mapeamento_retina.ds_retina_periferica_oe;
			ds_observacao_od_w			:= c_mapeamento_retina.ds_observacao_od;
			ds_observacao_oe_w			:= c_mapeamento_retina.ds_observacao_oe;
      ds_nervo_optico_od_w        := c_mapeamento_retina.ds_nervo_optico_od;
      ds_nervo_optico_oe_w        := c_mapeamento_retina.ds_nervo_optico_oe;
      ds_copa_disco_od_w          := c_mapeamento_retina.ds_copa_disco_od;
      ds_copa_disco_oe_w          := c_mapeamento_retina.ds_copa_disco_oe;
			dt_liberacao_w				:=	c_mapeamento_retina.dt_liberacao;
			dt_liberacao_w					:=	c_mapeamento_retina.dt_liberacao;
			cd_profissional_w				:=	c_mapeamento_retina.cd_profissional;
			end;
		end loop;	
	else
		FOR c_mapeamento_retina IN mapeamento_retina_paciente LOOP
			begin
			ds_observacao_w				:= c_mapeamento_retina.ds_observacao;
			ie_normal_od_w					:= c_mapeamento_retina.ie_normal_od;
			ie_normal_oe_w					:= c_mapeamento_retina.ie_normal_oe;
			ds_vitreo_od_w					:= c_mapeamento_retina.ds_vitreo_od;
			ds_vitreo_oe_w					:= c_mapeamento_retina.ds_vitreo_oe;	
			ds_papila_od_w					:= c_mapeamento_retina.ds_papila_od;
			ds_vasos_od_w					:= c_mapeamento_retina.ds_vasos_od;
			ds_papila_oe_w					:= c_mapeamento_retina.ds_papila_oe;
			ds_vasos_oe_w					:= c_mapeamento_retina.ds_vasos_oe;		
			ds_macula_od_w					:= c_mapeamento_retina.ds_macula_od;
			ds_macula_oe_w					:= c_mapeamento_retina.ds_macula_oe;
			ds_retina_posterior_od_w	:= c_mapeamento_retina.ds_retina_posterior_od;
			ds_retina_posterior_oe_w	:= c_mapeamento_retina.ds_retina_posterior_oe;
			ds_retina_periferica_od_w	:= c_mapeamento_retina.ds_retina_periferica_od;
			ds_retina_periferica_oe_w	:= c_mapeamento_retina.ds_retina_periferica_oe;
			ds_observacao_od_w			:= c_mapeamento_retina.ds_observacao_od;
			ds_observacao_oe_w			:= c_mapeamento_retina.ds_observacao_oe;
      ds_nervo_optico_od_w        := c_mapeamento_retina.ds_nervo_optico_od;
      ds_nervo_optico_oe_w        := c_mapeamento_retina.ds_nervo_optico_oe;
      ds_copa_disco_od_w          := c_mapeamento_retina.ds_copa_disco_od;
      ds_copa_disco_oe_w          := c_mapeamento_retina.ds_copa_disco_oe;
			cd_profissional_w				:=	obter_pf_usuario(nm_usuario_w,'C');
			dt_exame_w						:= clock_timestamp();
			end;
		end loop;	
	end if;

	for i in 1..vListaMapeamentoRetina.count loop
		begin
		if (ie_opcao_p = 'F') or (vListaMapeamentoRetina[i].ie_obter_resultado = 'S') then
			vListaMapeamentoRetina[i].dt_liberacao	:= dt_liberacao_w;
			case upper(vListaMapeamentoRetina[i].nm_campo)
				WHEN 'CD_PROFISSIONAL' THEN
					vListaMapeamentoRetina[i].ds_valor	:= cd_profissional_w;
				when 'DT_REGISTRO' then
					vListaMapeamentoRetina[i].dt_valor	:= dt_exame_w;
				when 'DS_OBSERVACAO' then
					vListaMapeamentoRetina[i].ds_valor	:= ds_observacao_w;
				when 'IE_NORMAL_OD' then
					vListaMapeamentoRetina[i].ds_valor	:= ie_normal_od_w;
				when 'IE_NORMAL_OE' then
					vListaMapeamentoRetina[i].ds_valor	:= ie_normal_oe_w;
				when 'DS_VITREO_OD' then
					vListaMapeamentoRetina[i].ds_valor	:= ds_vitreo_od_w;
				when 'DS_VITREO_OE' then
					vListaMapeamentoRetina[i].ds_valor	:= ds_vitreo_oe_w;
				when 'DS_PAPILA_OD' then
					vListaMapeamentoRetina[i].ds_valor	:= ds_papila_od_w;
				when 'DS_VASOS_OD' then
					vListaMapeamentoRetina[i].ds_valor	:= ds_vasos_od_w;
				when 'DS_PAPILA_OE' then
					vListaMapeamentoRetina[i].ds_valor	:= ds_papila_oe_w;
				when 'DS_VASOS_OE' then
					vListaMapeamentoRetina[i].ds_valor	:= ds_vasos_oe_w;
				when 'DS_MACULA_OD' then
					vListaMapeamentoRetina[i].ds_valor	:= ds_macula_od_w;
				when 'DS_MACULA_OE' then
					vListaMapeamentoRetina[i].ds_valor	:= ds_macula_oe_w;
				when 'DS_RETINA_POSTERIOR_OD' then
					vListaMapeamentoRetina[i].ds_valor	:= ds_retina_posterior_od_w;
				when 'DS_RETINA_POSTERIOR_OE' then
					vListaMapeamentoRetina[i].ds_valor	:= ds_retina_posterior_oe_w;
				when 'DS_RETINA_PERIFERICA_OD' then
					vListaMapeamentoRetina[i].ds_valor	:= ds_retina_periferica_od_w;
				when 'DS_RETINA_PERIFERICA_OE' then
					vListaMapeamentoRetina[i].ds_valor	:= ds_retina_periferica_oe_w;
				when 'DS_OBSERVACAO_OD' then
					vListaMapeamentoRetina[i].ds_valor	:= ds_observacao_od_w;
				when 'DS_OBSERVACAO_OE' then
					vListaMapeamentoRetina[i].ds_valor	:= ds_observacao_oe_w;
        when 'DS_NERVO_OPTICO_OD' then
          vListaMapeamentoRetina[i].ds_valor	:= ds_nervo_optico_od_w;
        when 'DS_NERVO_OPTICO_OE' then            
            vListaMapeamentoRetina[i].ds_valor	:= ds_nervo_optico_oe_w;
        when 'DS_COPA_DISCO_OD' then            
            vListaMapeamentoRetina[i].ds_valor	:= ds_copa_disco_od_w;
        when 'DS_COPA_DISCO_OE' then            
            vListaMapeamentoRetina[i].ds_valor	:= ds_copa_disco_oe_w;
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
-- REVOKE ALL ON PROCEDURE oft_obter_mapeamento_retina ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text, vListaMapeamentoRetina INOUT strRecTypeFormOft) FROM PUBLIC;

