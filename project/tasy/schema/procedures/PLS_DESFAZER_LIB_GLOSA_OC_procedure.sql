-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_lib_glosa_oc ( nr_seq_analise_conta_item_p bigint, nr_sequencia_p bigint, nm_usuario_p text, nr_seq_conta_p bigint, nr_seq_analise_p bigint, nr_seq_glosa_oc_p bigint, ie_tipo_p text, cd_estabelecimento_p bigint, nr_seq_grupo_atual_p bigint, nr_seq_item_analise_p bigint, ie_reconsistencia_p text, ie_conta_inteira_p text) AS $body$
DECLARE


ie_tipo_historico_w		smallint;
nr_seq_glosa_w			bigint;
nr_seq_ocorrencia_w		bigint;
nr_nivel_liberacao_w		bigint;
nr_seq_oc_benef_w		bigint;
nr_nivel_liberacao_auditor_w	bigint;
ie_se_grupo_auditor_w		varchar(1);
ie_grupo_liberado_w		varchar(1);
ie_status_w			varchar(1);
cd_codigo_glosa_oco_w		varchar(20);
nr_seq_analise_conta_glosa_w	bigint;
nr_seq_conta_proc_w		bigint;
nr_seq_conta_mat_w		bigint;
nr_seq_conta_w			bigint;
nr_seq_glosa_oc_w		bigint;
qt_registros_w			bigint;
nr_seq_conta_mat_ww		bigint;
nr_seq_conta_proc_ww		bigint;
qt_apresentado_w		bigint;
vl_total_apres_w		double precision;
ie_origem_analise_w		bigint;
nr_seq_proc_partic_w		bigint;
ie_tipo_item_w			varchar(1);
nr_seq_item_w			bigint;
vl_uni_calculado_w		double precision;
vl_calculado_w			double precision;
ie_pre_analise_w		varchar(2);		
qt_ocorr_pre_w			bigint;
ie_status_pre_analise_w		varchar(2);


BEGIN

select	nr_seq_conta_proc,
	nr_seq_conta_mat,
	ie_status,
	cd_codigo,
	nr_seq_proc_partic
into STRICT	nr_seq_conta_proc_w,
	nr_seq_conta_mat_w,
	ie_status_w,
	cd_codigo_glosa_oco_w,
	nr_seq_proc_partic_w
from	pls_analise_conta_item
where 	nr_sequencia = nr_seq_analise_conta_item_p;

if (coalesce(nr_seq_conta_proc_w,0) > 0) then
	nr_seq_item_w	:= nr_seq_conta_proc_w;
	ie_tipo_item_w	:= 'P';
elsif (coalesce(nr_seq_conta_mat_w,0) > 0) then
	nr_seq_item_w	:= nr_seq_conta_mat_w;
	ie_tipo_item_w	:= 'M';
elsif (coalesce(nr_seq_proc_partic_w,0) > 0) then
	nr_seq_item_w	:= nr_seq_proc_partic_w;
	ie_tipo_item_w	:= 'R';
	
	update	pls_proc_participante
	set	ie_glosa = 'S'
	where	nr_sequencia = nr_seq_proc_partic_w;
end if;
	

nr_seq_conta_mat_ww	:= nr_seq_conta_mat_w;
nr_seq_conta_proc_ww	:= nr_seq_conta_proc_w;

if (ie_status_w = 'P') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(173789);
end if;

ie_grupo_liberado_w := pls_obter_se_grupo_liberado(nm_usuario_p, nr_seq_analise_p, nr_seq_grupo_atual_p);

if (ie_status_w = 'C') then	
	CALL wheb_mensagem_pck.exibir_mensagem_abort(173790);
	
elsif (ie_status_w = 'E') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(173792);
	
elsif (ie_grupo_liberado_w = 'S') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(173793);
	
end if;

if (ie_tipo_p = 'O') and (coalesce(ie_reconsistencia_p,'N') = 'N') then

	ie_se_grupo_auditor_w := pls_obter_dados_auditor(cd_codigo_glosa_oco_w, null, nm_usuario_p, 'C', nr_seq_grupo_atual_p);

	
	if (ie_se_grupo_auditor_w = 'N') then		
		CALL wheb_mensagem_pck.exibir_mensagem_abort(173796);
	end if;
	
	select	c.nr_nivel_liberacao,
		a.nr_sequencia
	into STRICT	nr_nivel_liberacao_w,
		nr_seq_oc_benef_w
	FROM pls_ocorrencia_benef b, pls_ocorrencia a
LEFT OUTER JOIN pls_nivel_liberacao c ON (a.nr_seq_nivel_lib = c.nr_sequencia)
WHERE b.nr_seq_ocorrencia = a.nr_sequencia  and b.nr_sequencia = nr_seq_glosa_oc_p;

	nr_nivel_liberacao_auditor_w := (pls_obter_dados_auditor(cd_codigo_glosa_oco_w, null, nm_usuario_p, 'L', nr_seq_grupo_atual_p))::numeric;

	if (coalesce(nr_nivel_liberacao_auditor_w,0) < coalesce(nr_nivel_liberacao_w,0)) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(173798);
	end if;	

