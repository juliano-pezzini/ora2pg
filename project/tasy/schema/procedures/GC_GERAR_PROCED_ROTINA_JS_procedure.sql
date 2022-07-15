-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gc_gerar_proced_rotina_js ( nr_cirurgia_p bigint, ds_lista_proced_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
nr_seq_proc_interno_w	bigint;
tamanho_lista_w		bigint;
posicao_virgula_w 	smallint;
nr_max_loop_w		smallint := 9999;
ds_lista_w 		varchar(10000);


BEGIN 
if (ds_lista_proced_p IS NOT NULL AND ds_lista_proced_p::text <> '') then 
	begin 
	tamanho_lista_w := length(ds_lista_proced_p);
	ds_lista_w := ds_lista_proced_p;
	 
	while(ds_lista_w IS NOT NULL AND ds_lista_w::text <> '') and (nr_max_loop_w > 0) loop 
		begin 
		posicao_virgula_w := position(',' in ds_lista_w);
		if (posicao_virgula_w > 1) and ((substr(ds_lista_w, 1, posicao_virgula_w -1) IS NOT NULL AND (substr(ds_lista_w, 1, posicao_virgula_w -1))::text <> '')) then 
			begin 
			nr_seq_proc_interno_w := (substr(ds_lista_w, 1, posicao_virgula_w -1))::numeric;
			ds_lista_w := substr(ds_lista_w, posicao_virgula_w +1, tamanho_lista_w);
			end;
		elsif (ds_lista_w IS NOT NULL AND ds_lista_w::text <> '') then 
			begin 
			nr_seq_proc_interno_w := (replace(ds_lista_w, ',', ''))::numeric;
			ds_lista_w := '';
			end;
		end if;
		 
		if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') and (nr_seq_proc_interno_w > 0) then 
			begin			 
			CALL gerar_procedimento_rotina(nr_cirurgia_p,nr_seq_proc_interno_w,cd_estabelecimento_p,nm_usuario_p);
			end;
		end if;
		 
		nr_max_loop_w := nr_max_loop_w -1;
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
-- REVOKE ALL ON PROCEDURE gc_gerar_proced_rotina_js ( nr_cirurgia_p bigint, ds_lista_proced_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

