-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_envio_email_manual_resc ( nr_seq_solicitacao_p bigint, nr_seq_email_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_prioridade_w			pls_email_parametros.cd_prioridade%type;
nr_seq_email_w			pls_email.nr_sequencia%type;
nr_seq_anexo_w			pls_email_anexo.nr_sequencia%type;
ds_mensagem_w			varchar(4000);
ds_assunto_w			varchar(255);
ds_destinatario_w		varchar(255);
vl_parametro_w			varchar(255);

C01 CURSOR FOR
	SELECT 	nr_sequencia,
		ds_anexo
	from 	w_pls_envio_email_anexo
	where 	nr_seq_w_email = nr_seq_email_p
	order by 1;

BEGIN
--Origem : 2 - OPS - Gestão de Rescisão de Contrato
select	coalesce(max(cd_prioridade),5)
into STRICT	cd_prioridade_w
from	pls_email_parametros
where	ie_origem 		= 2
and	cd_estabelecimento 	= cd_estabelecimento_p
and	ie_situacao 		= 'A';

vl_parametro_w := Obter_Param_Usuario(268, 10, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, vl_parametro_w);

if (nr_seq_email_p IS NOT NULL AND nr_seq_email_p::text <> '') and (nr_seq_solicitacao_p IS NOT NULL AND nr_seq_solicitacao_p::text <> '') then

	select 	ds_mensagem,
		ds_assunto,
		ds_destinatario
	into STRICT	ds_mensagem_w,
		ds_assunto_w,
		ds_destinatario_w
	from 	w_pls_envio_email
	where 	nr_sequencia = nr_seq_email_p;

	select	nextval('pls_email_seq')
	into STRICT	nr_seq_email_w
	;

	insert into pls_email(
				nr_sequencia,
				nr_seq_solic_rescisao,
				cd_estabelecimento,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nm_usuario,
				dt_atualizacao,
				ie_tipo_mensagem,
				ie_status,
				ie_origem,
				ds_remetente,
				ds_mensagem,
				ds_destinatario,
				ds_assunto,
				cd_prioridade)
	values (			nr_seq_email_w,
				nr_seq_solicitacao_p,
				cd_estabelecimento_p,
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				2,	--Envio de Dados da Solicitação de rescisão
				'P',	--Pendente
				2,	--OPS - Gestão de Rescisão de Contrato
				vl_parametro_w, 	--Remetente
				ds_mensagem_w,
				ds_destinatario_w,
				ds_assunto_w,
				cd_prioridade_w
				);
	for r_C01_w in C01 loop
		select	nextval('pls_email_anexo_seq')
		into STRICT	nr_seq_anexo_w
		;

		insert into pls_email_anexo(
					nr_sequencia,
					nr_seq_email,
					nm_usuario,
					nm_usuario_nrec,
					dt_atualizacao,
					dt_atualizacao_nrec,
					ds_arquivo,
					ie_tipo_anexo )
		values (			nr_seq_anexo_w,
					nr_seq_email_w,
					nm_usuario_p,
					nm_usuario_p,
					clock_timestamp(),
					clock_timestamp(),
					r_C01_w.ds_anexo,
					'A'
					);

	end loop;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_envio_email_manual_resc ( nr_seq_solicitacao_p bigint, nr_seq_email_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

