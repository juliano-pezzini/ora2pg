-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_duplicar_guia_plano_anexo ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type) AS $body$
DECLARE


nr_seq_guia_plano_proc_w	pls_guia_plano_proc.nr_sequencia%type;
nr_seq_guia_plano_mat_w		pls_guia_plano_mat.nr_sequencia%type;

nr_seq_lote_anexo_proc_w	pls_lote_anexo_proc_aut.nr_sequencia%type;
nr_seq_lote_anexo_mat_w		pls_lote_anexo_mat_aut.nr_sequencia%type;
nr_seq_lote_anexo_guia_w	pls_lote_anexo_guias_aut.nr_sequencia%type;
nr_seq_lote_anexo_guia_new_w	pls_lote_anexo_guias_aut.nr_sequencia%type;
nr_seq_lote_anexo_diag_w	pls_lote_anexo_diag_aut.nr_sequencia%type;

c01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_guia_plano_proc
	where	nr_seq_guia	= nr_seq_guia_p;

c02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_guia_plano_mat
	where	nr_seq_guia	= nr_seq_guia_p;

c03 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_lote_anexo_guias_aut
	where	nr_seq_guia	= nr_seq_guia_p;


BEGIN

open C01;
loop
fetch C01 into nr_seq_guia_plano_proc_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
begin

select	nextval('pls_lote_anexo_proc_aut_seq')
	into STRICT	nr_seq_lote_anexo_proc_w
	;

insert into pls_lote_anexo_proc_aut(cd_procedimento, cd_tipo_tabela, ds_procedimento,
	dt_atualizacao, dt_atualizacao_nrec, dt_prev_realizacao,
	ie_origem_proced, ie_status, nm_usuario,
	nm_usuario_nrec, nr_seq_lote_anexo_guia, nr_seq_plano_proc,
	nr_sequencia, qt_solicitado)
(SELECT cd_procedimento, cd_tipo_tabela, ds_procedimento,
	clock_timestamp(), clock_timestamp(), dt_prev_realizacao,
	ie_origem_proced, ie_status, nm_usuario,
	nm_usuario_nrec, nr_seq_lote_anexo_guia, nr_seq_plano_proc,
	nr_seq_lote_anexo_proc_w, qt_solicitado
from	pls_lote_anexo_proc_aut
where	nr_seq_plano_proc	= nr_seq_guia_plano_proc_w);

commit;
end;
end loop;
close C01;

open C02;
loop
fetch C02 into nr_seq_guia_plano_mat_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
begin

select	nextval('pls_lote_anexo_mat_aut_seq')
	into STRICT	nr_seq_lote_anexo_mat_w
	;

insert into pls_lote_anexo_mat_aut(cd_aut_funcionamento, cd_material, cd_ref_fabricante_imp,
	cd_tipo_tabela_imp, ds_material, ds_observacao,
	dt_atualizacao, dt_atualizacao_nrec, dt_prevista,
	ie_frequencia_dose, ie_opcao_fabricante, ie_status,
	ie_via_administracao, nm_usuario, nm_usuario_nrec,
	nr_registro_anvisa, nr_seq_lote_anexo_guia, nr_seq_material,
	nr_seq_plano_mat, nr_sequencia, qt_autorizado,
	qt_solicitado, vl_unit_material_aut, vl_unit_material_solic)
(SELECT cd_aut_funcionamento, cd_material, cd_ref_fabricante_imp,
	cd_tipo_tabela_imp, ds_material, ds_observacao,
	clock_timestamp(), clock_timestamp(), dt_prevista,
	ie_frequencia_dose, ie_opcao_fabricante, ie_status,
	ie_via_administracao, nm_usuario, nm_usuario_nrec,
	nr_registro_anvisa, nr_seq_lote_anexo_guia, nr_seq_material,
	nr_seq_plano_mat, nr_seq_lote_anexo_mat_w, qt_autorizado,
	qt_solicitado, vl_unit_material_aut, vl_unit_material_solic
from	pls_lote_anexo_mat_aut
where	nr_seq_plano_mat	= nr_seq_guia_plano_mat_w);
commit;

end;
end loop;
close C02;

open C03;
loop
fetch C03 into nr_seq_lote_anexo_guia_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
begin

