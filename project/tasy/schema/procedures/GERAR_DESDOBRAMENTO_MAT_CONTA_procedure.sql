-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_desdobramento_mat_conta (nr_sequencia_p bigint, qt_item_p bigint, nm_usuario_p text) AS $body$
DECLARE

	 
nr_seq_gerada_w		bigint;
nr_seq_item_w		bigint;
qt_diferenca_w		double precision:=0;
qt_original_w		double precision:=0;
cd_convenio_w		integer;
	

BEGIN 
 
nr_seq_gerada_w := Duplicar_mat_paciente(nr_sequencia_p, nm_usuario_p, 'N', nr_seq_gerada_w);
	 
select 	coalesce(max(qt_material),0), 
	coalesce(max(cd_convenio),0) 
into STRICT	qt_original_w, 
	cd_convenio_w 
from 	material_atend_paciente 
where 	nr_sequencia = nr_sequencia_p;
 
qt_diferenca_w:= qt_original_w - qt_item_p;
 
update	material_atend_paciente 
set 	qt_material = qt_item_p, 
	nm_usuario = nm_usuario_p, 
	dt_atualizacao = clock_timestamp(), 
	ds_observacao = Wheb_mensagem_pck.get_Texto(305931) /*'Desdobramento Item -> Conta Paciente'*/
 
where 	nr_sequencia = nr_sequencia_p;
 
CALL atualiza_preco_material(nr_sequencia_p, nm_usuario_p);
 
update	material_atend_paciente 
set 	qt_material = qt_diferenca_w, 
	nm_usuario = nm_usuario_p, 
	dt_atualizacao = clock_timestamp(), 
	ds_observacao = Wheb_mensagem_pck.get_Texto(305931) /*'Desdobramento Item -> Conta Paciente'*/
 
where 	nr_sequencia = nr_seq_gerada_w;
 
CALL atualiza_preco_material(nr_seq_gerada_w, nm_usuario_p);
 
commit;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_desdobramento_mat_conta (nr_sequencia_p bigint, qt_item_p bigint, nm_usuario_p text) FROM PUBLIC;
