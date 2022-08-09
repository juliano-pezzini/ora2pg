-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE agenda_pac_equip_before_post ( nr_seq_agenda_p bigint, cd_equipamento_p bigint, nr_seq_classif_equip_p bigint, nm_usuario_p text, ie_novo_reg_p text, ie_status_equipamento_p INOUT text, ds_erro_p INOUT text) AS $body$
DECLARE


ds_valor_parametro_w	varchar(255);
ds_valor_parametro2_w	varchar(255);
ds_erro_w		varchar(1000);
qt_retorno_w		bigint;


BEGIN
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then
	begin
	ds_valor_parametro_w := Obter_Param_Usuario(871, 457, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ds_valor_parametro_w);
	if (ds_valor_parametro_w = 'S') then
		begin
		select	count(*)
		into STRICT	qt_retorno_w
		from	agenda_pac_equip
		where	ie_origem_inf	= 'I'
		and	nr_seq_agenda	= nr_seq_agenda_p
		and	cd_equipamento	= cd_equipamento_p;
		if (qt_retorno_w > 0) then
			begin
			CALL wheb_mensagem_pck.exibir_mensagem_abort(183208,'DS_ERRO_P='|| obter_texto_tasy(70177, wheb_usuario_pck.get_nr_seq_idioma));
			end;
		end if;
		end;
	end if;
	ds_valor_parametro_w := Obter_Param_Usuario(871, 81, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ds_valor_parametro_w);
	if (ds_valor_parametro_w <> 'N') then
		begin
		ds_valor_parametro2_w := Obter_Param_Usuario(871, 100, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ds_valor_parametro2_w);
		if (ds_valor_parametro2_w = 'C') then
			begin
			ds_erro_w := obter_se_classif_equip_disp(
					nr_seq_agenda_p, nr_seq_classif_equip_p, ds_erro_w, nm_usuario_p, null, null, ie_novo_reg_p);
			end;
		elsif (ds_valor_parametro2_w = 'E') then
			begin
			ds_erro_w := obter_se_equip_disp_cirur(nr_seq_agenda_p, cd_equipamento_p, ds_erro_w, nm_usuario_p, null, null, ie_novo_reg_p);
			ie_status_equipamento_p := obter_status_equipamento(nr_seq_agenda_p, cd_equipamento_p, 'S');
			end;
		end if;
		if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
			ds_erro_p := ds_erro_w;
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
-- REVOKE ALL ON PROCEDURE agenda_pac_equip_before_post ( nr_seq_agenda_p bigint, cd_equipamento_p bigint, nr_seq_classif_equip_p bigint, nm_usuario_p text, ie_novo_reg_p text, ie_status_equipamento_p INOUT text, ds_erro_p INOUT text) FROM PUBLIC;
