-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gc_consiste_inic_cir_js ( nr_atendimento_wpac_p bigint, nr_atendimento_wlcb_p bigint, dt_entrada_p timestamp, dt_inicio_real_p timestamp, nr_sala_selecao_p text, nm_usuario_p text, cd_estabelecimento_p bigint ) AS $body$
DECLARE

		 
		 
ie_vinv_atend_alta_w		varchar(1);
dt_alta_w			timestamp;
qtd_min_perm_ant_ini_cir_w	bigint;
dt_entrada_minima_w		timestamp;
dt_inicio_minimo		timestamp;
	

BEGIN 
 
ie_vinv_atend_alta_w := obter_param_usuario(900, 50, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_vinv_atend_alta_w);
 
select	dt_alta 
into STRICT	dt_alta_w 
from	atendimento_paciente 
where	nr_atendimento = nr_atendimento_wlcb_p;
 
if (ie_vinv_atend_alta_w = 'N') and (dt_alta_w IS NOT NULL AND dt_alta_w::text <> '') then 
	begin 
	--(-20011, substr(obter_texto_tasy (54315, wheb_usuario_pck.get_nr_seq_idioma),1,255) || '#@#@'); 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(54315);
	end;
end if;
 
if (nr_atendimento_wpac_p > 0) and (nr_atendimento_wlcb_p <> nr_atendimento_wpac_p) then 
	begin 
	--(-20011, substr(obter_texto_tasy (54317, wheb_usuario_pck.get_nr_seq_idioma),1,255) || '#@#@'); 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(54317);
	end;
end if;
 
if (nr_atendimento_wlcb_p IS NOT NULL AND nr_atendimento_wlcb_p::text <> '') and (dt_entrada_p IS NOT NULL AND dt_entrada_p::text <> '') and (dt_inicio_real_p IS NOT NULL AND dt_inicio_real_p::text <> '') and (nr_sala_selecao_p IS NOT NULL AND nr_sala_selecao_p::text <> '') then 
	begin 
	 
	qtd_min_perm_ant_ini_cir_w := obter_param_usuario(900, 270, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, qtd_min_perm_ant_ini_cir_w);
	 
	if (qtd_min_perm_ant_ini_cir_w > 0) then 
		begin 
		dt_entrada_minima_w := dt_entrada_p + qtd_min_perm_ant_ini_cir_w/1440;
		dt_inicio_minimo := dt_inicio_real_p + qtd_min_perm_ant_ini_cir_w/1440;
		if (dt_entrada_minima_w < clock_timestamp()) then 
			begin 
			--(-20011, substr(obter_texto_tasy (54321, wheb_usuario_pck.get_nr_seq_idioma),1,255) || '#@#@');			 
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(54321);
			end;
		end if;
		if (dt_inicio_minimo < clock_timestamp()) then 
			begin 
			--(-20011, substr(obter_texto_tasy (54322, wheb_usuario_pck.get_nr_seq_idioma),1,255) || '#@#@');			 
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(54322);
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
-- REVOKE ALL ON PROCEDURE gc_consiste_inic_cir_js ( nr_atendimento_wpac_p bigint, nr_atendimento_wlcb_p bigint, dt_entrada_p timestamp, dt_inicio_real_p timestamp, nr_sala_selecao_p text, nm_usuario_p text, cd_estabelecimento_p bigint ) FROM PUBLIC;
