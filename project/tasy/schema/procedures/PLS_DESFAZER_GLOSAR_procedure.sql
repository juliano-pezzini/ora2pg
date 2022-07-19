-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_glosar ( nr_seq_item_resumo_p bigint, nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text ) AS $body$
DECLARE

 
nr_seq_glosa_manual_w		bigint;
nr_seq_conta_mat_w			bigint;
nr_seq_conta_proc_w			bigint;
nr_seq_conta_w				bigint;
nr_seq_glosa_w				bigint;
nr_seq_ocorrencia_benef_w	bigint;
nr_seq_partic_proc_w		bigint;
nr_seq_item_w				bigint;
nr_seq_ocorrencia_w			bigint;
nr_seq_conta_ww				bigint;
nr_seq_conta_mat_ww			bigint;
nr_seq_conta_proc_ww		bigint;
nr_seq_partic_proc_ww		bigint;
nr_seq_motivo_liberacao_w	bigint;
qt_glosa_w					bigint := 0;
vl_glosa_w					double precision := 0;
nr_seq_mot_lib_analise_conta_w	bigint;
ds_obsevacao_anterior_w		varchar(4000);
nm_usuario_liberacao_w		varchar(15);
ie_situacao_w				varchar(1);
ie_status_w					varchar(1);
ie_tipo_motivo_w			varchar(1);
ie_origem_analise_w			bigint;
dt_liberacao_anterior_w		timestamp;
				
C01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
			a.nr_seq_glosa, 
			a.nr_seq_ocorrencia, 
			a.nr_seq_conta, 
			a.nr_seq_conta_mat, 
			a.nr_seq_conta_proc, 
			a.nr_seq_proc_partic, 
			a.nr_seq_glosa_manual 
	from	pls_analise_conta_item a 
	where	nr_seq_w_resumo_conta = nr_seq_item_resumo_p;	
				 

BEGIN 
	 
