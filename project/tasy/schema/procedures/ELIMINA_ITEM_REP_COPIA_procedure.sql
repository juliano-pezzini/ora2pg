-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE elimina_item_rep_copia ( nr_prescricao_p bigint, ds_jejum_p text, ds_hemoterapia_p text, ds_CCG_p text, ds_IVC_p text, ds_coleta_p text, ds_nutr_dieta_oral_p text, ds_nutr_suplemento_p text, ds_nutr_sne_p text, ds_solucao_p text, ds_medicamento_p text, ds_material_p text, ds_procedimento_p text, ds_recomendacao_p text, ds_gasoterapia_p text, ds_ordem_p text, ds_npt_p text, nr_prescr_orig_p bigint, cd_perfil_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nm_usuario_w			varchar(15);
ie_origem_inf_w			varchar(1);
nr_agrupamento_w		bigint;
count_w				bigint;
nr_seq_anterior_w		bigint;
ie_suspender_origem_w		varchar(1);

c01 CURSOR FOR 
SELECT	distinct 
	nr_agrupamento 
from	prescr_material 
where	nr_prescricao		= nr_prescricao_p 
and	ie_agrupador		= 1 
and	coalesce(nr_sequencia_solucao::text, '') = '' 
and	coalesce(nr_sequencia_proc::text, '') = '' 
and	coalesce(nr_sequencia_dieta::text, '') = '' 
and	coalesce(nr_sequencia_diluicao::text, '') = '' 
and	obter_se_contido(nr_sequencia, '('||ds_medicamento_p||')') = 'S';

/* Jejum */
 
c02 CURSOR FOR 
SELECT	nr_seq_anterior 
from	rep_jejum 
where	nr_prescricao 	= nr_prescricao_p 
and	ds_nutr_dieta_oral_p	like '%' || nr_sequencia || '%';

/* Nutrições - Dieta Oral */
 
c03 CURSOR FOR 
SELECT	nr_seq_anterior 
from	prescr_dieta 
where	nr_prescricao 	= nr_prescricao_p 
and	ds_nutr_dieta_oral_p	like '%' || nr_sequencia || '%';

/* Nutrições - Suplemento */
 
c04 CURSOR FOR 
SELECT	nr_seq_anterior 
from	prescr_material 
where	nr_prescricao		= nr_prescricao_p	 
and	ie_agrupador		= 12 
and	ds_nutr_suplemento_p	like '%' || nr_sequencia || '%';

/* Nutrições - Suporte Nutricional Enteral */
 
c05 CURSOR FOR 
SELECT	nr_seq_anterior 
from	prescr_material 
where	nr_prescricao		= nr_prescricao_p 
and	ie_agrupador		= 8 
and	ds_nutr_sne_p		like '%' || nr_sequencia || '%';

/* Soluções */
 
c06 CURSOR FOR 
SELECT	nr_seq_anterior 
from	prescr_solucao 
where	nr_prescricao		= nr_prescricao_p 
and	coalesce(ie_hemodialise,'N')	= 'N' 
and	ds_solucao_p		like '%' || nr_seq_solucao || '%';

/*Medicamentos*/
 
c07 CURSOR FOR 
SELECT	nr_seq_anterior 
from	prescr_material 
where	nr_prescricao		= nr_prescricao_p 
and	ie_agrupador		= 1 
and	coalesce(nr_sequencia_solucao::text, '') = '' 
and	coalesce(nr_sequencia_proc::text, '') = '' 
and	coalesce(nr_sequencia_dieta::text, '') = '' 
and	coalesce(nr_sequencia_diluicao::text, '') = '' 
and	nr_agrupamento		= nr_agrupamento_w 
and	obter_se_contido(nr_sequencia, '('||ds_medicamento_p||')') = 'N';

c071 CURSOR FOR 
SELECT	nr_seq_anterior 
from	prescr_material 
where	nr_prescricao		= nr_prescricao_p 
and	ie_agrupador		= 1 
and	coalesce(nr_sequencia_solucao::text, '') = '' 
and	coalesce(nr_sequencia_proc::text, '') = '' 
and	coalesce(nr_sequencia_dieta::text, '') = '' 
and	coalesce(nr_sequencia_diluicao::text, '') = '' 
and	obter_se_contido(nr_sequencia, '('||ds_medicamento_p||')') = 'S';

/* Materiais */
 
c08 CURSOR FOR 
SELECT	nr_seq_anterior 
from	prescr_material 
where	nr_prescricao		= nr_prescricao_p 
and	obter_se_contido(nr_sequencia, '('||ds_material_p||')') = 'S' 
and	ie_agrupador		= 2;

/* Procedimentos */
 
c09 CURSOR FOR 
SELECT	nr_seq_anterior 
from	prescr_procedimento 
where	nr_prescricao		= nr_prescricao_p 
and	obter_se_contido(nr_sequencia, '('||ds_procedimento_p||')') = 'S';

/*Recomendações*/
 
c10 CURSOR FOR 
SELECT	nr_seq_anterior 
from	prescr_recomendacao 
where	nr_prescricao		= nr_prescricao_p 
and	obter_se_contido(nr_sequencia, '('||ds_recomendacao_p||')') = 'S';

/*Gasoterapia */
 
c11 CURSOR FOR 
SELECT	nr_seq_anterior 
from	prescr_gasoterapia 
where	nr_prescricao		= nr_prescricao_p 
and	obter_se_contido(nr_sequencia, '('||ds_gasoterapia_p||')') = 'S';

/* IVC*/
 
c12 CURSOR FOR 
SELECT	nr_seq_anterior 
from	prescr_procedimento 
where	nr_prescricao		= nr_prescricao_p 
and	ds_IVC_p	like '%' || nr_sequencia || '%';

/*Coleta*/
 
c13 CURSOR FOR 
SELECT	nr_seq_anterior 
from	prescr_procedimento 
where	nr_prescricao		= nr_prescricao_p 
and	ds_coleta_p	like '%' || nr_sequencia || '%';

/*CCG*/
 
c14 CURSOR FOR 
SELECT	nr_seq_anterior 
from	prescr_procedimento 
where	nr_prescricao		= nr_prescricao_p 
and	ds_CCG_p	like '%' || nr_sequencia || '%';

/* Hemoterapia*/
 
c15 CURSOR FOR 
SELECT	nr_seq_anterior 
from	prescr_procedimento 
where	nr_prescricao			= nr_prescricao_p 
and	ds_hemoterapia_p	like '%' || nr_sequencia || '%';

/* NPT Adulta*/
 
c16 CURSOR FOR 
SELECT	nr_seq_anterior 
from	nut_pac 
where	nr_prescricao			= nr_prescricao_p 
and	ds_npt_p		like '%' || nr_sequencia || '%';


BEGIN 
 
ie_suspender_origem_w := obter_param_usuario(-2170, 4, cd_perfil_p, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_suspender_origem_w);
 
/* Jejum */
 
if (ds_jejum_p IS NOT NULL AND ds_jejum_p::text <> '') then 
	 
	if (ie_suspender_origem_w = 'S') then 
		open c02;
		loop 
		fetch c02 into	 
			nr_seq_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			 
			CALL Suspender_item_Prescricao(nr_prescr_orig_p,nr_seq_anterior_w,0,null,'REP_JEJUM',nm_usuario_p,'S',8030);
			 
		end loop;
		close c02;
	end if;
	 
	delete	 
	from	rep_jejum 
	where	nr_prescricao		= nr_prescricao_p 
	and	ds_jejum_p	like '%' || nr_sequencia || '%';	
end if;
 
/* Nutrições - Dieta Oral */
 
if (ds_nutr_dieta_oral_p IS NOT NULL AND ds_nutr_dieta_oral_p::text <> '') then 
 
	if (ie_suspender_origem_w = 'S') then 
	 
		open c03;
		loop 
		fetch c03 into	 
			nr_seq_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
					 
			CALL Suspender_item_Prescricao(nr_prescr_orig_p,nr_seq_anterior_w,0,null,'PRESCR_DIETA',nm_usuario_p,'S',8030);
			 
		end loop;
		close c03;
	end if;
 
	delete	 
	from	prescr_dieta 
	where	nr_prescricao		= nr_prescricao_p 
	and	ds_nutr_dieta_oral_p	like '%' || nr_sequencia || '%';	
	 
end if;
 
/* Nutrições - Suplemento */
 
if (ds_nutr_suplemento_p IS NOT NULL AND ds_nutr_suplemento_p::text <> '') then 
 
	if (ie_suspender_origem_w = 'S') then 
	 
		open c04;
		loop 
		fetch c04 into	 
			nr_seq_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c04 */
					 
			CALL Suspender_item_Prescricao(nr_prescr_orig_p,nr_seq_anterior_w,0,null,'PRESCR_MATERIAL',nm_usuario_p,'S',8030);
			 
		end loop;
		close c04;
	end if;
 
	delete	 
	from	prescr_material 
	where	nr_prescricao		= nr_prescricao_p	 
	and	ie_agrupador		= 12 
	and	ds_nutr_suplemento_p	like '%' || nr_sequencia || '%';
end if;
 
/* Nutrições - Suporte Nutricional Enteral */
 
if (ds_nutr_sne_p IS NOT NULL AND ds_nutr_sne_p::text <> '') then 
	if (ie_suspender_origem_w = 'S') then 
		open c05;
		loop 
		fetch c05 into	 
			nr_seq_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c05 */
					 
			CALL Suspender_item_Prescricao(nr_prescr_orig_p,nr_seq_anterior_w,0,null,'PRESCR_MATERIAL',nm_usuario_p,'N',8030);
			 
		end loop;
		close c05;
	end if;
 
	delete	 
	from	prescr_material 
	where	nr_prescricao		= nr_prescricao_p 
	and	ie_agrupador		= 8 
	and	ds_nutr_sne_p		like '%' || nr_sequencia || '%';
end if;
 
/* Soluções */
 
if (ds_solucao_p IS NOT NULL AND ds_solucao_p::text <> '') then 
	if (ie_suspender_origem_w = 'S') then 
		open c06;
		loop 
		fetch c06 into	 
			nr_seq_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c06 */
					 
			CALL Suspender_item_Prescricao(nr_prescr_orig_p,nr_seq_anterior_w,0,null,'PRESCR_SOLUCAO',nm_usuario_p,'S',8030);
			 
		end loop;
		close c06;
	end if;
 
	delete 
	from	prescr_solucao 
	where	nr_prescricao		= nr_prescricao_p 
	and	coalesce(ie_hemodialise,'N')	= 'N' 
	and	ds_solucao_p		like '%' || nr_seq_solucao || '%';
	/* Reordenações */
 
	CALL reordenar_solucoes(nr_prescricao_p);
end if;
 
/* Medicamentos */
 
if (ds_medicamento_p IS NOT NULL AND ds_medicamento_p::text <> '') then 
	open C01;
	loop 
	fetch C01 into	 
		nr_agrupamento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	 
		if (ie_suspender_origem_w = 'S') then 
			open C07;
			loop 
			fetch C07 into	 
				nr_seq_anterior_w;
			EXIT WHEN NOT FOUND; /* apply on C07 */
				CALL Suspender_item_Prescricao(nr_prescr_orig_p,nr_seq_anterior_w,0,null,'PRESCR_MATERIAL',nm_usuario_p,'S',8030);
				 
			end loop;
			close C07;
		end if;
	 
		 
		delete	from	prescr_material 
		where	nr_prescricao		= nr_prescricao_p 
		and	ie_agrupador		= 1 
		and	coalesce(nr_sequencia_solucao::text, '') = '' 
		and	coalesce(nr_sequencia_proc::text, '') = '' 
		and	coalesce(nr_sequencia_dieta::text, '') = '' 
		and	coalesce(nr_sequencia_diluicao::text, '') = '' 
		and	nr_agrupamento		= nr_agrupamento_w 
		and	obter_se_contido(nr_sequencia, '('||ds_medicamento_p||')') = 'N';
	end loop;
	close C01;
	 
	if (ie_suspender_origem_w = 'S') then 
		open C071;
		loop 
		fetch C071 into	 
			nr_seq_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on C071 */
			CALL Suspender_item_Prescricao(nr_prescr_orig_p,nr_seq_anterior_w,0,null,'PRESCR_MATERIAL',nm_usuario_p,'S',8030);
			 
		end loop;
		close C071;
	end if;
	 
	delete 
	from	prescr_material 
	where	nr_prescricao		= nr_prescricao_p 
	and	ie_agrupador		= 1 
	and	coalesce(nr_sequencia_solucao::text, '') = '' 
	and	coalesce(nr_sequencia_proc::text, '') = '' 
	and	coalesce(nr_sequencia_dieta::text, '') = '' 
	and	coalesce(nr_sequencia_diluicao::text, '') = '' 
	and	obter_se_contido(nr_sequencia, '('||ds_medicamento_p||')') = 'S';
	/* Reordenações */
 
	CALL reordenar_medicamento(nr_prescricao_p);
end if;
 
/* Materiais */
 
if (ds_material_p IS NOT NULL AND ds_material_p::text <> '') then 
	 
	if (ie_suspender_origem_w = 'S') then 
		open c08;
		loop 
		fetch c08 into	 
			nr_seq_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c08 */
					 
			CALL Suspender_item_Prescricao(nr_prescr_orig_p,nr_seq_anterior_w,0,null,'PRESCR_MATERIAL',nm_usuario_p,'S',8030);
			 
		end loop;
		close c08;
	end if;
 
	delete	 
	from	prescr_material 
	where	nr_prescricao		= nr_prescricao_p 
	and	obter_se_contido(nr_sequencia, '('||ds_material_p||')') = 'S' 
	and	ie_agrupador		= 2;
end if;
 
/* Procedimentos */
 
if (ds_procedimento_p IS NOT NULL AND ds_procedimento_p::text <> '') then 
	 
	if (ie_suspender_origem_w = 'S') then 
		open c09;
		loop 
		fetch c09 into	 
			nr_seq_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c09 */
					 
			CALL Suspender_item_Prescricao(nr_prescr_orig_p,nr_seq_anterior_w,0,null,'PRESCR_PROCEDIMENTO',nm_usuario_p,'S',8030);
			 
		end loop;
		close c09;
	end if;
 
	delete	 
	from	prescr_procedimento 
	where	nr_prescricao		= nr_prescricao_p 
	and	obter_se_contido(nr_sequencia, '('||ds_procedimento_p||')') = 'S';
	/* Reordenações */
 
	CALL reordenar_procedimento(nr_prescricao_p);
end if;
 
/* Recomendações */
 
if (ds_recomendacao_p IS NOT NULL AND ds_recomendacao_p::text <> '') then 
	 
	if (ie_suspender_origem_w = 'S') then 
		open c10;
		loop 
		fetch c10 into	 
			nr_seq_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c10 */
					 
			CALL Suspender_item_Prescricao(nr_prescr_orig_p,nr_seq_anterior_w,0,null,'PRESCR_RECOMENDACAO',nm_usuario_p,'S',8030);
			 
		end loop;
		close c10;
	end if;
		 
	delete	 
	from	prescr_recomendacao 
	where	nr_prescricao		= nr_prescricao_p 
	and	obter_se_contido(nr_sequencia, '('||ds_recomendacao_p||')') = 'S';
	/* Reordenações */
 
	CALL reordenar_recomendacao(nr_prescricao_p);
end if;
 
/* Coleta*/
 
if (ds_coleta_p IS NOT NULL AND ds_coleta_p::text <> '') then 
	 
	if (ie_suspender_origem_w = 'S') then 
		open c13;
		loop 
		fetch c13 into	 
			nr_seq_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c13 */
					 
			CALL Suspender_item_Prescricao(nr_prescr_orig_p,nr_seq_anterior_w,0,null,'PRESCR_PROCEDIMENTO',nm_usuario_p,'S',8030);
			 
		end loop;
		close c13;
	end if;
 
	delete	 
	from	prescr_procedimento 
	where	nr_prescricao			= nr_prescricao_p 
	and	ds_coleta_p	like '%' || nr_sequencia || '%';
	/* Reordenações */
 
	CALL reordenar_procedimento(nr_prescricao_p);	
end if;
 
/* IVC*/
 
if (ds_IVC_p IS NOT NULL AND ds_IVC_p::text <> '') then 
 
	if (ie_suspender_origem_w = 'S') then 
		open c12;
		loop 
		fetch c12 into	 
			nr_seq_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c12 */
					 
			CALL Suspender_item_Prescricao(nr_prescr_orig_p,nr_seq_anterior_w,0,null,'PRESCR_PROCEDIMENTO',nm_usuario_p,'S',8030);
			 
		end loop;
		close c12;
	end if;
 
	delete	 
	from	prescr_procedimento 
	where	nr_prescricao			= nr_prescricao_p 
	and	ds_IVC_p	like '%' || nr_sequencia || '%';
	/* Reordenações */
 
	CALL reordenar_procedimento(nr_prescricao_p);	
end if;
 
/* CCG*/
 
if (ds_CCG_p IS NOT NULL AND ds_CCG_p::text <> '') then 
 
	if (ie_suspender_origem_w = 'S') then 
		open c14;
		loop 
		fetch c14 into	 
			nr_seq_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c14 */
					 
			CALL Suspender_item_Prescricao(nr_prescr_orig_p,nr_seq_anterior_w,0,null,'PRESCR_PROCEDIMENTO',nm_usuario_p,'S',8030);
			 
		end loop;
		close c14;
	end if;
 
	delete	 
	from	prescr_procedimento 
	where	nr_prescricao			= nr_prescricao_p 
	and	ds_CCG_p	like '%' || nr_sequencia || '%';
	/* Reordenações */
 
	CALL reordenar_procedimento(nr_prescricao_p);	
end if;
 
/* Hemoterapia*/
 
if (ds_hemoterapia_p IS NOT NULL AND ds_hemoterapia_p::text <> '') then 
	 
	if (ie_suspender_origem_w = 'S') then 
		open c15;
		loop 
		fetch c15 into	 
			nr_seq_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c15 */
					 
			CALL Suspender_item_Prescricao(nr_prescr_orig_p,nr_seq_anterior_w,0,null,'PRESCR_PROCEDIMENTO',nm_usuario_p,'S',8030);
			 
		end loop;
		close c15;
	end if;
 
	delete	 
	from	prescr_procedimento 
	where	nr_prescricao			= nr_prescricao_p 
	and	ds_hemoterapia_p	like '%' || nr_sequencia || '%';
	/* Reordenações */
 
	CALL reordenar_procedimento(nr_prescricao_p);	
end if;
 
/*Gasoterapia */
 
if (ds_gasoterapia_p IS NOT NULL AND ds_gasoterapia_p::text <> '') then 
	 
	if (ie_suspender_origem_w = 'S') then 
		open c11;
		loop 
		fetch c11 into	 
			nr_seq_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c11 */
					 
			CALL Suspender_item_Prescricao(nr_prescr_orig_p,nr_seq_anterior_w,0,null,'PRESCR_GASOTERAPIA',nm_usuario_p,'S',8030);
			 
		end loop;
		close c11;
	end if;
 
	delete	 
	from	prescr_gasoterapia 
	where	nr_prescricao		= nr_prescricao_p 
	and	obter_se_contido(nr_sequencia, '('||ds_gasoterapia_p||')') = 'S';
end if;
 
/* NPT Adulta*/
 
if (ds_npt_p IS NOT NULL AND ds_npt_p::text <> '') then 
	 
	if (ie_suspender_origem_w = 'S') then 
		open c16;
		loop 
		fetch c16 into	 
			nr_seq_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c16 */
					 
			CALL Suspender_item_Prescricao(nr_prescr_orig_p,nr_seq_anterior_w,0,null,'NUT_PAC',nm_usuario_p,'S',8030);
			 
		end loop;
		close c16;
	end if;
 
	delete	 
	from	nut_pac 
	where	nr_prescricao			= nr_prescricao_p 
	and	ds_npt_p		like '%' || nr_sequencia || '%';
end if;
 
/*Ordem médica */
 
if (ds_ordem_p IS NOT NULL AND ds_ordem_p::text <> '') then 
	delete	 
	from	prescr_medica_ordem 
	where	nr_prescricao		= nr_prescricao_p 
	and	obter_se_contido(nr_sequencia, '('||ds_ordem_p||')') = 'S';
end if;
 
/* Seleciona o usuário da prescrição para terminar a origem da informação */
 
select	max(nm_usuario) 
into STRICT	nm_usuario_w 
from	prescr_medica 
where	nr_prescricao			= nr_prescricao_p;
 
/* Determina a origem da informação */
 
select	coalesce(max('1'),'3') 
into STRICT	ie_origem_inf_w 
from	medico b, 
	usuario a 
where 	a.nm_usuario			= nm_usuario_w 
and	a.cd_pessoa_fisica		= b.cd_pessoa_fisica;
 
/* Atualiza origem da informação na prescrição */
 
update	prescr_medica 
set	ie_origem_inf			= ie_origem_inf_w 
where	nr_prescricao			= nr_prescricao_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE elimina_item_rep_copia ( nr_prescricao_p bigint, ds_jejum_p text, ds_hemoterapia_p text, ds_CCG_p text, ds_IVC_p text, ds_coleta_p text, ds_nutr_dieta_oral_p text, ds_nutr_suplemento_p text, ds_nutr_sne_p text, ds_solucao_p text, ds_medicamento_p text, ds_material_p text, ds_procedimento_p text, ds_recomendacao_p text, ds_gasoterapia_p text, ds_ordem_p text, ds_npt_p text, nr_prescr_orig_p bigint, cd_perfil_p bigint, nm_usuario_p text) FROM PUBLIC;
