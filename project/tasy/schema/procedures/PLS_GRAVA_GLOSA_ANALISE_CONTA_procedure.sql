-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_grava_glosa_analise_conta ( nr_seq_motivo_glosa_p bigint, nr_seq_ocorrencia_p bigint, nr_seq_item_analise_p bigint, qt_liberada_p bigint, vl_liberado_p bigint, vl_lib_co_p bigint, vl_lib_hi_p bigint, vl_lib_mat_p bigint, ds_observacao_p text, nr_seq_grupo_atual_p bigint, nr_seq_analise_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_motivo_lib_w bigint, --parecer 
 nr_glosa_oc_criada_p INOUT bigint, ie_commitar_p text, ie_lib_demais_glosas_p text, ie_acao_p text) AS $body$
DECLARE

 
/* ie_acao_p 
	"S" - Substituir item 
	null - Outros */
 
 
ds_observacao_w			varchar(4000);
ds_parecer_w			varchar(4000);
ds_observacao_ww		varchar(4000);
ds_motivo_liberacao_w		varchar(255);
ds_tipo_motivo_w		varchar(255);
ds_ocorrencia_w			varchar(255);
ds_glosa_w			varchar(255);
nm_usuario_nrec_w		varchar(20);
cd_glosa_oc_w			varchar(10);
vl_parametro_20_w		varchar(2);
ie_tipo_item_w			varchar(1);
ie_tipo_w			varchar(1);
ie_tipo_motivo_w		varchar(1);
ie_tipo_glosa_oc_w		varchar(1);
ie_tipo_item_ww			varchar(1);
ie_situacao_w			varchar(1);
ie_status_w			varchar(1);
ie_tipo_motivo_ww		varchar(1);
ie_calculo_base_glosa_w		varchar(1);
ie_valor_base_w			varchar(1);
ie_pagamento_w			varchar(1);
vl_glosa_w			double precision;
vl_liberado_w			double precision;
vl_glosa_ww			double precision;
vl_glosa_co_w			double precision;
vl_glosa_hi_w			double precision;
vl_glosa_mat_w			double precision;
vl_lib_co_w			double precision;
vl_lib_hi_w			double precision;
vl_lib_mat_w			double precision;
vl_apres_co_w			double precision;
vl_apres_hi_w			double precision;
vl_apres_material_w		double precision;
vl_unitario_apres_w		double precision;
vl_unitario_calc_w		double precision;
vl_calculado_hi_w		double precision;
vl_liberado_hi_w		double precision;
vl_liberado_material_w		double precision;
vl_glosa_material_w		double precision;
vl_liberado_co_w		double precision;
vl_calculado_hi_ww		double precision;
vl_calculado_w			double precision;
vl_glosado_w			double precision := 0;
vl_total_apresentado_w		double precision;
qt_liberado_w			double precision;
qt_liberada_w			double precision;
qt_apresentado_ww		double precision;
qt_glosada_w			double precision := 0;
nr_seq_conta_w			bigint;
qt_apresentado_w		bigint;
nr_seq_segurado_w		bigint;
nr_seq_glosa_vinculada_w	bigint;		
nr_seq_ocorrencia_benef_w	bigint;
nr_seq_glosa_w			bigint;
nr_seq_conta_proc_w		bigint;
nr_seq_conta_mat_w		bigint;
nr_seq_partic_proc_w		bigint;
nr_seq_item_w			bigint;
nr_seq_mot_liberacao_w		bigint;
nr_seq_item_glosa_oc_w		bigint;
nr_seq_proc_partic_w		bigint;
nr_seq_ocorrencia_w		bigint;
nr_seq_motivo_glosa_w		bigint;
nr_seq_ocor_w			bigint;
ie_tipo_historico_w		bigint;
nr_seq_analise_pos_w		bigint;
nr_seq_motivo_w			bigint;
nr_seq_conta_ww			bigint;
nr_seq_conta_mat_ww		bigint;
nr_seq_conta_proc_ww		bigint;
nr_seq_partic_proc_ww		bigint;
qt_glosa_w			bigint;
ie_origem_analise_w		bigint;
nr_seq_ordem_w			bigint;
nr_seq_partic_proc_www		bigint;
dt_atualizacao_nrec_w		timestamp;
nr_seq_conta_aux_w		bigint;
vl_glosa_partic_w		double precision;
nr_seq_partic_item_w		bigint;
nr_seq_partic_ref_w		bigint;
qt_partic_w			integer := 0;

