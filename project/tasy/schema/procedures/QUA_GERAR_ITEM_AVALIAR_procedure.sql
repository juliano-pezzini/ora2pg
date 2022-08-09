-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_gerar_item_avaliar ( nr_seq_auditoria_p bigint, nr_seq_tipo_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_estrut_w		bigint;
nr_seq_item_w		bigint;
nr_seq_subitem_w		bigint;
nr_sequencia_w		bigint;
nr_seq_amb_mat_w		bigint;
nr_seq_result_mat_w	bigint;
nr_seq_ambiente_w		bigint;
nr_seq_ambiente_regra_w	bigint;
cd_setor_regra_w		integer;
cd_setor_auditoria_w	integer;
qt_regra_w		bigint;
nr_seq_audit_estrut_w	bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	qua_auditoria_estrut
	where	nr_seq_tipo = nr_seq_tipo_p
	and	((nr_sequencia= nr_seq_audit_estrut_w) or (coalesce(nr_seq_audit_estrut_w,0) = 0))
	and	nr_sequencia = qua_obter_estrut_regra(nr_sequencia,cd_setor_auditoria_w,nr_seq_ambiente_w)
	order by	coalesce(nr_seq_apres, nr_sequencia);

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	qua_auditoria_item
	where	nr_seq_estrutura = nr_seq_estrut_w
	order by	coalesce(nr_seq_apres, nr_sequencia);

C03 CURSOR FOR
	SELECT	c.nr_sequencia
	from	qua_audit_amb_mat c,
		qua_auditoria_ambiente b,
		qua_auditoria_tipo a
	where	a.nr_sequencia = b.nr_seq_tipo
	and	b.nr_sequencia = c.nr_seq_audit_ambiente
	and	a.nr_sequencia = nr_seq_tipo_p
	and	a.ie_mat_ambiente = 'S'
	and	a.ie_situacao = 'A'
	and (b.nr_sequencia = nr_seq_ambiente_w or nr_seq_ambiente_w = 0)
	order by	a.nr_sequencia;

C04 CURSOR FOR
	SELECT	coalesce(nr_seq_ambiente,0),
		coalesce(cd_setor_atendimento,0)
	from	qua_audit_item_regra
	where	nr_seq_item = nr_seq_item_w;

C05 CURSOR FOR
	SELECT	nr_sequencia
	from	qua_auditoria_subitem
	where	nr_seq_item = nr_seq_item_w
	order by	coalesce(nr_seq_apres, nr_sequencia);


BEGIN
select	coalesce(max(nr_seq_ambiente),0),
	coalesce(max(cd_setor_atendimento),0),
	coalesce(max(nr_seq_audit_estrut),0)
into STRICT	nr_seq_ambiente_w,
	cd_setor_auditoria_w,
	nr_seq_audit_estrut_w
from	qua_auditoria
where	nr_sequencia = nr_seq_auditoria_p;

open C01;
loop
fetch C01 into
	nr_seq_estrut_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	open C02;
	loop
	fetch C02 into
		nr_seq_item_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		/* Verifica se o item possui regra */

		select	count(*)
		into STRICT	qt_regra_w
		from	qua_audit_item_regra
		where	nr_seq_item = nr_seq_item_w;

		if (qt_regra_w > 0) then
			begin
			open C04;
			loop
			fetch C04 into
				nr_seq_ambiente_regra_w,
				cd_setor_regra_w;
			EXIT WHEN NOT FOUND; /* apply on C04 */
				begin

				/* Possui regra, verifica se o ambiente ou setor está informado e é o mesmo da auditoria */

				if	(nr_seq_ambiente_regra_w <> 0 AND nr_seq_ambiente_regra_w = nr_seq_ambiente_w) or
					(cd_setor_regra_w <> 0 AND cd_setor_regra_w = cd_setor_auditoria_w) then
					begin
					select	nextval('qua_auditoria_result_seq')
					into STRICT	nr_sequencia_w
					;
					insert into qua_auditoria_result(
						nr_sequencia,
						nr_seq_auditoria,
						dt_atualizacao,
						nm_usuario,
						nr_seq_item,
						ie_resultado,
						ds_complemento,
						nr_seq_estrutura,
						vl_item,
						nr_seq_subitem)
					values (	nr_sequencia_w,
						nr_seq_auditoria_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_item_w,
						null,
						null,
						nr_seq_estrut_w,
						0,
						0);
					end;
				end if;
				end;
			end loop;
			close C04;
			end;
		elsif (qt_regra_w = 0) then
			begin
			select	nextval('qua_auditoria_result_seq')
			into STRICT	nr_sequencia_w
			;
			insert into qua_auditoria_result(
				nr_sequencia,
				nr_seq_auditoria,
				dt_atualizacao,
				nm_usuario,
				nr_seq_item,
				ie_resultado,
				ds_complemento,
				nr_seq_estrutura,
				vl_item,
				nr_seq_subitem)
			values (
				nr_sequencia_w,
				nr_seq_auditoria_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_item_w,
				null,
				null,
				nr_seq_estrut_w,
				0,
				0);
			end;
		end if;

		open C05;
		loop
		fetch C05 into
			nr_seq_subitem_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
			begin
			insert into qua_auditoria_result(
				nr_sequencia,
				nr_seq_auditoria,
				dt_atualizacao,
				nm_usuario,
				nr_seq_item,
				ie_resultado,
				ds_complemento,
				nr_seq_estrutura,
				vl_item,
				nr_seq_subitem)
			values (	nextval('qua_auditoria_result_seq'),
				nr_seq_auditoria_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_item_w,
				null,
				null,
				nr_seq_estrut_w,
				0,
				nr_seq_subitem_w);
			end;
		end loop;
		close C05;

		end;
	end loop;
	close C02;
	end;
end loop;
close C01;

open C03;
loop
fetch C03 into
	nr_seq_amb_mat_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
	begin
	select	nextval('qua_audit_result_mat_seq')
	into STRICT	nr_seq_result_mat_w
	;
	insert into qua_audit_result_mat(
		nr_sequencia,
		nr_seq_amb_mat,
		nr_seq_qua_audit,
		dt_atualizacao,
		nm_usuario,
		ie_existe)
	values (	nr_seq_result_mat_w,
		nr_seq_amb_mat_w,
		nr_seq_auditoria_p,
		clock_timestamp(),
		nm_usuario_p,
		'N');
	end;
end loop;
close C03;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_gerar_item_avaliar ( nr_seq_auditoria_p bigint, nr_seq_tipo_p bigint, nm_usuario_p text) FROM PUBLIC;
