-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tre_gerar_eficaz ( ie_opcao_p text, nr_seq_efi_p text, cd_pessoa_solicitante_p text, ds_dano_breve_p text, ds_dano_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;


BEGIN

if (ie_opcao_p = 'S') then

	update	qms_treinamento_classif
	set 	dt_liberacao 	= trunc(clock_timestamp()),
		ie_eficaz	= 'S'
        where   nr_sequencia 	= nr_seq_efi_p;

else

	update	qms_treinamento_classif
	set 	ie_eficaz	= 'N'
        where   nr_sequencia 	= nr_seq_efi_p;


	select	nextval('man_ordem_servico_seq')
	into STRICT	nr_sequencia_w
	;

	insert into man_ordem_servico(nr_sequencia,
					cd_pessoa_solicitante,
					dt_ordem_servico,
					ie_prioridade,
					ie_parado,
					ds_dano_breve,
					dt_atualizacao,
					nm_usuario,
					ds_dano,
					ie_tipo_ordem)
	values (nr_sequencia_w,
					cd_pessoa_solicitante_p,
					clock_timestamp(),
					'M',
					'N',
					ds_dano_breve_p,
					clock_timestamp(),
					nm_usuario_p,
					ds_dano_p,
					13);

	update 	qms_treinamento_classif
	set	nr_seq_ordem = 	nr_sequencia_w
	where 	nr_sequencia = 	nr_seq_efi_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tre_gerar_eficaz ( ie_opcao_p text, nr_seq_efi_p text, cd_pessoa_solicitante_p text, ds_dano_breve_p text, ds_dano_p text, nm_usuario_p text) FROM PUBLIC;