C01 CURSOR FOR 
	SELECT	ie_tipo,	 
		nr_sequencia,		 
		ie_status, 
		ie_situacao, 
		nr_seq_conta, 
		nr_seq_conta_mat, 
		nr_seq_conta_proc, 
		nr_seq_proc_partic, 
		vl_glosa, 
		qt_glosa		 
	from	pls_analise_conta_item 
	where	nr_seq_conta = nr_seq_conta_w 
	and	((nr_seq_conta_proc 	= nr_seq_conta_proc_w) 
	or (nr_seq_conta_mat 	= nr_seq_conta_mat_w) 
	or (nr_seq_proc_partic 	= nr_seq_partic_proc_w)) 
	and	ie_status 		not in ('I', 'E', 'C') 
	and	nr_sequencia 		<> nr_glosa_oc_criada_p 
	order by 1;

C03 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_conta 
	where	nr_seq_analise = nr_seq_analise_p 
	order by 1;
C02 CURSOR FOR
	SELECT	nr_sequencia 
	from	pls_conta 
	where	nr_seq_analise = nr_seq_analise_p 
	order by 1;
	
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Inserir uma glosa para o item em questão, inserir paracer. histórico e log para esta ação atualizar a via de acesso, informações do item e status do item e de pagamento/faturamento do item 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ X ] Objetos do dicionário [ X ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: esta rotina possui ie_commitar_p 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
	 

BEGIN 
vl_parametro_20_w := Obter_Param_Usuario(1317, 20, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, vl_parametro_20_w);
 
 
select	max(ie_calculo_base_glosa) 
into STRICT	ie_calculo_base_glosa_w 
from	pls_parametros 
where	cd_estabelecimento	= cd_estabelecimento_p;
 
if (coalesce(nr_seq_motivo_glosa_p,0) > 0) then 
	/*Obter dados da glosa*/
 
	begin 
	select	cd_motivo_tiss, 
		'G', 
		ds_motivo_tiss 
	into STRICT	cd_glosa_oc_w, 
		ie_tipo_w, 
		ds_glosa_w 
	from	tiss_motivo_glosa 
	where	nr_sequencia	= nr_seq_motivo_glosa_p;
	exception 
	when others then 
		cd_glosa_oc_w	:= 0;
	end;
elsif (coalesce(nr_seq_ocorrencia_p,0) > 0) then 
	begin 
	select	cd_ocorrencia, 
		'O', 
		nr_seq_motivo_glosa, 
		ds_ocorrencia 
	into STRICT	cd_glosa_oc_w, 
		ie_tipo_w, 
		nr_seq_glosa_vinculada_w, 
		ds_ocorrencia_w 
	from	pls_ocorrencia 
	where	nr_sequencia	= nr_seq_ocorrencia_p;
	exception 
	when others then 
		cd_glosa_oc_w	:= 0;
	end;	
else 
	goto final;
end if;
 
/*Obter os dados do item*/
 
select	ie_tipo_item, 
	vl_calculado, 
	dividir_sem_round(vl_calculado,qt_apresentado), 
	vl_unitario_apres, 
	qt_apresentado,	 
	vl_total_apres, 
	nr_seq_partic_proc, 
	nr_seq_conta_proc, 
	nr_seq_conta_mat, 
	nr_seq_conta, 
	ie_valor_base, 
	vl_calculado_hi, 
	vl_liberado_hi 
into STRICT	ie_tipo_item_w, 
	vl_calculado_w, 
	vl_unitario_calc_w, 
	vl_unitario_apres_w, 
	qt_apresentado_w,	 
	vl_total_apresentado_w, 
	nr_seq_partic_proc_w, 
	nr_seq_conta_proc_w, 
	nr_seq_conta_mat_w, 
	nr_seq_conta_w, 
	ie_valor_base_w, 
	vl_calculado_hi_w, 
	vl_liberado_hi_w 
from	w_pls_resumo_conta 
where	nr_sequencia	= nr_seq_item_analise_p;
 
CALL pls_atualizar_via_acesso_conta(nr_seq_conta_w, nm_usuario_p);
 
select	max(nr_seq_segurado) 
into STRICT	nr_seq_segurado_w 
from	pls_conta 
where	nr_sequencia	= nr_seq_conta_w;
 
if (coalesce(qt_liberada_p,0) > 0) then 
 
	qt_glosada_w	:= qt_apresentado_w - qt_liberada_p;
 
	ds_observacao_ww := ds_observacao_ww||chr(13)||chr(10)||'Glosa parcial'||chr(13)||chr(10)||'Qt. glosada: '||Campo_Mascara_virgula_casas(qt_glosada_w,4)||chr(13)||chr(10);
	 
	if (coalesce(ie_calculo_base_glosa_w,'N') = 'S') and (coalesce(vl_total_apresentado_w,0) = 0) then 
		vl_glosado_w	:= vl_calculado_w - (vl_unitario_apres_w * qt_liberada_p);
	else 
		vl_glosado_w	:= vl_total_apresentado_w - (vl_unitario_apres_w * qt_liberada_p);
	end if;
	 
elsif (coalesce(vl_liberado_p,0) > 0) then 
 
	if (coalesce(ie_calculo_base_glosa_w,'N') = 'S') and (coalesce(vl_total_apresentado_w,0) = 0) then 
		vl_glosado_w	:= vl_calculado_w - vl_liberado_p;
	else 
		vl_glosado_w	:= vl_total_apresentado_w - vl_liberado_p;
	end if;
	 
	ds_observacao_ww := ds_observacao_ww||chr(13)||chr(10)||'Glosa parcial'||chr(13)||chr(10)||'Vl. glosado: '||Campo_Mascara_virgula_casas(vl_glosado_w,2)||chr(13)||chr(10);
else 
	qt_glosada_w	:= qt_apresentado_w - qt_liberada_p;
 
	if (coalesce(ie_calculo_base_glosa_w,'N') = 'S') and (coalesce(vl_total_apresentado_w,0) = 0) 	 then 
		vl_glosado_w	:= vl_calculado_w - vl_liberado_p;
	else 
		vl_glosado_w	:= vl_total_apresentado_w - vl_liberado_p;
	end if;
	 
	ds_observacao_ww	:= ds_observacao_ww||chr(13)||chr(10)||'Glosa Total'||chr(13)||chr(10);
end if;
 
if (coalesce(nr_seq_motivo_glosa_p,0) > 0) then 
 
	CALL pls_gravar_conta_glosa(	cd_glosa_oc_w, null, nr_seq_conta_proc_w, 
				nr_seq_conta_mat_w, 'N', 'Glosa inserida pelo auditor ' || obter_nome_usuario(nm_usuario_p), 
				nm_usuario_p, 'A', 'SCE', 
				null, cd_estabelecimento_p, null, nr_seq_partic_proc_w, qt_glosada_w);
 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_glosa_w 
	from	pls_conta_glosa 
	where	((nr_seq_conta_proc 	= nr_seq_conta_proc_w) 
	or (nr_seq_conta_mat 	= nr_seq_conta_mat_w) 
	or (nr_seq_proc_partic	= nr_seq_partic_proc_w));
 
	ds_observacao_ww := 'Glosa inserida: ' || cd_glosa_oc_w || ' - ' || ds_glosa_w;
	 
elsif (coalesce(nr_seq_ocorrencia_p,0) > 0) then 
 
	nr_seq_ocorrencia_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_w, nr_seq_ocorrencia_p, null, null, nr_seq_conta_w, nr_seq_conta_proc_w, nr_seq_conta_mat_w, null, nm_usuario_p, 'Ocorrência inserida pelo auditor '||obter_nome_usuario(nm_usuario_p), nr_seq_glosa_vinculada_w, 3, cd_estabelecimento_p, 'N', null, nr_seq_ocorrencia_benef_w, null, nr_seq_partic_proc_w, null, null);
				 
	ds_observacao_ww	:= 'Ocorrência inserida: ' || cd_glosa_oc_w || ' - ' || ds_ocorrencia_w;
