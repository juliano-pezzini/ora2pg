-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_leite_rotina_js ( nr_prescricao_p bigint, ds_lista_leites_p text, cd_perfil_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ds_lista_w		varchar(4000);
ds_lista_aux_w		varchar(2000);
nr_pos_virgula_w	bigint;
nr_pos_hifem_w		bigint;
cd_leite_w		bigint;
nr_ctrl_loop_w		smallint := 0;


BEGIN 
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (ds_lista_leites_p IS NOT NULL AND ds_lista_leites_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
	 
	ds_lista_w	:= ds_lista_leites_p;
	 
	while(ds_lista_w IS NOT NULL AND ds_lista_w::text <> '') and (nr_ctrl_loop_w < 100) loop 
		begin 
		nr_ctrl_loop_w 		:= nr_ctrl_loop_w + 1;		
		nr_pos_virgula_w	:= position(',' in ds_lista_w);
		 
		cd_leite_w		:= 0;		
		 
		if (coalesce(nr_pos_virgula_w,0) > 0) then 
			begin 
			ds_lista_aux_w	:= substr(ds_lista_w,0,nr_pos_virgula_w-1);
			ds_lista_w	:= substr(ds_lista_w,nr_pos_virgula_w+1,length(ds_lista_w));
			end;
		else 
			begin 
			ds_lista_aux_w	:= ds_lista_w;
			ds_lista_w	:= null;
			end;
		end if;
		 
		if (ds_lista_aux_w IS NOT NULL AND ds_lista_aux_w::text <> '') then 
			begin 
			nr_pos_hifem_w	:= position('-' in ds_lista_aux_w);
			 
			if (nr_pos_hifem_w > 0) then	 
				cd_leite_w := substr(ds_lista_aux_w,1,nr_pos_hifem_w-1);
			else 
				cd_leite_w := ds_lista_aux_w;
			end if;			
						 
			end;
		end if;
		 
		if (cd_leite_w IS NOT NULL AND cd_leite_w::text <> '') then 
			begin			 
			CALL gerar_leite_rotina(	nr_prescricao_p, 
								cd_leite_w, 
								nm_usuario_p, 
								cd_perfil_p);
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
-- REVOKE ALL ON PROCEDURE gerar_leite_rotina_js ( nr_prescricao_p bigint, ds_lista_leites_p text, cd_perfil_p bigint, nm_usuario_p text) FROM PUBLIC;
