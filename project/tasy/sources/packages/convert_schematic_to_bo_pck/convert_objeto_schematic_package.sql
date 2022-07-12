-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

 
	--COPIA DO OBJETO_SCHEMATIC 
CREATE OR REPLACE PROCEDURE convert_schematic_to_bo_pck.convert_objeto_schematic (nr_seq_objeto_p bigint) AS $body$
DECLARE

 
	objeto_schematic_w	objeto_schematic%rowtype;
	nr_sequencia_w		objeto_schematic.nr_sequencia%type;
	nr_seq_dic_obj_new_w	dic_objeto.nr_sequencia%type;
	i			integer;

	
BEGIN 
 
	select	a.* 
	into STRICT	objeto_schematic_w 
	from	objeto_schematic a 
	where	a.nr_sequencia	= nr_seq_objeto_p;
 
	select	nextval('objeto_schematic_seq') 
	into STRICT	nr_sequencia_w 
	;
 
	objeto_schematic_w.nr_sequencia			:= nr_sequencia_w;
	objeto_schematic_w.id_objeto			:= nr_sequencia_w; --Verificar como gravar um id automatico e não a sequencia	 
	objeto_schematic_w.nr_seq_bo			:= current_setting('convert_schematic_to_bo_pck.nr_seq_bo_w')::business_object.nr_sequencia%type;
	objeto_schematic_w.nr_seq_funcao_schematic	:= null;
	objeto_schematic_w.nr_seq_dic_panel		:= null;
	objeto_schematic_w.cd_funcao			:= null;
	objeto_schematic_w.nm_usuario			:= current_setting('convert_schematic_to_bo_pck.nm_usuario_w')::usuario.nm_usuario%type;
	objeto_schematic_w.nm_usuario_nrec		:= current_setting('convert_schematic_to_bo_pck.nm_usuario_w')::usuario.nm_usuario%type;
	objeto_schematic_w.dt_atualizacao		:= clock_timestamp();
	objeto_schematic_w.dt_atualizacao_nrec		:= clock_timestamp();
	if (objeto_schematic_w.nr_seq_obj_sup IS NOT NULL AND objeto_schematic_w.nr_seq_obj_sup::text <> '') then 
		objeto_schematic_w.nr_seq_obj_sup	:= convert_schematic_to_bo_pck.get_seq_obj_new(objeto_schematic_w.nr_seq_obj_sup);
	end if;	
 
	insert into objeto_schematic values (objeto_schematic_w.*);
 
	i	:= current_setting('convert_schematic_to_bo_pck.array_obj_sche_cp_w')::obj_sche_cp.Count + 1;
	current_setting('convert_schematic_to_bo_pck.array_obj_sche_cp_w')::obj_sche_cp[i].nr_seq_obj_old	:= nr_seq_objeto_p;
	current_setting('convert_schematic_to_bo_pck.array_obj_sche_cp_w')::obj_sche_cp[i].nr_seq_obj_new	:= nr_sequencia_w;
	 
	if (objeto_schematic_w.nr_seq_dic_objeto IS NOT NULL AND objeto_schematic_w.nr_seq_dic_objeto::text <> '') then 
		nr_seq_dic_obj_new_w := convert_schematic_to_bo_pck.copy_dic_objeto(nr_seq_objeto_p, nr_sequencia_w, objeto_schematic_w.nr_seq_dic_objeto, null, current_setting('convert_schematic_to_bo_pck.nr_seq_bo_w')::business_object.nr_sequencia%type, current_setting('convert_schematic_to_bo_pck.nm_usuario_w')::usuario.nm_usuario%type, nr_seq_dic_obj_new_w);
		 
		update	objeto_schematic 
		set	nr_seq_dic_objeto 	= nr_seq_dic_obj_new_w 
		where	nr_sequencia		= nr_sequencia_w;
	end if;
 
	CALL convert_schematic_to_bo_pck.copy_obj_schematic_prop( nr_seq_objeto_p,nr_sequencia_w);
	CALL convert_schematic_to_bo_pck.copy_obj_schematic_ativ( nr_seq_objeto_p,nr_sequencia_w, null, null);
	CALL convert_schematic_to_bo_pck.copy_schematic_relatorio( nr_seq_objeto_p,nr_sequencia_w);
	CALL convert_schematic_to_bo_pck.copy_crud_rules( nr_seq_objeto_p,nr_sequencia_w);
	CALL convert_schematic_to_bo_pck.copy_schematic_legenda( nr_seq_objeto_p,nr_sequencia_w);
	 
	if (objeto_schematic_w.ie_tipo_objeto = 'BTN') then 
		CALL convert_schematic_to_bo_pck.copy_obj_schematic_evento(nr_seq_objeto_p, nr_sequencia_w, null, null);
	end if;
 
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE convert_schematic_to_bo_pck.convert_objeto_schematic (nr_seq_objeto_p bigint) FROM PUBLIC;
