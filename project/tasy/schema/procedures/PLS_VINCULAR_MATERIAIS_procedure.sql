-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_vincular_materiais ( ds_materiais_p text, ie_tipo_despesa_p text, nr_seq_estrut_mat_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_material_w			varchar(1000);	/* Conjunto de identificadores  */
ie_pos_virgula_w			smallint;	/* posicao da virgula */
tam_lista_w			bigint;	/* tamanha da lista de identificadores */
cd_material_w			bigint;	/* identificador atual */
nr_controle_loop_w			smallint := 0;	/* controle do loop */
BEGIN
if (ds_materiais_p IS NOT NULL AND ds_materiais_p::text <> '') then
	begin
	ds_material_w := ds_materiais_p;

	while(ds_material_w IS NOT NULL AND ds_material_w::text <> '') and (nr_controle_loop_w < 100) loop
		begin
		tam_lista_w	:= length(ds_material_w);
		ie_pos_virgula_w	:= position(',' in ds_material_w);
		cd_material_w	:= 0;

		if (ie_pos_virgula_w <> 0) then
			begin
			cd_material_w	:= (substr(ds_material_w,1,(ie_pos_virgula_w - 1)))::numeric;
			ds_material_w	:= substr(ds_material_w,(ie_pos_virgula_w + 1),tam_lista_w);
			end;
		else
			begin
			cd_material_w	:= (ds_material_w)::numeric;
			ds_material_w	:= null;
			end;
		end if;

		if (coalesce(cd_material_w,0) > 0) then
			begin
			CALL pls_vincular_material(cd_material_w, ie_tipo_despesa_p, nr_seq_estrut_mat_p, cd_estabelecimento_p, nm_usuario_p);
			end;
		end if;

		nr_controle_loop_w := nr_controle_loop_w + 1;
		end;
	end loop;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_vincular_materiais ( ds_materiais_p text, ie_tipo_despesa_p text, nr_seq_estrut_mat_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