end if;
 
 
if	((coalesce(nr_seq_glosa_w,0) <> 0 ) or (coalesce(nr_seq_ocorrencia_benef_w,0) <> 0 )) then 
 
	nr_glosa_oc_criada_p := pls_atual_analise_conta_item(	nr_seq_item_analise_p, nr_seq_conta_w, nr_seq_conta_proc_w, nr_seq_conta_mat_w, nr_seq_partic_proc_w, nr_seq_glosa_w, nr_seq_ocorrencia_benef_w, qt_glosada_w, vl_glosado_w, cd_estabelecimento_p, nm_usuario_p, nr_seq_analise_p, nr_glosa_oc_criada_p);
end if;
 
select 	CASE WHEN ie_tipo_item_w='R' THEN nr_seq_partic_proc_w WHEN ie_tipo_item_w='P' THEN  nr_seq_conta_proc_w WHEN ie_tipo_item_w='M' THEN  nr_seq_conta_mat_w END  
into STRICT 	nr_seq_item_w
;
 
ds_observacao_ww	:= ds_observacao_ww||'Observação/Parecer: '||ds_observacao_p;
 
CALL pls_inserir_hist_analise(nr_seq_conta_w, nr_seq_analise_p, 3, nr_seq_item_w, ie_tipo_item_w, nr_seq_ocorrencia_benef_w, 
			nr_seq_glosa_w, ds_observacao_ww, nr_seq_grupo_atual_p, nm_usuario_p, cd_estabelecimento_p);
			 
