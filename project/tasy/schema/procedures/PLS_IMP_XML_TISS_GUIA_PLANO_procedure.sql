-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_imp_xml_tiss_guia_plano ( nr_seq_guia_p bigint, cd_estabelecimento_p bigint, cd_guia_imp_p text, nm_usuario_p text, ie_tipo_guia_p text, cd_usuario_plano_imp_p text, nm_pessoa_fisica_p text, ds_plano_p text, dt_validade_cartao_p text, cd_ans_p text, ie_carater_internacao_imp_p text, dt_solicitacao_imp_p text, ds_indicacao_clinica_imp_p text, ie_regime_internacao_imp_p text, nr_seq_autorizacao_imp_p bigint, nr_seq_clinica_imp_p bigint, qt_dia_autorizado_imp_p bigint, dt_admissao_hosp_imp_p text, dt_validade_senha_imp_p text, cd_tipo_acomod_autor_imp_p text, ie_tipo_processo_p text, nr_cartao_nac_sus_imp_p bigint, ds_observacao_imp_p text, cd_senha_imp_p text, nr_seq_guia_novo_p INOUT bigint) AS $body$
DECLARE


nr_seq_guia_w	bigint;


BEGIN
select	nextval('pls_guia_plano_seq')
into STRICT	nr_seq_guia_w
;

nr_seq_guia_novo_p	:= nr_seq_guia_w;

insert into pls_guia_plano(nr_sequencia,
	cd_estabelecimento,
	cd_guia,
	cd_guia_imp,
	ie_status,
	ie_situacao,
	ie_estagio,
	nm_usuario,
	dt_atualizacao,
	ie_tipo_guia,
	cd_usuario_plano_imp,
	nm_segurado_imp,
	ds_plano_imp,
	dt_validade_cartao_imp,
	cd_ans_imp,
	ie_carater_internacao_imp,
	dt_solicitacao_imp,
	ds_indicacao_clinica_imp,
	ie_regime_internacao_imp,
	nr_seq_autorizacao_imp,
	nr_seq_clinica_imp,
	qt_dia_autorizado_imp,
	dt_admissao_hosp_imp,
	dt_validade_senha_imp,
	cd_tipo_acomod_autor_imp,
	ie_tipo_processo,
	nr_cartao_nac_sus_imp,
	ds_observacao_imp,
	cd_senha_imp)
values (nr_seq_guia_w,
	cd_estabelecimento_p,
	to_char(nr_seq_guia_p),
	cd_guia_imp_p,
	'2',
	'U',
	7,
	nm_usuario_p,
	clock_timestamp(),
	ie_tipo_guia_p,
	cd_usuario_plano_imp_p,
	nm_pessoa_fisica_p,
	ds_plano_p,
	to_date(dt_validade_cartao_p, 'dd/mm/yyyy'),
	cd_ans_p,
	ie_carater_internacao_imp_p,
	to_date(dt_solicitacao_imp_p, 'dd/mm/yyyy'),
	ds_indicacao_clinica_imp_p,
	ie_regime_internacao_imp_p,
	nr_seq_autorizacao_imp_p,
	nr_seq_clinica_imp_p,
	qt_dia_autorizado_imp_p,
	to_date(dt_admissao_hosp_imp_p, 'dd/mm/yyyy'),
	to_date(dt_validade_senha_imp_p, 'dd/mm/yyyy'),
	cd_tipo_acomod_autor_imp_p,
	ie_tipo_processo_p,
	nr_cartao_nac_sus_imp_p,
	ds_observacao_imp_p,
	cd_senha_imp_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_xml_tiss_guia_plano ( nr_seq_guia_p bigint, cd_estabelecimento_p bigint, cd_guia_imp_p text, nm_usuario_p text, ie_tipo_guia_p text, cd_usuario_plano_imp_p text, nm_pessoa_fisica_p text, ds_plano_p text, dt_validade_cartao_p text, cd_ans_p text, ie_carater_internacao_imp_p text, dt_solicitacao_imp_p text, ds_indicacao_clinica_imp_p text, ie_regime_internacao_imp_p text, nr_seq_autorizacao_imp_p bigint, nr_seq_clinica_imp_p bigint, qt_dia_autorizado_imp_p bigint, dt_admissao_hosp_imp_p text, dt_validade_senha_imp_p text, cd_tipo_acomod_autor_imp_p text, ie_tipo_processo_p text, nr_cartao_nac_sus_imp_p bigint, ds_observacao_imp_p text, cd_senha_imp_p text, nr_seq_guia_novo_p INOUT bigint) FROM PUBLIC;

