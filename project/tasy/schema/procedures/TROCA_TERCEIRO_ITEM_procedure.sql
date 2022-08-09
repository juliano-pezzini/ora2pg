-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE troca_terceiro_item (nr_seq_item_p bigint, nr_seq_terceiro_p bigint, cd_medico_p text, nr_seq_trans_fin_p bigint, ds_observacao_p text, nr_repasse_terceiro_p bigint, nm_usuario_p text, ie_tipo_item_p text, ds_retorno_p INOUT text) AS $body$
DECLARE

/*
ie_tipo_item_p
	'P'	Procedimento
	'M'	Material
	'I'	Item de repasse
*/
nr_seq_terceiro_w	bigint;
cd_medico_w		varchar(255);
nr_seq_trans_fin_w	bigint;
nr_atendimento_w	bigint;
ds_item_w		varchar(4000);
ds_retorno_w		varchar(4000);
ds_mensagem_w		varchar(4000);
nr_seq_proc_repasse_w	bigint;
nr_seq_mat_repasse_w	bigint;
vl_repasse_w		double precision;
nr_lote_contabil_w	bigint;
nr_seq_propaci_w	bigint;
nr_seq_matpaci_w	bigint;
nr_interno_conta_w	bigint;
ie_calcular_repasse_w	varchar(10);
ie_troca_repasse_nao_contab_w	varchar(10);


BEGIN

ie_calcular_repasse_w := obter_param_usuario(89, 100, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_calcular_repasse_w);
ie_troca_repasse_nao_contab_w := obter_param_usuario(89, 107, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_troca_repasse_nao_contab_w);

if (ie_tipo_item_p = 'I') then

	select	max(a.nr_seq_terceiro),
		max(a.cd_medico),
		max(a.nr_seq_trans_fin),
		max(a.nr_atendimento),
		CASE WHEN coalesce(max(a.nr_atendimento)::text, '') = '' THEN null  ELSE ' - ' END  || substr(max(a.ds_observacao),1,252),
		CASE WHEN coalesce(max(a.nr_atendimento)::text, '') = '' THEN null  ELSE substr(wheb_mensagem_pck.get_texto(302015),1,255) END ,
		max(a.nr_lote_contabil)
	into STRICT	nr_seq_terceiro_w,
		cd_medico_w,
		nr_seq_trans_fin_w,
		nr_atendimento_w,
		ds_item_w,
		ds_mensagem_w,
		nr_lote_contabil_w
	from	repasse_terceiro_item a
	where	a.nr_sequencia		= nr_seq_item_p;

	/*	Edgar 10/06/2011, tirado este tratamento, pois o repasse pode ser torcado, mesmo se contabilizado
	if	(nvl(nr_lote_contabil_w, 0) > 0) then
		'O item ja esta contabilizado!');
	end if;
	*/
	
	if (coalesce(nr_lote_contabil_w, 0) = 0) and (coalesce(ie_troca_repasse_nao_contab_w,'S') = 'N') then
		-- 'Nao e permitido trocar o terceiro de um item nao contabilizado! Param [107]');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(184563);
	elsif (coalesce(nr_lote_contabil_w, 0) > 0) and (coalesce(ie_troca_repasse_nao_contab_w,'S') = 'C') then
		--O item ja esta contabilizado! Param [107]
		CALL wheb_mensagem_pck.exibir_mensagem_abort(194074);
	end if;

	update	repasse_terceiro_item
	set	nr_seq_terceiro		= coalesce(nr_seq_terceiro_p,nr_seq_terceiro_w),
		cd_medico		= coalesce(cd_medico_p,cd_medico_w),
		nr_seq_trans_fin	= coalesce(nr_seq_trans_fin_p,nr_seq_trans_fin_w),
		ds_observacao		= substr(coalesce(ds_observacao_p,ds_observacao),1,4000),
		nr_repasse_terceiro	= coalesce(nr_repasse_terceiro_p,nr_repasse_terceiro),
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_sequencia		= nr_seq_item_p;