if (coalesce(ie_lib_demais_glosas_p,'S') = 'S') or (coalesce(vl_parametro_20_w,'N') = 'N') then 
	/*Obter o motivo de liberação padrão para liberação manual.*/
 
	if (coalesce(ie_lib_demais_glosas_p,'S') = 'S') then 
		begin 
		/* Caso a ação seja 'N' será verificado o campo IE_GLOSA_MANUAL no subselect do NR_SEQUENCIA, caso seja 'N' será verificado o campo IE_SUBSTITUI_ITEM no mesmo*/
 
		if (ie_acao_p = 'N' or coalesce(ie_acao_p::text, '') = '') then 
			select	nr_sequencia, 
				ie_tipo_motivo, 
				ds_motivo_liberacao 
			into STRICT	nr_seq_mot_liberacao_w, 
				ie_tipo_motivo_w, 
				ds_motivo_liberacao_w 
			from	pls_mot_lib_analise_conta 
			where	nr_sequencia	=	(SELECT	max(nr_sequencia) 
							from	pls_mot_lib_analise_conta 
							where	coalesce(ie_glosa_manual,'N') = 'S' 
							and	ie_tipo_motivo = 'S');
		else 
			select	nr_sequencia, 
				ie_tipo_motivo, 
				ds_motivo_liberacao 
			into STRICT	nr_seq_mot_liberacao_w, 
				ie_tipo_motivo_w, 
				ds_motivo_liberacao_w 
			from	pls_mot_lib_analise_conta 
			where	nr_sequencia	=	(SELECT	max(nr_sequencia) 
							from	pls_mot_lib_analise_conta 
							where	coalesce(ie_substitui_item,'N') = 'S' 
							and	ie_tipo_motivo = 'S');
		end if;
		exception 
		when others then 
			nr_seq_mot_liberacao_w	:= null;
			ie_tipo_motivo_w	:= null;
		end;
 
		if (ie_tipo_motivo_w = 'N') then 
			ds_tipo_motivo_w	:= 'Liberação desfavorável';
		else 
			ds_tipo_motivo_w	:= 'Liberação favorável';
		end if;
 
		/*Se o motivo de liberação manual não existe, o processo não pode continuar. */
 
		if (coalesce(nr_seq_mot_liberacao_w,0) = 0) then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(176126);
			--'Não existe motivo padrão de liberação de glosas/ocorrências para glosa manual. O motivo de liberação citado, é o campo "Glosa manual", dos "Cadastros gerais / Plano de Saúde / Contas médicas / Motivos de liberação da análise da conta"' 
		end if;
 
		open C01;
		loop 
		fetch C01 into 
			ie_tipo_glosa_oc_w, 
			nr_seq_item_glosa_oc_w,	 
			ie_status_w, 
			ie_situacao_w,	 
			nr_seq_conta_ww, 
			nr_seq_conta_mat_ww, 
			nr_seq_conta_proc_ww, 
			nr_seq_partic_proc_ww, 
			vl_glosa_w, 
			qt_glosa_w;	
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			/*Apagar o log anterior*/
 
			delete	FROM pls_analise_conta_item_log 
			where	nr_seq_analise_item 	= nr_seq_item_glosa_oc_w 
			and	ie_tipo_log		= 'G';
			 
			begin 
			select	dt_atualizacao_nrec, 
				ds_parecer, 
				nr_seq_motivo, 
				nm_usuario_nrec, 
				ie_tipo_motivo 
			into STRICT	dt_atualizacao_nrec_w, 
				ds_parecer_w, 
				nr_seq_motivo_w, 
				nm_usuario_nrec_w, 
				ie_tipo_motivo_ww 
			from	pls_analise_parecer_item 
			where	nr_seq_item	= nr_seq_item_glosa_oc_w;
			exception 
			when others then 
				dt_atualizacao_nrec_w	:= null;
				ds_parecer_w		:= null;
				nr_seq_motivo_w		:= null;
			end;	
			 
			/*Cria o log do item (será utilizado no desfazer)*/
 
			insert into pls_analise_conta_item_log(nr_sequencia, 
				nr_seq_analise_item, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				dt_log, 
				ie_status, 
				ie_situacao, 
				nr_seq_motivo_liberacao, 
				ds_obsevacao_anterior, 
				nm_usuario_liberacao, 
				dt_liberacao_anterior, 
				vl_glosa, 
				qt_glosa, 
				ie_tipo_log) 
			values (nextval('pls_analise_conta_item_log_seq'), 
				nr_seq_item_glosa_oc_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p,			 
				clock_timestamp(), 
				ie_status_w, 
				ie_situacao_w,			 
				nr_seq_motivo_w, 
				ds_parecer_w, 
				nm_usuario_nrec_w, 
				dt_atualizacao_nrec_w, 
				vl_glosa_w, 
				qt_glosa_w, 
				'G');	
			 
			/*Desfeita qualquer liberação que pode ter ocorrido préviamente*/
 
			/*Apagar parecer*/
 
			delete	FROM pls_analise_parecer_item 
			where	nr_seq_item	= nr_seq_item_glosa_oc_w;	
			 
			select	nr_seq_ocorrencia, 
				nr_seq_glosa 
			into STRICT	nr_seq_ocorrencia_w, 
				nr_seq_glosa_w 
			from	pls_analise_conta_item 
			where 	nr_sequencia	= nr_seq_item_glosa_oc_w;
			 
			/*Obtem o tipo de histórico se é uma liberação de glosa ou de ocorrencia*/
 
			select	CASE WHEN ie_tipo_glosa_oc_w='G' THEN  5 WHEN ie_tipo_glosa_oc_w='O' THEN  6 END  
			into STRICT	ie_tipo_historico_w 
			;
			 
			if (coalesce(nr_seq_conta_proc_w,0) = 0) and (coalesce(nr_seq_conta_mat_w,0) = 0) and (coalesce(nr_seq_partic_proc_w,0) = 0)then 
				qt_glosa_w	:= 0;
				vl_glosa_w	:= 0;
			else		 
				qt_glosa_w			:= coalesce(qt_apresentado_w,0);
				 
				/*Diego OS - 392753 - Nos casos onde o valor apresentado for zero e o sistema deve considerar o calculado para valor de glosa. */
 
				if (coalesce(ie_calculo_base_glosa_w,'N') = 'S') and (coalesce(vl_total_apresentado_w,0) = 0) then		 
					vl_glosa_w 	:= coalesce(vl_calculado_w,0);			
				else 
					vl_glosa_w 	:= coalesce(vl_total_apresentado_w,0);
				end if;
			end if;
 
			/*Atualizado a glosa / ocorrencia*/
 
			update	pls_analise_conta_item 
			set	ie_status 		= CASE WHEN ie_tipo_motivo_w='S' THEN  'A'  ELSE 'N' END , 
				nm_usuario		= nm_usuario_p, 
				dt_atualizacao 		= clock_timestamp(), 
				ie_consistencia 	= 'N', 
				ie_principal		= 'N', 
				qt_glosa		= qt_glosa_w, 
				vl_glosa		= vl_glosa_w, 
				ie_situacao		= CASE WHEN ie_tipo_motivo_w='N' THEN  'A' WHEN ie_tipo_motivo_w='L' THEN  'A' WHEN ie_tipo_motivo_w='S' THEN  'I' END , 
				nr_seq_glosa_manual 	= nr_glosa_oc_criada_p 
			where	nr_sequencia		= nr_seq_item_glosa_oc_w 
			and	ie_status		not in ('I','A');
 
			/*Criado o parecer*/
 
			insert into pls_analise_parecer_item(nr_sequencia, 
				nr_seq_item, 
				nr_seq_motivo, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				ds_parecer, 
				ie_tipo_motivo)			 
			values (nextval('pls_analise_parecer_item_seq'), 
				nr_seq_item_glosa_oc_w, 
				nr_seq_mot_liberacao_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				'Parecer criado automáticamente pelo sistema na glosa/ocorrência manual.', 
				ie_tipo_motivo_w);		
			 
			ds_observacao_w	:= 	'Tipo de liberação: '||chr(13)||chr(10)|| 
						chr(9)||ds_tipo_motivo_w||chr(13)||chr(10)||chr(13)||chr(10)|| 
						'Motivo de liberação:'||chr(13)||chr(10)|| 
						chr(9)||ds_motivo_liberacao_w||chr(13)||chr(10)||chr(13)||chr(10)|| 
						'Observação/Parecer: '||chr(13)||chr(10)|| 
						chr(9)||'Parecer criado automáticamente pelo sistema na glosa/ocorrência manual.';
						 
			/*Adiciona o histórico da ação*/
 
			CALL pls_inserir_hist_analise(nr_seq_conta_w, nr_seq_analise_p, ie_tipo_historico_w, 
						 coalesce(nr_seq_ocorrencia_w, nr_seq_glosa_w), ie_tipo_item_ww, nr_seq_ocorrencia_w, 
						 nr_seq_glosa_w, ds_observacao_w, nr_seq_grupo_atual_p, 
						 nm_usuario_p, cd_estabelecimento_p);
 
			end;			
			/*incluído a atualização da análise, para que os valores de participante sejam atualizados após a pls_análise_status_pgto Diogo*/
				 
		end loop;
		close C01;
	end if;
	 
	if (coalesce(vl_parametro_20_w,'N') = 'N') then 
		if (coalesce(qt_liberada_p,0) > 0) then 
			if (coalesce(ie_valor_base_w,'1') = '1') then 
				vl_liberado_w	:= round((vl_unitario_apres_w * qt_liberada_p)::numeric,2);
			else 
				vl_liberado_w	:= round((vl_unitario_calc_w * qt_liberada_p)::numeric,2);
			end if;
				 
			qt_liberado_w	:= qt_liberada_p;
			vl_lib_hi_w 	:= null;
			vl_lib_co_w 	:= null;
			vl_lib_mat_w 	:= null;			
		elsif (coalesce(vl_liberado_p,0) > 0) then 
			vl_liberado_w	:= vl_liberado_p;
			qt_liberado_w	:= qt_apresentado_w;
			vl_lib_hi_w 	:= vl_lib_hi_p;
			vl_lib_co_w 	:= vl_lib_co_p;
			vl_lib_mat_w 	:= vl_lib_mat_p;
		else 
			vl_liberado_w	:= 0;
			qt_liberado_w	:= 0;
			vl_lib_hi_w 	:= 0;
			vl_lib_co_w 	:= 0;
			vl_lib_mat_w 	:= 0;
		end if;		
 
		select	max(a.nr_seq_ordem) 
		into STRICT	nr_seq_ordem_w 
		from	pls_tempo_conta_grupo		b, 
			pls_auditoria_conta_grupo	a 
		where	a.nr_sequencia		= b.nr_seq_auditoria 
		and	a.nr_seq_analise	= nr_seq_analise_p 
		and	a.nr_seq_grupo		= nr_seq_grupo_atual_p 
		and	coalesce(a.dt_liberacao::text, '') = '' 
		and	(b.dt_inicio_analise IS NOT NULL AND b.dt_inicio_analise::text <> '') 
		and	coalesce(b.dt_final_analise::text, '') = '';		
		 
		SELECT * FROM pls_obter_valores_lib_analise(	nr_seq_item_analise_p, cd_estabelecimento_p, vl_glosa_w, vl_liberado_w, qt_liberado_w, vl_lib_co_w, vl_lib_mat_w, vl_lib_hi_w, vl_glosa_co_w, vl_glosa_mat_w, vl_glosa_hi_w) INTO STRICT vl_glosa_w, vl_liberado_w, qt_liberado_w, vl_lib_co_w, vl_lib_mat_w, vl_lib_hi_w, vl_glosa_co_w, vl_glosa_mat_w, vl_glosa_hi_w;	
		 
		if (coalesce(vl_glosa_w,0) = 0) and (coalesce(vl_liberado_w,0)	> 0) then 
			ie_pagamento_w	:= 	'L';
		elsif (coalesce(vl_glosa_w,0) > 0) and (coalesce(vl_liberado_w,0) > 0) then 
			ie_pagamento_w	:= 	'P';
		else 
			ie_pagamento_w	:= 	'G';
		end if;		
		 
		insert into pls_analise_fluxo_item(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			vl_total, 
			nr_seq_analise, 
			nr_seq_grupo, 
			nr_seq_conta_proc, 
			nr_seq_conta_mat, 
			nr_seq_proc_partic, 
			vl_glosa, 
			vl_liberado_hi, 
			vl_liberado_co, 
			vl_liberado_material, 
			vl_glosa_co, 
			vl_glosa_hi, 
			vl_glosa_material, 
			nr_seq_ordem, 
			qt_liberada, 
			ie_pagamento, 
			nr_seq_glosa_item) 
		values (nextval('pls_analise_fluxo_item_seq'), 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			vl_liberado_w, 
			nr_seq_analise_p, 
			nr_seq_grupo_atual_p, 
			nr_seq_conta_proc_w, 
			nr_seq_conta_mat_w, 
			nr_seq_partic_proc_w, 
			vl_glosa_w, 
			vl_lib_hi_w, 
			vl_lib_co_w, 
			vl_lib_mat_w, 
			vl_glosa_co_w, 
			vl_glosa_hi_w, 
			vl_glosa_mat_w, 
			nr_seq_ordem_w, 
			qt_liberado_w, 
			ie_pagamento_w, 
			nr_glosa_oc_criada_p);
			 
		if (coalesce(nr_seq_partic_proc_w,0) = 0) and (coalesce(nr_seq_conta_proc_w,0) > 0) then 
			 
			select	count(1) 
			into STRICT	qt_partic_w 
			from	w_pls_resumo_conta 
			where	nr_seq_item_ref = nr_seq_conta_proc_w 
			and	(nr_seq_partic_proc IS NOT NULL AND nr_seq_partic_proc::text <> '') 
			and	coalesce(ie_fluxo_com_glosa,'X') <> 'P';
			 
			if (qt_partic_w = 1) then 
			 
				select	max(nr_sequencia), 
					max(nr_seq_partic_proc) 
				into STRICT	nr_seq_partic_item_w, 
					nr_seq_partic_ref_w 
				from	w_pls_resumo_conta 
				where	nr_seq_item_ref = nr_seq_conta_proc_w 
				and	(nr_seq_partic_proc IS NOT NULL AND nr_seq_partic_proc::text <> '') 
				and	coalesce(ie_fluxo_com_glosa,'X') <> 'P';
				 
				insert into pls_analise_fluxo_item(nr_sequencia, 
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					vl_total, 
					nr_seq_analise, 
					nr_seq_grupo, 
					nr_seq_conta_proc, 
					nr_seq_conta_mat, 
					nr_seq_proc_partic, 
					vl_glosa, 
					vl_liberado_hi, 
					vl_liberado_co, 
					vl_liberado_material, 
					vl_glosa_co, 
					vl_glosa_hi, 
					vl_glosa_material, 
					nr_seq_ordem, 
					qt_liberada, 
					ie_pagamento, 
					nr_seq_glosa_item) 
				values (nextval('pls_analise_fluxo_item_seq'), 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					vl_liberado_w, 
					nr_seq_analise_p, 
					nr_seq_grupo_atual_p, 
					nr_seq_conta_proc_w, 
					nr_seq_conta_mat_w, 
					nr_seq_partic_ref_w, 
					vl_glosa_w, 
					vl_lib_hi_w, 
					vl_lib_co_w, 
					vl_lib_mat_w, 
					vl_glosa_co_w, 
					vl_glosa_hi_w, 
					vl_glosa_mat_w, 
					nr_seq_ordem_w, 
					qt_liberado_w, 
					ie_pagamento_w, 
					nr_glosa_oc_criada_p);
			end if;
		end if;
	end if;
