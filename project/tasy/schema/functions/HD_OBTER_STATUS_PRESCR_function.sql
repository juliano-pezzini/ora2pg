-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_status_prescr (nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w			varchar(400);

dt_suspensao_w			timestamp;
dt_assinatura_w			timestamp;
ie_pendencia_assinatura_w	varchar(1);
nr_cirurgia_grid_w		bigint;
ie_emergencia_w			varchar(1);
ie_prescr_emergencia_w		varchar(1);
dt_liberacao_w			timestamp;
dt_liberacao_medico_w		timestamp;
ie_motivo_prescricao_w		varchar(3);
ie_hemodialise_w		varchar(1);
nr_seq_atend_w			bigint;
ie_prescr_farm_w		varchar(1);
dt_validade_prescr_w		timestamp;
dt_liberacao_farmacia_w		timestamp;
ie_lib_farm_w			varchar(1);
ie_recem_nato_w			varchar(1);
ie_prescricao_alta_w		varchar(1);
ds_cor_motivo_prescricao_w	varchar(40);
ie_origem_inf_w			varchar(1);
ie_funcao_prescritor_w		varchar(3);
nr_seq_sae_w			bigint;

tipo_ori_prescritor_w		varchar(2);
param_1153_w 			varchar(2);
legenda_cirurgia_w 		varchar(2);
destaca_rep_motivo_w 		varchar(2);
destacar_expiradas_w 		varchar(2);
legenda_libera_farmacia_w 	varchar(2);
destacar_prescricao_rn_w 	varchar(2);

C01 CURSOR FOR 
	SELECT	dt_suspensao, 
		obter_data_assinatura_digital(nr_seq_assinatura), 
		substr(obter_pendencia_assinatura(wheb_usuario_pck.get_nm_usuario,nr_prescricao,'PR'),1,1), 
		obter_cirurgia_prescricao(nr_prescricao), 
		ie_emergencia, 
		ie_prescr_emergencia, 
		dt_liberacao, 
		dt_liberacao_medico, 
		ie_motivo_prescricao, 
		ie_hemodialise, 
		nr_seq_atend, 
		ie_prescr_farm, 
		dt_validade_prescr, 
		dt_liberacao_farmacia, 
		ie_lib_farm, 
		ie_recem_nato, 
		ie_prescricao_alta, 
		substr((SELECT z.ds_expressao 
			from  valor_dominio_v z 
			where z.cd_dominio = 136 
			and z.ie_situacao = 'A' 
			and z.vl_dominio = ie_motivo_prescricao),1,40), 
		ie_origem_inf, 
		ie_funcao_prescritor, 
		substr(obter_sae_prescricao(nr_prescricao),1,80) 
	from	prescr_medica a 
	where	nr_prescricao = nr_prescricao_p;


BEGIN 
param_1153_w 		:= Obter_Valor_Param_Usuario(924, 1153, Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
legenda_cirurgia_w 	:= Obter_Valor_Param_Usuario(924, 589, Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
destaca_rep_motivo_w 	:= Obter_Valor_Param_Usuario(924, 1031, Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
destacar_expiradas_w 	:= Obter_Valor_Param_Usuario(924, 891, Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
legenda_libera_farmacia_w := Obter_Valor_Param_Usuario(924, 885, Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
destacar_prescricao_rn_w := Obter_Valor_Param_Usuario(924, 900, Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
 
open C01;
loop 
fetch C01 into	 
	dt_suspensao_w, 
	dt_assinatura_w, 
	ie_pendencia_assinatura_w, 
	nr_cirurgia_grid_w, 
	ie_emergencia_w, 
	ie_prescr_emergencia_w, 
	dt_liberacao_w, 
	dt_liberacao_medico_w, 
	ie_motivo_prescricao_w, 
	ie_hemodialise_w, 
	nr_seq_atend_w, 
	ie_prescr_farm_w, 
	dt_validade_prescr_w, 
	dt_liberacao_farmacia_w, 
	ie_lib_farm_w, 
	ie_recem_nato_w, 
	ie_prescricao_alta_w, 
	ds_cor_motivo_prescricao_w, 
	ie_origem_inf_w, 
	ie_funcao_prescritor_w, 
	nr_seq_sae_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	if (coalesce(dt_suspensao_w::text, '') = '') and (coalesce(dt_assinatura_w::text, '') = '') and (param_1153_w = 'S') and (ie_pendencia_assinatura_w = 'S') then 
		ds_retorno_w := wheb_mensagem_pck.get_texto(292295, null); -- 4324 - 'Pend assinatura' 
	elsif not(coalesce(dt_suspensao_w::text, '') = '')then
		ds_retorno_w := wheb_mensagem_pck.get_texto(292296, null); -- 864 - 'Suspensa' 
	elsif (not(coalesce(nr_cirurgia_grid_w::text, '') = '')) and (nr_cirurgia_grid_w <> 0) and (legenda_cirurgia_w = 'S') then
		ds_retorno_w := wheb_mensagem_pck.get_texto(292297, null); -- 1918 - 'Cirurgia' 
	elsif (ie_emergencia_w = 'S') or (ie_prescr_emergencia_w = 'S') then
		ds_retorno_w := wheb_mensagem_pck.get_texto(292298, null); -- 510 - 'Prescr de emergência' 
	elsif (coalesce(dt_liberacao_w::text, '') = '') then		
		ds_retorno_w := wheb_mensagem_pck.get_texto(292299, null); -- 241 - 'Aguarda lib enfer' 
		if (coalesce(dt_liberacao_medico_w::text, '') = '') then
			ds_retorno_w := wheb_mensagem_pck.get_texto(292300,null); -- 243 - 'Aguarda lib médico' 
		end if;		
	elsif (destaca_rep_motivo_w = 'S') and (not(coalesce(ie_motivo_prescricao_w::text, '') = '')) then 
		ds_retorno_w := wheb_mensagem_pck.get_texto(292301, null); -- 3927 - 'Motivo informado' 
	elsif (ie_hemodialise_w = 'E') or (ie_hemodialise_w = 'S') then
		ds_retorno_w := wheb_mensagem_pck.get_texto(292302, null); -- 2346 - 'Hemodiálise' 
	elsif (ie_hemodialise_w = 'A') then
		ds_retorno_w := wheb_mensagem_pck.get_texto(292303, null); -- 3775 - 'Alta UTI/CTI' 
	elsif (nr_seq_atend_w <> '') then
		ds_retorno_w := wheb_mensagem_pck.get_texto(292304, null); -- 2271 - 'Quimioterapia' 
	elsif (ie_prescr_farm_w = 'S') then
		ds_retorno_w := wheb_mensagem_pck.get_texto(292305, null); -- 2274 - 'Interv farm' 
	elsif (destacar_expiradas_w = 'S') and (not(coalesce(dt_validade_prescr_w::text, '') = '')) and (dt_validade_prescr_w < clock_timestamp()) then
		ds_retorno_w := wheb_mensagem_pck.get_texto(292306, null); -- 3127 - 'Expirada' 
	elsif (legenda_libera_farmacia_w = 'S') and (coalesce(dt_liberacao_farmacia_w::text, '') = '') and (ie_lib_farm_w = 'S') then
		ds_retorno_w := wheb_mensagem_pck.get_texto(292307, null); -- 461 - 'Aguarda lib farmácia' 
	elsif (destacar_prescricao_rn_w = 'S') and (ie_recem_nato_w = 'S') then
		ds_retorno_w := wheb_mensagem_pck.get_texto(292308, null); -- 3178 - 'Prescrição de RN' 
	elsif (ie_prescricao_alta_w = 'S') then
		ds_retorno_w := wheb_mensagem_pck.get_texto(292309, null); -- 367 - 'Prescrição de alta' 
	elsif (ds_cor_motivo_prescricao_w <> '') then
		ds_retorno_w := ds_cor_motivo_prescricao_w;
	elsif (not(coalesce(dt_liberacao_w::text, '') = '')) and (coalesce(dt_suspensao_w::text, '') = '') and (coalesce(nr_seq_atend_w::text, '') = '') and (ie_prescricao_alta_w <> 'S') and (ie_emergencia_w <> 'S') then 
		begin 
		select	coalesce(ie_tipo_ori_prescritor,'F') 
		into STRICT	tipo_ori_prescritor_w 
		from	parametro_medico 
		where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;
		 
		if (tipo_ori_prescritor_w = 'O') then 
			begin 
			if (ie_origem_inf_w = 1) then 
				ds_retorno_w := wheb_mensagem_pck.get_texto(292310, null); -- 4284 - 'Origem médico' 
			elsif (ie_origem_inf_w = 3) then
				ds_retorno_w := wheb_mensagem_pck.get_texto(292311, null); -- 4285 - 'Origem funcionário'			 
			end if;
			end;
		else 
			begin 
			if (ie_funcao_prescritor_w = 1) then 
				ds_retorno_w := wheb_mensagem_pck.get_texto(292310, null); -- 4284 - 'Origem médico' 
			elsif (ie_funcao_prescritor_w = 3) then
				ds_retorno_w := wheb_mensagem_pck.get_texto(292311, null); -- 4285 - 'Origem funcionário' 
			elsif (ie_funcao_prescritor_w = 4) then
				ds_retorno_w := wheb_mensagem_pck.get_texto(292312, null); -- 5075 - 'Origem nutricionista' 
			elsif (ie_funcao_prescritor_w = 10) then
				ds_retorno_w := wheb_mensagem_pck.get_texto(292313, null); -- 5076 - 'Origem fisioterapeuta' 
			end if;			
			end;
		end if;
		end;
	elsif (not(coalesce(nr_seq_sae_w::text, '') = '')) and (nr_seq_sae_w <> 0) then 
		ds_retorno_w := wheb_mensagem_pck.get_texto(292314, null); -- 4774 - 'SAE' 
	end if;					
	 
	end;
end loop;
close C01;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_status_prescr (nr_prescricao_p bigint) FROM PUBLIC;