open C01;
loop 
fetch C01 into	 
	nr_seq_item_w,	 
	nr_seq_glosa_w, 
	nr_seq_ocorrencia_benef_w, 
	nr_seq_conta_ww, 
	nr_seq_conta_mat_ww, 
	nr_seq_conta_proc_ww, 
	nr_seq_partic_proc_ww, 
	nr_seq_glosa_manual_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	delete	FROM pls_analise_parecer_item 
	where	nr_seq_item = nr_seq_item_w;	
	 
	if (coalesce(nr_seq_glosa_manual_w,0) > 0) then 
		begin 
		select	a.ie_status, 
				a.ie_situacao, 
				a.nr_seq_motivo_liberacao, 
				a.ds_obsevacao_anterior, 
				a.nm_usuario_liberacao, 
				a.dt_liberacao_anterior, 
				a.vl_glosa, 
				a.qt_glosa, 
				'' 
		into STRICT	ie_status_w, 
				ie_situacao_w, 
				nr_seq_motivo_liberacao_w, 
				ds_obsevacao_anterior_w, 
				nm_usuario_liberacao_w, 
				dt_liberacao_anterior_w, 
				vl_glosa_w, 
				qt_glosa_w, 
				ie_tipo_motivo_w 
		from	pls_analise_conta_item_log a 
		where	a.nr_seq_analise_item = nr_seq_item_w 
		and	a.ie_tipo_log = 'G';
 
		insert into pls_analise_parecer_item(	ds_parecer, dt_atualizacao, dt_atualizacao_nrec, 
					ie_tipo_motivo, nm_usuario, nm_usuario_nrec, 
					nr_seq_item, nr_seq_motivo, nr_sequencia	) 
		values (	ds_obsevacao_anterior_w, clock_timestamp(), dt_liberacao_anterior_w, 
				'', nm_usuario_p, nm_usuario_liberacao_w, 
				nr_seq_item_w, nr_seq_motivo_liberacao_w, nextval('pls_analise_parecer_item_seq')	);
		exception 
		when others then	 
			ie_status_w					:= null;
			ie_situacao_w				:= null;
			nr_seq_motivo_liberacao_w	:= null;
			ds_obsevacao_anterior_w		:= null;
			nm_usuario_liberacao_w		:= null;
			dt_liberacao_anterior_w		:= null;
			vl_glosa_w					:= null;
			qt_glosa_w					:= null;
			ie_tipo_motivo_w			:= null;
		end;			
	else 
		select	max(nr_sequencia) 
		into STRICT	nr_seq_mot_lib_analise_conta_w 
		from	pls_mot_lib_analise_conta 
		where	coalesce(ie_glosa_manual,'N') = 'N';
		 
		select	CASE WHEN ie_tipo_motivo='S' THEN  'A' WHEN ie_tipo_motivo='N' THEN  'N' END , 
			ie_tipo_motivo 
		into STRICT	ie_status_w, 
			ie_tipo_motivo_w 
		from	pls_mot_lib_analise_conta 
		where	nr_sequencia = nr_seq_mot_lib_analise_conta_w;		
		 
		insert into pls_analise_parecer_item(	ds_parecer, dt_atualizacao, dt_atualizacao_nrec, 
					ie_tipo_motivo, nm_usuario, nm_usuario_nrec, 
					nr_seq_item, nr_seq_motivo, nr_sequencia	) 
		values (	'Parecer automático por uso da opção "Desfazer glosar" ', clock_timestamp(), clock_timestamp(), 
				ie_tipo_motivo_w, nm_usuario_p, nm_usuario_p, 
				nr_seq_item_w, nr_seq_mot_lib_analise_conta_w, nextval('pls_analise_parecer_item_seq')	);
		 
		ie_situacao_w	:= 'I';
	end if;
	 
	/*Apagar o log anterior*/
 
	delete	FROM pls_analise_conta_item_log 
	where	nr_seq_analise_item 	= nr_seq_item_w 
	and	ie_tipo_log		= 'G';
	 
	/*Atualizado a glosa / ocorrencia*/
 
	update	pls_analise_conta_item 
	set	ie_status 			= coalesce(ie_status_w,'P'), 
		ie_situacao			= coalesce(ie_situacao_w,'A'), 
		nm_usuario			= nm_usuario_p, 
		dt_atualizacao 		= clock_timestamp(), 
		ie_consistencia 	= 'N', 
		vl_glosa			= vl_glosa_w, 
		qt_glosa			= qt_glosa_w, 
		nr_seq_glosa_manual	 = NULL 
	where	nr_sequencia	= nr_seq_item_w 
	and	ie_status	<> 'I';
	 
	CALL pls_analise_status_item(	nr_seq_conta_ww, nr_seq_conta_mat_ww, nr_seq_conta_proc_ww, 
					nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p, 
					nr_seq_partic_proc_ww	);
					 
	CALL pls_analise_status_pgto(	nr_seq_conta_ww, nr_seq_conta_mat_ww, nr_seq_conta_proc_ww,				 
					nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p, 
					nr_seq_partic_proc_ww, null, null, 
					null	);	
					 
	/*incluído a atualização da análise, para que os valores de participante sejam atualizados após a pls_análise_status_pgto Diogo*/
				 
	 
	select	max(ie_origem_analise) 
	into STRICT	ie_origem_analise_w 
	from	pls_analise_conta 
	where	nr_sequencia = nr_seq_analise_p;
 
	if (ie_origem_analise_w = 3) then 
		CALL pls_atual_w_resumo_conta_ptu(	nr_seq_conta_ww, null, null, 
						null, nr_seq_analise_p, nm_usuario_p	);
 
	else 
		CALL pls_atualiza_w_resumo_conta(	nr_seq_conta_ww, null, null, 
						null, nr_seq_analise_p, nm_usuario_p	);
	end if;	
	 
	end;		
end loop;
close C01;
	 
update	w_pls_resumo_conta 
set		nm_usuario_glosa 	= ''	 
where	nr_sequencia	 	= nr_seq_item_resumo_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_glosar ( nr_seq_item_resumo_p bigint, nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text ) FROM PUBLIC;