end if;
 
/*Necessário rodar a status pegto antes e depois pois a mesma ajusta o valor liberado, é necessário para aplicar o percentual correto sobre os itens após a glosa do mesmo Diogo*/
 
CALL pls_analise_status_pgto(nr_seq_conta_aux_w, nr_seq_conta_mat_w, nr_seq_conta_proc_w, nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p, nr_seq_partic_proc_w, 'S', null, null);
 
/*Se o item possui analises de pós deve ser atualizado o mesmo*/
 
select	max(nr_sequencia) 
into STRICT	nr_seq_analise_pos_w 
from	pls_analise_conta 
where	nr_seq_analise_ref = nr_seq_analise_p;	
 
if (coalesce(nr_seq_analise_pos_w,0) > 0) then 
	CALL pls_analise_status_fat(nr_seq_conta_w, nr_seq_conta_mat_w, nr_seq_conta_proc_w, nr_seq_analise_pos_w, cd_estabelecimento_p, nm_usuario_p);						
	 
	CALL pls_analise_status_pgto_pos(nr_seq_conta_w, nr_seq_conta_mat_w, nr_seq_conta_proc_w, nr_seq_analise_pos_w, cd_estabelecimento_p, nm_usuario_p);	
end if;
 
/*Para o caso de já se criar a glosa com alguma liberação.*/
 
