-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_atualizar_movto_pendente () AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_movimento_estoque_w	bigint;
cd_estabelecimento_w	smallint;
dt_mesano_referencia_w	timestamp := trunc(clock_timestamp(),'mm');
dt_mesano_referencia_ww	timestamp;
cd_material_estoque_w	integer;
ie_estoque_lote_w		varchar(1);
qt_estoque_w		double precision;
cd_acao_w		varchar(1);
cd_operacao_estoque_w	smallint;
cd_local_estoque_w	smallint;
nr_seq_lote_fornec_w	bigint;
cd_fornecedor_w		bigint;
ie_erro_w			varchar(1);
ds_erro_w		varchar(255);
nm_usuario_w		varchar(15) := 'Tasy';
ie_movto_consignado_w	varchar(1);
dt_processo_w		timestamp;

C01 CURSOR FOR
SELECT	a.nr_sequencia,
	b.ie_movto_consignado,
	b.nr_movimento_estoque,
	b.cd_estabelecimento,
	b.cd_material_estoque,
	b.cd_local_estoque,
	b.cd_operacao_estoque,
	b.qt_estoque,
	b.cd_acao,
	b.nr_seq_lote_fornec,
	b.cd_fornecedor,
	b.dt_processo
from	sup_movto_pendente a,
	movimento_estoque  b
where	a.nr_movimento_estoque = b.nr_movimento_estoque
and	b.dt_mesano_referencia = dt_mesano_referencia_w
and	a.ie_pendente = 'S';

c02 CURSOR FOR
     	SELECT /*+ index(a salesto_pk) */		dt_mesano_referencia
	from	saldo_estoque a
	where (a.dt_mesano_referencia	> dt_mesano_referencia_w)
	and (a.cd_estabelecimento	= cd_estabelecimento_w)
	and (a.cd_local_estoque	= cd_local_estoque_w)
	and (a.cd_material		= cd_material_estoque_w)
	and (ie_erro_w		= 'N');


c03 CURSOR FOR
     	SELECT /*+ index(a salesto_pk) */		dt_mesano_referencia
	from	fornecedor_mat_consignado a
	where (a.dt_mesano_referencia	> dt_mesano_referencia_w)
	and (a.cd_estabelecimento	= cd_estabelecimento_w)
	and (a.cd_local_estoque	= cd_local_estoque_w)
	and (a.cd_material		= cd_material_estoque_w)
	and (a.cd_fornecedor		= cd_fornecedor_w)
	and (ie_erro_w		= 'N');


BEGIN

