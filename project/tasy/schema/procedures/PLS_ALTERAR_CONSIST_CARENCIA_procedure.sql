-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_consist_carencia ( nr_seq_contrato_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


ie_consist_carenc_w	varchar(1);


BEGIN

if (coalesce(nr_seq_contrato_p, 0) <> 0) then

	select	ie_consistir_carencia_rede
	into STRICT	ie_consist_carenc_w
	from	pls_contrato
	where	nr_sequencia = nr_seq_contrato_p;

	if (coalesce(ie_consist_carenc_w, 'N') = 'N') then
		ie_consist_carenc_w	:= 'S';
	elsif (coalesce(ie_consist_carenc_w, 'N') = 'S') then
		ie_consist_carenc_w	:= 'N';
	end if;

	update	pls_contrato
	set	ie_consistir_carencia_rede = ie_consist_carenc_w,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_seq_contrato_p;

	insert into pls_contrato_historico(	nr_sequencia, cd_estabelecimento, nr_seq_contrato, dt_historico, ie_tipo_historico,
			dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ds_historico,
			ds_observacao)
		values (	nextval('pls_contrato_historico_seq'), cd_estabelecimento_p, nr_seq_contrato_p, clock_timestamp(), '67',
			clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 'Alterada a consistência de carência da rede de atendimento',
			'pls_alterar_consist_carencia');

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_consist_carencia ( nr_seq_contrato_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