end if;

delete	FROM pls_analise_parecer_item
where	nr_seq_item	= nr_seq_analise_conta_item_p;

if (ie_tipo_p = 'G') then
	nr_seq_glosa_w		:= nr_seq_glosa_oc_p;
elsif (ie_tipo_p = 'O') then
	nr_seq_ocorrencia_w	:= nr_seq_glosa_oc_p;
end if;

begin
select	qt_apresentado,
	vl_total_apres,	
	vl_calculado
into STRICT	qt_apresentado_w,
	vl_total_apres_w,	
	vl_calculado_w
from	w_pls_resumo_conta
where	((nr_seq_conta_proc_ww 	= nr_seq_item		and ie_tipo_item = 'P')
or (nr_seq_conta_mat_ww  	= nr_seq_item		and ie_tipo_item = 'M')
or (nr_seq_proc_partic_w  = nr_seq_partic_proc	and ie_tipo_item = 'R'))
and	nr_seq_analise 		= nr_seq_analise_p;
exception
when others then
	qt_apresentado_w	:= null;
	vl_total_apres_w	:= null;		
	vl_calculado_w		:= null;
end;

update	pls_analise_conta_item
set	ie_status	= 'P',
	qt_glosa	= coalesce(qt_apresentado_w,0),
	vl_glosa	= coalesce(vl_total_apres_w,0),
	ie_consistencia = 'N',
	ie_situacao	= 'A'
where	nr_sequencia	= nr_seq_analise_conta_item_p
and	ie_status	<> 'I';

select	CASE WHEN ie_tipo_p='G' THEN  8  ELSE 9 END
into STRICT	ie_tipo_historico_w
;

insert into pls_hist_analise_conta(nr_sequencia, nr_seq_conta, nr_seq_analise,
	 ie_tipo_historico, dt_atualizacao, nm_usuario,
	 dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_item,
	 ie_tipo_item, nr_seq_ocorrencia, ds_observacao,
	 nr_seq_glosa, nr_seq_grupo)
values (nextval('pls_hist_analise_conta_seq'), nr_seq_conta_p, nr_seq_analise_p,
	 ie_tipo_historico_w, clock_timestamp(), nm_usuario_p,
	 clock_timestamp(), nm_usuario_p, null,
	 null, nr_seq_ocorrencia_w, null,
	 nr_seq_glosa_w, nr_seq_grupo_atual_p);
begin
select	ie_origem_analise,
	ie_pre_analise,
	ie_status_pre_analise
into STRICT	ie_origem_analise_w,
	ie_pre_analise_w,
	ie_status_pre_analise_w
from	pls_analise_conta
where	nr_sequencia = nr_seq_analise_p;
exception
when others then
	ie_origem_analise_w	:= null;
	ie_pre_analise_w	:= null;
end;

if (coalesce(ie_conta_inteira_p,'N') = 'N') then	
	CALL pls_analise_status_item(nr_seq_conta_p, nr_seq_conta_mat_ww, nr_seq_conta_proc_ww,
				nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p,
				nr_seq_proc_partic_w);
end if;

if (coalesce(ie_conta_inteira_p,'N') = 'N') then
	if (coalesce(ie_origem_analise_w,1) in (1,3)) then	
	
		CALL pls_analise_status_pgto(nr_seq_conta_p, nr_seq_conta_mat_ww, nr_seq_conta_proc_ww,
					nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p,
					nr_seq_proc_partic_w, null, null,
					null	);	
	elsif (coalesce(ie_origem_analise_w,1) = 2) then
		
		CALL pls_analise_status_pgto_pos(	nr_seq_conta_p, nr_seq_conta_mat_ww, nr_seq_conta_proc_ww,				
						nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p);

						
		CALL pls_analise_status_fat(		nr_seq_conta_p, nr_seq_conta_mat_ww, nr_seq_conta_proc_ww,				
						nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p);

	end if;
end if;

if (ie_pre_analise_w = 'S') and (ie_status_pre_analise_w = 'F') then
	/*conta as ocorrencias pendentes*/
	
	update	pls_analise_conta
	set	ie_status_pre_analise 	= 'S' -- AINDA EM PRE-ANALISE NAO FINALIZADA
	where	nr_sequencia 		= nr_seq_analise_p;
end if;

--tratativas para isolar apenas analise de prestador e apenas para acao de desfazer analise na analise antiga
if ( coalesce(ie_reconsistencia_p::text, '') = '' and coalesce(ie_conta_inteira_p::text, '') = '' and ie_origem_analise_w != 7) then
	update pls_conta set ie_status = 'A' where nr_sequencia = nr_seq_conta_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_lib_glosa_oc ( nr_seq_analise_conta_item_p bigint, nr_sequencia_p bigint, nm_usuario_p text, nr_seq_conta_p bigint, nr_seq_analise_p bigint, nr_seq_glosa_oc_p bigint, ie_tipo_p text, cd_estabelecimento_p bigint, nr_seq_grupo_atual_p bigint, nr_seq_item_analise_p bigint, ie_reconsistencia_p text, ie_conta_inteira_p text) FROM PUBLIC;

