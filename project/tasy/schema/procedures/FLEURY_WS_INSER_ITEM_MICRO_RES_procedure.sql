-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fleury_ws_inser_item_micro_res ( nr_ficha_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, cd_exame_p text, cd_microorganismo_p text, cd_medicamento_p text, ie_result_p text, cd_unidade_p text, nm_usuario_p text, ds_erro_p INOUT text ) AS $body$
DECLARE

 
nr_prescricao_w		bigint;
cd_exame_w		varchar(20);
nr_seq_prescr_w		bigint;
ie_agrupa_w		varchar(1);
cd_estabelecimento_w	bigint;

ie_existe_param_maq_w	varchar(1);
ie_result_w			exame_lab_result_antib.ie_resultado%type;


BEGIN 
 
 
/* 
 
Tipos de resultado do Fleury 
LEGENDA: 	( S ) Sensível             
			( R ) Resistente     
			( N ) Sem Criterios Interpretativos  
			(PO ) Positivo     
			( I ) Intermediário          
			(NE ) Negativo     
			( D ) Sensibilidade Dose Dependente  
			( - ) Não Pesquisado 
 
 
*/
 
 
CALL gerar_lab_log_interf_imp(nr_prescricao_p, 
			null, 
			null, 
			null, 
			substr('fleury_ws_inser_item_micro_res - cd_exame_p: '||cd_exame_p||' cd_microorganismo_p:'||cd_microorganismo_p||' cd_medicamento_p: '||cd_medicamento_p||' ie_result_p: '||ie_result_p,1,1999), 
			'FleuryWS', 
			'', 
			nm_usuario_p, 
			'N');
			 
			 
			 
			 
if (ie_result_p in ('S','R','I','D')) then 
	ie_result_w	:= ie_result_p;
elsif (ie_result_p = 'PO') then 
	ie_result_w	:= '+';
elsif (ie_result_p = 'NE') then 
	ie_result_w	:= '-';
elsif (ie_result_p = '-') then 
	ie_result_w	:= 'N';
elsif (ie_result_p = 'N') then 
	ie_result_w	:= 'I';
end if;
			 
			 
			 
 
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then 
 
	nr_prescricao_w := nr_prescricao_p;
 
else 
	/*select	nvl(max(ie_agrupa_ficha_fleury),'N'), 
		nvl(max(cd_estabelecimento),0) 
	into	ie_agrupa_w, 
		cd_estabelecimento_w 
	from	lab_parametro 
	where	nvl(cd_unidade_fleury,nvl(cd_unidade_p,'0')) = nvl(cd_unidade_p,'0');*/
 
	 
	select	fleury_obter_dados_unidade(cd_unidade_p, 'AF'),		 
			fleury_obter_dados_unidade(cd_unidade_p, 'E') 
	into STRICT	ie_agrupa_w,		 
			cd_estabelecimento_w 
	;
	 
	if (ie_agrupa_w <> 'N') then 
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
		into STRICT	ie_existe_param_maq_w 
		from	lab_param_maquina a 
		where	a.cd_estabelecimento = cd_estabelecimento_w;
	 
		if (ie_existe_param_maq_w = 'S') then 
			select	max(a.nr_prescricao) 
			into STRICT	nr_prescricao_w 
			from ( 
					SELECT	a.nr_prescricao, 
							substr(lab_obter_parametro(cd_estabelecimento_w, a.nr_prescricao, null, 'UF'),1,255) cd_unidade_fleury 
					from	prescr_procedimento a 
					where	a.nr_controle_ext = nr_ficha_p 
					) a 
			where	a.cd_unidade_fleury = cd_unidade_p;
		else 
			select	max(a.nr_prescricao) 
			into STRICT	nr_prescricao_w 
			from	prescr_procedimento a, 
					prescr_medica b 
			where	a.nr_prescricao = b.nr_prescricao 
			and		a.nr_controle_ext = nr_ficha_p 
			and		b.cd_estabelecimento = cd_estabelecimento_w;
		end if;
	else 
		select	max(a.nr_prescricao) 
		into STRICT	nr_prescricao_w 
		from 	prescr_medica a 
		where	a.nr_controle = nr_ficha_p 
		and		a.cd_estabelecimento = cd_estabelecimento_w;
		 
		/*if (nr_prescricao_w is null) then 
			select	max(b.nr_prescricao) 
			into	nr_prescricao_w 
			from	prescr_procedimento a, prescr_medica b 
			where	a.nr_prescricao = b.nr_prescricao 
			and		a.nr_controle_ext = nr_ficha_p 
			and		((b.cd_estabelecimento = cd_estabelecimento_w) or (cd_estabelecimento_w = 0)); 
		end if;*/
 
		 
	end if;
end if;
 
 
if (coalesce(nr_seq_prescr_p::text, '') = '') or (not nr_seq_prescr_p > 0) then 
	 
	nr_seq_prescr_w := obter_seq_prescr_prescricao(nr_prescricao_w, 'FLEURY', cd_exame_p);
		 
else 
	nr_seq_prescr_w := nr_seq_prescr_p;
	 
end if;	
 
 
 
select	max(coalesce(e.cd_exame_integracao, e.cd_exame)) 
into STRICT	cd_exame_w 
from	exame_laboratorio e, 
	prescr_procedimento p 
where	e.nr_seq_exame 	= p.nr_seq_exame 
and	p.nr_prescricao	= nr_prescricao_w 
and	p.nr_sequencia	= nr_seq_prescr_w;
 
 
ds_erro_p := Lab_inserir_item_micro_result(	nr_prescricao_w, nr_seq_prescr_w, cd_exame_w, cd_microorganismo_p, cd_medicamento_p, null, null, ie_result_w, nm_usuario_p, ds_erro_p);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fleury_ws_inser_item_micro_res ( nr_ficha_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, cd_exame_p text, cd_microorganismo_p text, cd_medicamento_p text, ie_result_p text, cd_unidade_p text, nm_usuario_p text, ds_erro_p INOUT text ) FROM PUBLIC;
