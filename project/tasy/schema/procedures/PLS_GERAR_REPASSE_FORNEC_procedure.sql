-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_repasse_fornec ( nr_seq_lote_p bigint, ie_acao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_prestador_w		bigint;
nr_seq_vinculo_w		bigint;
dt_movimentacao_w		timestamp;
qt_registros_w			bigint;
vl_repasse_w			double precision;
nr_seq_sca_w			bigint;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		e.vl_repasse
	from	pls_sca_vinculo a,
		pls_plano b,
		pls_plano_fornecedor c,
		pls_prestador d,
		pls_regra_preco_serv_adic e
	where	a.nr_seq_plano	= b.nr_sequencia
	and	b.nr_sequencia	= c.nr_seq_plano
	and	d.nr_sequencia	= c.nr_seq_prestador
	and	d.nr_sequencia	= e.nr_seq_prestador
	and	b.nr_sequencia	= e.nr_seq_plano
	and	c.nr_seq_prestador	= nr_seq_prestador_w
	and	dt_movimentacao_w between trunc(coalesce(a.dt_inicio_vigencia,dt_movimentacao_w),'dd')
		and fim_dia(coalesce(a.dt_fim_vigencia,dt_movimentacao_w))
	and	coalesce(nr_seq_sca_w,a.nr_seq_plano)	= a.nr_seq_plano;


BEGIN

if (ie_acao_p	= 'D') then
	delete	from pls_fornec_repasse
	where	nr_seq_lote	= nr_seq_lote_p;
else
	select	a.nr_seq_prestador,
		a.dt_movimentacao,
		a.nr_seq_sca
	into STRICT	nr_seq_prestador_w,
		dt_movimentacao_w,
		nr_seq_sca_w
	from	pls_fornec_lote_repasse a
	where	a.nr_sequencia	= nr_seq_lote_p;

	if (coalesce(nr_seq_prestador_w,0) > 0) then
		open C01;
		loop
		fetch C01 into
			nr_seq_vinculo_w,
			vl_repasse_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin

			select	count(*)
			into STRICT	qt_registros_w
			from	pls_fornec_lote_repasse a,
				pls_fornec_repasse b
			where	a.nr_sequencia	= b.nr_seq_lote
			and	b.nr_seq_vinculo_sca	= nr_seq_vinculo_w
			and	a.dt_movimentacao	= dt_movimentacao_w;

			if (qt_registros_w = 0) then
				insert into pls_fornec_repasse(	nr_sequencia,
								nr_seq_lote,
								cd_estabelecimento,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_seq_vinculo_sca,
								vl_repasse)
							values (	nextval('pls_fornec_repasse_seq'),
								nr_seq_lote_p,
								cd_estabelecimento_p,
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								nr_seq_vinculo_w,
								vl_repasse_w);
			end if;

			end;
		end loop;
		close C01;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_repasse_fornec ( nr_seq_lote_p bigint, ie_acao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
