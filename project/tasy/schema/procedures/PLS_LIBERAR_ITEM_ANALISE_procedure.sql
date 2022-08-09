-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_liberar_item_analise ( nr_seq_item_resumo_p bigint, nr_seq_analise_p bigint, nr_seq_mot_liberacao_p bigint, ds_observacao_p text, cd_estabelecimento_p bigint, nr_seq_grupo_atual_p bigint, nm_usuario_p text, ie_comitar_p text) AS $body$
DECLARE

 
/*PROCEDURE QUE IRA OBTER TODAS AS GLOSAS E OCORRÊNCIAS PENDETES AO USUÁRIO, NOS ITEN SELECIONADOS, E LIBERA-LAS*/
 
 
nr_seq_conta_mat_w		bigint;
nr_seq_conta_proc_w		bigint;
nr_seq_conta_w			bigint;
nr_seq_glosa_w			bigint;
nr_seq_ocorrencia_benef_w	bigint;
nr_seq_partic_proc_w		bigint;
nr_seq_item_w			bigint;
nr_seq_ocorrencia_w		bigint;
nr_seq_conta_ww			bigint;
nr_seq_conta_mat_ww		bigint;
nr_seq_conta_proc_ww		bigint;
nr_seq_partic_proc_ww		bigint;
nr_seq_motivo_w			bigint;
vl_glosa_w			double precision;
qt_glosa_w			bigint;
dt_atualizacao_nrec_w		timestamp;
ds_parecer_w			varchar(4000);
nm_usuario_nrec_w		varchar(15);
ie_situacao_w			varchar(1);
ie_status_w			varchar(1);
ie_origem_conta_w		varchar(1);
ie_tipo_motivo_w		varchar(1);
ie_status_item_w		varchar(1);
ie_analise_multipla_w		varchar(1)	:= 'N';
vl_liberado_co_w		double precision;
vl_liberado_material_w		double precision;
vl_liberado_hi_w		double precision;
vl_liberado_w			double precision;
qt_liberada_w			double precision;
vl_glosa_co_w			double precision;
vl_glosa_material_w		double precision;
vl_glosa_hi_w			double precision;
ie_valor_base_w			double precision;
vl_calculado_w			double precision;
qt_apresentado_w		double precision;
vl_total_apres_w		double precision;
nr_seq_ordem_w			bigint;
ie_abriu_cursor_w		varchar(1)	:= 'N';
ie_possui_perm_w		varchar(1)	:= 'N';
qt_liberado_conta_w		bigint;

/*Obter as glosas do ITEM*/
 
C01 CURSOR FOR 
	SELECT	nr_sequencia, 
		ie_status, 
		ie_situacao, 
		nr_seq_glosa, 
		nr_seq_ocorrencia, 
		nr_seq_conta, 
		nr_seq_conta_mat, 
		nr_seq_conta_proc, 
		nr_seq_proc_partic, 
		vl_glosa, 
		qt_glosa 
	from	pls_analise_conta_item 
	where	nr_seq_conta = nr_seq_conta_w	 
	and 	((nr_seq_conta_proc = nr_seq_conta_proc_w) or (nr_seq_conta_mat = nr_seq_conta_mat_w) or (nr_seq_proc_partic = nr_seq_partic_proc_w)) 
	and	coalesce(nr_seq_discussao::text, '') = '' 
	and	coalesce(nr_seq_conta_pos_estab::text, '') = '' 
	and	nr_seq_analise = nr_seq_analise_p;


BEGIN 
select	a.nr_seq_conta_mat, 
	a.nr_seq_conta_proc, 
	a.nr_seq_conta, 
	a.nr_seq_partic_proc, 
	b.ie_origem_conta, 
	a.ie_status,	 
	a.vl_total_apres, 
	a.vl_calculado, 
	a.ie_valor_base, 
	a.qt_apresentado 
into STRICT	nr_seq_conta_mat_w, 
	nr_seq_conta_proc_w, 
	nr_seq_conta_w, 
	nr_seq_partic_proc_w, 
	ie_origem_conta_w, 
	ie_status_item_w,	 
	vl_total_apres_w, 
	vl_calculado_w, 
	ie_valor_base_w, 
	qt_apresentado_w 
from	w_pls_resumo_conta a, 
	pls_analise_conta b 
