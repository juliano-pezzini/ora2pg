-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_recursos_agenda ( nr_seq_agenda_p bigint, lista_equip_p text, lista_cme_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
lista_equip_w		varchar(400);
lista_cme_w		varchar(400);
nr_seq_conjunto_w	bigint;
ie_contador_w		bigint	:= 0;
tam_lista_w		bigint;
ie_pos_virgula_w	smallint;
nr_sequencia_w		bigint;
cd_equipamento_w	bigint;
nr_seq_classif_equip_w	bigint;
ie_tipo_w		varchar(1);
ie_consiste_w		varchar(15);
ie_consiste_grid_w	varchar(1);
ds_erro_w		varchar(4000):=null;


BEGIN 
 
select	coalesce(max(obter_valor_param_usuario(871, 100, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)),'C') 
into STRICT	ie_tipo_w
;
 
ie_consiste_w := Obter_Param_Usuario(871, 81, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consiste_w);
ie_consiste_grid_w := Obter_Param_Usuario(871, 368, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consiste_grid_w);
 
cd_equipamento_w	:= null;
nr_seq_classif_equip_w	:= null;
 
if (lista_equip_p IS NOT NULL AND lista_equip_p::text <> '') then 
	lista_equip_w	:= lista_equip_p ||',';
end if;	
if (lista_cme_p IS NOT NULL AND lista_cme_p::text <> '') then 
	lista_cme_w	:= lista_cme_p ||',';
end if;
 
if (ie_tipo_w = 'E') and (ie_consiste_w <> 'N') then 
	while	(lista_equip_w IS NOT NULL AND lista_equip_w::text <> '') or 
		ie_contador_w > 200 loop 
		begin 
		tam_lista_w		:= length(lista_equip_w);
		ie_pos_virgula_w	:= position(',' in lista_equip_w);
		 
		 
 
		if (ie_pos_virgula_w <> 0) then 
			cd_equipamento_w	:= substr(lista_equip_w,1,(ie_pos_virgula_w - 1));
			lista_equip_w		:= substr(lista_equip_w,(ie_pos_virgula_w + 1),tam_lista_w);
		end if;
		 
		 
		 
		CALL obter_se_equip_disp_cir(nr_seq_agenda_p, cd_equipamento_w,nm_usuario_p, cd_estabelecimento_p,0,'S');
		ie_contador_w	:= ie_contador_w + 1;
		end;
	end loop;
end if;	
ie_contador_w := 0;
while	(lista_cme_w IS NOT NULL AND lista_cme_w::text <> '') or 
	ie_contador_w > 200 loop 
	begin 
	tam_lista_w		:= length(lista_cme_w);
	ie_pos_virgula_w	:= position(',' in lista_cme_w);
 
	if (ie_pos_virgula_w <> 0) then 
		begin 
		nr_seq_conjunto_w	:= substr(lista_cme_w,1,(ie_pos_virgula_w - 1));
		lista_cme_w		:= substr(lista_cme_w,(ie_pos_virgula_w + 1),tam_lista_w);
		end;
	end if;
	ds_erro_w := cme_consistir_conj_agenda(nr_seq_agenda_p, nr_seq_conjunto_w, 'N', nm_usuario_p, cd_estabelecimento_p, ds_erro_w);
	if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then 
		insert into	consistencia_agenda_cir(	nr_sequencia, 
								dt_atualizacao, 
								nm_usuario, 
								nr_seq_agenda, 
								ie_tipo_consistencia, 
								ds_consistencia, 
								nr_seq_conjunto) 
		values (	nextval('consistencia_agenda_cir_seq'), 
								clock_timestamp(), 
								nm_usuario_p, 
								nr_seq_agenda_p, 
								'C', 
								ds_erro_w, 
								nr_seq_conjunto_w);
		commit;
	end if;	
	ie_contador_w	:= ie_contador_w + 1;
	end;
end loop;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_recursos_agenda ( nr_seq_agenda_p bigint, lista_equip_p text, lista_cme_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