open C01;
loop
fetch C01 into
	nr_sequencia_w,
	ie_movto_consignado_w,
	nr_movimento_estoque_w,
	cd_estabelecimento_w,
	cd_material_estoque_w,
	cd_local_estoque_w,
	cd_operacao_estoque_w,
	qt_estoque_w,
	cd_acao_w,
	nr_seq_lote_fornec_w,
	cd_fornecedor_w,
	dt_processo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_erro_w := 'N';

	if (coalesce(dt_processo_w::text, '') = '') then
		begin
		select	coalesce(max(ie_estoque_lote),'N')
		into STRICT	ie_estoque_lote_w
		from	material_estab
		where	cd_material = cd_material_estoque_w
		and	cd_estabelecimento = cd_estabelecimento_w;

		/*atualiza saldo */

		if (ie_movto_consignado_w = 'N') then
			begin
			SELECT * FROM atualizar_saldo(
				cd_estabelecimento_w, cd_local_estoque_w, cd_material_estoque_w, dt_mesano_referencia_w, cd_operacao_estoque_w, qt_estoque_w, cd_acao_w, nm_usuario_w, ie_erro_w, ds_erro_w) INTO STRICT ie_erro_w, ds_erro_w;

			if (nr_seq_lote_fornec_w IS NOT NULL AND nr_seq_lote_fornec_w::text <> '') and (ie_estoque_lote_w = 'S') then
				ie_erro_w := atualizar_saldo_lote(
					cd_estabelecimento_w, cd_local_estoque_w, cd_material_estoque_w, dt_mesano_referencia_w, nr_seq_lote_fornec_w, cd_operacao_estoque_w, qt_estoque_w, cd_acao_w, nm_usuario_w, ie_erro_w);
			end if;

			open c02;
			loop
			fetch c02 into
				dt_mesano_referencia_ww;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				begin
				SELECT * FROM atualizar_saldo(
					cd_estabelecimento_w, cd_local_estoque_w, cd_material_estoque_w, dt_mesano_referencia_ww, cd_operacao_estoque_w, qt_estoque_w, cd_acao_w, nm_usuario_w, ie_erro_w, ds_erro_w) INTO STRICT ie_erro_w, ds_erro_w;

				if (nr_seq_lote_fornec_w IS NOT NULL AND nr_seq_lote_fornec_w::text <> '') and (ie_estoque_lote_w = 'S') then
					ie_erro_w := atualizar_saldo_lote(
						cd_estabelecimento_w, cd_local_estoque_w, cd_material_estoque_w, dt_mesano_referencia_ww, nr_seq_lote_fornec_w, cd_operacao_estoque_w, qt_estoque_w, cd_acao_w, nm_usuario_w, ie_erro_w);
				end if;
				end;
			end loop;
			close c02;
			end;
		else
			begin
			ie_erro_w := atualizar_saldo_consig(
				cd_estabelecimento_w, cd_local_estoque_w, cd_fornecedor_w, cd_material_estoque_w, dt_mesano_referencia_w, cd_operacao_estoque_w, qt_estoque_w, cd_acao_w, nm_usuario_w, ie_erro_w);

			if (nr_seq_lote_fornec_w IS NOT NULL AND nr_seq_lote_fornec_w::text <> '') and (ie_estoque_lote_w = 'S') then
				ie_erro_w := atualizar_saldo_consig_lote(
					cd_estabelecimento_w, cd_local_estoque_w, cd_fornecedor_w, cd_material_estoque_w, dt_mesano_referencia_w, nr_seq_lote_fornec_w, cd_operacao_estoque_w, qt_estoque_w, cd_acao_w, nm_usuario_w, ie_erro_w);
			end if;

			open c03;
			loop
			fetch c03 into
				dt_mesano_referencia_ww;
			EXIT WHEN NOT FOUND; /* apply on c03 */
				begin
				ie_erro_w := atualizar_saldo_consig(
					cd_estabelecimento_w, cd_local_estoque_w, cd_fornecedor_w, cd_material_estoque_w, dt_mesano_referencia_ww, cd_operacao_estoque_w, qt_estoque_w, cd_acao_w, nm_usuario_w, ie_erro_w);

				if (nr_seq_lote_fornec_w IS NOT NULL AND nr_seq_lote_fornec_w::text <> '') and (ie_estoque_lote_w = 'S') then
					ie_erro_w := atualizar_saldo_consig_lote(
						cd_estabelecimento_w, cd_local_estoque_w, cd_fornecedor_w, cd_material_estoque_w, dt_mesano_referencia_ww, nr_seq_lote_fornec_w, cd_operacao_estoque_w, qt_estoque_w, cd_acao_w, nm_usuario_w, ie_erro_w);
				end if;
				end;
			end loop;
			close c03;
			end;
		end if;
		end;
	end if;

	if (ie_erro_w  = 'N') then
		begin
		if (coalesce(dt_processo_w::text, '') = '') then
			update	movimento_estoque
			set	dt_processo = clock_timestamp()
			where	nr_movimento_estoque = nr_movimento_estoque_w;
		end if;

		update	sup_movto_pendente
		set	ie_pendente = 'N'
		where	nr_sequencia = nr_sequencia_w;
		end;
	end if;
	end;
end loop;
close C01;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_atualizar_movto_pendente () FROM PUBLIC;