if (coalesce(nr_seq_motivo_lib_w,0) > 0) then					 
	CALL pls_conta_liberar_glosa_oc(nr_glosa_oc_criada_p, nr_seq_analise_p, nr_seq_motivo_lib_w, ds_observacao_p, nm_usuario_p, cd_estabelecimento_p, nr_seq_grupo_atual_p, 'N', 'N','N');
end if;
 
update	w_pls_resumo_conta 
set	nm_usuario_glosa 	= nm_usuario_p, 
	nm_usuario_liberacao 	= '', 
	ie_fluxo_com_glosa	= 'S' 
where	nr_sequencia	 	= nr_seq_item_analise_p;
 
<<final>> 
null;
 
if (coalesce(ie_commitar_p,'S') = 'S') then 
	commit;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_grava_glosa_analise_conta ( nr_seq_motivo_glosa_p bigint, nr_seq_ocorrencia_p bigint, nr_seq_item_analise_p bigint, qt_liberada_p bigint, vl_liberado_p bigint, vl_lib_co_p bigint, vl_lib_hi_p bigint, vl_lib_mat_p bigint, ds_observacao_p text, nr_seq_grupo_atual_p bigint, nr_seq_analise_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_motivo_lib_w bigint, nr_glosa_oc_criada_p INOUT bigint, ie_commitar_p text, ie_lib_demais_glosas_p text, ie_acao_p text) FROM PUBLIC;
