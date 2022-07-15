-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE afip_atualizar_lab_result_item ( nr_prescricao_p text, nr_seq_material_p bigint, cd_exame_p text, cd_exame_integracao_p text, cd_exame_integ_analito_p text, ds_resultado_p text, cd_resp_libera_p text, cd_resp_tecnico_p text, cd_resp_assina_p text, cd_metodo_int_p text, nm_usuario_p text, dt_liberacao_resul_p text, dt_liberacao_laudo_p text, ds_erro_p INOUT text) AS $body$
DECLARE
 	
 
nr_seq_prescr_w			integer;
nr_seq_prescr_ww		integer;
nr_seq_material_w		bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
nr_seq_exame_w			bigint;
--nr_seq_exame_ww			number(10); 
nr_seq_resultado_w		bigint;
nr_atendimento_w		bigint;
ds_erro_w				varchar(4000);
cd_analito_w			varchar(20) := '';
cd_analito_ww			varchar(20) := '';
cd_exame_w				varchar(20) := '';
qt_resultado_w			double precision := 0;
pr_resultado_w			double precision := 0;
ds_resultado_w			varchar(4000) := '';
qt_anos_w				double precision;
ie_sexo_w				varchar(1);
nr_seq_metodo_w			bigint;
nr_seq_formato_w		bigint;
ie_formato_result_w   varchar(5);

--cd_proc_exame_w			number(15,0); 
--ie_origem_proc_exame_w	number(10,0); 
										  

BEGIN 
select 	MAX(a.nr_seq_exame), 
		MAX(a.nr_sequencia), 
		MAX(c.nr_sequencia), 
		MAX(coalesce(b.cd_exame_integracao,b.cd_exame)) 
into STRICT 	nr_seq_exame_w, 
		nr_seq_prescr_w, 
		nr_seq_material_w, 
		cd_exame_w 
from 	material_exame_lab c, 
		exame_laboratorio b, 
		prescr_procedimento a 
where 	a.nr_seq_exame = b.nr_seq_exame 
and		a.cd_material_exame = c.cd_material_exame 
and		a.nr_prescricao = nr_prescricao_p 
and		coalesce(coalesce(Obter_Equipamento_Exame(a.nr_seq_exame,null,'AFIP'),b.cd_exame_integracao),b.cd_exame) = cd_exame_integracao_p;
 
-- Busca pelo código do analito 
if (cd_exame_integ_analito_p IS NOT NULL AND cd_exame_integ_analito_p::text <> '') then 
 
	select	max(coalesce(e.cd_exame_integracao, e.cd_exame)) 
	into STRICT	cd_analito_w 
	from	exame_laboratorio e 
	where	e.nr_seq_exame = (SELECT nr_seq_exame 
				 from equipamento_lab b, 
					lab_exame_equip a 
				 WHERE	a.cd_equipamento = b.cd_equipamento 
				 AND	a.cd_exame_equip = cd_exame_integ_analito_p 
				 AND	upper(b.ds_sigla) = 'AFIP' 
				 AND	a.nr_seq_exame = nr_seq_exame_w) 
	and coalesce(e.ie_situacao,'A') = 'A';WITH RECURSIVE cte AS (

	 
	 
	if (coalesce(cd_analito_w::text, '') = '') then 
 
		select	max(coalesce(e.cd_exame_integracao, e.cd_exame)) 
		into STRICT	cd_analito_w 
		from	exame_laboratorio e WHERE nr_seq_superior = nr_seq_exame_w
  UNION ALL
 
	 
	 
	if (coalesce(cd_analito_w::text, '') = '') then 
 
		select	max(coalesce(e.cd_exame_integracao, e.cd_exame)) 
		into STRICT	cd_analito_w 
		from	exame_laboratorio e JOIN cte c ON (c.prior nr_seq_exame = e.nr_seq_superior)

) SELECT * FROM cte WHERE nr_seq_exame = (SELECT nr_seq_exame 
					from equipamento_lab b, 
						 lab_exame_equip a 
					WHERE	a.cd_equipamento = b.cd_equipamento 
					AND	a.cd_exame_equip = cd_exame_integ_analito_p 
					AND	upper(b.ds_sigla) = 'AFIP' 
					AND	a.nr_seq_exame = e.nr_seq_exame) 
		and coalesce(e.ie_situacao,'A') = 'A';
;
		 
	end if;
end if;WITH RECURSIVE cte AS (
	
if (coalesce(cd_analito_w::text, '') = '') then 
 
		 
	select	max(coalesce(e.cd_exame_integracao, e.cd_exame)) 
	into STRICT	cd_analito_ww 
	from	exame_laboratorio e WHERE nr_seq_superior = nr_seq_exame_w
  UNION ALL
	 
if (coalesce(cd_analito_w::text, '') = '') then 
 
		 
	select	max(coalesce(e.cd_exame_integracao, e.cd_exame)) 
	into STRICT	cd_analito_ww 
	from	exame_laboratorio e JOIN cte c ON (c.prior nr_seq_exame = e.nr_seq_superior)

) SELECT * FROM cte WHERE coalesce(e.ie_situacao,'A') = 'A';
;
 
	 
	 
	if (coalesce(cd_analito_ww::text, '') = '') then -- cd_analito_ww somente deve ser nulo quando o exame principal não possuir analitos 
		select max(coalesce(cd_exame_integracao, cd_exame)) 
		into STRICT cd_analito_w 
		from exame_laboratorio 
		where coalesce(ie_situacao,'A') = 'A' 
		and	 nr_seq_exame = nr_seq_exame_w;
	end if;
 
	 
