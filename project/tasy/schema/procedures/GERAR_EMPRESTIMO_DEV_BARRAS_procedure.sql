-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_emprestimo_dev_barras ( nr_emprestimo_p bigint, cd_material_p bigint, qt_emprestimo_p bigint, nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			integer;
nr_seq_dev_w			integer;
dt_validade_w			timestamp;
ds_lote_fornec_w		varchar(20);
cd_estabelecimento_w		integer;
cd_local_estoque_w		smallint;
ie_erro_w			varchar(255);
ie_estoque_lote_w		varchar(1);
qt_material_dev_w		double precision;
ie_gerar_nf_dev_emp_barras_w 	varchar(1);
qt_material_w			double precision;
qt_emprestimo_w			double precision;
qt_devolucao_w			double precision;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		qt_material
	from	emprestimo_material
	where	nr_emprestimo	= nr_emprestimo_p
	and	cd_material	= cd_material_p
	and	coalesce(nr_seq_lote, coalesce(nr_seq_lote_p,0)) = coalesce(nr_seq_lote_p,0)
	
union all

	SELECT	nr_sequencia,
		qt_material
	from	emprestimo_material
	where	nr_emprestimo	= nr_emprestimo_p
	and	obter_controlador_estoque(cd_material) = obter_controlador_estoque(cd_material_p);


BEGIN
/* Parâmetro para verificar se gera a nota fiscal após a leitura por barras na devolução do empréstimo */

ie_gerar_nf_dev_emp_barras_w := obter_param_usuario(143, 316, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_gerar_nf_dev_emp_barras_w);

select	cd_estabelecimento,
	cd_local_estoque
into STRICT	cd_estabelecimento_w,
	cd_local_estoque_w
from	emprestimo
where	nr_emprestimo	= nr_emprestimo_p;

if (nr_seq_lote_p > 0) then
	select	dt_validade,
		ds_lote_fornec
	into STRICT	dt_validade_w,
		ds_lote_fornec_w
	from	material_lote_fornec
	where	nr_sequencia = nr_seq_lote_p;
end if;

qt_emprestimo_w := qt_emprestimo_p;

open c01;
loop
fetch c01 into
	nr_sequencia_w,
	qt_material_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	if (qt_emprestimo_w > 0) and (qt_material_w > 0) then
		if (qt_emprestimo_w > qt_material_w) then
			qt_emprestimo_w := qt_emprestimo_w - qt_material_w;
			qt_devolucao_w := qt_material_w;
		else
			qt_devolucao_w := qt_emprestimo_w;
			qt_emprestimo_w := 0;
		end if;

		select	coalesce(max(nr_seq_dev), 0) + 1
		into STRICT	nr_seq_dev_w
		from	EMPRESTIMO_MATERIAL_DEV
		where	nr_emprestimo	= nr_emprestimo_p
		and	NR_SEQUENCIA	= nr_sequencia_w;

		insert into emprestimo_material_dev(
			nr_emprestimo,
			nr_sequencia,
			nr_seq_dev,
			cd_material,
			qt_material,
			dt_atualizacao,
			nm_usuario,
			ds_lote_fornec,
			dt_validade,
			nr_seq_lote)
		values (	nr_emprestimo_p,
			nr_sequencia_w,
			nr_seq_dev_w,
			cd_material_p,
			qt_devolucao_w,
			clock_timestamp(),
			nm_usuario_p,
			ds_lote_fornec_w,
			dt_validade_w,
			nr_seq_lote_p);

		select	coalesce(sum(qt_material),0)
		into STRICT	qt_material_dev_w
		from	emprestimo_material_dev
		where	nr_emprestimo	= nr_emprestimo_p
		and	nr_sequencia	= nr_sequencia_w;

		update	emprestimo_material
		set	qt_material	= qt_emprestimo - qt_material_dev_w
		where	nr_emprestimo	= nr_emprestimo_p
		and	nr_sequencia	= nr_sequencia_w;

		select	coalesce(sum(qt_material),0)
		into STRICT	qt_material_dev_w
		from	emprestimo_material
		where	nr_emprestimo = nr_emprestimo_p;

		if (qt_material_dev_w = 0) then
			update	emprestimo
			set	ie_situacao = 'B'
			where nr_emprestimo = nr_emprestimo_p;
		end if;
	end if;
	end;
end loop;
close c01;

ie_estoque_lote_w := substr(obter_se_material_estoque_lote(cd_estabelecimento_w, cd_material_p),1,1);

if (coalesce(ie_gerar_nf_dev_emp_barras_w,'N') = 'N') then

	if (ie_estoque_lote_w = 'S') then
		ie_erro_w := atualizar_saldo_lote(
			cd_estabelecimento_w, cd_local_estoque_w, cd_material_p, trunc(clock_timestamp(),'mm'), nr_seq_lote_p, 0, qt_emprestimo_p, 2, nm_usuario_p, ie_erro_w);
end if;

end if;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_emprestimo_dev_barras ( nr_emprestimo_p bigint, cd_material_p bigint, qt_emprestimo_p bigint, nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;
