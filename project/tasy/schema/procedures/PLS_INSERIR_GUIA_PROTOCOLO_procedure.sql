-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_inserir_guia_protocolo (nr_seq_guia_p bigint, nr_seq_protocolo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_conta_w			pls_conta.nr_sequencia%type;
cd_procedimento_w		pls_conta_proc.cd_procedimento%type;
ie_origem_proced_w		pls_conta_proc.ie_origem_proced%type;
qt_autorizada_proc_w		pls_guia_plano_proc.qt_autorizada%type;
ie_tipo_doenca_w		pls_diagnostico.ie_tipo_doenca%type;
ie_indicacao_acidente_w		pls_diagnostico.ie_indicacao_acidente%type;
ie_classificacao_w		pls_diagnostico.ie_classificacao%type;
cd_doenca_w			pls_diagnostico.cd_doenca%type;
ds_diagnostico_w		pls_diagnostico.ds_diagnostico%type;
ie_classificacao_proc_w		procedimento.ie_classificacao%type;
qt_registros_w			integer;
ie_tipo_guia_w			pls_guia_plano.ie_tipo_guia%type;

cd_validacao_benef_tiss_w	pls_conta_tiss.cd_validacao_benef_tiss%type;
cd_ausencia_val_benef_tiss_w	pls_conta_tiss.cd_ausencia_val_benef_tiss%type;
cd_ident_biometria_benef_w	pls_conta_tiss.cd_ident_biometria_benef%type;
cd_template_biomet_benef_w	text; --pls_conta_tiss.cd_template_biomet_benef%type;
ie_tipo_ident_benef_w		pls_conta_tiss.ie_tipo_ident_benef%type;
nr_seq_item_tiss_w		pls_guia_plano_proc.nr_seq_item_tiss%type;
nr_seq_conta_proc_novo_w	pls_conta_proc.nr_sequencia%type;

c01 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced,
		qt_autorizada,
		nr_seq_item_tiss
	from	pls_guia_plano_proc
	where	nr_seq_guia	= nr_seq_guia_p;

c03 CURSOR FOR
	SELECT	ie_tipo_doenca,
		ie_indicacao_acidente,
		ie_classificacao,
		cd_doenca,
		ds_diagnostico
	from	pls_diagnostico
	where	nr_seq_guia	= nr_seq_guia_p;


BEGIN

if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then

	select	count(1)
	into STRICT	qt_registros_w
	from	pls_conta
	where	nr_seq_guia		= nr_seq_guia_p
	and	nr_seq_protocolo	= nr_seq_protocolo_p;

	if (qt_registros_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(230686,';NR_SEQ_GUIA=' ||nr_seq_guia_p);
	end if;

	select	ie_tipo_guia
	into STRICT	ie_tipo_guia_w
	from	pls_guia_plano
	where	nr_sequencia	= nr_seq_guia_p;

	if (ie_tipo_guia_w = '2') then
		ie_tipo_guia_w	:= '4';
	else
		ie_tipo_guia_w	:= '5';
	end if;

	select	nextval('pls_conta_seq')
	into STRICT	nr_seq_conta_w
	;

	insert into pls_conta(nr_sequencia, nm_usuario, dt_atualizacao,
		nr_seq_protocolo, cd_guia, dt_autorizacao,
		cd_senha, dt_validade_senha, nr_seq_segurado,
		cd_medico_solicitante, cd_medico_executor, ie_status,
		nr_seq_guia, ie_tipo_guia, vl_procedimentos,
		vl_taxas, vl_diarias, vl_materiais,
		vl_medicamentos, vl_gases, vl_opm,
		vl_cobrado, vl_saldo, vl_glosa,
		vl_total, cd_estabelecimento, cd_cooperativa,
		ie_origem_conta)
	SELECT	nr_seq_conta_w, nm_usuario_p, clock_timestamp(),
		nr_seq_protocolo_p, cd_guia, dt_autorizacao,
		cd_senha, dt_validade_senha, nr_seq_segurado,
		cd_medico_solicitante, null,
		'U', nr_seq_guia_p, ie_tipo_guia_w,
		0,0,0,0,0,0,0,0,0,0,0,cd_estabelecimento_p,
		substr(obter_cooperativa_benef(nr_seq_segurado, cd_estabelecimento_p),1,4),
		'T'
	from	pls_guia_plano
	where	nr_sequencia	= nr_seq_guia_p;


	select	max(cd_validacao_benef_tiss),
		max(cd_ausencia_val_benef_tiss),
		max(cd_ident_biometria_benef),
		max(cd_template_biomet_benef),
		max(ie_tipo_ident_benef)
	into STRICT	cd_validacao_benef_tiss_w,
		cd_ausencia_val_benef_tiss_w,
		cd_ident_biometria_benef_w,
		cd_template_biomet_benef_w,
		ie_tipo_ident_benef_w
	from	pls_guia_plano
	where	nr_sequencia	= nr_seq_guia_p;

	CALL pls_conta_tiss_pck.criar_registro(	nr_seq_conta_w,
						cd_estabelecimento_p,
						cd_validacao_benef_tiss_w,
						cd_ausencia_val_benef_tiss_w,
						cd_ident_biometria_benef_w,
						cd_template_biomet_benef_w,
						ie_tipo_ident_benef_w,
						null,
						nm_usuario_p);




	open c01;
	loop
	fetch c01 into	cd_procedimento_w,
			ie_origem_proced_w,
			qt_autorizada_proc_w,
			nr_seq_item_tiss_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		select	ie_classificacao
		into STRICT	ie_classificacao_proc_w
		from	procedimento
		where	cd_procedimento		= cd_procedimento_w
		and	ie_origem_proced	= ie_origem_proced_w;

		insert into pls_conta_proc(nr_sequencia, nm_usuario, dt_atualizacao,
			cd_procedimento, ie_origem_proced, qt_procedimento_imp,
			nr_seq_conta, ie_tipo_despesa, ie_status,
			ie_situacao, vl_procedimento_imp, vl_unitario_imp,
			vl_unitario, qt_procedimento, vl_liberado,
			vl_procedimento, vl_glosa, vl_saldo,
			tx_item)
		values (nextval('pls_conta_proc_seq'), nm_usuario_p, clock_timestamp(),
			cd_procedimento_w, ie_origem_proced_w, qt_autorizada_proc_w,
			nr_seq_conta_w, ie_classificacao_proc_w, 'U',
			'D', 0,0,0,0,0,0,0,0,100) returning nr_sequencia into nr_seq_conta_proc_novo_w;

		if (nr_seq_item_tiss_w IS NOT NULL AND nr_seq_item_tiss_w::text <> '') then

			-- Se existe a regra, so atualiza, senão gera novamente
			CALL pls_cta_proc_mat_regra_pck.cria_registro_regra_proc(nr_seq_conta_proc_novo_w, nm_usuario_p);

			CALL pls_cta_proc_mat_regra_pck.atualiza_seq_tiss_proc(nr_seq_conta_proc_novo_w, nr_seq_item_tiss_w, null,  nm_usuario_p);

		end if;
	end loop;
	close c01;

	open c03;
	loop
	fetch c03 into	ie_tipo_doenca_w,
			ie_indicacao_acidente_w,
			ie_classificacao_w,
			cd_doenca_w,
			ds_diagnostico_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */

		insert into pls_diagnostico_conta(nr_sequencia, dt_atualizacao, nm_usuario,
			ie_tipo_doenca, ie_indicacao_acidente, ie_classificacao,
			cd_doenca, ds_diagnostico, nr_seq_conta)
		values (nextval('pls_diagnostico_conta_seq'), clock_timestamp(), nm_usuario_p,
			ie_tipo_doenca_w, ie_indicacao_acidente_w, ie_classificacao_w,
			cd_doenca_w, ds_diagnostico_w, nr_seq_conta_w);
	end loop;
	close c03;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_inserir_guia_protocolo (nr_seq_guia_p bigint, nr_seq_protocolo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
