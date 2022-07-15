-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insere_inspecao_registro ( cd_estabelecimento_p bigint, cd_pessoa_resp_p text, cd_cnpj_p text, nm_usuario_p text, nr_seq_registro_p INOUT bigint, cd_pessoa_fisica_p text default null) AS $body$
DECLARE


nr_seq_registro_w  inspecao_registro.nr_sequencia%type;


BEGIN

if (cd_estabelecimento_p > 0) and (cd_pessoa_resp_p IS NOT NULL AND cd_pessoa_resp_p::text <> '') and
	((cd_cnpj_p IS NOT NULL AND cd_cnpj_p::text <> '') or (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '')) and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin

	select	nextval('inspecao_registro_seq')
	into STRICT	nr_seq_registro_w
	;

	insert into inspecao_registro(
		nr_sequencia,
		cd_estabelecimento,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_registro,
		cd_pessoa_resp,
		nr_seq_nf,
		cd_cnpj,
		dt_liberacao,
		nr_seq_nf_estornada,
		cd_pessoa_fisica,
		cd_cnpj_transportador,
		dt_devolucao,
		nm_usuario_dev,
		ie_origem)
	values (	nr_seq_registro_w,
		cd_estabelecimento_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		cd_pessoa_resp_p,
		null,
		cd_cnpj_p,
		null,
		null,
		cd_pessoa_fisica_p,
		null,
		null,
		null,
		'OC');
	commit;

	end;
end if;

nr_seq_registro_p := nr_seq_registro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insere_inspecao_registro ( cd_estabelecimento_p bigint, cd_pessoa_resp_p text, cd_cnpj_p text, nm_usuario_p text, nr_seq_registro_p INOUT bigint, cd_pessoa_fisica_p text default null) FROM PUBLIC;