else
	
	if (ie_tipo_item_p	= 'P') then

		nr_seq_proc_repasse_w	:= nr_seq_item_p;

		select	max(a.nr_seq_terceiro),
			max(a.cd_medico),
			max(a.nr_seq_trans_fin),
			max(b.nr_atendimento),
			' - ' || substr(obter_desc_propaci(max(b.nr_sequencia)),1,253),
			substr(wheb_mensagem_pck.get_texto(302015),1,255),
			max(a.vl_repasse),
			max(a.nr_lote_contabil),
			max(b.nr_sequencia),
			max(b.nr_interno_conta)
		into STRICT	nr_seq_terceiro_w,
			cd_medico_w,
			nr_seq_trans_fin_w,
			nr_atendimento_w,
			ds_item_w,
			ds_mensagem_w,
			vl_repasse_w,
			nr_lote_contabil_w,
			nr_seq_propaci_w,
			nr_interno_conta_w
		from	procedimento_paciente b,
			procedimento_repasse a
		where	a.nr_sequencia		= nr_seq_proc_repasse_w
		and	a.nr_seq_procedimento	= b.nr_sequencia;

		/*Edgar 10/06/2011, tirado este tratamento, pois o repasse pode ser torcado, mesmo se contabilizado
		if	(nvl(nr_lote_contabil_w, 0) > 0) then
			'O item ja esta contabilizado!');
		end if;
		*/
		
		if (coalesce(nr_lote_contabil_w, 0) = 0) and (coalesce(ie_troca_repasse_nao_contab_w,'S') = 'N') then
			-- 'Nao e permitido trocar o terceiro de um item nao contabilizado! Param [107]');
			CALL wheb_mensagem_pck.exibir_mensagem_abort(184563);
		elsif (coalesce(nr_lote_contabil_w, 0) > 0) and (coalesce(ie_troca_repasse_nao_contab_w,'S') = 'C') then
			--O item ja esta contabilizado! Param [107]
			CALL wheb_mensagem_pck.exibir_mensagem_abort(194074);
		end if;

		begin
		update	procedimento_repasse
		set	nr_seq_terceiro		= coalesce(nr_seq_terceiro_p,nr_seq_terceiro_w),
			cd_medico		= coalesce(cd_medico_p,cd_medico_w),
			nr_seq_trans_fin		= coalesce(nr_seq_trans_fin_p,nr_seq_trans_fin_w),
			ds_observacao		= substr(coalesce(ds_observacao_p,ds_observacao),1,255),
			nr_repasse_terceiro	= coalesce(nr_repasse_terceiro_p,nr_repasse_terceiro),
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p,
			nm_medico	= substr(obter_nome_pf_pj(coalesce(cd_medico_p,cd_medico_w), null),1,100)
		where	nr_sequencia		= nr_seq_proc_repasse_w;
		exception
		when others then
			--sqlerrm || chr(13) || chr(10) || 'cd_medico=' || nvl(cd_medico_p,cd_medico_w));	
			CALL wheb_mensagem_pck.exibir_mensagem_abort(184567,'SQLERRM_P='||sqlerrm || ';CD_MEDICO_P='||coalesce(cd_medico_p,cd_medico_w));
		end;

	elsif (ie_tipo_item_p = 'M') then

		nr_seq_mat_repasse_w	:= nr_seq_item_p;

		select	max(a.nr_seq_terceiro),
			max(a.cd_medico),
			max(a.nr_seq_trans_fin),
			max(b.nr_atendimento),
			' - ' || substr(obter_desc_matpaci(max(b.nr_sequencia)),1,253),
			substr(wheb_mensagem_pck.get_texto(302015),1,255),
			max(a.vl_repasse),
			max(a.nr_lote_contabil),
			max(b.nr_sequencia),
			max(b.nr_interno_conta)
		into STRICT	nr_seq_terceiro_w,
			cd_medico_w,
			nr_seq_trans_fin_w,
			nr_atendimento_w,
			ds_item_w,
			ds_mensagem_w,
			vl_repasse_w,
			nr_lote_contabil_w,
			nr_seq_matpaci_w,
			nr_interno_conta_w
		from	material_atend_paciente b,
			material_repasse a
		where	a.nr_sequencia		= nr_seq_mat_repasse_w
		and	a.nr_seq_material	= b.nr_sequencia;

		/*Edgar 10/06/2011, tirado este tratamento, pois o repasse pode ser torcado, mesmo se contabilizado
		if	(nvl(nr_lote_contabil_w, 0) > 0) then
			'O item ja esta contabilizado!');
		end if;
		*/
		
		if (coalesce(nr_lote_contabil_w, 0) = 0) and (coalesce(ie_troca_repasse_nao_contab_w,'S') = 'N') then
			-- 'Nao e permitido trocar o terceiro de um item nao contabilizado! Param [107]');
			CALL wheb_mensagem_pck.exibir_mensagem_abort(184563);
		elsif (coalesce(nr_lote_contabil_w, 0) > 0) and (coalesce(ie_troca_repasse_nao_contab_w,'S') = 'C') then
			--O item ja esta contabilizado! Param [107]
			CALL wheb_mensagem_pck.exibir_mensagem_abort(194074);
		end if;

		update	material_repasse
		set	nr_seq_terceiro		= coalesce(nr_seq_terceiro_p,nr_seq_terceiro_w),
			cd_medico		= coalesce(cd_medico_p,cd_medico_w),
			nr_seq_trans_fin	= coalesce(nr_seq_trans_fin_p,nr_seq_trans_fin_w),
			ds_observacao		= substr(coalesce(ds_observacao_p,ds_observacao),1,255),
			nr_repasse_terceiro	= coalesce(nr_repasse_terceiro_p,nr_repasse_terceiro),
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p,
			nm_medico	= substr(obter_nome_pf_pj(coalesce(cd_medico_p,cd_medico_w), null),1,100)
		where	nr_sequencia		= nr_seq_mat_repasse_w;

	end if;	

	insert	into proc_mat_repasse_terc(dt_atualizacao,
		dt_troca,
		nm_usuario,
		nr_lote_contabil,
		nr_seq_mat_repasse,
		nr_seq_proc_repasse,
		nr_seq_terc_ant,
		nr_seq_terc_novo,
		nr_seq_trans_financ,
		nr_sequencia,
		vl_repasse)
	values (clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		0,
		nr_seq_mat_repasse_w,
		nr_seq_proc_repasse_w,
		nr_seq_terceiro_w,
		coalesce(nr_seq_terceiro_p,nr_seq_terceiro_w),
		nr_seq_trans_fin_p,
		nextval('proc_mat_repasse_terc_seq'),
		vl_repasse_w);
		
	if (coalesce(ie_calcular_repasse_w,'N') = 'S') then
		CALL Recalcular_Conta_Repasse(nr_interno_conta_w,nr_seq_propaci_w,nr_seq_matpaci_w,nm_usuario_p);
	end if;	

