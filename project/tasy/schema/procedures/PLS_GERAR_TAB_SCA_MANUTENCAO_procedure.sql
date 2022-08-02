-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_tab_sca_manutencao ( nr_seq_proposta_p bigint, nr_seq_tabela_p bigint, nr_seq_plano_p bigint, nm_usuario_p text, nr_seq_tabela_nova_p INOUT bigint) AS $body$
DECLARE


qt_registros_w				bigint;
nr_seq_tabela_w				bigint;
nr_seq_sca_vinculo_w		bigint;
nr_seq_preco_w				bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_plano_preco
	where	nr_seq_tabela	= nr_seq_tabela_p;

C02 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_sca_vinculo a,
			pls_proposta_beneficiario b
	where	b.nr_sequencia		= a.nr_seq_benef_proposta
	and		b.nr_seq_proposta	= nr_seq_proposta_p
	and		a.nr_seq_tabela		= nr_seq_tabela_p
	and		a.nr_seq_plano		= nr_seq_plano_p;


BEGIN

select	count(*)
into STRICT	qt_registros_w
from	pls_tabela_preco
where	nr_seq_proposta	= nr_seq_proposta_p
and		nr_sequencia	= nr_seq_tabela_p;

if (qt_registros_w = 0) then

	select	nextval('pls_sca_vinculo_seq')
	into STRICT	nr_seq_tabela_w
	;

	if (qt_registros_w = 0) then

		select	nextval('pls_tabela_preco_seq')
		into STRICT	nr_seq_tabela_w
		;

		insert into pls_tabela_preco(	nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, nm_tabela,
						dt_inicio_vigencia, dt_fim_vigencia, nr_seq_plano, dt_liberacao, cd_codigo_ant, ie_tabela_base,
						nr_contrato, ie_tabela_contrato, nr_segurado, nr_seq_tabela_origem, ie_proposta_adesao,
						ie_simulacao_preco, nr_seq_sca, nr_seq_tabela_ant, nr_seq_proposta,nr_seq_tabela_original,
						nr_seq_faixa_etaria)
					(SELECT	nr_seq_tabela_w, clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 'Tabela para a proposta ' || nr_seq_proposta_p,
						dt_inicio_vigencia, dt_fim_vigencia, nr_seq_plano_p, dt_liberacao, cd_codigo_ant, ie_tabela_base,
						nr_contrato, ie_tabela_contrato, nr_segurado, nr_seq_tabela_origem, ie_proposta_adesao,
						ie_simulacao_preco, nr_seq_sca, nr_seq_tabela_ant, nr_seq_proposta_p,nr_seq_tabela_p,
						nr_seq_faixa_etaria
					from	pls_tabela_preco
					where	nr_sequencia	= nr_seq_tabela_p);


		open C01;
		loop
		fetch C01 into
			nr_seq_preco_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			insert into pls_plano_preco(	nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
							nr_seq_tabela, qt_idade_inicial, qt_idade_final, vl_preco_inicial, vl_preco_atual,
							tx_acrescimo, vl_preco_nao_subsidiado, vl_preco_nao_subsid_atual, vl_minimo,
							ie_grau_titularidade)
						(SELECT	nextval('pls_plano_preco_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p,
							nr_seq_tabela_w, qt_idade_inicial, qt_idade_final, vl_preco_inicial, vl_preco_atual,
							tx_acrescimo, vl_preco_nao_subsidiado, vl_preco_nao_subsid_atual, vl_minimo,
							ie_grau_titularidade
						from	pls_plano_preco
						where	nr_sequencia = nr_seq_preco_w);
			end;
		end loop;
		close C01;


		open C02;
		loop
		fetch C02 into
			nr_seq_sca_vinculo_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
				update	pls_sca_vinculo
				set	nr_seq_tabela = nr_seq_tabela_w,
					nm_usuario = nm_usuario_p,
					dt_atualizacao = clock_timestamp()
				where	nr_sequencia = nr_seq_sca_vinculo_w;
			end;
		end loop;
		close C02;
	end if;
else
	nr_seq_tabela_w	:= nr_seq_tabela_p;
end if;

nr_seq_tabela_nova_p	:= nr_seq_tabela_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_tab_sca_manutencao ( nr_seq_proposta_p bigint, nr_seq_tabela_p bigint, nr_seq_plano_p bigint, nm_usuario_p text, nr_seq_tabela_nova_p INOUT bigint) FROM PUBLIC;

