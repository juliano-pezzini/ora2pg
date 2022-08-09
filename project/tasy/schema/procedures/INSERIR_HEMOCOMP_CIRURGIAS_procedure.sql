-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_hemocomp_cirurgias ( ds_lista_proc_interno_p text, nr_prescricao_p bigint, nr_seq_solic_sangue_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ds_lista_proc_interno_w	varchar(2000);
nr_pos_virgula_w	bigint;
nr_seq_proc_interno_w	bigint;		

BEGIN 
if (ds_lista_proc_interno_p IS NOT NULL AND ds_lista_proc_interno_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solic_sangue_p IS NOT NULL AND nr_seq_solic_sangue_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
	ds_lista_proc_interno_w	:= ds_lista_proc_interno_p;
	 
	while(ds_lista_proc_interno_w IS NOT NULL AND ds_lista_proc_interno_w::text <> '') loop 
		begin 
		nr_pos_virgula_w	:= position(',' in ds_lista_proc_interno_w);
		if (nr_pos_virgula_w > 0) then 
			begin 
			nr_seq_proc_interno_w		:= substr(ds_lista_proc_interno_w,0,nr_pos_virgula_w-1);
			ds_lista_proc_interno_w	:= substr(ds_lista_proc_interno_w,nr_pos_virgula_w+1,length(ds_lista_proc_interno_w));			
			end;
		else 
			begin 
			nr_seq_proc_interno_w		:= (ds_lista_proc_interno_w)::numeric;
			ds_lista_proc_interno_w	:= null;
			end;
		end if;	
		 
		if (coalesce(nr_seq_proc_interno_w,0) > 0) then 
			begin			 
			CALL inserir_hemocomp_cirurgia( 
				nr_seq_proc_interno_w, 
				nr_prescricao_p, 
				nr_seq_solic_sangue_p, 
				wheb_usuario_pck.get_cd_perfil, 
				nm_usuario_p);
			end;
		end if;
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
-- REVOKE ALL ON PROCEDURE inserir_hemocomp_cirurgias ( ds_lista_proc_interno_p text, nr_prescricao_p bigint, nr_seq_solic_sangue_p bigint, nm_usuario_p text) FROM PUBLIC;