end if;

/*insert	into logxxxxx_tasy
	(dt_atualizacao,
	nm_usuario,
	cd_log,
	ds_log)
values	(sysdate,
	nm_usuario_p,
	89,
	'NR_SEQUENCIA=' || 			nr_seq_item_p ||
	',NR_TERCEIRO_ANTERIOR=' ||		nr_seq_terceiro_w ||
	',NR_TERCEIRO_ATUAL=' ||		nvl(nr_seq_terceiro_p,nr_seq_terceiro_w) ||
	',CD_MEDICO_ANTERIOR=' ||		cd_medico_w ||
	',CD_MEDICO_ATUAL=' ||			nvl(cd_medico_p,cd_medico_w) ||
	',NR_SEQ_TRANS_FIN_ANTERIOR=' ||	nr_seq_trans_fin_w ||
	',NR_SEQ_TRANS_FIN_ATUAL=' ||		nvl(nr_seq_trans_fin_p,nr_seq_trans_fin_w) ||
	',DT_ATUALIZACAO=' ||			to_char(sysdate,'dd/mm/yyy hh24:mi:ss') ||
	',NM_USUARIO=' || 			nm_usuario_p);*/
ds_retorno_w	:= substr((ds_mensagem_w || nr_atendimento_w || ds_item_w || wheb_mensagem_pck.get_texto(302537) || vl_repasse_w),1,255);
ds_retorno_p	:= ds_retorno_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE troca_terceiro_item (nr_seq_item_p bigint, nr_seq_terceiro_p bigint, cd_medico_p text, nr_seq_trans_fin_p bigint, ds_observacao_p text, nr_repasse_terceiro_p bigint, nm_usuario_p text, ie_tipo_item_p text, ds_retorno_p INOUT text) FROM PUBLIC;
