-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_dieta_js ( ds_lista_dieta_p text, nm_usuario_p text) AS $body$
DECLARE

		 
ds_lista_dieta_w	varchar(2000);
nr_pos_virgula_w	bigint;	
nr_seq_sequencia_w	bigint;


BEGIN 
 
if (ds_lista_dieta_p IS NOT NULL AND ds_lista_dieta_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
	 ds_lista_dieta_w	:=	ds_lista_dieta_p;
	 
	 while(ds_lista_dieta_w IS NOT NULL AND ds_lista_dieta_w::text <> '')	loop 
	 	begin 
	 	nr_pos_virgula_w := position(',' in ds_lista_dieta_w);
		 
		if (nr_pos_virgula_w > 0) then 
			begin 
			nr_seq_sequencia_w	:= (substr(ds_lista_dieta_w,0,nr_pos_virgula_w-1))::numeric;
			ds_lista_dieta_w	:= substr(ds_lista_dieta_w,nr_pos_virgula_w+1,length(ds_lista_dieta_w));			
			end;
		else 
			begin 
			nr_seq_sequencia_w	:= (ds_lista_dieta_w)::numeric;
			ds_lista_dieta_w	:= null;
			end;
		end if;
				 
		if (nr_seq_sequencia_w > 0)then 
			begin 
			CALL liberar_dieta(nr_seq_sequencia_w, nm_usuario_p);
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
-- REVOKE ALL ON PROCEDURE liberar_dieta_js ( ds_lista_dieta_p text, nm_usuario_p text) FROM PUBLIC;