where	a.nr_seq_analise = b.nr_sequencia 
and	a.nr_sequencia	 = nr_seq_item_resumo_p;
 
if (coalesce(ie_status_item_w,'X') <> 'C') then	 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_item_w, 
		ie_status_w, 
		ie_situacao_w, 
		nr_seq_glosa_w, 
		nr_seq_ocorrencia_benef_w, 
		nr_seq_conta_ww, 
		nr_seq_conta_mat_ww, 
		nr_seq_conta_proc_ww, 
		nr_seq_partic_proc_ww, 
		vl_glosa_w, 
		qt_glosa_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin		 
		ie_possui_perm_w := 'S';
		 
		/*Apagar o log anterior*/
 
		delete	FROM pls_analise_conta_item_log 
		where	nr_seq_analise_item	= nr_seq_item_w 
		and	coalesce(ie_tipo_log,'L')	= 'L';
			 
		if (coalesce(nr_seq_ocorrencia_benef_w,0) > 0) then 
 
			begin 
			select	nr_seq_ocorrencia 
			into STRICT	nr_seq_ocorrencia_w 
			from	pls_ocorrencia_benef 
			where	nr_sequencia = nr_seq_ocorrencia_benef_w;
			exception 
			when others then 
				nr_seq_ocorrencia_w := null;
			end;		
			 
			ie_possui_perm_w := pls_obter_se_auditor_lib_oc(nr_seq_ocorrencia_w, nm_usuario_p, nr_seq_grupo_atual_p, ie_origem_conta_w);
		end if;		
		 
		if (ie_possui_perm_w = 'S') then 
			ie_abriu_cursor_w	:= 'S';
		end if;
		 
		if (ie_status_w in ('P', 'L', 'N')) and (ie_possui_perm_w = 'S') then 
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
				ie_tipo_motivo_w 
			from	pls_analise_parecer_item 
			where	nr_seq_item = nr_seq_item_w;
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
				nr_seq_item_w, 
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
				'L');		
 
			/*Apagar o parecer de modo se este existir*/
 
			delete	FROM pls_analise_parecer_item 
			where	nr_seq_item	= nr_seq_item_w;	
			 
			/*Atualizado a glosa / ocorrencia*/
 
			update	pls_analise_conta_item 
			set	ie_status 		= 'A', 
				nm_usuario		= nm_usuario_p, 
				dt_atualizacao 		= clock_timestamp(), 
				ie_consistencia 	= 'N', 
				ie_situacao 		= 'I', --Inativada a glosa/ocorrencia 
				nr_seq_glosa_manual	 = NULL 
			where	nr_sequencia		= nr_seq_item_w 
			and	ie_status		<> 'I';
 
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
				nr_seq_item_w, 
				nr_seq_mot_liberacao_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				ds_observacao_p, 
				'A');								
		end if;		
		end;
	end loop;
	close C01;
 
	if (ie_abriu_cursor_w = 'S') then 
		/* Francisco e Diego - 20/06/2012 - Gravar liberação do grupo para o item */
 
		ie_analise_multipla_w := obter_param_usuario(1317, 20, null, nm_usuario_p, cd_estabelecimento_p, ie_analise_multipla_w);
		if (coalesce(ie_analise_multipla_w,'N') = 'N') then			 
			if (coalesce(ie_valor_base_w,'1') = '1') then 
				vl_liberado_w	:= vl_total_apres_w;
			else 
				vl_liberado_w	:= vl_calculado_w;
			end if;
				 
			qt_liberada_w		:= qt_apresentado_w;
			vl_liberado_hi_w 	:= null;
			vl_liberado_co_w 	:= null;
			vl_liberado_material_w 	:= null;				
			 
			SELECT * FROM pls_obter_valores_lib_analise(	nr_seq_item_resumo_p, cd_estabelecimento_p, vl_glosa_w, vl_liberado_w, qt_liberada_w, vl_liberado_co_w, vl_liberado_material_w, vl_liberado_hi_w, vl_glosa_co_w, vl_glosa_material_w, vl_glosa_hi_w) INTO STRICT vl_glosa_w, vl_liberado_w, qt_liberada_w, vl_liberado_co_w, vl_liberado_material_w, vl_liberado_hi_w, vl_glosa_co_w, vl_glosa_material_w, vl_glosa_hi_w;
			 
			select	max(a.nr_seq_ordem) 
			into STRICT	nr_seq_ordem_w 
			from	pls_tempo_conta_grupo b, 
				pls_auditoria_conta_grupo a 
			where	a.nr_sequencia		= b.nr_seq_auditoria 
			and	a.nr_seq_analise	= nr_seq_analise_p 
			and	a.nr_seq_grupo		= nr_seq_grupo_atual_p 
			and	coalesce(a.dt_liberacao::text, '') = '' 
			and	(b.dt_inicio_analise IS NOT NULL AND b.dt_inicio_analise::text <> '') 
			and	coalesce(b.dt_final_analise::text, '') = '';
			 
			if (nr_seq_ordem_w IS NOT NULL AND nr_seq_ordem_w::text <> '') then 
				insert into pls_analise_fluxo_item(nr_sequencia, 
					nm_usuario, 
					dt_atualizacao, 
					nm_usuario_nrec, 
					dt_atualizacao_nrec, 
					nr_seq_analise, 
					nr_seq_grupo, 
					nr_seq_conta_proc, 
					nr_seq_conta_mat, 
					nr_seq_proc_partic, 
					nr_seq_ordem, 
					vl_glosa, 
					vl_liberado_hi, 
					vl_liberado_co,  
					vl_liberado_material, 
					vl_total, 
					vl_glosa_co,  
					vl_glosa_hi, 
					vl_glosa_material, 
					qt_liberada, 
					ie_pagamento) 
				values (nextval('pls_analise_fluxo_item_seq'), 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					nr_seq_analise_p, 
					nr_seq_grupo_atual_p, 
					nr_seq_conta_proc_w, 
					nr_seq_conta_mat_w, 
					nr_seq_partic_proc_w, 
					nr_seq_ordem_w, 
					vl_glosa_w, 
					vl_liberado_hi_w, 
					vl_liberado_co_w,  
					vl_liberado_material_w, 
					vl_liberado_w, 
					vl_glosa_co_w,  
					vl_glosa_hi_w, 
					vl_glosa_material_w, 
					qt_liberada_w, 
					'L');
			end if;
		end if;
		 
		if (nr_seq_conta_proc_w IS NOT NULL AND nr_seq_conta_proc_w::text <> '') and (coalesce(qt_liberada_w,0) > 0) then 
			update	pls_conta_proc 
			set	ie_glosa	= 'N' 
			where	nr_sequencia	= nr_seq_conta_proc_w;
		end if;
		 
		CALL pls_analise_status_item(	nr_seq_conta_ww, nr_seq_conta_mat_ww, nr_seq_conta_proc_ww, 
						nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p, 
						nr_seq_partic_proc_ww	);			
			 
		CALL pls_analise_status_pgto(	nr_seq_conta_ww, nr_seq_conta_mat_ww, nr_seq_conta_proc_ww,				 
						nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p, 
						nr_seq_partic_proc_ww, null, null, 
						null	);
						 
		select	coalesce(sum(qt_liberado),0) 
		into STRICT	qt_liberado_conta_w 
		from	w_pls_resumo_conta 
		where	nr_seq_conta	= nr_seq_conta_ww;
 
		if (qt_liberado_conta_w = 0) then 
			update	pls_conta 
			set	ie_glosa	= 'S' 
			where	nr_sequencia	= nr_seq_conta_ww;
		else 
			update	pls_conta 
			set	ie_glosa	= 'N' 
			where	nr_sequencia	= nr_seq_conta_ww;
		end if;
	end if;
	 
	update	w_pls_resumo_conta 
	set	nm_usuario_liberacao 	= nm_usuario_p, 
		nm_usuario_glosa	= '' 
	where	nr_sequencia	 	= nr_seq_item_resumo_p;
 
	if (coalesce(ie_comitar_p,'S') = 'S') then 
		commit;
	end if;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_liberar_item_analise ( nr_seq_item_resumo_p bigint, nr_seq_analise_p bigint, nr_seq_mot_liberacao_p bigint, ds_observacao_p text, cd_estabelecimento_p bigint, nr_seq_grupo_atual_p bigint, nm_usuario_p text, ie_comitar_p text) FROM PUBLIC;
