-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gc_atualizar_final_cir_js ( nr_cirurgia_p bigint, dt_termino_p timestamp, dt_inicio_real_p timestamp, nr_atendimento_p bigint, ie_status_cirurgia_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ds_mensagem_p INOUT text ) AS $body$
DECLARE

		 
		 
ds_pergunta_w		varchar(255) := '';
gera_taxa_sala_cirurgica_w	varchar(1);
alterar_dt_participante_w	varchar(1);
alerta_exec_w		varchar(1);
ie_se_cirur_exec_w		varchar(1);


BEGIN 
 
gera_taxa_sala_cirurgica_w := obter_param_usuario(900, 136, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, gera_taxa_sala_cirurgica_w);
alterar_dt_participante_w := obter_param_usuario(900, 179, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, alterar_dt_participante_w);
alerta_exec_w := obter_param_usuario(900, 190, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, alerta_exec_w);
 
 
if (gera_taxa_sala_cirurgica_w = 'S') and (ie_status_cirurgia_p = '2') then 
	begin 
	CALL atualiza_taxa_sala_cirurgica(nr_atendimento_p,nr_cirurgia_p);	
	end;
end if;
 
if (alterar_dt_participante_w = 'S') then 
	begin 
	CALL alterar_dt_partic_cirurgia(nr_cirurgia_p,dt_termino_p,dt_inicio_real_p);
	end;
end if;
 
--ie_se_cirur_exec_w := obter_se_cirur_exec(nr_cirurgia_p); 
 
/*if	(alerta_exec_w = 'NP') and 
	(ie_se_cirur_exec_w = 'N') then 
	begin 
	WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(51628); 
	end; 
elsif	(alerta_exec_w = 'S') and 
	(ie_se_cirur_exec_w = 'N') then 
	begin 
	ds_mensagem_p := substr(obter_texto_tasy (51628, wheb_usuario_pck.get_nr_seq_idioma),1,255); 
	end; 
end if;*/
 
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gc_atualizar_final_cir_js ( nr_cirurgia_p bigint, dt_termino_p timestamp, dt_inicio_real_p timestamp, nr_atendimento_p bigint, ie_status_cirurgia_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ds_mensagem_p INOUT text ) FROM PUBLIC;

