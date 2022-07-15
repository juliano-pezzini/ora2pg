-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_prof_escala_periodo_js ( ds_lista_profissional_p text, dt_inicio_p timestamp, dt_fim_p timestamp, nr_seq_escala_p bigint, nm_usuario_p text, ds_consistencia_p INOUT text, ie_dias_intercalado_p text) AS $body$
DECLARE

					 
qt_anestesista_w			integer;
ds_consistencia_w			varchar(2000);
ds_consistencia_anestesita_w	varchar(255);
nr_seq_escala_dir_w		bigint;
ie_gerar_dia_escala_w		varchar(1) := 'S';
cd_profissional_w			varchar(10);

C01 CURSOR FOR 
	SELECT	nr_sequencia 
	from	escala_diaria 
	where	trunc(dt_inicio) between dt_inicio_p and fim_dia(dt_fim_p)	 
	and	nr_seq_escala = nr_seq_escala_p 
	order by	dt_inicio;
	
C02 CURSOR FOR 
	SELECT	cd_pessoa_fisica 
	from	pessoa_fisica 
	where	obter_se_contido_char(cd_pessoa_fisica, ds_lista_profissional_p) = 'S' 
	order by	cd_pessoa_fisica;


BEGIN 
 
open C02;
loop 
fetch C02 into	 
	cd_profissional_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
	open c01;
	loop 
	fetch c01 into 
		nr_seq_escala_dir_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
 
		begin 
 
		if (nr_seq_escala_dir_w > 0) then 
			if (ie_gerar_dia_escala_w	= 'S') then 
				 
				if (ie_dias_intercalado_p	= 'S') then 
					ie_gerar_dia_escala_w	:= 'N';
				end if;	
				 
				select	count(*) 
				into STRICT	qt_anestesista_w 
				from	escala_diaria_adic 
				where	cd_pessoa_fisica	=	cd_profissional_w 
				and	nr_seq_escala_diaria	=	nr_seq_escala_dir_w;
				 
				if (qt_anestesista_w = 0) then 
					 
					select	obter_se_prof_liberado_escala(cd_profissional_w,b.nr_seq_escala,b.dt_inicio) 
					into STRICT	ds_consistencia_anestesita_w 
					from	escala_diaria b 
					where	b.nr_sequencia 		= nr_seq_escala_dir_w;
					 
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
							nr_seq_escala_dir_w, 
							clock_timestamp(), 
							nm_usuario_p, 
							cd_profissional_w, 
							clock_timestamp(), 
							nm_usuario_p);
					end if;	
				 
					if (ds_consistencia_w IS NOT NULL AND ds_consistencia_w::text <> '') then 
				 
						ds_consistencia_p := substr(wheb_mensagem_pck.get_texto(802193, 'DS_CONSISTENCIA_W='||ds_consistencia_w),1,255);
						 
					end if;
				 
				commit;
				end if;
			else 
				ie_gerar_dia_escala_w := 'S';
			end if;
 
		end if;
		end;
 
	end loop;
	close c01;
	 
	end;
end loop;
close C02;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_prof_escala_periodo_js ( ds_lista_profissional_p text, dt_inicio_p timestamp, dt_fim_p timestamp, nr_seq_escala_p bigint, nm_usuario_p text, ds_consistencia_p INOUT text, ie_dias_intercalado_p text) FROM PUBLIC;

