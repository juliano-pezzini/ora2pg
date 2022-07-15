-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ehro_dispensation ( nr_cirurgia_p bigint, nr_seq_pepo_p bigint, ie_gera_controle_p text, cd_material_p bigint, nr_seq_lote_fornec_p bigint, dt_validade_p timestamp, qt_material_controle_p bigint, qt_dispensacao_p bigint, cd_unid_med_p text, ie_origem_gasto_p text, nr_seq_agente_p bigint, ie_via_aplicacao_p text, cd_local_estoque_p bigint, nr_sequencia_p INOUT bigint, ds_just_alergico_p text default null) AS $body$
DECLARE

										
nm_usuario_w			varchar(15);
cd_estabelecimento_w		integer;
ie_opcao_w			varchar(15);
nr_sequencia_w			bigint;	


BEGIN
nm_usuario_w			:= wheb_usuario_pck.get_nm_usuario;
cd_estabelecimento_w		:= wheb_usuario_pck.get_cd_estabelecimento;

if (ie_gera_controle_p = 'S') then
	nr_sequencia_w := gerar_item_controle(nr_cirurgia_p, cd_material_p, nr_seq_lote_fornec_p, dt_validade_p, nm_usuario_w, nr_seq_pepo_p, qt_material_controle_p, nr_sequencia_w);
end if;

if (coalesce(nr_sequencia_w,0) > 0) then
	nr_sequencia_p	:= nr_sequencia_w;
end if;

if (ie_origem_gasto_p = 0) then
	ie_opcao_w	:= 'A';
elsif (ie_origem_gasto_p = 1) then
	ie_opcao_w	:= 'C';
elsif (ie_origem_gasto_p = 2) then
	ie_opcao_w	:= 'E';
elsif (ie_origem_gasto_p = 3) then
	ie_opcao_w	:= 'P';
end if;	
	
CALL grava_cirurgia_dispensacao(cd_material_p,cd_unid_med_p,qt_dispensacao_p,nr_cirurgia_p,nm_usuario_w,'D',null,null,nr_seq_lote_fornec_p,dt_validade_p,ie_origem_gasto_p,nr_seq_agente_p,'N',cd_local_estoque_p);
CALL gerar_medicamento_cod_barras(nr_cirurgia_p,cd_material_p,nm_usuario_w,cd_estabelecimento_w,nr_seq_agente_p,ie_via_aplicacao_p,nr_seq_pepo_p,ie_opcao_w,ds_just_alergico_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ehro_dispensation ( nr_cirurgia_p bigint, nr_seq_pepo_p bigint, ie_gera_controle_p text, cd_material_p bigint, nr_seq_lote_fornec_p bigint, dt_validade_p timestamp, qt_material_controle_p bigint, qt_dispensacao_p bigint, cd_unid_med_p text, ie_origem_gasto_p text, nr_seq_agente_p bigint, ie_via_aplicacao_p text, cd_local_estoque_p bigint, nr_sequencia_p INOUT bigint, ds_just_alergico_p text default null) FROM PUBLIC;

