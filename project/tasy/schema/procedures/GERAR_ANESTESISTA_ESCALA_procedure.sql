-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_anestesista_escala ( cd_profissional_p bigint, nr_seq_escala_dir_p bigint, nm_usuario_p text, ds_consistencia_p INOUT text) AS $body$
DECLARE

					 
qt_anestesista_w	integer;
ds_consistencia_w		varchar(2000);
ds_consistencia_anestesita_w	varchar(255);


BEGIN 
 
if (nr_seq_escala_dir_p > 0) then 
	 
	select	count(*) 
	into STRICT	qt_anestesista_w 
	from	escala_diaria_adic 
	where	cd_pessoa_fisica	=	cd_profissional_p 
	and	nr_seq_escala_diaria	=	nr_seq_escala_dir_p;
	 
	if (qt_anestesista_w = 0) then 
		 
		select	obter_se_prof_liberado_escala(cd_profissional_p,b.nr_seq_escala,b.dt_inicio) 
		into STRICT	ds_consistencia_anestesita_w 
		from	escala_diaria b 
		where	b.nr_sequencia 		= nr_seq_escala_dir_p;
		 
		if (ds_consistencia_anestesita_w IS NOT NULL AND ds_consistencia_anestesita_w::text <> '') and (length(ds_consistencia_w || ds_consistencia_anestesita_w || chr(10)) < 2000) then 
		 
			ds_consistencia_w	:= ds_consistencia_w || ds_consistencia_anestesita_w || chr(10);
			 
		else	 
	 
			insert into escala_diaria_adic( 
				nr_sequencia,      
				nr_seq_escala_diaria, 
				dt_atualizacao,     
				nm_usuario,       
				cd_pessoa_fisica,    
				dt_atualizacao_nrec,   
				nm_usuario_nrec) 
			values ( 
				nextval('escala_diaria_adic_seq'), 
				nr_seq_escala_dir_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				cd_profissional_p, 
				clock_timestamp(), 
				nm_usuario_p);
		end if;	
		 
		if (ds_consistencia_w IS NOT NULL AND ds_consistencia_w::text <> '') then 
		 
			ds_consistencia_p := wheb_mensagem_pck.get_texto(307599, 'DS_CONSISTENCIA_W=' || ds_consistencia_w);
								/* 
									O profissional não foi inserido: 
									#@DS_CONSISTENCIA_W#@ 
								*/
 
		end if;
		 
		commit;
	end if;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_anestesista_escala ( cd_profissional_p bigint, nr_seq_escala_dir_p bigint, nm_usuario_p text, ds_consistencia_p INOUT text) FROM PUBLIC;

