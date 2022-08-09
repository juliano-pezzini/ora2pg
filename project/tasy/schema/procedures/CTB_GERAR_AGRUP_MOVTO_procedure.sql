-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_agrup_movto ( nr_lote_contabil_p bigint, nm_usuario_p text) AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	nr_seq_agrupamento,
		dt_movto,
		nr_seq_partida,
		row_number() OVER () AS nr_agrup_sequencial
	from (
		SELECT	nr_seq_agrupamento,
			dt_movto,
			min(nr_seq_partida) keep(dense_rank first order by qt_conta,nr_seq_partida) nr_seq_partida
		from (
			select	count(cd_conta_debito) qt_conta, /* DEBITO */
				nr_seq_agrupamento,
				trunc(dt_movimento) dt_movto,
				min(nr_sequencia) nr_seq_partida
			from	ctb_movimento
			where	nr_lote_contabil = nr_lote_contabil_p
			and	(cd_conta_debito IS NOT NULL AND cd_conta_debito::text <> '')
			group by
				nr_seq_agrupamento,
				trunc(dt_movimento)
			
union all

			select	count(cd_conta_credito) qt_conta, /* CREDITO */
				nr_seq_agrupamento,
				trunc(dt_movimento) dt_movto,
				min(nr_sequencia) nr_seq_partida
			from	ctb_movimento
			where	nr_lote_contabil = nr_lote_contabil_p
			and	(cd_conta_credito IS NOT NULL AND cd_conta_credito::text <> '')
			group by
				nr_seq_agrupamento,
				trunc(dt_movimento)
			) alias12
		group by
			nr_seq_agrupamento,
			dt_movto
		) alias13;

type C01_type is table of C01%rowtype;
C01_regs_w C01_type;

BEGIN
if (coalesce(philips_contabil_pck.get_ie_reat_saldo(),'N') = 'N') then
	begin
	update 	ctb_movimento
	set	nr_agrup_sequencial 	= 0
	where	nr_lote_contabil	= nr_lote_contabil_p;
	end;
end if;

open C01;
loop
fetch C01 bulk collect into C01_regs_w limit 1000;
	begin
	for i in 1..C01_regs_w.count loop
		begin
		update	ctb_movimento a
		set	a.nr_seq_movto_partida = CASE WHEN C01_regs_w[i].nr_seq_partida=a.nr_sequencia THEN null  ELSE C01_regs_w[i].nr_seq_partida END ,
			nr_agrup_sequencial = C01_regs_w[i].nr_agrup_sequencial
		where a.nr_lote_contabil = nr_lote_contabil_p
		and	a.nr_seq_agrupamento = C01_regs_w[i].nr_seq_agrupamento
		and a.dt_movimento between Inicio_Dia(C01_regs_w[i].dt_movto) and Fim_Dia(C01_regs_w[i].dt_movto);
		end;
	end loop;
	commit;
	end;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_agrup_movto ( nr_lote_contabil_p bigint, nm_usuario_p text) FROM PUBLIC;
