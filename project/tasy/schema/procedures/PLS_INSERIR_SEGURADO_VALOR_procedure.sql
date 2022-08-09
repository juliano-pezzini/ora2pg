-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_inserir_segurado_valor ( nr_seq_segurado_p bigint, ie_motivo_alteracao_p text, dt_preco_p timestamp, nr_seq_plano_p bigint, nr_seq_tabela_p bigint, nr_seq_processo_judicial_p bigint, ds_reservado1_p text, ds_reservado2_p text, ds_reservado3_p text, ds_reservado4_p text, ie_commit_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_contrato_w		pls_contrato.nr_sequencia%type;
nr_seq_parentesco_w		pls_segurado.nr_seq_parentesco%type;
ie_tipo_parentesco_benef_w	pls_segurado.ie_tipo_parentesco%type;
nr_seq_plano_w			pls_plano.nr_sequencia%type;
nr_seq_tabela_w			pls_tabela_preco.nr_sequencia%type;
ie_calculo_vidas_w		pls_tabela_preco.ie_calculo_vidas%type;
ie_tipo_parentesco_w		pls_segurado_valor.ie_tipo_parentesco%type;
ie_tabela_qt_vidas_w		pls_segurado_valor.ie_tabela_qt_vidas%type;
qt_vidas_w			pls_segurado_valor.qt_vidas%type	:= 0;
tx_desconto_w			pls_segurado_valor.tx_desconto%type	:= 0;
vl_desconto_w			pls_segurado_valor.vl_desconto%type	:= 0;
nr_seq_regra_desconto_w		pls_regra_desconto.nr_sequencia%type;
nr_seq_regra_desconto_atual_w	pls_regra_desconto.nr_sequencia%type;
ie_inserir_valor_w		varchar(1);


BEGIN

select	nr_seq_contrato,
	nr_seq_parentesco,
	ie_tipo_parentesco,
	coalesce(nr_seq_plano_p,nr_seq_plano),
	coalesce(nr_seq_tabela_p,nr_seq_tabela)
into STRICT	nr_seq_contrato_w,
	nr_seq_parentesco_w,
	ie_tipo_parentesco_benef_w,
	nr_seq_plano_w,
	nr_seq_tabela_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

if (nr_seq_plano_w IS NOT NULL AND nr_seq_plano_w::text <> '') and (nr_seq_tabela_w IS NOT NULL AND nr_seq_tabela_w::text <> '') then
	ie_inserir_valor_w	:= 'S';

	if (ie_motivo_alteracao_p <> '1') then
		select	max(nr_seq_regra_desconto)
		into STRICT	nr_seq_regra_desconto_atual_w
		from	pls_segurado_valor
		where	nr_sequencia	= (	SELECT	max(nr_sequencia)
						from	pls_segurado_valor
						where	nr_seq_segurado	= nr_seq_segurado_p);
	else
		nr_seq_regra_desconto_atual_w	:= null;
	end if;

	SELECT * FROM pls_obter_regra_desconto_benef(nr_seq_segurado_p, dt_preco_p, nr_seq_regra_desconto_w, tx_desconto_w, vl_desconto_w) INTO STRICT nr_seq_regra_desconto_w, tx_desconto_w, vl_desconto_w;

	if (ie_motivo_alteracao_p = '7') then
		if (coalesce(nr_seq_regra_desconto_w::text, '') = '') and (coalesce(nr_seq_regra_desconto_atual_w::text, '') = '') then
			ie_inserir_valor_w	:= 'N';
		end if;
	end if;

	select	coalesce(ie_preco_vidas_contrato,'N'),
		ie_calculo_vidas
	into STRICT	ie_tabela_qt_vidas_w,
		ie_calculo_vidas_w
	from	pls_tabela_preco
	where	nr_sequencia	= nr_seq_tabela_w;

	if (ie_tabela_qt_vidas_w = 'S') then
		qt_vidas_w	:= pls_obter_qt_vidas_tab_preco(nr_seq_segurado_p,ie_calculo_vidas_w, null);
	end if;

	if (nr_seq_parentesco_w IS NOT NULL AND nr_seq_parentesco_w::text <> '') and (coalesce(ie_tipo_parentesco_benef_w::text, '') = '') then
		select	max(ie_tipo_parentesco)
		into STRICT	ie_tipo_parentesco_benef_w
		from	grau_parentesco
		where	nr_sequencia	= nr_seq_parentesco_w;
	end if;

	if (ie_tipo_parentesco_benef_w = 1) then
		ie_tipo_parentesco_w	:= 'DL';
	elsif (ie_tipo_parentesco_benef_w = 2) then
		ie_tipo_parentesco_w	:= 'DA';
	else
		ie_tipo_parentesco_w	:= 'T';
	end if;

	if (ie_inserir_valor_w = 'S') then
		update	pls_segurado_valor
		set	ie_situacao	= 'I',
			dt_inativacao	= clock_timestamp()
		where	nr_seq_segurado	= nr_seq_segurado_p
		and	dt_preco	>= trunc(dt_preco_p,'month')
		and	ie_situacao	= 'A';

		insert	into	pls_segurado_valor(	nr_sequencia, nr_seq_segurado, ie_motivo_alteracao, dt_alteracao, ie_situacao, dt_preco,
				dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
				nr_seq_plano, nr_seq_tabela, ie_tipo_parentesco, ie_tabela_qt_vidas, qt_vidas,
				nr_seq_processo_judicial, ie_permite_reaj_fx_etaria, ie_permite_reaj_indice,
				nr_seq_regra_desconto, tx_desconto, vl_desconto )
			values (nextval('pls_segurado_valor_seq'), nr_seq_segurado_p, ie_motivo_alteracao_p, clock_timestamp(), 'A', trunc(dt_preco_p,'month'),
				clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p,
				nr_seq_plano_w, nr_seq_tabela_w, ie_tipo_parentesco_w, ie_tabela_qt_vidas_w, qt_vidas_w,
				nr_seq_processo_judicial_p, 'S', 'S',
				nr_seq_regra_desconto_w, tx_desconto_w, vl_desconto_w );
	end if;
end if;

if (ie_commit_p = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_inserir_segurado_valor ( nr_seq_segurado_p bigint, ie_motivo_alteracao_p text, dt_preco_p timestamp, nr_seq_plano_p bigint, nr_seq_tabela_p bigint, nr_seq_processo_judicial_p bigint, ds_reservado1_p text, ds_reservado2_p text, ds_reservado3_p text, ds_reservado4_p text, ie_commit_p text, nm_usuario_p text) FROM PUBLIC;
