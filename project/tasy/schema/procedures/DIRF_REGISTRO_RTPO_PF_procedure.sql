-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dirf_registro_rtpo_pf (nr_seq_lote_dirf_p bigint, cd_pessoa_fisica_p text, cd_dirf_p text, dt_lote_p timestamp, nm_usuario_p text, nr_seq_posicao_p bigint, nr_seq_apres_p INOUT bigint) AS $body$
DECLARE

				 
ds_arquivo_w 		varchar(4000);	
separador_w		varchar(1) := '|';
nr_seq_arquivo_w	bigint;
qt_registro_w		bigint;
ie_entou_w		boolean;
ie_mes_w		varchar(2);
vl_rendimento_w		double precision;
				
C02 CURSOR FOR 
	SELECT	coalesce(sum((obter_dados_tit_pagar(f.nr_titulo,'V'))::numeric ),0) 
	from	dirf_lote a, 
		gps d, 
		gps_titulo e, 
		titulo_pagar p,  
		titulo_pagar f  
	where	a.nr_sequencia 	= d.nr_seq_dirf 
	and	d.nr_sequencia 	= e.nr_seq_gps 
	and	f.nr_titulo	= e.nr_titulo 
	and	f.nr_titulo_original = p.nr_titulo 
	and	trunc(p.dt_liquidacao,'YYYY') = trunc(dt_lote_p,'YYYY') 
	and	a.nr_sequencia = nr_seq_lote_dirf_p 
	and	p.cd_pessoa_fisica = cd_pessoa_fisica_p 
	and	to_char(p.dt_liquidacao,'mm') = lpad(ie_mes_w,2,'0');		
 

BEGIN 
nr_seq_arquivo_w := nr_seq_posicao_p;
 
 
select	count(*) 
into STRICT	qt_registro_w 
from	dirf_lote a, 
	gps d, 
	gps_titulo e, 
	titulo_pagar p,  
	titulo_pagar f  
where	a.nr_sequencia 	= d.nr_seq_dirf 
and	d.nr_sequencia 	= e.nr_seq_gps 
and	f.nr_titulo	= e.nr_titulo 
and	f.nr_titulo_original = p.nr_titulo 
and	trunc(p.dt_liquidacao,'YYYY') = trunc(dt_lote_p,'YYYY') 
and	a.nr_sequencia = nr_seq_lote_dirf_p 
and	p.cd_pessoa_fisica = cd_pessoa_fisica_p;
 
 
if (qt_registro_w > 0) then 
	if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then 
		ds_arquivo_w := 'RTPO' || separador_w;
		ie_mes_w := '01';
		ie_entou_w := false;
 
		while (ie_mes_w)::numeric  <= 13 loop 
			OPEN c02;
			LOOP 
			FETCH c02 INTO 
				vl_rendimento_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				ds_arquivo_w := ds_arquivo_w || lpad(replace(campo_mascara(coalesce(vl_rendimento_w,'0'),2),'.',''),15,'0') || separador_w;
				ie_entou_w := true;
			END LOOP;
			CLOSE c02;
 
			if (not ie_entou_w) and ((ie_mes_w)::numeric  = 13 ) then 
				ds_arquivo_w := ds_arquivo_w || separador_w;			
			elsif (not ie_entou_w) and ((ie_mes_w)::numeric  <> 13 ) then 
				ds_arquivo_w := ds_arquivo_w || lpad(replace(campo_mascara(coalesce(0,'0'),2),'.',''),15,'0') || separador_w;							
			end if;
				 
			ie_entou_w := false;	
			ie_mes_w := to_char((ie_mes_w + 1)::numeric );
		end loop;
 
		nr_seq_arquivo_w := nr_seq_arquivo_w + 1; --incremento de cada linha do arquivo 
		insert 	into w_dirf_arquivo(nr_sequencia, 
					   nm_usuario, 
					   nm_usuario_nrec, 
					   dt_atualizacao, 
					   dt_atualizacao_nrec, 
					   ds_arquivo, 
					   nr_seq_apresentacao, 
					   nr_seq_registro, 
					   cd_pessoa_fisica, 
					   cd_darf) 
		values (nextval('w_dirf_arquivo_seq'), 
					   nm_usuario_p, 
					   nm_usuario_p, 
					   clock_timestamp(), 
					   clock_timestamp(), 
					   ds_arquivo_w, 
					   nr_seq_arquivo_w, 
					   1, 
					   cd_pessoa_fisica_p, 
					   cd_dirf_p);		
	end if;
end if;
 
commit;
 
nr_seq_apres_p := nr_seq_arquivo_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dirf_registro_rtpo_pf (nr_seq_lote_dirf_p bigint, cd_pessoa_fisica_p text, cd_dirf_p text, dt_lote_p timestamp, nm_usuario_p text, nr_seq_posicao_p bigint, nr_seq_apres_p INOUT bigint) FROM PUBLIC;
