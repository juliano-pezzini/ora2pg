-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	--FIM DIC_OBJETOS DO OBJETO SCHEMATIC 
	 
	--COPIA ATRIBUTOS DA DIC_OBJETO_FILTRO 
CREATE OR REPLACE PROCEDURE convert_schematic_to_bo_pck.copy_dic_obj_filtro ( nr_seq_dic_obj_old_p bigint, nr_seq_dic_obj_new_p bigint) AS $body$
DECLARE

					 
	c01 CURSOR FOR 
	SELECT	a.* 
	from	dic_objeto_filtro a 
	where	a.nr_seq_objeto = nr_seq_dic_obj_old_p;
	
	c01_w	c01%rowtype;
	
	dic_objeto_filtro_w		dic_objeto_filtro%rowtype;
	nr_sequencia_w			dic_objeto_filtro.nr_sequencia%type;
	nr_seq_dic_objeto_new_w		dic_objeto_filtro.nr_seq_dic_objeto%type;
	vl_default_dic_obj_new_w	dic_objeto_filtro.vl_default_dic_obj%type;
	
	
BEGIN 
	 
	open C01;
	loop 
	fetch C01 into 
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	 
		select	* 
		into STRICT	dic_objeto_filtro_w 
		from	dic_objeto_filtro 
		where	nr_sequencia	= c01_w.nr_sequencia;
		 
		select	nextval('dic_objeto_filtro_seq') 
		into STRICT	nr_sequencia_w 
		;
		 
		dic_objeto_filtro_w.nr_sequencia	:= nr_sequencia_w;
		dic_objeto_filtro_w.nr_seq_objeto	:= nr_seq_dic_obj_new_p;
		dic_objeto_filtro_w.nm_usuario		:= current_setting('convert_schematic_to_bo_pck.nm_usuario_w')::usuario.nm_usuario%type;
		dic_objeto_filtro_w.nm_usuario_nrec	:= current_setting('convert_schematic_to_bo_pck.nm_usuario_w')::usuario.nm_usuario%type;
		dic_objeto_filtro_w.dt_atualizacao	:= clock_timestamp();
		dic_objeto_filtro_w.dt_atualizacao_nrec	:= clock_timestamp();
		if (c01_w.nr_seq_dic_objeto IS NOT NULL AND c01_w.nr_seq_dic_objeto::text <> '') then --sql de lookup, scripts 
			nr_seq_dic_objeto_new_w := convert_schematic_to_bo_pck.copy_dic_objeto(null, null, c01_w.nr_seq_dic_objeto, null, current_setting('convert_schematic_to_bo_pck.nr_seq_bo_w')::business_object.nr_sequencia%type, current_setting('convert_schematic_to_bo_pck.nm_usuario_w')::usuario.nm_usuario%type, nr_seq_dic_objeto_new_w);
			dic_objeto_filtro_w.nr_seq_dic_objeto	:= nr_seq_dic_objeto_new_w;
		end if;		
		if (c01_w.vl_default_dic_obj IS NOT NULL AND c01_w.vl_default_dic_obj::text <> '') then --sql de lookup, scripts 
			vl_default_dic_obj_new_w := convert_schematic_to_bo_pck.copy_dic_objeto(null, null, c01_w.vl_default_dic_obj, null, current_setting('convert_schematic_to_bo_pck.nr_seq_bo_w')::business_object.nr_sequencia%type, current_setting('convert_schematic_to_bo_pck.nm_usuario_w')::usuario.nm_usuario%type, vl_default_dic_obj_new_w);
			dic_objeto_filtro_w.vl_default_dic_obj	:= vl_default_dic_obj_new_w;
		end if;	
		 
		insert into dic_objeto_filtro values (dic_objeto_filtro_w.*);	
		 
		--copia os itens do corsis_fv, filtros multiselecao 
		if (c01_w.ie_componente = 'ADVF') and (c01_w.ds_opcoes IS NOT NULL AND c01_w.ds_opcoes::text <> '') then			 
			CALL convert_schematic_to_bo_pck.copy_filter_dimensions(nr_sequencia_w,c01_w.ds_opcoes);
		end if;
	 
	end loop;
	close C01;
		 
	end;
	--FIM COPIA ATRIBUTOS DA DIC_OBJETO_FILTRO 
 
	--COPIA OS ITENS DO CORSIS_FV, FILTROS MULTISELECAO 
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE convert_schematic_to_bo_pck.copy_dic_obj_filtro ( nr_seq_dic_obj_old_p bigint, nr_seq_dic_obj_new_p bigint) FROM PUBLIC;
