-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_parcelas_neg_cr ( ds_lista_nr_parcela_p text, ie_acao_p text, nm_usuario_lib_p text, qt_lib_parc_p bigint) AS $body$
DECLARE

 
ds_lista_nr_parcela_w	varchar(2000);
nr_pos_virgula_w	bigint;
nr_sequencia_w	bigint;


BEGIN 
if (ds_lista_nr_parcela_p IS NOT NULL AND ds_lista_nr_parcela_p::text <> '') and (ie_acao_p IS NOT NULL AND ie_acao_p::text <> '') and (nm_usuario_lib_p IS NOT NULL AND nm_usuario_lib_p::text <> '') then 
	begin 
	 
	ds_lista_nr_parcela_w := ds_lista_nr_parcela_p;
	 
	while(ds_lista_nr_parcela_w IS NOT NULL AND ds_lista_nr_parcela_w::text <> '') loop 
		begin		 
		nr_pos_virgula_w	:= position(',' in ds_lista_nr_parcela_w);
	 
		if (nr_pos_virgula_w > 0) then 
			begin 
			nr_sequencia_w		:= (substr(ds_lista_nr_parcela_w,0,nr_pos_virgula_w-1))::numeric;
			ds_lista_nr_parcela_w	:= substr(ds_lista_nr_parcela_w,nr_pos_virgula_w+1,length(ds_lista_nr_parcela_w));			
			end;
		else 
			begin 
			nr_sequencia_w		:= (ds_lista_nr_parcela_w)::numeric;
			ds_lista_nr_parcela_w	:= null;
			end;
		end if;
		 
		if (nr_sequencia_w > 0) then 
			begin 
			CALL liberar_parcela_neg_cr( 
					nr_sequencia_w, 
					nm_usuario_lib_p, 
					null, 
					ie_acao_p, 
					qt_lib_parc_p);
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
-- REVOKE ALL ON PROCEDURE liberar_parcelas_neg_cr ( ds_lista_nr_parcela_p text, ie_acao_p text, nm_usuario_lib_p text, qt_lib_parc_p bigint) FROM PUBLIC;

