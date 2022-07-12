-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_path_schematic (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_obj_sup_w 		  bigint;
ds_path_object_w		  varchar(2000) := '';
ds_objeto_w				    varchar(255) := '';
ie_tipo_objeto_w		  objeto_schematic.ie_tipo_objeto%type;
ie_tipo_componente_w	objeto_schematic.ie_tipo_componente%type;


BEGIN

select	max(nr_sequencia)
into STRICT	  nr_seq_obj_sup_w
from	  objeto_schematic
where	  nr_sequencia = nr_sequencia_p;

while	(nr_seq_obj_sup_w IS NOT NULL AND nr_seq_obj_sup_w::text <> '') loop
	begin
		
		select	max(coalesce(obter_desc_expressao(CD_EXP_DESC_OBJ),ds_objeto)),
				    max(nr_seq_obj_sup),
				    max(ie_tipo_objeto),
				    max(ie_tipo_componente)
		into STRICT    ds_objeto_w,
				    nr_seq_obj_sup_w,
				    ie_tipo_objeto_w,
				    ie_tipo_componente_w
		from	  objeto_schematic
		where	  nr_sequencia = nr_seq_obj_sup_w;
		
		if (ie_tipo_objeto_w in ('IT', 'T', 'TVN')) then
			begin
			
			  ds_path_object_w	:= to_char(' -> ' || ds_objeto_w ||  ds_path_object_w || ' ');
				
			end;
		end if;
		
	end;	
end loop;	

return ds_path_object_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_path_schematic (nr_sequencia_p bigint) FROM PUBLIC;

