-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_analise_conta_item ( nr_seq_conta_p bigint, nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*Diego 18/12/2010 - Esta procedure tem por finalidade copiar as glosas e ocorrencias da conta e inseri-las em uma tabela especifica de modo que possam ser utilizadas na analise de contas medicas.
    Diego OS - 310809 - 18/04/2011 - Modificada esta rotina para que as glosas que geraram ocorrencias nao sejam apresentadas (Ou glosas geradas por ocorrencia tambem). Gerando somente a ocorrencia e um campo onde sera informado a glosa que o gerou.
			 So seram gerados glosas quando estas nao forem vinculadas a ocorrencias.*/
cd_codigo_w		varchar(15);
ds_observacao_w		varchar(4000);
ie_tipo_w		varchar(1);	
nr_seq_conta_w		bigint;
nr_seq_conta_mat_w	bigint;
nr_seq_conta_proc_w	bigint;
nr_seq_glosa_oc_w	bigint;
ie_status_w		varchar(1);
nr_seq_motivo_padrao_w	bigint;
ie_tipo_motivo_w	varchar(1) := 'P';
ie_existe_grupo_glosa_w varchar(1);
nr_seq_conta_item_w	bigint;
nr_seq_glosa_ref_w	bigint;
qt_glosa_w		bigint;
vl_glosa_w		double precision;
ie_pre_analise_w	varchar(2);
ie_auditoria_w		varchar(2);
nr_seq_ocorrencia_w	bigint;
nr_seq_glosa_w		bigint;
ie_finalizar_analise_w	varchar(2);
qt_solicitado_w		double precision;
vl_solicitado_w		double precision;
qt_autorizado_w		double precision;
vl_unitario_w		double precision;
vl_calculado_w		double precision;
qt_ocorrencia_benef_w	bigint;
ie_tipo_glosa_w		varchar(1);
nr_seq_proc_partic_w	bigint;
ie_glosar_pagamento_w	varchar(1);
ie_glosar_faturamento_w	varchar(1);
cd_glosa_w		varchar(10);
nr_seq_motivo_glosa_w	bigint;
nr_regra_lib_valor_w	bigint;
nr_seq_oco_w		bigint;
ie_glosa_w		smallint;
vl_liberado_w		double precision;
nr_seq_item_resumo_w	bigint;
nr_seq_analise_item_w	bigint;
ie_origem_conta_w	varchar(1);
nr_seq_grupo_w		bigint;
ie_tipo_despesa_proc_w	varchar(1);
ie_tipo_despesa_mat_w	varchar(1);
nr_seq_grupo_oc_w	bigint;
qt_despesa_w		bigint;
ie_gera_grupo_w		varchar(1) := 'S';
ie_origem_analise_w	pls_analise_conta.ie_origem_analise%type;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		null,
		qt_procedimento_imp,
		vl_procedimento_imp,
		qt_autorizado,
		(vl_procedimento/CASE WHEN coalesce(qt_procedimento_imp,0)=0 THEN 1  ELSE qt_procedimento_imp END ),
		vl_procedimento,
		nr_seq_regra_valor
	from	pls_conta_proc
	where	nr_seq_conta = nr_seq_conta_p
	
union

	SELECT	null,
		nr_sequencia,
		qt_material_imp,
		vl_material_imp,
		qt_autorizado,
		(vl_material/CASE WHEN coalesce(qt_material_imp,0)=0 THEN 1  ELSE qt_material_imp END ),
		vl_material,
		nr_seq_regra_valor
	from	pls_conta_mat
	where	nr_seq_conta = nr_seq_conta_p;
	
C02 CURSOR FOR
	SELECT	substr(tiss_obter_motivo_glosa(nr_seq_motivo_glosa,'C'),1,10) cd_codigo,								
		substr(ds_observacao,1,255) ds_observacao,
		'G' ie_tipo,
		a.nr_seq_conta 		nr_seq_conta,
		a.nr_seq_conta_mat	nr_seq_mat,
		a.nr_seq_conta_proc	nr_seq_proc,
		a.nr_sequencia,		
		a.qt_glosa,
		a.vl_glosa,
		a.nr_sequencia,
		a.nr_seq_proc_partic,
		a.nr_seq_motivo_glosa
	from	pls_conta_glosa	a		
	where	nr_seq_conta_mat 	= nr_seq_conta_mat_w
	and	coalesce(nr_seq_ocorrencia_benef::text, '') = ''
	
union all

	SELECT	substr(tiss_obter_motivo_glosa(nr_seq_motivo_glosa,'C'),1,10) cd_codigo,								
		substr(ds_observacao,1,255) ds_observacao,
		'G' ie_tipo,
		a.nr_seq_conta 		nr_seq_conta,
		a.nr_seq_conta_mat	nr_seq_mat,
		a.nr_seq_conta_proc	nr_seq_proc,
		a.nr_sequencia,		
		a.qt_glosa,
		a.vl_glosa,
		a.nr_sequencia,
		a.nr_seq_proc_partic,
		a.nr_seq_motivo_glosa
	from	pls_conta_glosa	a
	where 	nr_seq_conta_proc 	= nr_seq_conta_proc_w
	and	coalesce(nr_seq_ocorrencia_benef::text, '') = ''; -- Diego 28/04/2011 - So ira gerar glosas na analise se estas nao foram GERADAS POR OCORReNCIAS ou geram ocorrencias ou sejam Nao possuem representante em ocorrencias
C04 CURSOR FOR
	SELECT	substr(tiss_obter_motivo_glosa(nr_seq_motivo_glosa,'C'),1,10) cd_codigo,								
		substr(ds_observacao,1,255) ds_observacao,
		'G' ie_tipo,
		a.nr_seq_conta 		nr_seq_conta,
		a.nr_seq_conta_mat	nr_seq_mat,
		a.nr_seq_conta_proc	nr_seq_proc,
		a.nr_sequencia,
		null nr_seq_glosa,
		a.qt_glosa,
		a.vl_glosa,
		null ie_pre_analise,
		null ie_auditoria_conta,
		null nr_seq_oco,
		a.nr_sequencia nr_seq_glosa,
		null ie_finalizar_analise,
		null,
		null,
		a.nr_seq_proc_partic,
		a.nr_seq_motivo_glosa,
		null
	from	pls_conta_glosa	a		
	where	nr_seq_conta			= nr_seq_conta_p
	and	coalesce(nr_seq_conta_mat,0) 	= 0 
	and 	coalesce(nr_seq_conta_proc,0) 	= 0
	and	coalesce(nr_seq_ocorrencia_benef,0)  = 0 -- Diego 28/04/2011 - So ira gerar glosas na analise se estas nao foram GERADAS POR OCORReNCIAS ou geram ocorrencias ou sejam Nao possuem representante em ocorrencias
	/*and	not exists (	select	x.nr_sequencia
				from	pls_ocorrencia_benef x
				where	x.nr_seq_glosa = a.nr_sequencia	) */
-- Diego 28/04/2011 - So ira gerar glosas na analise se estas nao foram geradas por ocorrencias ou GERARAM OCORReNCIAS ou sejam Nao possuem representante em ocorrencias
	
union

	SELECT	b.cd_ocorrencia cd_codigo,
		substr(b.ds_documentacao,1,4000) ds_observacao,
		'O' ie_tipo,
		a.nr_seq_conta	nr_seq_conta,
		a.nr_seq_mat	nr_seq_mat,
		a.nr_seq_proc	nr_seq_proc,										
		a.nr_sequencia,
		coalesce(a.nr_seq_glosa, (	select	max(x.nr_sequencia)
					from	pls_conta_glosa x
					where	x.nr_seq_ocorrencia_benef = a.nr_sequencia ) ), -- Diego 28/04/2011 - Cria o vinculo com a glosa sera aquela gerada pela ocorrencia ou que gerou a ocorrencia
		a.qt_glosa,
		a.vl_glosa,
		coalesce(b.ie_pre_analise,'N'),
		coalesce(b.ie_auditoria_conta,'N'),
		a.nr_sequencia nr_seq_oco,
		null nr_seq_glosa,
		b.ie_finalizar_analise,
		b.ie_glosar_pagamento,
		b.ie_glosar_faturamento,
		a.nr_seq_proc_partic,
		(select	max(x.nr_seq_motivo_glosa)
		 from	pls_conta_glosa x
		 where	x.nr_seq_ocorrencia_benef = a.nr_sequencia ),
		b.nr_sequencia
	from	pls_ocorrencia_benef	a,
		pls_ocorrencia		b
	where	a.nr_seq_ocorrencia = b.nr_sequencia
	and	coalesce(nr_seq_guia_plano::text, '') = ''
	and	coalesce(nr_seq_requisicao::text, '') = ''	
	and	coalesce(nr_seq_conta_pos_estab::text, '') = ''
	and	nr_seq_conta	= nr_seq_conta_p;	
	
C05 CURSOR FOR
	SELECT	a.nr_seq_grupo,
		a.nr_sequencia
	from	pls_ocorrencia_grupo a,
		pls_ocorrencia_benef b,
		pls_ocorrencia c
	where	a.nr_seq_ocorrencia = c.nr_sequencia
	and	b.nr_seq_ocorrencia = c.nr_sequencia
	and	coalesce(a.ie_origem_conta,ie_origem_conta_w) = ie_origem_conta_w
	and	coalesce(a.ie_conta_medica,'S') = 'S'
	and	a.ie_situacao = 'A'
	and	b.nr_sequencia = nr_seq_ocorrencia_w
	and	((coalesce(a.ie_tipo_analise::text, '') = '') or (a.ie_tipo_analise = 'A') or (a.ie_tipo_analise = 'C' and ie_origem_analise_w in ('1','3','4','5','6')) or (a.ie_tipo_analise	= 'P' and ie_origem_analise_w in ('2','7')))
	and	not exists (SELECT	x.nr_sequencia
				 from	pls_analise_grupo_item x
				 where	x.nr_seq_item_analise	= nr_seq_analise_item_w
				 and	x.nr_seq_grupo		= a.nr_seq_grupo);	
	

BEGIN

select	max(ie_origem_conta)
into STRICT	ie_origem_conta_w
from	pls_conta
where	nr_sequencia = nr_seq_conta_p;

select	max(ie_origem_analise)
into STRICT	ie_origem_analise_w
from	pls_analise_conta
where	nr_sequencia	= nr_seq_analise_p;
/*Inserir glosas e ocorrencias  dos procs e mats*/

open C01;
loop
fetch C01 into	
	nr_seq_conta_proc_w,
	nr_seq_conta_mat_w,
	qt_glosa_w,
	vl_glosa_w,
	qt_autorizado_w,
	vl_unitario_w,
	vl_calculado_w,
	nr_regra_lib_valor_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	select	max(nr_sequencia)
	into STRICT	nr_seq_item_resumo_w
	from	w_pls_resumo_conta
	where	nr_seq_analise = nr_seq_analise_p
	and	nr_seq_conta_proc = nr_seq_conta_proc_w;
	
	if (nr_seq_conta_proc_w > 0) then
		select	max(nr_sequencia)
		into STRICT	nr_seq_item_resumo_w
		from	w_pls_resumo_conta
		where	nr_seq_analise = nr_seq_analise_p
		and	nr_seq_conta_proc = nr_seq_conta_proc_w;
	else
		select	max(nr_sequencia)
		into STRICT	nr_seq_item_resumo_w
		from	w_pls_resumo_conta
		where	nr_seq_analise = nr_seq_analise_p
		and	nr_seq_conta_mat  = nr_seq_conta_mat_w;
	end if;
	
	/*Obter as glosas e ocorrencias dos procedimentos e materiais.*/

	open C02;
	loop
	fetch C02 into	
		cd_codigo_w,
		ds_observacao_w,
		ie_tipo_w,
		nr_seq_conta_w,
		nr_seq_conta_mat_w,
		nr_seq_conta_proc_w,
		nr_seq_glosa_oc_w,
		qt_glosa_w,
		vl_glosa_w,
		nr_seq_glosa_w,
		nr_seq_proc_partic_w,
		nr_seq_motivo_glosa_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		
		ie_tipo_motivo_w := 'P';
		
		select	count(x.nr_sequencia)
		into STRICT	qt_ocorrencia_benef_w
		from	pls_ocorrencia_benef x
		where	x.nr_seq_glosa = nr_seq_glosa_w;
		
		if (qt_ocorrencia_benef_w	= 0) then					
			
			/*Nao existe glosa informativa.
			if	(nvl(nr_seq_glosa_oc_w,0) > 0) then
			
				select 	substr(tiss_obter_motivo_glosa(nr_seq_motivo_glosa_w,'C'),1,10)
				into	cd_glosa_w
				from	dual;

				if	((nvl(cd_glosa_w,'X') = '1705')   or
					 (nvl(cd_glosa_w,'X') = '1706'))  and
					(nvl(nr_regra_lib_valor_w,0) > 0) and
					(nvl(ie_tipo_motivo_w,'P') = 'I') then
					vl_glosa_w :=0;
					qt_glosa_w :=0;	
					ie_tipo_motivo_w := 'A';
				end if;
			
			end if;*/
			
			if (coalesce(nr_seq_proc_partic_w,0) > 0) then
				nr_seq_conta_mat_w	:= null;
				nr_seq_conta_proc_w	:= null;
			end if;
			
			select	max(nr_sequencia)
			into STRICT	nr_seq_analise_item_w
			from	pls_analise_conta_item
			where	ie_tipo		= 'G'
			and	nr_seq_glosa	= nr_seq_glosa_w
			and	nr_seq_analise	= nr_seq_analise_p;		
			
			if (coalesce(nr_seq_analise_item_w,0) = 0) then
			
				select  nextval('pls_analise_conta_item_seq')
				into STRICT	nr_seq_analise_item_w
				;
			
				insert into pls_analise_conta_item(cd_codigo, ds_obs_glosa_oc, dt_atualizacao,
					 dt_atualizacao_nrec, ie_situacao, ie_status,
					 ie_tipo, nm_usuario, nm_usuario_nrec,
					 nr_seq_analise, nr_seq_conta, nr_seq_conta_mat,
					 nr_seq_conta_proc, nr_seq_glosa_oc, nr_sequencia,
					 qt_glosa, vl_glosa, ie_fechar_conta,
					 nr_seq_ocorrencia, nr_seq_glosa, nr_seq_proc_partic,
					 nr_seq_w_resumo_conta)	
				values (cd_codigo_w, ds_observacao_w, clock_timestamp(),
					 clock_timestamp(), 'A', ie_tipo_motivo_w,
					 ie_tipo_w, nm_usuario_p, nm_usuario_p,
					 nr_seq_analise_p, nr_seq_conta_p, nr_seq_conta_mat_w,
					 nr_seq_conta_proc_w, nr_seq_glosa_oc_w, nr_seq_analise_item_w,
					 qt_glosa_w, vl_glosa_w, pls_obter_glos_oco_permite(cd_codigo_w, ie_tipo_w),
					 nr_seq_ocorrencia_w, nr_seq_glosa_w, nr_seq_proc_partic_w,
					 nr_seq_item_resumo_w);
			else
				update	pls_analise_conta_item
				set	cd_codigo 		= cd_codigo_w,
					ds_obs_glosa_oc 	= ds_observacao_w,
					dt_atualizacao 		= clock_timestamp(),
					nm_usuario 		= nm_usuario_p,					
					nr_seq_analise 		= nr_seq_analise_p,
					nr_seq_conta 		= nr_seq_conta_p,
					nr_seq_conta_mat 	= nr_seq_conta_mat_w,
					nr_seq_conta_proc 	= nr_seq_conta_proc_w,
					nr_seq_glosa_oc 	= nr_seq_glosa_oc_w,					
					ie_fechar_conta 	= pls_obter_glos_oco_permite(cd_codigo_w, ie_tipo_w),
					nr_seq_ocorrencia 	= nr_seq_ocorrencia_w,
					nr_seq_glosa 		= nr_seq_glosa_w,
					nr_seq_proc_partic 	= nr_seq_proc_partic_w,
					nr_seq_w_resumo_conta 	= nr_seq_item_resumo_w				
				where	nr_sequencia 		= nr_seq_analise_item_w;
			end if;
		end if;
		
		end;
	end loop;
	close C02;	
	
	end;
end loop;
close C01;

/*Inserir glosas da conta e ocorrencias  dos procedimentos, materiais e da conta*/

open C04;
loop
fetch C04 into	
	cd_codigo_w,
	ds_observacao_w,
	ie_tipo_w,
	nr_seq_conta_w,
	nr_seq_conta_mat_w,
	nr_seq_conta_proc_w,
	nr_seq_glosa_oc_w,
	nr_seq_glosa_ref_w,
	qt_glosa_w,
	vl_glosa_w,
	ie_pre_analise_w,
	ie_auditoria_w,
	nr_seq_ocorrencia_w,
	nr_seq_glosa_w,
	ie_finalizar_analise_w,
	ie_glosar_pagamento_w,
	ie_glosar_faturamento_w,
	nr_seq_proc_partic_w,
	nr_seq_motivo_glosa_w,
	nr_seq_oco_w;
EXIT WHEN NOT FOUND; /* apply on C04 */
	begin	
	
	ie_tipo_motivo_w := 'P';
	
	if (coalesce(nr_seq_conta_mat_w,0) > 0) or (coalesce(nr_seq_conta_proc_w,0) > 0) or (coalesce(nr_seq_proc_partic_w,0) > 0) then
		
		if (nr_seq_proc_partic_w > 0) then
			select	max(nr_sequencia)
			into STRICT	nr_seq_item_resumo_w
			from	w_pls_resumo_conta
			where	nr_seq_analise = nr_seq_analise_p
			and	nr_seq_partic_proc = nr_seq_proc_partic_w;
		elsif (nr_seq_conta_proc_w > 0) then
			select	max(nr_sequencia)
			into STRICT	nr_seq_item_resumo_w
			from	w_pls_resumo_conta
			where	nr_seq_analise = nr_seq_analise_p
			and	nr_seq_conta_proc = nr_seq_conta_proc_w;
		else
			select	max(nr_sequencia)
			into STRICT	nr_seq_item_resumo_w
			from	w_pls_resumo_conta
			where	nr_seq_analise = nr_seq_analise_p
			and	nr_seq_conta_mat = nr_seq_conta_mat_w;
		end if;
		
	end if;
	
	if (coalesce(ie_pre_analise_w,'N') = 'S') and (ie_origem_conta_w = 'A') then
		update	pls_analise_conta
		set	ie_status_pre_analise	= 'S'
		where	nr_sequencia		= nr_seq_analise_p;
	end if;

	if (coalesce(nr_seq_conta_proc_w,0) > 0) then			
		select	qt_procedimento_imp,
			vl_procedimento_imp,
			qt_autorizado,
			(vl_procedimento/CASE WHEN coalesce(qt_procedimento_imp,0)=0 THEN 1  ELSE qt_procedimento_imp END ),
			vl_procedimento,
			nr_seq_regra_valor,
			vl_liberado
		into STRICT	qt_solicitado_w,
			vl_solicitado_w,
			qt_autorizado_w,
			vl_unitario_w,
			vl_calculado_w,
			nr_regra_lib_valor_w,
			vl_liberado_w
		from	pls_conta_proc
		where	nr_sequencia = nr_seq_conta_proc_w;			
	
		qt_glosa_w	:= qt_solicitado_w;
		vl_glosa_w	:= vl_solicitado_w;
		
	elsif (coalesce(nr_seq_conta_mat_w,0) > 0) then
		
		select	qt_material_imp,
			vl_material_imp,
			qt_autorizado,
			(vl_material/CASE WHEN coalesce(qt_material_imp,0)=0 THEN 1  ELSE qt_material_imp END ),
			vl_material,
			nr_seq_regra_valor,
			vl_liberado
		into STRICT	qt_solicitado_w,
			vl_solicitado_w,
			qt_autorizado_w,
			vl_unitario_w,
			vl_calculado_w,
			nr_regra_lib_valor_w,
			vl_liberado_w
		from	pls_conta_mat
		where	nr_sequencia = nr_seq_conta_mat_w;
		
		qt_glosa_w	:= qt_solicitado_w;			
		vl_glosa_w	:= vl_solicitado_w;

	end if;

	if (ie_glosar_pagamento_w = 'S') and (ie_glosar_faturamento_w = 'S') then
		ie_tipo_glosa_w := 'A';
	elsif (ie_glosar_pagamento_w = 'S') then
		ie_tipo_glosa_w := 'P';
	elsif (ie_glosar_faturamento_w = 'S') then
		ie_tipo_glosa_w := 'F';
	end if;

	if (coalesce(nr_seq_proc_partic_w,0) > 0) then
		nr_seq_conta_mat_w	:= null;
		nr_seq_conta_proc_w	:= null;
	end if;
	
	if (coalesce(nr_seq_ocorrencia_w,0) > 0)  then
	
		if (ie_origem_conta_w <> 'A') and (ie_pre_analise_w = 'S') then
	
			ie_tipo_motivo_w := 'I';
			qt_glosa_w := 0;
			vl_glosa_w := 0;
		end if;
		
		if (ie_auditoria_w = 'N') then
			ie_tipo_motivo_w := 'I'; /*Diego Os 342553 - Caso a ocorrencia nao seja de auditoria sera meramente informativa.*/
			qt_glosa_w := 0;
			vl_glosa_w := 0;
		else
			if (coalesce(ie_finalizar_analise_w,'S') = 'S') then
				ie_tipo_motivo_w := 'P';
			else
				ie_tipo_motivo_w := 'E';
			end if;
		end if;
	
		select	max(nr_seq_motivo_glosa)
		into STRICT	nr_seq_motivo_glosa_w
		from	pls_ocorrencia
		where	nr_sequencia		= nr_seq_oco_w
		and	ie_glosa		= 'S';
		
		if (coalesce(nr_seq_motivo_glosa_w,0) > 0) then
		
			if (coalesce(ie_tipo_motivo_w,'P') = 'I') and (coalesce(nr_regra_lib_valor_w,0) > 0) then
			
				select 	substr(tiss_obter_motivo_glosa(nr_seq_motivo_glosa_w,'C'),1,10)
				into STRICT	cd_glosa_w
				;
			
				if (coalesce(cd_glosa_w,'X') = '1705')  or (coalesce(cd_glosa_w,'X') = '1706')  then					
					ie_tipo_motivo_w := 'A';
					vl_glosa_w :=0;
					qt_glosa_w :=0;					
				end if;
				
			end if;
			
		end if;
		
		select	max(nr_sequencia)
		into STRICT	nr_seq_analise_item_w
		from	pls_analise_conta_item
		where	ie_tipo			= 'O'
		and	nr_seq_ocorrencia	= nr_seq_ocorrencia_w
		and	nr_seq_analise		= nr_seq_analise_p;
		
		if (coalesce(nr_seq_analise_item_w,0) = 0) and (coalesce(nr_seq_glosa_ref_w,0) > 0) then
			/*Se for uma glosa que virou uma ocorrencia.*/

			select	max(nr_sequencia)
			into STRICT	nr_seq_analise_item_w
			from	pls_analise_conta_item
			where	ie_tipo			= 'G'
			and	nr_seq_glosa		= nr_seq_glosa_ref_w
			and	nr_seq_analise		= nr_seq_analise_p;		
		end if;

	elsif (coalesce(nr_seq_glosa_w,0) > 0) then
		
		/*Nao existe ocorrencia informativa.
		select 	substr(tiss_obter_motivo_glosa(nr_seq_motivo_glosa_w,'C'),1,10)
		into	cd_glosa_w
		from	dual;
		
		if	((nvl(cd_glosa_w,'X') = '1705') or
			(nvl(cd_glosa_w,'X') = '1706')) and
			(nvl(nr_regra_lib_valor_w,0) > 0)and
			(nvl(ie_tipo_motivo_w,'P') = 'I')then
			ie_tipo_motivo_w := 'A';
			vl_glosa_w :=0;
			qt_glosa_w :=0;
		end if;*/
		
		select	max(nr_sequencia)
		into STRICT	nr_seq_analise_item_w
		from	pls_analise_conta_item
		where	ie_tipo		= 'G'
		and	nr_seq_glosa	= nr_seq_glosa_w
		and	nr_seq_analise	= nr_seq_analise_p;
		
		select	count(x.nr_sequencia)
		into STRICT	qt_ocorrencia_benef_w
		from	pls_ocorrencia_benef x
		where	x.nr_seq_glosa = nr_seq_glosa_w;
		
		if (coalesce(qt_ocorrencia_benef_w,0) > 0) then
			goto final;
		end if;
	end if;	
	
	if (coalesce(nr_seq_analise_item_w,0) = 0) then	
			
		select  nextval('pls_analise_conta_item_seq')
		into STRICT	nr_seq_analise_item_w
		;
	
		insert into pls_analise_conta_item(cd_codigo, ds_obs_glosa_oc, dt_atualizacao,
			 dt_atualizacao_nrec, ie_situacao, ie_status,
			 ie_tipo, nm_usuario, nm_usuario_nrec,
			 nr_seq_analise, nr_seq_conta, nr_seq_conta_mat,
			 nr_seq_conta_proc, nr_seq_glosa_oc, nr_sequencia,
			 ie_fechar_conta, nr_seq_glosa_ref,
			 qt_glosa, vl_glosa, ie_pre_analise,
			 nr_seq_ocorrencia, nr_seq_glosa, ie_finalizar_analise,
			 ie_tipo_glosa, nr_seq_proc_partic, nr_seq_w_resumo_conta)
		values (cd_codigo_w, ds_observacao_w, clock_timestamp(),
			 clock_timestamp(), 'A', ie_tipo_motivo_w,
			 ie_tipo_w, nm_usuario_p, nm_usuario_p,
			 nr_seq_analise_p, nr_seq_conta_p, nr_seq_conta_mat_w,
			 nr_seq_conta_proc_w, nr_seq_glosa_oc_w, nr_seq_analise_item_w,
			 pls_obter_glos_oco_permite(cd_codigo_w, ie_tipo_w), nr_seq_glosa_ref_w,
			 qt_glosa_w, vl_glosa_w, ie_pre_analise_w,
			 nr_seq_ocorrencia_w, nr_seq_glosa_w, ie_finalizar_analise_w,
			 ie_tipo_glosa_w, nr_seq_proc_partic_w, nr_seq_item_resumo_w);
	else
		update	pls_analise_conta_item
		set	cd_codigo		= cd_codigo_w,
			ds_obs_glosa_oc 	= ds_observacao_w,
			dt_atualizacao		= clock_timestamp(),
			dt_atualizacao_nrec	= clock_timestamp(),
			ie_tipo			= ie_tipo_w, 
			nm_usuario		= nm_usuario_p, 
			nm_usuario_nrec		= nm_usuario_p,			
			nr_seq_conta		= nr_seq_conta_p,
			nr_seq_conta_mat	= nr_seq_conta_mat_w,
			nr_seq_conta_proc	= nr_seq_conta_proc_w, 
			nr_seq_glosa_oc		= nr_seq_glosa_oc_w, 			
			ie_fechar_conta		= pls_obter_glos_oco_permite(cd_codigo_w, ie_tipo_w), 
			nr_seq_glosa_ref	= nr_seq_glosa_ref_w,			
			ie_pre_analise		= ie_pre_analise_w,
			nr_seq_ocorrencia	= nr_seq_ocorrencia_w,
			nr_seq_glosa		= nr_seq_glosa_w,
			ie_finalizar_analise	= ie_finalizar_analise_w,
			ie_tipo_glosa		= ie_tipo_glosa_w,
			nr_seq_proc_partic	= nr_seq_proc_partic_w,
			nr_seq_w_resumo_conta	= nr_seq_item_resumo_w
		where	nr_sequencia		= nr_seq_analise_item_w;			
	end if;
	
	if (coalesce(nr_seq_ocorrencia_w,0) > 0) then
		if	not (ie_origem_conta_w <> 'A' AND ie_pre_analise_w = 'S') then
			open C05;
			loop
			fetch C05 into	
				nr_seq_grupo_w,
				nr_seq_grupo_oc_w;
			EXIT WHEN NOT FOUND; /* apply on C05 */
				begin
				ie_gera_grupo_w := 'S';
				
				ie_tipo_despesa_proc_w:= null;
				ie_tipo_despesa_mat_w:= null;
				
				select	count(1)
				into STRICT 	qt_despesa_w
				from	pls_oc_grupo_tipo_desp
				where	nr_seq_ocorrencia_grupo = nr_seq_grupo_oc_w;
				
				if (qt_despesa_w > 0) then
					if (nr_seq_conta_proc_w > 0) then
						select	max(ie_tipo_despesa)
						into STRICT	ie_tipo_despesa_proc_w
						from	pls_conta_proc
						where	nr_sequencia = nr_seq_conta_proc_w;
						
						if (ie_tipo_despesa_proc_w IS NOT NULL AND ie_tipo_despesa_proc_w::text <> '') then
							select	count(1)
							into STRICT 	qt_despesa_w
							from	pls_oc_grupo_tipo_desp
							where	nr_seq_ocorrencia_grupo = nr_seq_grupo_oc_w
							and	ie_tipo_despesa_proc = ie_tipo_despesa_proc_w;
							
							if (coalesce(qt_despesa_w,0) = 0) then
								ie_gera_grupo_w := 'N';
							end if;
						end if;
					elsif (nr_seq_conta_mat_w > 0) then
						select	max(ie_tipo_despesa)
						into STRICT	ie_tipo_despesa_mat_w
						from	pls_conta_mat
						where	nr_sequencia = nr_seq_conta_mat_w;
						
						if (ie_tipo_despesa_mat_w IS NOT NULL AND ie_tipo_despesa_mat_w::text <> '') then
							select	count(1)
							into STRICT 	qt_despesa_w
							from	pls_oc_grupo_tipo_desp
							where	nr_seq_ocorrencia_grupo = nr_seq_grupo_oc_w
							and	ie_tipo_despesa_mat = ie_tipo_despesa_mat_w;
							
							if (coalesce(qt_despesa_w,0) = 0) then
								ie_gera_grupo_w := 'N';
							end if;
						end if;
					end if;
				end if;
				
				if (ie_gera_grupo_w = 'S') then
					insert into pls_analise_grupo_item(nr_sequencia, cd_estabelecimento, dt_atualizacao,
						 nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
						 nr_seq_grupo, nr_seq_item_analise)
					values (nextval('pls_analise_grupo_item_seq'), cd_estabelecimento_p, clock_timestamp(),
						nm_usuario_p, clock_timestamp(), nm_usuario_p,
						nr_seq_grupo_w, nr_seq_analise_item_w);
				end if;
				
				end;
			end loop;
			close C05;
			
		end if;
	end if;
	
	<<final>>
	null;
	end;
end loop;
close C04;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_analise_conta_item ( nr_seq_conta_p bigint, nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

