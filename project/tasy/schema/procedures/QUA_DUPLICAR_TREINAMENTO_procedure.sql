-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_duplicar_treinamento ( nr_seq_treinamento_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_seq_treinamento_novo_w	bigint;
cd_cargo_w		bigint;
cd_pessoa_resp_w		varchar(10);
nm_responsavel_w		varchar(225);
ie_faltou_w		varchar(1);
cd_pessoa_fisica_w	varchar(10);
ds_observacao_w		varchar(255);
dt_confirmacao_w		timestamp;
dt_envio_nota_w		timestamp;
nm_pessoa_externo_w	varchar(255);
vl_nota_w		integer;
cd_funcao_w		integer;
cd_setor_atendimento_w	bigint;

C01 CURSOR FOR
	SELECT	cd_cargo,
		cd_pessoa_resp,
		nm_responsavel
	from	qua_doc_trein_resp
	where	nr_seq_treinamento = nr_seq_treinamento_p;

C02 CURSOR FOR
	SELECT	ie_faltou,
		cd_pessoa_fisica,
		ds_observacao,
		dt_confirmacao,
		dt_envio_nota,
		nm_pessoa_externo,
		vl_nota,
		cd_setor_atendimento
	from	qua_doc_trein_pessoa
	where	nr_seq_treinamento = nr_seq_treinamento_p;

C03 CURSOR FOR
	SELECT	cd_funcao
	from	qua_doc_trein_funcao
	where	nr_seq_treinamento = nr_seq_treinamento_p;


BEGIN

select	nextval('qua_doc_treinamento_seq')
into STRICT	nr_seq_treinamento_novo_w
;

insert into qua_doc_treinamento(
			nr_sequencia,
			ds_treinamento,
			dt_atualizacao,
			dt_prevista,
			ie_filmagem,
			nm_usuario,
			nr_seq_documento,
			qt_tempo_previsto,
			cd_funcao,
			ds_arquivo,
			dt_atualizacao_nrec,
			dt_fim_real,
			dt_real,
			ie_controla_confirmacao,
			ie_interno_externo,
			ie_retreinamento,
			nm_usuario_nrec,
			nr_seq_modulo,
			qt_particip_prev,
			qt_tempo_real)
		SELECT	nr_seq_treinamento_novo_w,
			ds_treinamento,
			clock_timestamp(),
			dt_prevista,
			ie_filmagem,
			nm_usuario_p,
			nr_seq_documento,
			qt_tempo_previsto,
			cd_funcao,
			ds_arquivo,
			clock_timestamp(),
			dt_fim_real,
			dt_real,
			ie_controla_confirmacao,
			ie_interno_externo,
			ie_retreinamento,
			nm_usuario_p,
			nr_seq_modulo,
			qt_particip_prev,
			qt_tempo_real
		from	qua_doc_treinamento
		where	nr_sequencia = nr_seq_treinamento_p;

open C01;
loop
fetch C01 into
	cd_cargo_w,
	cd_pessoa_resp_w,
	nm_responsavel_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	insert into qua_doc_trein_resp( nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					nr_seq_treinamento,
					cd_cargo,
					cd_pessoa_resp,
					dt_atualizacao_nrec,
					nm_responsavel,
					nm_usuario_nrec)
				values ( nextval('qua_doc_trein_resp_seq'),
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_treinamento_novo_w,
					cd_cargo_w,
					cd_pessoa_resp_w,
					clock_timestamp(),
					nm_responsavel_w,
					clock_timestamp());

	end;

end loop;
close C01;

open C02;
loop
fetch C02 into
	ie_faltou_w,
	cd_pessoa_fisica_w,
	ds_observacao_w,
	dt_confirmacao_w,
	dt_envio_nota_w,
	nm_pessoa_externo_w,
	vl_nota_w,
	cd_setor_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin

		insert into qua_doc_trein_pessoa( nr_sequencia,
					dt_atualizacao,
					ie_faltou,
					nm_usuario,
					nr_seq_treinamento,
					cd_pessoa_fisica,
					ds_observacao,
					dt_atualizacao_nrec,
					dt_confirmacao,
					dt_envio_nota,
					nm_pessoa_externo,
					nm_usuario_nrec,
					vl_nota,
					cd_setor_atendimento)
				values ( nextval('qua_doc_trein_pessoa_seq'),
					clock_timestamp(),
					ie_faltou_w,
					nm_usuario_p,
					nr_seq_treinamento_novo_w,
					cd_pessoa_fisica_w,
					ds_observacao_w,
					clock_timestamp(),
					dt_confirmacao_w,
					dt_envio_nota_w,
					nm_pessoa_externo_w,
					nm_usuario_p,
					vl_nota_w,
					cd_setor_atendimento_w);
	end;
end loop;
close C02;

open C03;
loop
fetch C03 into
	cd_funcao_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin

	insert into qua_doc_trein_funcao(nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					nr_seq_treinamento,
					cd_funcao,
					dt_atualizacao_nrec,
					nm_usuario_nrec)
				values ( nextval('qua_doc_trein_funcao_seq'),
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_treinamento_novo_w,
					cd_funcao_w,
					clock_timestamp(),
					nm_usuario_p);

	end;
end loop;
close C03;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_duplicar_treinamento ( nr_seq_treinamento_p bigint, nm_usuario_p text) FROM PUBLIC;
