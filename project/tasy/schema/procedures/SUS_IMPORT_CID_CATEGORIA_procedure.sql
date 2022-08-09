-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_import_cid_categoria ( ie_tipo_import_p text, dt_importacao_p timestamp, nm_usuario_p text) AS $body$
DECLARE

					 
cd_categoria_cid_w		cid_categoria.cd_categoria_cid%type;
cd_especialidade_w		cid_categoria.cd_especialidade%type;
ds_categoria_cid_w		cid_categoria.ds_categoria_cid%type;
ds_categoria_compl_w		cid_categoria.ds_categoria_compl%type;
ds_excluidos_w			cid_categoria.ds_excluidos%type;
ds_referencia_w			cid_categoria.ds_referencia%type;
qt_categ_w			bigint := 0;
qt_cid_w			bigint := 0;
ds_erro_w			varchar(2000);

C01 CURSOR FOR 
	SELECT	substr(obter_valor_campo_separador(ds_conteudo,1,';'),1,10) cd_categoria_cid, 
		substr(obter_valor_campo_separador(ds_conteudo,3,';'),1,255) ds_categoria_cid, 
		substr(obter_valor_campo_separador(ds_conteudo,4,';'),1,240) ds_categoria_compl, 
		substr(obter_valor_campo_separador(ds_conteudo,5,';'),1,2000) ds_referencia, 
		substr(obter_valor_campo_separador(ds_conteudo,6,';'),1,2000) ds_excluidos 
	from	w_sus_importacao_cid 
	where	nm_usuario		= nm_usuario_p 
	and	ie_tipo_importacao		= ie_tipo_import_p 
	and	trunc(dt_importacao)	= trunc(dt_importacao_p) 
	order by	ds_conteudo;
	
type 		fetch_array is table of c01%rowtype;
s_array 	fetch_array;
i		integer := 1;
type vetor is table of fetch_array index by integer;
vetor_c01_w			vetor;
					
BEGIN 
 
open c01;
loop 
fetch c01 bulk collect into s_array limit 100000;
	vetor_c01_w(i) := s_array;
	i := i + 1;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;
 
for i in 1..vetor_c01_w.count loop 
	begin 
	s_array := vetor_c01_w(i);
	for z in 1..s_array.count loop 
		begin 
		 
		cd_categoria_cid_w		:= s_array[z].cd_categoria_cid;
		ds_categoria_compl_w		:= s_array[z].ds_categoria_compl;
		ds_categoria_cid_w		:= s_array[z].ds_categoria_cid;
		ds_referencia_w			:= s_array[z].ds_referencia;
		ds_excluidos_w			:= s_array[z].ds_excluidos;
		 
		if (cd_categoria_cid_w <> 'CAT') then 
			begin 
			 
			select 	count(1) 
			into STRICT	qt_categ_w 
			from 	cid_categoria 
			where	cd_categoria_cid = cd_categoria_cid_w  LIMIT 1;
		 
			if (qt_categ_w = 0) then 
				begin 
				 
				begin 
				select	coalesce(max(cd_especialidade_cid),'X') 
				into STRICT	cd_especialidade_w 
				from	cid_especialidade 
				where	cd_categoria_cid_w between cd_categ_inicial and	cd_categ_final;			
				exception 
				when others then 
					cd_especialidade_w := 'X';
				end;
				 
				if (cd_especialidade_w <> 'X') then 
					begin 
					insert into cid_categoria( 
						cd_categoria_cid, 
						cd_especialidade, 
						ds_categoria_cid, 
						ds_categoria_compl, 
						ds_excluidos, 
						ds_referencia, 
						dt_atualizacao, 
						nm_usuario, 
						ie_situacao) 
					values (	cd_categoria_cid_w, 
						cd_especialidade_w, 
						ds_categoria_cid_w, 
						ds_categoria_compl_w, 
						ds_excluidos_w, 
						ds_referencia_w, 
						clock_timestamp(), 
						nm_usuario_p, 
						'A');
					end;
				end if;
				 
				end;
			else 
				begin 
				 
				begin 
				select	coalesce(max(cd_especialidade_cid),'X') 
				into STRICT	cd_especialidade_w 
				from	cid_especialidade 
				where	cd_categoria_cid_w between cd_categ_inicial and	cd_categ_final;			
				exception 
				when others then 
					cd_especialidade_w := 'X';
				end;
				 
				if (cd_especialidade_w <> 'X') then 
					begin 
					update 	cid_categoria 
					set 	cd_especialidade	= cd_especialidade_w, 
						ds_categoria_cid 	= ds_categoria_cid_w, 
						ds_excluidos		= ds_excluidos_w, 
						ds_categoria_compl	= ds_categoria_compl_w, 
						ds_referencia		= ds_referencia_w, 
						dt_atualizacao		= clock_timestamp(), 
						nm_usuario		= nm_usuario_p 
					where	substr(cd_categoria_cid,1,3) = cd_categoria_cid_w;				
					end;
				end if;			
				 
				end;
			end if;
		 
			commit;
		 
			end;
		end if;		
		 
		end;
	end loop;
	end;
end loop;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_import_cid_categoria ( ie_tipo_import_p text, dt_importacao_p timestamp, nm_usuario_p text) FROM PUBLIC;