end if;
 
 
if (cd_analito_w IS NOT NULL AND cd_analito_w::text <> '') then 
	begin 
		select 	max(ie_formato_resultado) 
		into STRICT 	ie_formato_result_w 
		from 	exame_laboratorio 
		where 	coalesce(cd_exame_integracao, cd_exame) = cd_analito_w;
		 
				 
		if (substr(ie_formato_result_w,1,1) = 'P') then 
			select (coalesce(replace(ds_resultado_p, ',', '.'),0))::numeric  
			into STRICT  pr_resultado_w 
			;
		else 
			begin 
				 
				select (coalesce(ds_resultado_p,0))::numeric  
				into STRICT qt_resultado_w 
				;
				ie_formato_result_w := 'V';
			exception 
				when others then 
				begin 
				ie_formato_result_w := 'V';
				select (coalesce(replace(ds_resultado_p, '.', ''),0))::numeric  
				into STRICT qt_resultado_w 
				;
				 
				 
				exception 
					when others then 
						begin 
						 
						ie_formato_result_w := 'V';
						select (coalesce(replace(ds_resultado_p, ',', '.'),0))::numeric  
						into STRICT qt_resultado_w 
						;
						 
						exception 
							when others then 
							ds_resultado_w := trim(both ds_resultado_p);
							ie_formato_result_w := 'D';
						end;
				end;
			end;
		end if;
		if (ds_erro_p <> '') then 
			ds_erro_p := ds_erro_p||chr(13)||chr(10)||WHEB_MENSAGEM_PCK.get_texto(277767,'IE_FORMATO_RESULT='||ie_formato_result_w);
		else 
			ds_erro_p := WHEB_MENSAGEM_PCK.get_texto(277768,'IE_FORMATO_RESULT='||ie_formato_result_w);
		end if;	
		 
		 
		ds_erro_w := atualizar_lab_result_item(	nr_prescricao_p, nr_seq_prescr_w, cd_analito_w, qt_resultado_w, pr_resultado_w, ds_resultado_w, '', null, null, nm_usuario_p, null, '', '', null, null, ds_erro_w);
		 
	exception 
	when others then 
		begin 
			ds_erro_p := substr(ds_erro_p||chr(13)||chr(10)||WHEB_MENSAGEM_PCK.get_texto(277769,null)||substr(sqlerrm,1,3000),1,3900);
		end;
	end;
	 
	if (cd_metodo_int_p <> '0') then 
		 
		select 	MAX(a.nr_seq_metodo) 
		into STRICT	nr_seq_metodo_w 
		from 	metodo_exame_lab_int a, 
				equipamento_lab b 
		where 	a.cd_equipamento = b.cd_equipamento 
		and		a.cd_metodo_integracao = cd_metodo_int_p 
		and		upper(b.ds_sigla) = 'AFIP';
		 
		if (coalesce(nr_seq_metodo_w::text, '') = '') then 
			select 	MAX(nr_sequencia) 
			into STRICT	nr_seq_metodo_w 
			from	metodo_exame_lab 
			where	cd_integracao = cd_metodo_int_p;
		end if;		
		 
		 
		if (nr_seq_metodo_w IS NOT NULL AND nr_seq_metodo_w::text <> '') then 
			ds_erro_p := substr(ds_erro_p||chr(13)||chr(10)||WHEB_MENSAGEM_PCK.get_texto(277712,'NR_SEQ_METODO='||nr_seq_metodo_w||';NR_PRESCRICAO='||nr_prescricao_p),1,3900);
			--atualizar formato/metodo no resultado 
			select 	MAX(nr_seq_resultado) 
			into STRICT	nr_seq_resultado_w 
			from	exame_lab_resultado 
			where 	nr_prescricao = nr_prescricao_p;
			 
			if (nr_seq_resultado_w IS NOT NULL AND nr_seq_resultado_w::text <> '') then 
				update 	exame_lab_result_item 
				set		nr_seq_metodo = nr_seq_metodo_w, 
						nr_seq_formato = obter_formato_exame(nr_seq_exame_w,nr_seq_material_w,nr_seq_metodo_w,'L') 
				where 	(nr_seq_formato IS NOT NULL AND nr_seq_formato::text <> '') 
				and		nr_seq_resultado = nr_seq_resultado_w 
				and		nr_seq_prescr = nr_seq_prescr_w;				
			end if;
		 
		end if;
	end if;
	 
	if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then 
		ds_erro_p	:= substr(ds_erro_p||chr(13)||chr(10)||ds_erro_w,1,3900);
	end if;	
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE afip_atualizar_lab_result_item ( nr_prescricao_p text, nr_seq_material_p bigint, cd_exame_p text, cd_exame_integracao_p text, cd_exame_integ_analito_p text, ds_resultado_p text, cd_resp_libera_p text, cd_resp_tecnico_p text, cd_resp_assina_p text, cd_metodo_int_p text, nm_usuario_p text, dt_liberacao_resul_p text, dt_liberacao_laudo_p text, ds_erro_p INOUT text) FROM PUBLIC;

