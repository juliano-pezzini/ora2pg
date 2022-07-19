-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_consistir_reemb ( nr_seq_reembolso_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_reembolso_proc_w		bigint;
nr_seq_reembolso_mat_w		bigint;
ie_valor_informado_w		pls_conta_proc.ie_valor_informado%type;
vl_liberado_w			pls_conta_proc.vl_liberado%type;
vl_unitario_w			pls_conta_proc.vl_unitario%type;
ie_forma_contab_reembolso_w	pls_parametro_contabil.ie_forma_contab_reembolso%type;
ie_concil_contab_w		pls_visible_false.ie_concil_contab%type;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		ie_valor_informado,
		vl_liberado,
		vl_unitario
	from	pls_conta_proc
	where	nr_seq_conta	= nr_seq_reembolso_p
	and	ie_status	<> 'D';

C02 CURSOR FOR
	SELECT	nr_sequencia,
		ie_valor_informado,
		vl_liberado,
		vl_unitario
	from	pls_conta_mat
	where	nr_seq_conta	= nr_seq_reembolso_p;

c_contas CURSOR FOR
	SELECT	distinct coalesce(c.vl_procedimento_imp,0) vl_item,
		trunc(clock_timestamp(),'dd') dt_mes_competencia,
		23 nr_seq_info,
		d.nm_tabela,
		d.nm_atributo,
		d.cd_tipo_lote_contabil,
		a.nr_sequencia nr_seq_tab_orig,
		b.nr_sequencia nr_seq_tab_compl,
		c.nr_sequencia nr_doc_analitico,
		count(case d.ie_situacao_ctb when 'P' then 1 end) qt_pendente
	from	ctb_documento		d,
		pls_conta_proc 		c,
		pls_conta 		b,
		pls_protocolo_conta 	a
	where	b.nr_sequencia		= c.nr_seq_conta
	and	a.nr_sequencia		= b.nr_seq_protocolo
	and	b.nr_sequencia		= nr_seq_reembolso_p
	and	ie_forma_contab_reembolso_w = 'M'
	and	a.ie_tipo_protocolo	= 'R'
	and	d.nr_documento		= a.nr_sequencia
	and	d.nr_seq_doc_compl	= b.nr_sequencia
	and	d.nr_doc_analitico	= c.nr_sequencia
	and	d.cd_tipo_lote_contabil = 23
	and	d.nm_atributo 		= 'VL_CALC_PROC'
	group by c.vl_procedimento_imp,
		d.nm_tabela,
		d.nm_atributo,
		d.cd_tipo_lote_contabil,
		a.nr_sequencia,
		b.nr_sequencia,
		c.nr_sequencia
	
union all

	SELECT	distinct coalesce(c.vl_material_imp,0) vl_item,
		trunc(clock_timestamp(),'dd') dt_mes_competencia,
		23 nr_seq_info,
		d.nm_tabela,
		d.nm_atributo,
		d.cd_tipo_lote_contabil,
		a.nr_sequencia nr_seq_tab_orig,
		b.nr_sequencia nr_seq_tab_compl,
		c.nr_sequencia nr_doc_analitico,
		count(case d.ie_situacao_ctb when 'P' then 1 end) qt_pendente
	from	ctb_documento 		d,
		pls_conta_mat		c,
		pls_conta 		b,
		pls_protocolo_conta 	a
	where	b.nr_sequencia		= c.nr_seq_conta
	and	a.nr_sequencia		= b.nr_seq_protocolo
	and	b.nr_sequencia		= nr_seq_reembolso_p
	and	ie_forma_contab_reembolso_w = 'M'
	and	a.ie_tipo_protocolo	= 'R'
	and	d.nr_documento		= a.nr_sequencia
	and	d.nr_seq_doc_compl	= b.nr_sequencia
	and	d.nr_doc_analitico	= c.nr_sequencia
	and	d.cd_tipo_lote_contabil = 23
	and	d.nm_atributo		= 'VL_CALC_MAT'
	group by c.vl_material_imp,
		d.nm_tabela,
		d.nm_atributo,
		d.cd_tipo_lote_contabil,
		a.nr_sequencia,
		b.nr_sequencia,
		c.nr_sequencia;

vet_contas		c_contas%rowtype;



BEGIN

open C01;
loop
fetch C01 into	
	nr_seq_reembolso_proc_w,
	ie_valor_informado_w,
	vl_liberado_w,
	vl_unitario_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	begin
	
	if (ie_valor_informado_w = 'N') then
		vl_liberado_w := 0;
		vl_unitario_w := 0;
	end if;
	
	update	pls_conta_proc
	set	ie_status 	= 'U',
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		ds_log		= 'pls_desfazer_consistir_reemb',
		nr_seq_regra	 = NULL,
		vl_procedimento	= 0,
		vl_glosa	= 0,
		vl_liberado	= vl_liberado_w,
		vl_unitario	= vl_unitario_w
	where	nr_sequencia 	= nr_seq_reembolso_proc_w;
	
	delete	FROM pls_ocorrencia_benef a
	where	nr_seq_conta_proc 	= nr_seq_reembolso_proc_w;
	
	delete	FROM pls_conta_glosa
	where	nr_seq_conta_proc 	= nr_seq_reembolso_proc_w;
	
	end;
end loop;
close C01;

open C02;
loop
fetch C02 into	
	nr_seq_reembolso_mat_w,
	ie_valor_informado_w,
	vl_liberado_w,
	vl_unitario_w;
EXIT WHEN NOT FOUND; /* apply on C02 */

	begin
	
	if (ie_valor_informado_w = 'N') then
		vl_liberado_w := 0;
		vl_unitario_w := 0;
	end if;
	
	update	pls_conta_mat
	set	ie_status 	= 'U',
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		nr_seq_regra	 = NULL,
		vl_material	= 0,
		vl_glosa	= 0,
		vl_liberado	= vl_liberado_w,
		vl_unitario	= vl_unitario_w
	where	nr_sequencia 	= nr_seq_reembolso_mat_w;
	
	delete	FROM pls_ocorrencia_benef a
	where	nr_seq_conta_mat 	= nr_seq_reembolso_mat_w;
	delete	FROM pls_conta_glosa
	where	nr_seq_conta_mat 	= nr_seq_reembolso_mat_w;
	end;
end loop;
close C02;

CALL pls_gerenciar_reembolso_pck.pls_reemb_desfazer_aprop(nr_seq_reembolso_p, cd_estabelecimento_p, nm_usuario_p);

delete	FROM pls_ocorrencia_benef a
where	a.nr_seq_conta 	= nr_seq_reembolso_p;
	
delete	FROM pls_conta_glosa
where	nr_seq_conta 	= nr_seq_reembolso_p;

update	pls_conta
set	ie_status 	= 'U',
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp(),
	vl_glosa	= 0
where	nr_sequencia 	= nr_seq_reembolso_p;

select	coalesce(max(ie_concil_contab), 'N')
into STRICT	ie_concil_contab_w
from 	pls_visible_false;

if (ie_concil_contab_w = 'S') then
	begin

	select	coalesce(max(ie_forma_contab_reembolso),'C')
	into STRICT	ie_forma_contab_reembolso_w
	from	pls_parametro_contabil
	where	cd_estabelecimento = cd_estabelecimento_p;

	open c_contas; -- Cursor igual ao que consta na rotina pls_consistir_reembolso
		loop
		fetch c_contas into	
			vet_contas;
		EXIT WHEN NOT FOUND; /* apply on c_contas */
		begin
		if (vet_contas.qt_pendente > 0) then
				delete 	FROM ctb_documento
				where	nr_documento = vet_contas.nr_seq_tab_orig
				and	nr_seq_doc_compl = vet_contas.nr_seq_tab_compl
				and	nr_doc_analitico = vet_contas.nr_doc_analitico
				and 	nm_tabela = vet_contas.nm_tabela
				and	nm_atributo = vet_contas.nm_atributo
				and	cd_tipo_lote_contabil = vet_contas.cd_tipo_lote_contabil
				and	ie_situacao_ctb = 'P'
				and	vl_movimento > 0;
		else
			CALL ctb_concil_financeira_pck.ctb_gravar_documento(cd_estabelecimento_p,
									trunc(clock_timestamp(), 'dd'),
									23, 
									null, 
									vet_contas.nr_seq_info, 
									vet_contas.nr_seq_tab_orig,
									vet_contas.nr_seq_tab_compl,
									vet_contas.nr_doc_analitico,
									vet_contas.vl_item * -1, -- Inverte o valor pois é estorno
									vet_contas.nm_tabela,
									vet_contas.nm_atributo,
									nm_usuario_p,
									'P',
									ie_forma_contab_reembolso_w);
		end if;
		end;
		end loop;
	close c_contas;
	commit;
	
	end;
end if;

CALL pls_liberar_reembolso(nr_seq_reembolso_p, 'D', nm_usuario_p, cd_estabelecimento_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_consistir_reemb ( nr_seq_reembolso_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

