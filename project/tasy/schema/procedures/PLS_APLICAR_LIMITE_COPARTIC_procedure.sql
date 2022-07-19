-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_aplicar_limite_copartic ( nr_seq_lote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
nr_seq_contrato_w		pls_contrato.nr_sequencia%type;
nr_seq_regra_w			pls_regra_limite_copartic.nr_sequencia%type;
vl_max_copartic_w		pls_regra_limite_copartic.vl_max_copartic%type;
vl_total_copartic_w		pls_lib_coparticipacao.vl_coparticipacao%type;
nr_seq_conta_copartic_w		pls_lib_coparticipacao.nr_seq_conta_coparticipacao%type;
vl_coparticipacao_w		pls_lib_coparticipacao.vl_coparticipacao%type;
nr_seq_lib_copartic_w		pls_lib_coparticipacao.nr_sequencia%type;
tx_rateio_w			double precision;
vl_copartic_regra_w		double precision;
vl_copartic_aplicado_w		pls_lib_coparticipacao.vl_coparticipacao%type;
vl_direfenca_w			pls_lib_coparticipacao.vl_coparticipacao%type;

C01 CURSOR FOR
	SELECT	a.nr_seq_segurado,
		b.nr_seq_contrato,
		sum(a.vl_coparticipacao) vl_total_copartic
	from	pls_lib_coparticipacao	a,
		pls_segurado		b
	where	a.nr_seq_segurado	= b.nr_sequencia
	and	(a.nr_seq_conta_coparticipacao IS NOT NULL AND a.nr_seq_conta_coparticipacao::text <> '')
	and	a.nr_seq_lote		= nr_seq_lote_p
	group by a.nr_seq_segurado,
		b.nr_seq_contrato;

C02 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_conta_coparticipacao,
		vl_coparticipacao
	from	pls_lib_coparticipacao
	where	nr_seq_lote	= nr_seq_lote_p
	and	nr_seq_segurado	= nr_seq_segurado_w
	and	(nr_seq_conta_coparticipacao IS NOT NULL AND nr_seq_conta_coparticipacao::text <> '');


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_segurado_w,
	nr_seq_contrato_w,
	vl_total_copartic_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	max(nr_sequencia)
	into STRICT	nr_seq_regra_w
	from	pls_regra_limite_copartic
	where	nr_seq_contrato	= nr_seq_contrato_w;

	if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then
		select	vl_max_copartic
		into STRICT	vl_max_copartic_w
		from	pls_regra_limite_copartic
		where	nr_sequencia	= nr_seq_regra_w;

		if (vl_total_copartic_w > vl_max_copartic_w) then
			open C02;
			loop
			fetch C02 into
				nr_seq_lib_copartic_w,
				nr_seq_conta_copartic_w,
				vl_coparticipacao_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				tx_rateio_w		:= campo_mascara_virgula_casas(((vl_coparticipacao_w * 100) / vl_total_copartic_w),4);
				vl_copartic_regra_w	:= ((vl_max_copartic_w * tx_rateio_w) / 100);

				update	pls_lib_coparticipacao
				set	vl_coparticipacao	= vl_copartic_regra_w
				where	nr_sequencia		= nr_seq_lib_copartic_w;

				update	pls_conta_coparticipacao
				set	vl_copartic_mens		= vl_copartic_regra_w,
					tx_copartic_mens		= tx_rateio_w,
					nr_seq_regra_limite_copartic	= nr_seq_regra_w
				where	nr_sequencia			= nr_seq_conta_copartic_w;
				end;
			end loop;
			close C02;

			select	sum(vl_coparticipacao)
			into STRICT	vl_copartic_aplicado_w
			from	pls_lib_coparticipacao
			where	nr_seq_lote	= nr_seq_lote_p
			and	nr_seq_segurado	= nr_seq_segurado_w;

			vl_direfenca_w	:= vl_max_copartic_w - vl_copartic_aplicado_w;

			update	pls_lib_coparticipacao
			set	vl_coparticipacao = vl_coparticipacao + vl_direfenca_w
			where	nr_sequencia	= nr_seq_lib_copartic_w;

			update	pls_conta_coparticipacao
			set	vl_copartic_mens	= vl_copartic_mens + vl_direfenca_w
			where	nr_sequencia		= nr_seq_conta_copartic_w;
		end if;
	end if;
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_aplicar_limite_copartic ( nr_seq_lote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

