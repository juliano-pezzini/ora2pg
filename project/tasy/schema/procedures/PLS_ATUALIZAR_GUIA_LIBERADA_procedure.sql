-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_guia_liberada ( nr_seq_auditoria_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_guia_w			bigint;
nr_seq_motivo_exc_w		integer;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
qt_ajuste_w			pls_auditoria_item.qt_ajuste%type;
nr_seq_material_w		bigint;
ie_status_w			varchar(5);
nr_seq_proc_origem_w		bigint;
nr_seq_mat_origem_w		bigint;
qt_itens_lib_w			smallint;
qt_mat_liberado_w		smallint;
qt_proc_liberado_w		smallint;
qt_itens_neg_w			smallint;
qt_proc_negado_w		smallint;
qt_mat_negado_w			smallint;
ds_regra_pos_estabelecido_w	varchar(1);
nr_seq_regra_email_w		bigint;
cd_estabelecimento_w		bigint;
ie_status_guia_w		smallint;
nr_seq_guia_proc_w		bigint;
nr_seq_guia_mat_w		bigint;
ie_status_ww			varchar(5);
cd_procedimento_ww		bigint;
ie_origem_proced_ww		bigint;
nr_seq_material_ww		bigint;
qt_solicitada_w			bigint;
qt_autorizada_w			bigint;
nr_seq_guia_ww			bigint;
nr_seq_atend_pls_w		bigint;
nr_seq_evento_atend_w		bigint;
nr_seq_prest_fornec_w		bigint;
cd_anvisa_w			pls_auditoria_item.nr_registro_anvisa%type;
cd_ref_fabricante_w		pls_auditoria_item.cd_ref_fabricante_imp%type;
dt_fim_evento_w			timestamp;
vl_item_w			double precision;
ie_intercambio_w		varchar(1)	:= 'N';
ie_tipo_processo_w		varchar(4);
ie_status_aguard_interc_w	varchar(4)	:= 'N';
ie_lib_contrat_w		varchar(4)	:= 'N';
nr_seq_regra_vl_mat_w		bigint;
vl_procedimento_conta_w		double precision;
vl_material_conta_w		double precision;
nm_usuario_liberacao_w		varchar(15);
ie_status_itens_w		varchar(1);
qt_reg_pedido_aut_w		bigint;
nr_seq_material_forn_w		bigint;
qt_reg_pedido_aut_compl_w	bigint;
ie_anexo_guia_w			pls_guia_plano.ie_anexo_guia%type;
ie_anexo_quimioterapia_w	pls_guia_plano.ie_anexo_quimioterapia%type;
ie_anexo_radioterapia_w		pls_guia_plano.ie_anexo_radioterapia%type;
ie_anexo_opme_w			pls_guia_plano.ie_anexo_opme%type;
ie_estagio_w			pls_guia_plano.ie_estagio%type;
ie_pacote_ptu_w			pls_auditoria_item.ie_pacote_ptu%type;
qt_item_mat_anexo_w		bigint;
qt_item_proc_anexo_w		bigint;
ie_tipo_contrato_w		pls_intercambio.ie_tipo_contrato%type;
nr_seq_intercambio_w		pls_segurado.nr_seq_intercambio%type;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
nr_seq_prestador_web_w		pls_guia_plano.nr_seq_prestador_web%type;
nr_seq_perfil_web_w		pls_perfil_web.nr_sequencia%type;
ie_acao_auditor_w		pls_auditoria_item.ie_acao_auditor%type;
ie_status_solicitacao_w		pls_auditoria_item.ie_status_solicitacao%type;
qt_original_w			pls_auditoria_item.qt_original%type;
ds_observacao_glosa_w		pls_auditoria_item.ds_observacao_glosa%type;
vl_procedimento_w		pls_guia_plano_proc.vl_procedimento%type;
vl_material_w			pls_guia_plano_mat.vl_material%type;
ie_origem_solic_w		pls_guia_plano.ie_origem_solic%type;

C01 CURSOR FOR
	SELECT	nr_seq_proc_origem,
		cd_procedimento,
		ie_origem_proced,
		qt_ajuste,
		nr_seq_motivo_exc,
		ie_status,
		vl_item,
		vl_procedimento_conta,
		nm_usuario,
		ie_pacote_ptu,
		ie_acao_auditor,
		ie_status_solicitacao,
		qt_original,
		ds_observacao_glosa
	from	pls_auditoria_item
	where	nr_seq_auditoria 	= nr_seq_auditoria_p
	and	(nr_seq_proc_origem IS NOT NULL AND nr_seq_proc_origem::text <> '')
	order by nr_sequencia;

C02 CURSOR FOR
	SELECT	nr_seq_mat_origem,
		nr_seq_material,
		qt_ajuste,
		nr_seq_motivo_exc,
		ie_status,
		nr_seq_prest_fornec,
		vl_item,
		nr_seq_regra_vl_mat,
		vl_material_conta,
		nm_usuario,
		nr_seq_material_forn,
		ie_acao_auditor,
		ie_status_solicitacao,
		qt_original,
		ds_observacao_glosa,
		nr_registro_anvisa,
		cd_ref_fabricante_imp
	from	pls_auditoria_item
	where	nr_seq_auditoria = nr_seq_auditoria_p
	and	(nr_seq_mat_origem IS NOT NULL AND nr_seq_mat_origem::text <> '')
	order by nr_sequencia;

C03 CURSOR FOR
	SELECT	nextval('pls_guia_plano_proc_seq'),
		CASE WHEN ie_status='A' THEN 'P' WHEN ie_status='N' THEN 'M' END ,
		cd_procedimento,
		ie_origem_proced,
		qt_ajuste,
		qt_ajuste,
		nr_seq_guia_w,
		vl_item,
		nr_seq_motivo_exc,
		vl_procedimento_conta,
		nm_usuario,
		ie_pacote_ptu,
		ds_observacao_glosa
	from	pls_auditoria_item
	where	nr_seq_auditoria = nr_seq_auditoria_p
	and	coalesce(nr_seq_proc_origem::text, '') = ''
	and	(cd_procedimento IS NOT NULL AND cd_procedimento::text <> '');

C04 CURSOR FOR
	SELECT	nextval('pls_guia_plano_mat_seq'),
		CASE WHEN ie_status='A' THEN 'P' WHEN ie_status='N' THEN 'M' END ,
		nr_seq_material,
		qt_ajuste,
		qt_ajuste,
		nr_seq_guia_w,
		nr_seq_prest_fornec,
		vl_item,
		nr_seq_motivo_exc,
		nr_seq_regra_vl_mat,
		vl_material_conta,
		nm_usuario,
		ds_observacao_glosa,
		nr_registro_anvisa,
		cd_ref_fabricante_imp
	from	pls_auditoria_item
	where	nr_seq_auditoria = nr_seq_auditoria_p
	and	coalesce(nr_seq_mat_origem::text, '') = ''
	and	(nr_seq_material IS NOT NULL AND nr_seq_material::text <> '');


BEGIN

select	nr_seq_guia,
	cd_estabelecimento
into STRICT	nr_seq_guia_w,
	cd_estabelecimento_w
from	pls_auditoria
where	nr_sequencia = nr_seq_auditoria_p;

select	coalesce(ie_tipo_processo,'X'),
	nr_seq_segurado,
	nr_seq_prestador_web,
	coalesce(ie_origem_solic, 'X')
into STRICT	ie_tipo_processo_w,
	nr_seq_segurado_w,
	nr_seq_prestador_web_w,
	ie_origem_solic_w
from	pls_guia_plano
where	nr_sequencia = nr_seq_guia_w;

begin
	select	nr_seq_intercambio
	into STRICT	nr_seq_intercambio_w
	from	pls_segurado
	where	nr_sequencia = nr_seq_segurado_w;
exception
when others then
	nr_seq_intercambio_w	:= null;
end;

if (nr_seq_intercambio_w IS NOT NULL AND nr_seq_intercambio_w::text <> '') then
	begin
		select	ie_tipo_contrato
		into STRICT	ie_tipo_contrato_w
		from	pls_intercambio
		where	nr_sequencia = nr_seq_intercambio_w;
	exception
	when others then
		ie_tipo_contrato_w	:= null;
	end;

	if (ie_tipo_contrato_w = 'F') then
		ie_tipo_processo_w := 'F';
	end if;
end if;


open C01;
loop
fetch C01 into
	nr_seq_proc_origem_w,
	cd_procedimento_w,
	ie_origem_proced_w,
	qt_ajuste_w,
	nr_seq_motivo_exc_w,
	ie_status_w,
	vl_item_w,
	vl_procedimento_conta_w,
	nm_usuario_liberacao_w,
	ie_pacote_ptu_w,
	ie_acao_auditor_w,
	ie_status_solicitacao_w,
	qt_original_w,
	ds_observacao_glosa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	begin
		select	vl_procedimento
		into STRICT	vl_procedimento_w
		from	pls_guia_plano_proc
		where	nr_sequencia	= nr_seq_proc_origem_w;
	exception
	when others then
		vl_procedimento_w	:= 0;
	end;

	if	((ie_acao_auditor_w IS NOT NULL AND ie_acao_auditor_w::text <> '')			or (ie_status_w		<> ie_status_solicitacao_w) 	or (qt_ajuste_w		<> qt_original_w)		or (vl_item_w		<> vl_procedimento_w)) then

		update	pls_guia_plano_proc
		set	cd_procedimento		= cd_procedimento_w,
			ie_origem_proced	= ie_origem_proced_w,
			qt_solicitada		= CASE WHEN ie_tipo_processo_w='I' THEN  qt_ajuste_w  ELSE qt_solicitada END ,
			qt_autorizada		= CASE WHEN ie_status_w='N' THEN  0  ELSE qt_ajuste_w END ,
			nr_seq_motivo_exc	= nr_seq_motivo_exc_w,
			ie_status		= CASE WHEN ie_status_w='A' THEN 'P' WHEN ie_status_w='N' THEN 'M' END ,
			dt_atualizacao		= clock_timestamp(),
			dt_liberacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p,
			vl_procedimento		= vl_item_w,
			vl_procedimento_conta	= vl_procedimento_conta_w,
			nm_usuario_liberacao	= nm_usuario_liberacao_w,
			ie_pacote_ptu		= coalesce(ie_pacote_ptu_w,'N')
		where	nr_sequencia		= nr_seq_proc_origem_w;

		if (ie_status_w  = 'N') then
			if (ie_origem_solic_w = 'E') then
				CALL pls_gravar_motivo_glosa('1426', null, nr_seq_proc_origem_w, null,
							substr('Procedimento negado pelos grupos de análise. ' || ds_observacao_glosa_w, 1, 4000),
							nm_usuario_p, '', 'IG', null, '', null);
			else
				insert into pls_guia_glosa(nr_sequencia, dt_atualizacao, nm_usuario,
					dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_guia,
					nr_seq_guia_proc, nr_seq_guia_mat, nr_seq_motivo_glosa,
					ds_observacao, ie_origem)
				values (nextval('pls_guia_glosa_seq'), clock_timestamp(), nm_usuario_p,
					clock_timestamp(), nm_usuario_p,null,
					nr_seq_proc_origem_w, null, 566,
					substr('Procedimento negado pelos grupos de análise. '||ds_observacao_glosa_w,1,4000), '');
			end if;
		end if;
	end if;
	end;
end loop;
close C01;

open C02;
loop
fetch C02 into
	nr_seq_mat_origem_w,
	nr_seq_material_w,
	qt_ajuste_w,
	nr_seq_motivo_exc_w,
	ie_status_w,
	nr_seq_prest_fornec_w,
	vl_item_w,
	nr_seq_regra_vl_mat_w,
	vl_material_conta_w,
	nm_usuario_liberacao_w,
	nr_seq_material_forn_w,
	ie_acao_auditor_w,
	ie_status_solicitacao_w,
	qt_original_w,
	ds_observacao_glosa_w,
	cd_anvisa_w,
	cd_ref_fabricante_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin

	begin
		select	vl_material
		into STRICT	vl_material_w
		from	pls_guia_plano_mat
		where	nr_sequencia	= nr_seq_mat_origem_w;
	exception
	when others then
		vl_material_w	:= 0;
	end;

	if	((ie_acao_auditor_w IS NOT NULL AND ie_acao_auditor_w::text <> '')			or (ie_status_w		<> ie_status_solicitacao_w) 	or (qt_ajuste_w		<> qt_original_w)		or (vl_item_w		<> vl_material_w)) then

		update	pls_guia_plano_mat
		set	nr_seq_material		= nr_seq_material_w,
			qt_solicitada		= CASE WHEN ie_tipo_processo_w='I' THEN  qt_ajuste_w  ELSE qt_solicitada END ,
			qt_autorizada		= CASE WHEN ie_status_w='N' THEN  0  ELSE qt_ajuste_w END ,
			nr_seq_motivo_exc 	= nr_seq_motivo_exc_w,
			ie_status 		= CASE WHEN ie_status_w='A' THEN 'P' WHEN ie_status_w='N' THEN 'M' END ,
			dt_atualizacao		= clock_timestamp(),
			dt_liberacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p,
			nr_seq_prest_fornec	= nr_seq_prest_fornec_w,
			vl_material		= vl_item_w,
			nr_seq_regra		= nr_seq_regra_vl_mat_w,
			vl_material_conta	= vl_material_conta_w,
			nm_usuario_liberacao	= nm_usuario_liberacao_w,
			nr_seq_material_forn    = nr_seq_material_forn_w,
			nr_registro_anvisa	= cd_anvisa_w,
			cd_ref_fabricante_imp	= cd_ref_fabricante_w
		where	nr_sequencia 		= nr_seq_mat_origem_w;

		if (ie_status_w  = 'N') then
			if (ie_origem_solic_w = 'E') then
				CALL pls_gravar_motivo_glosa('1426', null, null, nr_seq_mat_origem_w,
							substr('Material negado pelos grupos de análise. ' || ds_observacao_glosa_w, 1, 4000),
							nm_usuario_p, '', 'IG', null, '', null);
			else
				insert into pls_guia_glosa(nr_sequencia, dt_atualizacao, nm_usuario,
					dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_guia,
					nr_seq_guia_proc, nr_seq_guia_mat, nr_seq_motivo_glosa,
					ds_observacao, ie_origem)
				values (nextval('pls_guia_glosa_seq'), clock_timestamp(), nm_usuario_p,
					clock_timestamp(), nm_usuario_p,null,
					null, nr_seq_mat_origem_w, 566,
					substr('Material negado pelos grupos de análise. '||ds_observacao_glosa_w,1,4000), '');
			end if;
		end if;
	end if;
	end;
end loop;
close C02;

-- ie_tipo_processo_w recebe 'F' pois estava passando a quantidade autorizada para a quantidade solicitada quando era beneficiário de fundação
-- agora estamos passando para 'I' para continuar o tratamento normalmente.
if (ie_tipo_processo_w	= 'F') then
	ie_tipo_processo_w	:= 'I';
end if;

open C03;
loop
fetch C03 into
	nr_seq_guia_proc_w,
	ie_status_ww,
	cd_procedimento_ww,
	ie_origem_proced_ww,
	qt_solicitada_w,
	qt_autorizada_w,
	nr_seq_guia_ww,
	vl_item_w,
	nr_seq_motivo_exc_w,
	vl_procedimento_conta_w,
	nm_usuario_liberacao_w,
	ie_pacote_ptu_w,
	ds_observacao_glosa_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin
	dbms_application_info.SET_ACTION('INCPROC');

	if (ie_status_ww  = 'M') then
		qt_autorizada_w := 0;
	end if;
	insert	into pls_guia_plano_proc(nr_sequencia, ie_status, cd_procedimento,
		 ie_origem_proced, qt_solicitada, dt_atualizacao,
		 nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		 qt_autorizada, nr_seq_guia, dt_liberacao,
		 vl_procedimento, nr_seq_motivo_exc, vl_procedimento_conta,
		 nm_usuario_liberacao, ie_pacote_ptu)
	values (nr_seq_guia_proc_w, ie_status_ww, cd_procedimento_ww,
		 ie_origem_proced_ww, qt_solicitada_w, clock_timestamp(),
		 nm_usuario_p, clock_timestamp(), nm_usuario_p,
		 qt_autorizada_w, nr_seq_guia_ww, clock_timestamp(),
		 vl_item_w, nr_seq_motivo_exc_w, vl_procedimento_conta_w,
		 nm_usuario_liberacao_w, coalesce(ie_pacote_ptu_w,'N'));
	if (ie_status_ww  = 'M') then
		if (ie_origem_solic_w = 'E') then
			CALL pls_gravar_motivo_glosa('1426', null, nr_seq_guia_proc_w, null,
						substr('Procedimento negado pelos grupos de análise. ' || ds_observacao_glosa_w, 1, 4000),
						nm_usuario_p, '', 'IG', null, '', null);
		else
			insert into pls_guia_glosa(nr_sequencia, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_guia,
				nr_seq_guia_proc, nr_seq_guia_mat, nr_seq_motivo_glosa,
				ds_observacao, ie_origem)
			values (nextval('pls_guia_glosa_seq'), clock_timestamp(), nm_usuario_p,
				clock_timestamp(), nm_usuario_p,null,
				nr_seq_guia_proc_w, null, 566,
				substr('Procedimento negado pelos grupos de análise. '||ds_observacao_glosa_w,1,4000), '');
		end if;
	end if;

	dbms_application_info.SET_ACTION('');
	end;
end loop;
close C03;

open C04;
loop
fetch C04 into
	nr_seq_guia_mat_w,
	ie_status_ww,
	nr_seq_material_ww,
	qt_solicitada_w,
	qt_autorizada_w,
	nr_seq_guia_ww,
	nr_seq_prest_fornec_w,
	vl_item_w,
	nr_seq_motivo_exc_w,
	nr_seq_regra_vl_mat_w,
	vl_material_conta_w,
	nm_usuario_liberacao_w,
	ds_observacao_glosa_w,
	cd_anvisa_w,
	cd_ref_fabricante_w;
EXIT WHEN NOT FOUND; /* apply on C04 */
	begin
	dbms_application_info.SET_ACTION('INCMATMED');

	if (ie_status_ww  = 'M') then
		qt_autorizada_w := 0;
	end if;
	insert	into pls_guia_plano_mat(nr_sequencia, ie_status, nr_seq_material,
		 qt_solicitada, dt_atualizacao, nm_usuario,
		 dt_atualizacao_nrec, nm_usuario_nrec, qt_autorizada,
		 nr_seq_guia,dt_liberacao, nr_seq_prest_fornec,
		 vl_material, nr_seq_motivo_exc, nr_seq_regra,
		 vl_material_conta, nm_usuario_liberacao, nr_registro_anvisa, cd_ref_fabricante_imp)
	values (nr_seq_guia_mat_w, ie_status_ww, nr_seq_material_ww,
		 qt_solicitada_w, clock_timestamp(), nm_usuario_p,
		 clock_timestamp(), nm_usuario_p, qt_autorizada_w,
		 nr_seq_guia_ww, clock_timestamp(), nr_seq_prest_fornec_w,
		 vl_item_w, nr_seq_motivo_exc_w, nr_seq_regra_vl_mat_w,
		 vl_material_conta_w, nm_usuario_liberacao_w, cd_anvisa_w, cd_ref_fabricante_w);
	if (ie_status_ww  = 'M') then
		if (ie_origem_solic_w = 'E') then
			CALL pls_gravar_motivo_glosa('1426', null, null, nr_seq_guia_mat_w,
						substr('Material negado pelos grupos de análise. ' || ds_observacao_glosa_w, 1, 4000),
						nm_usuario_p, '', 'IG', null, '', null);
		else
			insert into pls_guia_glosa(nr_sequencia, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_guia,
				nr_seq_guia_proc, nr_seq_guia_mat, nr_seq_motivo_glosa,
				ds_observacao, ie_origem)
			values (nextval('pls_guia_glosa_seq'), clock_timestamp(), nm_usuario_p,
				clock_timestamp(), nm_usuario_p,null,
				null, nr_seq_guia_mat_w, 566,
				substr('Material negado pelos grupos de análise. '||ds_observacao_glosa_w,1,4000), '');
		end if;
	end if;

	dbms_application_info.SET_ACTION('');
	end;
end loop;
close C04;

select	count(1)
into STRICT	qt_proc_liberado_w
from	pls_guia_plano_proc
where	nr_seq_guia	= nr_seq_guia_w
and	ie_status	in ('S','P','L');

select	count(1)
into STRICT	qt_mat_liberado_w
from	pls_guia_plano_mat
where	nr_seq_guia	= nr_seq_guia_w
and	ie_status	in ('S','P','L');

select	count(1)
into STRICT	qt_proc_negado_w
from	pls_guia_plano_proc
where	nr_seq_guia	= nr_seq_guia_w
and	ie_status	in ('N','M','K');

select	count(1)
into STRICT	qt_mat_negado_w
from	pls_guia_plano_mat
where	nr_seq_guia	= nr_seq_guia_w
and	ie_status	in ('N','M','K');

qt_itens_lib_w			:= qt_mat_liberado_w + qt_proc_liberado_w;
qt_itens_neg_w			:= qt_proc_negado_w + qt_mat_negado_w;

if (pls_obter_se_scs_ativo	<> 'A') then
	ie_status_aguard_interc_w	:= coalesce(obter_valor_param_usuario(1270, 40, Obter_Perfil_Ativo, nm_usuario_p, 0), 'N');
	if (qt_itens_lib_w > 0) then
		if (ie_tipo_processo_w	= 'I') and (ie_status_aguard_interc_w	= 'S') then
			ie_status_guia_w 	:= 2;
			ie_intercambio_w	:= 'S';
		else
			nr_seq_regra_email_w := pls_obter_regra_lib_estipu(nr_seq_guia_w, null, nr_seq_regra_email_w);
			if (coalesce(nr_seq_regra_email_w,0) > 0) then
				ie_status_guia_w := 2;
			else
				ie_status_guia_w := 1;
			end if;
		end if;
	elsif (qt_itens_neg_w > 0) then
		-- Djavan 05/04/2012 OS 426276 -  Conforme solicitação da Unimed Litoral independênte do status do item, deve ser enviado para o estipulante autorizar ou negar
		select	max(ie_liberacao_contratante)
		into STRICT	ie_lib_contrat_w
		from	pls_param_analise_aut;

		--Djavan 10/05/2012 OS  426549 - Conforme solicitação da Unimed Litoral independênte do status do item, a guia deve ficar com o estágio "Aguardando autorização intercâmbio"
		if (ie_tipo_processo_w	= 'I') then
			if (ie_status_aguard_interc_w	= 'S') then
				ie_status_guia_w 	:= 2;
				ie_intercambio_w	:= 'S';
			else
				ie_status_guia_w := 3;
			end if;
		elsif (coalesce(ie_lib_contrat_w,'N')	= 'S') then
			nr_seq_regra_email_w := pls_obter_regra_lib_estipu(nr_seq_guia_w, null, nr_seq_regra_email_w);
			if (coalesce(nr_seq_regra_email_w,0) > 0) then
				ie_status_guia_w := 2;
			else
				ie_status_guia_w := 3;
			end if;
		elsif (coalesce(ie_lib_contrat_w,'N')	= 'N') then
			ie_status_guia_w := 3;
		end if;
	end if;
elsif (pls_obter_se_scs_ativo	= 'A') then
	if (qt_itens_lib_w > 0) then
		if (ie_tipo_processo_w	= 'I') then
			select	count(1)
			into STRICT	qt_reg_pedido_aut_w
			from	ptu_pedido_autorizacao
			where	nr_seq_guia	= nr_seq_guia_w;

			select	count(1)
			into STRICT	qt_reg_pedido_aut_compl_w
			from	ptu_pedido_compl_aut
			where	nr_seq_guia	= nr_seq_guia_w;

			if (qt_reg_pedido_aut_w	= 0) and (qt_reg_pedido_aut_compl_w	= 0) then
				ie_status_guia_w 	:= 2;
				ie_status_itens_w	:= 'I';
				ie_intercambio_w	:= 'S';
			else
				ie_status_guia_w := 1;
			end if;

			nr_seq_regra_email_w := pls_obter_regra_lib_estipu(nr_seq_guia_w, null, nr_seq_regra_email_w);
			if (coalesce(nr_seq_regra_email_w,0) > 0) then
				ie_status_guia_w 	:= 2;
				ie_status_itens_w	:= '';
				ie_intercambio_w	:= 'N';
			end if;
		else
			nr_seq_regra_email_w := pls_obter_regra_lib_estipu(nr_seq_guia_w, null, nr_seq_regra_email_w);
			if (coalesce(nr_seq_regra_email_w,0) > 0) then
				ie_status_guia_w := 2;
			else
				ie_status_guia_w := 1;
			end if;
		end if;
	elsif (qt_itens_neg_w > 0) then
		select	max(ie_liberacao_contratante)
		into STRICT	ie_lib_contrat_w
		from	pls_param_analise_aut;

		if (coalesce(ie_lib_contrat_w,'N')	= 'S') then
			nr_seq_regra_email_w := pls_obter_regra_lib_estipu(nr_seq_guia_w, null, nr_seq_regra_email_w);
			if (coalesce(nr_seq_regra_email_w,0) > 0) then
				ie_status_guia_w := 2;
			else
				ie_status_guia_w := 3;
			end if;
		elsif (coalesce(ie_lib_contrat_w,'N')	= 'N') then
			ie_status_guia_w := 3;
		end if;
	end if;
end if;

if (ie_status_guia_w <> 2) then
	if (ie_status_guia_w	= 1)  then
		CALL pls_autoriza_guia_analise(nr_seq_guia_w,nm_usuario_p);
	else
		update	pls_guia_plano
		set	ie_status	= ie_status_guia_w
		where	nr_sequencia	= nr_seq_guia_w;

		CALL pls_atualizar_estagio_guia(nr_seq_guia_w,nm_usuario_p,null);
	end if;

	begin
	select	nr_seq_atend_pls,
		nr_seq_evento_atend
	into STRICT	nr_seq_atend_pls_w,
		nr_seq_evento_atend_w
	from	pls_guia_plano
	where	nr_sequencia = nr_seq_guia_w;
	exception
	when others then
		nr_seq_atend_pls_w := null;
	end;

	if (nr_seq_atend_pls_w IS NOT NULL AND nr_seq_atend_pls_w::text <> '') then
		begin
		select	dt_fim_evento
		into STRICT	dt_fim_evento_w
		from	pls_atendimento_evento
		where	nr_sequencia = nr_seq_evento_atend_w;
		exception
		when others then
			dt_fim_evento_w := null;
		end;

		if (ie_status_guia_w <> '2') and (nr_seq_atend_pls_w IS NOT NULL AND nr_seq_atend_pls_w::text <> '') and (dt_fim_evento_w IS NOT NULL AND dt_fim_evento_w::text <> '') then
			CALL pls_finalizar_atendimento(	nr_seq_atend_pls_w,
							nr_seq_evento_atend_w,
							null,
							null,
							nm_usuario_p);
		end if;
	end if;
elsif (ie_intercambio_w	= 'N') then
	update	pls_guia_plano
	set	ie_status	= ie_status_guia_w,
		ie_estagio	= '9'
	where	nr_sequencia	= nr_seq_guia_w;

	if (coalesce(nr_seq_regra_email_w,0) > 0) then
		CALL pls_enviar_email_autorizacao(nr_seq_guia_w, 1, nr_seq_regra_email_w, nm_usuario_p,null);
	end if;
elsif (ie_intercambio_w	= 'S') and (ie_status_aguard_interc_w	= 'S') then
	update	pls_guia_plano
	set	ie_status	= ie_status_guia_w,
		ie_estagio	= '12',
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_guia_w;
elsif (ie_intercambio_w	= 'S') and (pls_obter_se_scs_ativo	= 'A') then
	if (coalesce(ie_status_itens_w,'N')	= 'I') then
		update	pls_guia_plano_proc
		set	ie_status	= ie_status_itens_w,
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp()
		where	nr_seq_guia	= nr_seq_guia_w
		and	ie_status	in ('S','P');

		update	pls_guia_plano_mat
		set	ie_status	= ie_status_itens_w,
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp()
		where	nr_seq_guia	= nr_seq_guia_w
		and	ie_status	in ('S','P');

		update	pls_guia_plano
		set	ie_status	= ie_status_guia_w,
			ie_estagio	= '12',
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp()
		where	nr_sequencia	= nr_seq_guia_w;
	end if;
end if;

CALL pls_verif_se_exclui_item_anexo(nr_seq_auditoria_p, nm_usuario_p);

begin
	select	nr_seq_perfil_web
	into STRICT	nr_seq_perfil_web_w
	from	pls_usuario_web
	where	nr_sequencia	= nr_seq_prestador_web_w;
exception
when others then
	nr_seq_perfil_web_w	:= null;
end;

if (pls_obter_param_web(1247, 20, cd_estabelecimento_w, nr_seq_prestador_web_w, nr_seq_perfil_web_w, null, null, 'P', null, null) = 'S') and (qt_itens_lib_w > 0) then
	CALL pls_gerar_franquia_guia(nr_seq_guia_w, cd_estabelecimento_w, nm_usuario_p);
end if;

commit;

select	count(1)
into STRICT	qt_item_mat_anexo_w
from	pls_lote_anexo_mat_aut a,
	pls_lote_anexo_guias_aut b
where	a.nr_seq_lote_anexo_guia	= b.nr_sequencia
and	coalesce(a.nr_seq_motivo_exc::text, '') = ''
and	b.ie_tipo_anexo			in ('QU', 'OP')
and 	b.nr_seq_guia			= nr_seq_guia_w;

select	count(1)
into STRICT	qt_item_proc_anexo_w
from	pls_lote_anexo_proc_aut a,
	pls_lote_anexo_guias_aut b
where	a.nr_seq_lote_anexo_guia	= b.nr_sequencia
and	coalesce(a.nr_seq_motivo_exc::text, '') = ''
and	b.ie_tipo_anexo			= 'RA'
and 	b.nr_seq_guia			= nr_seq_guia_w;

if (qt_item_mat_anexo_w > 0) or (qt_item_proc_anexo_w > 0) then
	select 	ie_anexo_guia,
		ie_anexo_quimioterapia,
		ie_anexo_radioterapia,
		ie_anexo_opme
	into STRICT	ie_anexo_guia_w,
		ie_anexo_quimioterapia_w,
		ie_anexo_radioterapia_w,
		ie_anexo_opme_w
	from	pls_auditoria
	where	nr_sequencia = nr_seq_auditoria_p;

	update	pls_guia_plano
	set	ie_anexo_guia = ie_anexo_guia_w,
		ie_anexo_quimioterapia = ie_anexo_quimioterapia_w,
		ie_anexo_radioterapia = ie_anexo_radioterapia_w,
		ie_anexo_opme = ie_anexo_opme_w
	where 	nr_sequencia = nr_seq_guia_w;

	commit;
end if;

select	ie_estagio
into STRICT	ie_estagio_w
from	pls_guia_plano
where	nr_sequencia	= nr_seq_guia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_guia_liberada ( nr_seq_auditoria_p bigint, nm_usuario_p text) FROM PUBLIC;
