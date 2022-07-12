-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE bft_global_price_pck.insert_comp_material ( cd_composto_p text, cd_material_glo_p text, nm_usuario_p text) AS $body$
DECLARE

				
	ora2pg_rowcount int;
comp_material_global_w		comp_material_global%rowtype;
	nr_seq_w	bigint;
	
	
BEGIN
	update	comp_material_global
	set	cd_material_glo		=	cd_material_glo_p,
		nm_usuario			=	nm_usuario_p,
		dt_atualizacao		=	clock_timestamp()
	where	cd_composto		= 	cd_composto_p
	and 	cd_material_glo = cd_material_glo_p;
	
	GET DIAGNOSTICS ora2pg_rowcount = ROW_COUNT;

	
	if ( ora2pg_rowcount = 0) then
	
		select 	nextval('comp_material_global_seq')
		into STRICT	nr_seq_w
		;
	
		comp_material_global_w.nr_sequencia			:=	nr_seq_w;
		comp_material_global_w.cd_composto			:=	cd_composto_p;
		comp_material_global_w.cd_material_glo			:=	cd_material_glo_p;
		comp_material_global_w.dt_atualizacao			:=	clock_timestamp();
		comp_material_global_w.nm_usuario			:=	nm_usuario_p;
		comp_material_global_w.dt_atualizacao_nrec		:=	clock_timestamp();
		comp_material_global_w.nm_usuario_nrec			:=	nm_usuario_p;
		comp_material_global_w.ie_situacao			:=	'A';
	
		insert into comp_material_global values (comp_material_global_w.*);
	end if;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bft_global_price_pck.insert_comp_material ( cd_composto_p text, cd_material_glo_p text, nm_usuario_p text) FROM PUBLIC;
