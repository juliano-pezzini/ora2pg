-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_se_exame_alt_normal (nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint, ie_pesquisa_massas_p text default 'N') RETURNS varchar AS $body$
DECLARE

				 
ds_retorno_w		varchar(255);
nr_seq_patologia_w	lab_patologia.nr_sequencia%type;
nr_seq_grupo_pat_w	lab_patologia.nr_seq_grupo_pat%type;

C01 CURSOR FOR 
SELECT distinct 
		b.nr_seq_exame, 
		e.nr_sequencia nr_seq_material, 
		d.qt_resultado, 
		d.ds_resultado, 
		a.nr_prescricao, 
		b.nr_sequencia nr_seq_prescr, 
		b.ie_exame_bloqueado, 
		'C' ds_tipo, 
		c.nr_seq_resultado 
from 		material_exame_lab e, 
		prescr_medica a, 
		prescr_procedimento b, 
		lote_ent_sec_ficha f, 
		lote_ent_sec_ficha_exam g, 
		exame_lab_resultado c, 
		exame_lab_result_item d 
where 		a.nr_prescricao = b.nr_prescricao 
and		a.nr_prescricao = c.nr_prescricao 
and		c.nr_seq_resultado = d.nr_seq_resultado 
and		b.nr_sequencia = d. nr_seq_prescr 
and		b.cd_material_exame = e.cd_material_exame 
and		b.nr_prescricao = f.nr_prescricao 
and		d.nr_seq_exame = g.nr_seq_exame 
and		((qt_resultado <> 0) or (ds_resultado IS NOT NULL AND ds_resultado::text <> '')) 
AND 		(d.nr_seq_material IS NOT NULL AND d.nr_seq_material::text <> '') 
and		coalesce(b.ie_suspenso,'N') <> 'S' 
and		a.nr_prescricao = nr_prescricao_p 
and		b.nr_sequencia = coalesce(nr_seq_prescr_p,b.nr_sequencia)	 
and		b.nr_seq_exame = coalesce(nr_seq_exame_p,b.nr_seq_exame) 
and (ie_pesquisa_massas_p = 'N' or ie_pesquisa_massas_p = 'T') 
and not exists (SELECT	1 
		from 	lote_ent_exame_massa l 
		where	l.nr_seq_exame = b.nr_seq_exame 
		and	l.ie_situacao = 'A') 

union
 
select distinct 
		d.nr_seq_exame, 
		0 nr_seq_material, 
		d.qt_resultado, 
		d.ds_resultado, 
		a.nr_prescricao, 
		d.nr_seq_prescr, 
		b.ie_exame_bloqueado, 
		'M' ds_tipo, 
		c.nr_seq_resultado 
from 		prescr_medica a, 
		prescr_procedimento b, 
		lote_ent_exame_massa l,	 
		exame_lab_resultado c, 
		exame_lab_result_item d 
where 		a.nr_prescricao = b.nr_prescricao 
and		a.nr_prescricao = c.nr_prescricao 
and		c.nr_seq_resultado = d.nr_seq_resultado 
and		b.nr_sequencia = d.nr_seq_prescr 
and		l.nr_seq_exame = b.nr_seq_exame 
and		l.ie_situacao = 'A' 
and		((d.qt_resultado <> 0) or (d.ds_resultado IS NOT NULL AND d.ds_resultado::text <> '')) 
AND 		coalesce(d.nr_seq_material::text, '') = '' 
and		coalesce(b.ie_suspenso,'N') <> 'S' 
and		a.nr_prescricao = nr_prescricao_p 
and		b.nr_sequencia = coalesce(nr_seq_prescr_p,b.nr_sequencia)	 
and		b.nr_seq_exame = coalesce(nr_seq_exame_p,b.nr_seq_exame) 
and (ie_pesquisa_massas_p = 'S' or ie_pesquisa_massas_p = 'T');		
 
c01_w		C01%rowtype;


BEGIN 
ds_retorno_w := '0';
open C01;
loop 
fetch C01 into	 
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	if (ds_retorno_w = '0' ) then 
		if (c01_w.ds_tipo = 'C') then 
			select coalesce(lab_cons_valor_result_lote(c01_w.nr_seq_exame, c01_w.nr_seq_material, c01_w.qt_resultado, c01_w.ds_resultado, c01_w.nr_prescricao, c01_w.nr_seq_prescr,2),0) 
			into STRICT  ds_retorno_w	 
			;
		else 
			nr_seq_patologia_w := 0;
			nr_seq_grupo_pat_w := 0;
			 
			select	coalesce(max(a.nr_sequencia), 0), 
				coalesce(max(a.nr_seq_grupo_pat), 0) 
			into STRICT	nr_seq_patologia_w, 
				nr_seq_grupo_pat_w 
			from	lab_patologia a, 
				lab_patologia_exame b 
			where	a.nr_sequencia = b.nr_seq_patologia 
			 and	b.nr_seq_exame = c01_w.nr_seq_exame 
			 and	coalesce(a.ie_situacao, 'A') = 'A' 
			 and	coalesce(b.ie_situacao, 'A') = 'A';
			  
			select coalesce(lab_cons_val_lote_massas(c01_w.nr_seq_exame, c01_w.qt_resultado, c01_w.ds_resultado, c01_w.nr_seq_prescr,2, c01_w.nr_seq_resultado, nr_seq_patologia_w, nr_seq_grupo_pat_w),0) 
			into STRICT  ds_retorno_w	 
			;
		end if;
		 
		if (coalesce(nr_seq_prescr_p::text, '') = '') and (coalesce(nr_seq_exame_p::text, '') = '') and (ds_retorno_w = 0) then 
		  
		  select coalesce(max(1),0) 
		  into STRICT ds_retorno_w 
		  from lote_ent_res_ant_repet x 
		  where x.nr_prescricao = c01_w.nr_prescricao 
		  and  x.nr_seq_prescr = c01_w.nr_seq_prescr 
		  and  c01_w.ie_exame_bloqueado = 'R';		
		  
		end if;
	else 
		exit;
	end if;
	 
	end;
end loop;
close C01;
 
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_se_exame_alt_normal (nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint, ie_pesquisa_massas_p text default 'N') FROM PUBLIC;
