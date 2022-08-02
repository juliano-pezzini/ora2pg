-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_req_liberada ( nr_seq_auditoria_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_requisicao_w		bigint;
nr_seq_motivo_exc_w		integer;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
qt_ajuste_w			bigint;
nr_seq_material_w		bigint;
ie_status_w			varchar(5);
nr_seq_proc_origem_w		bigint;
nr_seq_mat_origem_w		bigint;
nr_seq_material_forn_w		bigint;
qt_itens_lib_w			smallint;
qt_mat_liberado_w		smallint;
qt_proc_liberado_w		smallint;
qt_itens_neg_w			smallint;
qt_proc_negado_w		smallint;
qt_mat_negado_w			smallint;
vl_item_w			double precision;
nr_seq_regra_vl_mat_w		bigint;
ie_tipo_intercambio_w		varchar(10);
ie_anexo_guia_w			pls_requisicao.ie_anexo_guia%type;
ie_anexo_quimioterapia_w	pls_requisicao.ie_anexo_quimioterapia%type;
ie_anexo_radioterapia_w		pls_requisicao.ie_anexo_radioterapia%type;
ie_anexo_opme_w			pls_requisicao.ie_anexo_opme%type;
ie_tipo_processo_w		pls_requisicao.ie_tipo_processo%type;
ie_estagio_w			pls_requisicao.ie_estagio%type;
ie_pacote_ptu_w			pls_auditoria_item.ie_pacote_ptu%type;
ds_observacao_glosa_w		pls_auditoria_item.ds_observacao_glosa%type;
nr_seq_prest_fornec_w		pls_requisicao_mat.nr_seq_prest_fornec%type;
cd_anvisa_w			pls_auditoria_item.nr_registro_anvisa%type;
cd_ref_fabricante_w		pls_auditoria_item.cd_ref_fabricante_imp%type;
ie_origem_solic_w		pls_requisicao.ie_origem_solic%type;

C01 CURSOR FOR
	SELECT	a.nr_seq_proc_origem,
		a.cd_procedimento,
		a.ie_origem_proced,
		a.qt_ajuste,
		a.nr_seq_motivo_exc,
		a.ie_status,
		a.vl_item,
		a.ie_pacote_ptu,
		a.ds_observacao_glosa
	from	pls_auditoria_item	a
	where	a.nr_seq_auditoria = nr_seq_auditoria_p
	and	(a.nr_seq_proc_origem IS NOT NULL AND a.nr_seq_proc_origem::text <> '')
	and	(((a.ie_acao_auditor IS NOT NULL AND a.ie_acao_auditor::text <> '')
	or	exists (	SELECT	1
				from	pls_requisicao_historico x
				where	x.nr_seq_item	= a.nr_sequencia))
	or (ie_tipo_intercambio_w = 'E'))
	order by nr_sequencia;

C02 CURSOR FOR
	SELECT	a.nr_seq_mat_origem,
		a.nr_seq_material,
		a.qt_ajuste,
		a.nr_seq_motivo_exc,
		a.ie_status,
		a.vl_item,
		a.nr_seq_regra_vl_mat,
		a.nr_seq_material_forn,
		a.nr_seq_prest_fornec,
		a.ds_observacao_glosa,
		a.nr_registro_anvisa,
		a.cd_ref_fabricante_imp
	from	pls_auditoria_item	a
	where	a.nr_seq_auditoria = nr_seq_auditoria_p
	and	(a.nr_seq_mat_origem IS NOT NULL AND a.nr_seq_mat_origem::text <> '')
	and	(((a.ie_acao_auditor IS NOT NULL AND a.ie_acao_auditor::text <> '')
	or	exists (	SELECT	1
				from	pls_requisicao_historico x
				where	x.nr_seq_item	= a.nr_sequencia))
	or (ie_tipo_intercambio_w = 'E'))
	order by nr_sequencia;


BEGIN

select	nr_seq_requisicao
into STRICT	nr_seq_requisicao_w
from	pls_auditoria
where	nr_sequencia = nr_seq_auditoria_p;

select	ie_tipo_intercambio,
	ie_tipo_processo,
	coalesce(ie_origem_solic, 'X')
into STRICT	ie_tipo_intercambio_w,
	ie_tipo_processo_w,
	ie_origem_solic_w
from	pls_requisicao
where	nr_sequencia = nr_seq_requisicao_w;

ie_tipo_intercambio_w := coalesce(ie_tipo_intercambio_w,'N');

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
	ie_pacote_ptu_w,
	ds_observacao_glosa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	update	pls_requisicao_proc
	set	cd_procedimento		= cd_procedimento_w,
		ie_origem_proced	= ie_origem_proced_w,
		qt_solicitado		= CASE WHEN ie_tipo_processo_w='I' THEN qt_ajuste_w  ELSE qt_solicitado END ,
		qt_procedimento		= CASE WHEN ie_status_w='N' THEN 0 WHEN ie_status_w='C' THEN 0  ELSE qt_ajuste_w END ,
		nr_seq_motivo_exc	= nr_seq_motivo_exc_w,
		ie_status		= CASE WHEN ie_status_w='A' THEN 'P' WHEN ie_status_w='N' THEN 'G' WHEN ie_status_w='C' THEN 'C' END ,
		ie_estagio		= CASE WHEN ie_status_w='A' THEN 'AE' WHEN ie_status_w='N' THEN 'N' WHEN ie_status_w='C' THEN 'N' END ,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p,
		vl_procedimento		= vl_item_w,
		ie_pacote_ptu		= coalesce(ie_pacote_ptu_w,'N')
	where	nr_sequencia		= nr_seq_proc_origem_w;
	if (ie_status_w  = 'N') then
		if (ie_origem_solic_w = 'E') then
			CALL pls_gravar_requisicao_glosa(	'1426', null, nr_seq_proc_origem_w, null,
							substr('Procedimento negado pelos grupos de análise. ' || ds_observacao_glosa_w, 1, 4000),
							nm_usuario_p, null, null, null, null, 'IG');
		else
			insert into pls_requisicao_glosa(nr_sequencia, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_requisicao,
				nr_seq_req_proc, nr_seq_req_mat, nr_seq_motivo_glosa,
				ds_observacao)
			values (nextval('pls_requisicao_glosa_seq'), clock_timestamp(), nm_usuario_p,
				clock_timestamp(), nm_usuario_p,null,
				nr_seq_proc_origem_w, null, 566,
				substr('Procedimento negado pelos grupos de análise. ' || ds_observacao_glosa_w,1,4000));
		end if;
	end if;

	if	ie_tipo_processo_w	= 'I' then
		CALL pls_gerar_de_para_req_intercam(	nr_seq_proc_origem_w, null, null,
						null, null, null,
						null, obter_estabelecimento_ativo, nm_usuario_p);
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
	vl_item_w,
	nr_seq_regra_vl_mat_w,
	nr_seq_material_forn_w,
	nr_seq_prest_fornec_w,
	ds_observacao_glosa_w,
	cd_anvisa_w,
	cd_ref_fabricante_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	update	pls_requisicao_mat
	set	nr_seq_material		= nr_seq_material_w,
		qt_solicitado		= CASE WHEN ie_tipo_processo_w='I' THEN qt_ajuste_w  ELSE qt_solicitado END ,
		qt_material		= CASE WHEN ie_status_w='N' THEN 0 WHEN ie_status_w='C' THEN 0  ELSE qt_ajuste_w END ,
		nr_seq_motivo_exc 	= nr_seq_motivo_exc_w,
		ie_status		= CASE WHEN ie_status_w='A' THEN 'P' WHEN ie_status_w='N' THEN 'G' WHEN ie_status_w='C' THEN 'C' END ,
		ie_estagio		= CASE WHEN ie_status_w='A' THEN 'AE' WHEN ie_status_w='N' THEN 'N' WHEN ie_status_w='C' THEN 'N' END ,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p,
		vl_material		= vl_item_w,
		nr_seq_regra		= nr_seq_regra_vl_mat_w,
		nr_seq_material_forn	= nr_seq_material_forn_w,
		nr_seq_prest_fornec	= nr_seq_prest_fornec_w,
		nr_registro_anvisa	= cd_anvisa_w,
		cd_ref_fabricante_imp	= cd_ref_fabricante_w
	where	nr_sequencia 		= nr_seq_mat_origem_w;
	if (ie_status_w  = 'N') then
		if (ie_origem_solic_w = 'E') then
			CALL pls_gravar_requisicao_glosa(	'1426', null, null, nr_seq_mat_origem_w,
							substr('Material negado pelos grupos de análise. ' || ds_observacao_glosa_w, 1, 4000),
							nm_usuario_p, null, null, null, null, 'IG');
		else
			insert into pls_requisicao_glosa(nr_sequencia, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_requisicao,
				nr_seq_req_proc, nr_seq_req_mat, nr_seq_motivo_glosa,
				ds_observacao)
			values (nextval('pls_requisicao_glosa_seq'), clock_timestamp(), nm_usuario_p,
				clock_timestamp(), nm_usuario_p,null,
				null, nr_seq_mat_origem_w, 566,
				substr('Material negado pelos grupos de análise. '|| ds_observacao_glosa_w,1,4000));
		end if;
	end if;

	if	ie_tipo_processo_w	= 'I' then
		CALL pls_gerar_de_para_req_intercam(	null, nr_seq_mat_origem_w, null,
						null, null, null,
						null, obter_estabelecimento_ativo, nm_usuario_p);
	end if;
	end;
end loop;
close C02;

CALL pls_atualiza_estagio_req(nr_seq_requisicao_w,nm_usuario_p);

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

update	pls_requisicao
set	ie_anexo_guia = ie_anexo_guia_w,
	ie_anexo_quimioterapia = ie_anexo_quimioterapia_w,
	ie_anexo_radioterapia = ie_anexo_radioterapia_w,
	ie_anexo_opme = ie_anexo_opme_w
where 	nr_sequencia = nr_seq_requisicao_w;

commit;

--Atualizar informações da guia quando a requisição ficou em análise recebida via WebService
--Só funciona para Requisições geradas pelo WebService
CALL pls_atualizar_aud_req_guia( nr_seq_auditoria_p, nr_seq_requisicao_w, nm_usuario_p );

select	ie_estagio
into STRICT	ie_estagio_w
from	pls_requisicao
where	nr_sequencia	= nr_seq_requisicao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_req_liberada ( nr_seq_auditoria_p bigint, nm_usuario_p text) FROM PUBLIC;

