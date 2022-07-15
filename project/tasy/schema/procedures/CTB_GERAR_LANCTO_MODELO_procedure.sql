-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_lancto_modelo ( nr_lote_contabil_p lote_contabil.nr_lote_contabil%TYPE, nr_seq_modelo_p ctb_modelo_lancamento.nr_sequencia%TYPE, nm_usuario_p ctb_modelo_lancto_item.nm_usuario%TYPE) AS $body$
DECLARE


nr_seq_mes_ref_w 			lote_contabil.nr_seq_mes_ref%type;
nr_seq_movimento_w 			ctb_movimento.nr_sequencia%type;

c01 CURSOR FOR
SELECT	a.cd_historico,
	a.cd_conta_debito,
	a.cd_conta_credito,
	a.ds_compl_historico,
	a.cd_centro_custo,
	a.nr_seq_crit_rateio
from	ctb_modelo_lancto_item a
where	a.nr_seq_modelo = nr_seq_modelo_p;

vet01 c01%rowtype;

c02 CURSOR FOR
SELECT	a.cd_centro_custo,
	a.pr_rateio
from	ctb_criterio_rateio_item a
where 	a.nr_seq_criterio	= vet01.nr_seq_crit_rateio;

vet02 c02%rowtype;


BEGIN

select	nr_seq_mes_ref
into STRICT	nr_seq_mes_ref_w
from	lote_contabil
where	nr_lote_contabil = nr_lote_contabil_p;

open c01;
loop
fetch c01 into
	vet01;
EXIT WHEN NOT FOUND; /* apply on c01 */

        select nextval('ctb_movimento_seq')
        into STRICT nr_seq_movimento_w
;

        insert into ctb_movimento(
		nr_sequencia,
		nr_lote_contabil,
		nr_seq_mes_ref,
		dt_movimento,
		vl_movimento,
		dt_atualizacao,
		nm_usuario,
		cd_historico,
		cd_conta_debito,
		cd_conta_credito,
		ds_compl_historico,
		ie_revisado,
		ie_status_origem,
		dt_atualizacao_nrec,
		nm_usuario_nrec)
	values (	nr_seq_movimento_w,
		nr_lote_contabil_p,
		nr_seq_mes_ref_w,
		trunc(clock_timestamp()),
		0,
		clock_timestamp(),
		nm_usuario_p,
		vet01.cd_historico,
		vet01.cd_conta_debito,
		vet01.cd_conta_credito,
		vet01.ds_compl_historico,
		'N',
		'S',
		clock_timestamp(),
		nm_usuario_p);

        if (coalesce(vet01.cd_centro_custo, 0) <> 0) then
		begin
		insert into ctb_movto_centro_custo(
			nr_sequencia,
			nr_seq_movimento,
			cd_centro_custo,
			dt_atualizacao,
			nm_usuario,
			vl_movimento,
			pr_rateio)
		values (nextval('ctb_movto_centro_custo_seq'),
			nr_seq_movimento_w,
			vet01.cd_centro_custo,
			clock_timestamp(),
			nm_usuario_p,
			0,
			null);
		end;
        elsif (coalesce(vet01.nr_seq_crit_rateio, 0) <> 0) then
		begin

                open c02;
                loop
		fetch c02 into
			vet02;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			insert into ctb_movto_centro_custo(
				nr_sequencia,
				nr_seq_movimento,
				cd_centro_custo,
				dt_atualizacao,
				nm_usuario,
				vl_movimento,
				pr_rateio)
			values ( nextval('ctb_movto_centro_custo_seq'),
				nr_seq_movimento_w,
				vet02.cd_centro_custo,
				clock_timestamp(),
				nm_usuario_p,
				0,
				vet02.pr_rateio);
			end;
                end loop;
		end;
        end if;
    end loop;

close c01;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_lancto_modelo ( nr_lote_contabil_p lote_contabil.nr_lote_contabil%TYPE, nr_seq_modelo_p ctb_modelo_lancamento.nr_sequencia%TYPE, nm_usuario_p ctb_modelo_lancto_item.nm_usuario%TYPE) FROM PUBLIC;

