-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cm_gerar_conjunto_item ( nr_seq_item_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nm_item_w		varchar(255);
nr_seq_interno_w		bigint;
nr_seq_conjunto_w	bigint;
nr_seq_int_item_w		bigint;
nr_seq_embalagem_w	bigint;
nr_seq_classif_conj_w	bigint;
cd_medico_w		varchar(10);
ds_lista_classif_medico_w	varchar(255);
ie_nome_med_conj_w	varchar(1);


BEGIN 
 
select	nm_item, 
	nr_seq_embalagem, 
	nr_seq_classif_conj, 
	cd_medico 
into STRICT	nm_item_w, 
	nr_seq_embalagem_w, 
	nr_seq_classif_conj_w, 
	cd_medico_w 
from	cm_item 
where	nr_sequencia = nr_seq_item_p;
 
select	coalesce(max(nr_seq_interno),0) + 1 
into STRICT	nr_seq_interno_w 
from	cm_conjunto 
where	nr_seq_classif = nr_seq_classif_conj_w;
	 
select	nextval('cm_conjunto_seq') 
into STRICT	nr_seq_conjunto_w
;
 
ds_lista_classif_medico_w := obter_valor_param_usuario(406,104, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);
 
if (ds_lista_classif_medico_w IS NOT NULL AND ds_lista_classif_medico_w::text <> '') and (coalesce(cd_medico_w,'X') <> 'X') then 
	begin 
 
	ds_lista_classif_medico_w	:=	replace(replace(ds_lista_classif_medico_w,';',','),' ','');
	 
	select	substr(obter_se_contido(nr_seq_classif_conj_w,ds_lista_classif_medico_w),1,1) 
	into STRICT	ie_nome_med_conj_w 
	;
 
	if (ie_nome_med_conj_w = 'S') then 
		nm_item_w	:= substr(obter_nome_medico(cd_medico_w,'N') || ' - ' || nm_item_w,1,255);
	end if;
 
	end;
end if;
 
insert into cm_conjunto( 
	nr_sequencia, 
	nm_conjunto, 
	nr_seq_classif, 
	dt_atualizacao, 
	nm_usuario, 
	ie_situacao, 
	nr_seq_embalagem, 
	cd_estabelecimento, 
	qt_ponto, 
	ie_agendamento, 
	nr_seq_interno, 
	cd_medico, 
	ie_reserva, 
	ie_gerar_conj_auto) 
values (	nr_seq_conjunto_w, 
	nm_item_w, 
	nr_seq_classif_conj_w, 
	clock_timestamp(), 
	nm_usuario_p, 
	'A', 
	nr_seq_embalagem_w, 
	cd_estabelecimento_p, 
	1, 
	'S', 
	nr_seq_interno_w, 
	cd_medico_w, 
	'N', 
	'S');
 
select	coalesce(max(nr_seq_interno),0) + 1 
into STRICT	nr_seq_int_item_w 
from	cm_conjunto_item;
 
insert into cm_conjunto_item( 
	nr_seq_conjunto, 
	nr_seq_item, 
	qt_item, 
	dt_atualizacao, 
	nm_usuario, 
	nr_seq_interno, 
	ie_indispensavel) 
values (	nr_seq_conjunto_w, 
	nr_seq_item_p, 
	1, 
	clock_timestamp(), 
	nm_usuario_p, 
	nr_seq_int_item_w, 
	'N');
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cm_gerar_conjunto_item ( nr_seq_item_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
