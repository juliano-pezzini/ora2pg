-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_gerar_rnc_fornecedor ( nr_seq_tipo_p bigint, cd_fornecedor_p text, cd_pf_abertura_p text, ds_nao_conformidade_p text, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;


BEGIN

select	nextval('qua_nao_conformidade_seq')
into STRICT	nr_sequencia_w
;

insert	into qua_nao_conformidade(
		nr_sequencia,
		cd_estabelecimento,
		dt_atualizacao,
		nm_usuario,
		dt_abertura,
		cd_pf_abertura,
		ds_nao_conformidade,
		cd_setor_atendimento,
		nm_usuario_origem,
		ie_status,
		nr_seq_tipo,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_fornecedor)
values (		nr_sequencia_w,
		cd_estabelecimento_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		cd_pf_abertura_p,
		ds_nao_conformidade_p,
		cd_setor_atendimento_p,
		nm_usuario_p,
		'Aberta',
		nr_seq_tipo_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_fornecedor_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_gerar_rnc_fornecedor ( nr_seq_tipo_p bigint, cd_fornecedor_p text, cd_pf_abertura_p text, ds_nao_conformidade_p text, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

