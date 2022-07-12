-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_itens_nf_devol_total (nr_seq_registro_p bigint, nr_seq_nf_p text) RETURNS varchar AS $body$
DECLARE


/*	--------------------------------------------------------
	N - Sem nota de devolução
	T - Devolução total dos itens da inspeção recebimento
	P - Devolução parcial dos itens da inspeção recebimento
	*/
qt_item_inspecao_w	inspecao_recebimento.qt_inspecao%type;
qt_item_nf_w		nota_fiscal_item.qt_item_nf%type;
qt_total_itens_nf_w		double precision;
cd_material_w		material.cd_material%type;
nr_nota_devolucao_w	nota_fiscal.nr_sequencia%type;
qt_notas_devolucao_w	bigint;
ie_status_w		varchar(1) := 'N';

c01 CURSOR FOR
SELECT	a.qt_inspecao,
	a.cd_material
from	inspecao_recebimento a
where	nr_seq_registro = nr_seq_registro_p;

c02 CURSOR FOR
SELECT	x.nr_sequencia
from	nota_fiscal x,
	operacao_nota o
where	x.cd_operacao_nf = o.cd_operacao_nf
and	o.ie_devolucao = 'S'
and	(x.dt_atualizacao_estoque IS NOT NULL AND x.dt_atualizacao_estoque::text <> '')
and	x.nr_sequencia_ref = nr_seq_nf_p;


BEGIN

select	count(*)
into STRICT	qt_notas_devolucao_w
from	nota_fiscal x,
	operacao_nota o
where	x.cd_operacao_nf = o.cd_operacao_nf
and	o.ie_devolucao = 'S'
and	x.nr_sequencia_ref = nr_seq_nf_p
and	(x.dt_atualizacao_estoque IS NOT NULL AND x.dt_atualizacao_estoque::text <> '');

if (qt_notas_devolucao_w > 0) then
	begin

	ie_status_w := 'T';

	open c01;
	loop
	fetch c01 into
		qt_item_inspecao_w,
		cd_material_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		qt_total_itens_nf_w := 0;

		open c02;
		loop
		fetch c02 into
			nr_nota_devolucao_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin

			select	coalesce(sum(qt_item_nf),0)
			into STRICT	qt_item_nf_w
			from	nota_fiscal_item
			where	cd_material = cd_material_w
			and	nr_sequencia = nr_nota_devolucao_w;

			qt_total_itens_nf_w := qt_total_itens_nf_w + qt_item_nf_w;

			end;
		end loop;
		close c02;

		if (qt_item_inspecao_w > qt_total_itens_nf_w) then
			ie_status_w := 'P';
		end if;

		end;
	end loop;
	close c01;

	end;
end if;

return	ie_status_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_itens_nf_devol_total (nr_seq_registro_p bigint, nr_seq_nf_p text) FROM PUBLIC;

