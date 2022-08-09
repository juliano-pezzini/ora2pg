-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_filtro_mala_direta ( nr_contrato_p bigint, cd_usuario_plano_p text, nm_usuario_p text, ie_opcao_p text, ie_escolha_p text) AS $body$
DECLARE

/*IE_ESCOLHA_P
	CO - Contratos do plano de saúde
	CI - Contratos de intercâmbio
	B - cd_usuario_plano_p*/
/*IE_OPCAO
	G - Gerar filtros
	L - Limpar filtros*/
nr_sequencia_w			bigint;
qt_contratos_w			bigint;
qt_carteira_w			bigint;
nr_seq_contrato_w		bigint;
nr_seq_carteira_w		bigint;
nr_seq_segurado_w		bigint;
qt_contratos_intercambio_w	bigint;


BEGIN

if (ie_opcao_p = 'L') then

	delete 	FROM pls_mala_direta_filtro
	where	nm_usuario = nm_usuario_p;

elsif (ie_opcao_p = 'G') then
	if (nr_contrato_p IS NOT NULL AND nr_contrato_p::text <> '') and (ie_escolha_p = 'CO')then
		select	count(*)
		into STRICT	qt_contratos_w
		from	pls_contrato
		where	nr_contrato = nr_contrato_p;

		if (qt_contratos_w = 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(238774, null);
			--contrato não existente!
		elsif (qt_contratos_w > 0) then
			select 	nr_sequencia
			into STRICT	nr_seq_contrato_w
			from	pls_contrato
			where	nr_contrato = nr_contrato_p;

			select	nextval('pls_mala_direta_filtro_seq')
			into STRICT	nr_sequencia_w
			;

			insert into pls_mala_direta_filtro(nr_sequencia, dt_atualizacao, nm_usuario, nr_seq_contrato)
			values (nr_sequencia_w, clock_timestamp(), nm_usuario_p, nr_seq_contrato_w);
		end if;
	elsif (nr_contrato_p IS NOT NULL AND nr_contrato_p::text <> '') and (ie_escolha_p = 'CI') then
		select	count(*)
		into STRICT	qt_contratos_intercambio_w
		from	pls_intercambio
		where	nr_sequencia = nr_contrato_p;

		if (qt_contratos_intercambio_w = 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(286805, null);
			--Contrato de intercâmbio não existente!
		else
			select	nextval('pls_mala_direta_filtro_seq')
			into STRICT	nr_sequencia_w
			;

			insert into pls_mala_direta_filtro(nr_sequencia, dt_atualizacao, nm_usuario, nr_seq_intercambio)
			values (nr_sequencia_w, clock_timestamp(), nm_usuario_p, nr_contrato_p);
		end if;
	elsif (cd_usuario_plano_p IS NOT NULL AND cd_usuario_plano_p::text <> '') and (ie_escolha_p = 'B')then
		select	count(*)
		into STRICT	qt_carteira_w
		from	pls_segurado_carteira
		where	cd_usuario_plano = cd_usuario_plano_p;

		if (qt_carteira_w = 0) then
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(270590, null);
			--Número de carteira não encontrado!
		elsif (qt_carteira_w > 0) then
			select	max(nr_sequencia)
			into STRICT	nr_seq_carteira_w
			from	pls_segurado_carteira
			where	cd_usuario_plano = cd_usuario_plano_p;

			select  a.nr_sequencia
			into STRICT	nr_seq_segurado_w
			from	pls_segurado_carteira b,
				pls_segurado a
			where	a.nr_sequencia = b.nr_seq_segurado
			and	b.nr_sequencia = nr_seq_carteira_w;

			select	nextval('pls_mala_direta_filtro_seq')
			into STRICT	nr_sequencia_w
			;

			insert into pls_mala_direta_filtro(nr_sequencia, dt_atualizacao, nm_usuario, nr_seq_segurado)
			values ( nr_sequencia_w, clock_timestamp(), nm_usuario_p, nr_seq_segurado_w);
		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_filtro_mala_direta ( nr_contrato_p bigint, cd_usuario_plano_p text, nm_usuario_p text, ie_opcao_p text, ie_escolha_p text) FROM PUBLIC;