select	nextval('pls_lote_anexo_guias_aut_seq')
into STRICT	nr_seq_lote_anexo_guia_new_w
;

insert into pls_lote_anexo_guias_aut(cd_ans, cd_cnes, cd_guia,
	cd_guia_prestador, cd_guia_referencia, cd_senha,
	cd_usuario_plano, ds_area_irradiada, ds_biometria,
	ds_email_prof_solic, ds_especificacao, ds_justificativa,
	ds_observacao, ds_procedimento_cirurgico, ds_quimioterapia,
	dt_atualizacao, dt_atualizacao_nrec, dt_autorizacao,
	dt_inicio_previsto, dt_quimioterapia, dt_radioterapia,
	dt_real_proc_cirurgico, dt_solicitacao, ie_recem_nascido,
	ie_sexo, ie_status, ie_tipo_anexo,
	nm_beneficiario, nm_profissional_solic, nm_usuario,
	nm_usuario_nrec, nr_campos, nr_ciclo_atual,
	nr_ciclo_previsto, nr_seq_guia, nr_seq_guia_principal,
	nr_seq_lote_anexo, nr_sequencia, nr_telef_prof_solic,
	qt_altura, qt_campo_irradiacao, qt_dias_previsto,
	qt_dose_dia, qt_dose_total, qt_idade_benef,
	qt_intervalo_ciclo, qt_peso, qt_superficie_corporal)
(SELECT 	cd_ans, cd_cnes, nr_seq_guia_p,
	cd_guia_prestador, cd_guia_referencia, cd_senha,
	cd_usuario_plano, ds_area_irradiada, ds_biometria,
	ds_email_prof_solic, ds_especificacao, ds_justificativa,
	ds_observacao, ds_procedimento_cirurgico, ds_quimioterapia,
	clock_timestamp(), clock_timestamp(), dt_autorizacao,
	dt_inicio_previsto, dt_quimioterapia, dt_radioterapia,
	dt_real_proc_cirurgico, dt_solicitacao, ie_recem_nascido,
	ie_sexo, ie_status, ie_tipo_anexo,
	nm_beneficiario, nm_profissional_solic, nm_usuario,
	nm_usuario_nrec, nr_campos, nr_ciclo_atual,
	nr_ciclo_previsto, nr_seq_guia, nr_seq_guia_principal,
	nr_seq_lote_anexo, nr_seq_lote_anexo_guia_new_w, nr_telef_prof_solic,
	qt_altura, qt_campo_irradiacao, qt_dias_previsto,
	qt_dose_dia, qt_dose_total, qt_idade_benef,
	qt_intervalo_ciclo, qt_peso, qt_superficie_corporal
from pls_lote_anexo_guias_aut
where nr_sequencia	= nr_seq_lote_anexo_guia_w);

commit;

select	nextval('pls_lote_anexo_diag_aut_seq')
	into STRICT	nr_seq_lote_anexo_diag_w
	;

insert into pls_lote_anexo_diag_aut(cd_diagnostico_imagem, cd_doenca, cd_finalidade_tratamento,
	ds_diagnostico, ds_observacao, ds_plano_terapeutico,
	dt_atualizacao, dt_atualizacao_nrec, dt_diagnostico,
	ie_capacidade_funcional, ie_classificacao, ie_estadia_tumor,
	ie_tipo_diagnostico, ie_tipo_quimioterapia,
	nm_usuario, nm_usuario_nrec, nr_seq_lote_anexo_guia,
	nr_sequencia)
(SELECT cd_diagnostico_imagem, cd_doenca, cd_finalidade_tratamento,
	ds_diagnostico, ds_observacao, ds_plano_terapeutico,
	clock_timestamp(), clock_timestamp(), dt_diagnostico,
	ie_capacidade_funcional, ie_classificacao, ie_estadia_tumor,
        ie_tipo_diagnostico, ie_tipo_quimioterapia,
	nm_usuario, nm_usuario_nrec, nr_seq_lote_anexo_guia,
	nr_seq_lote_anexo_diag_w
from pls_lote_anexo_diag_aut
where nr_seq_lote_anexo_guia	= nr_seq_lote_anexo_guia_w);

commit;
end;
end loop;
close C03;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_duplicar_guia_plano_anexo ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type) FROM PUBLIC;

