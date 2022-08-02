-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_gerar_item_avaliar_pront ( nr_seq_audit_pront_p bigint, nr_seq_tipo_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_estrut_w	bigint;
nr_seq_item_w	bigint;
nr_sequencia_w	bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	qua_auditoria_estrut
	where	nr_seq_tipo = nr_seq_tipo_p;

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	qua_auditoria_item
	where	nr_seq_estrutura = nr_seq_estrut_w;


BEGIN
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
		select	nextval('qua_audit_pront_result_seq')
		into STRICT	nr_sequencia_w
		;
		insert into qua_audit_pront_result(
			nr_sequencia,
			nr_seq_audit_pront,
			dt_atualizacao,
			nm_usuario,
			nr_seq_item,
			ie_resultado,
			ds_complemento,
			nr_seq_estrutura,
			vl_item,
			dt_atualizacao_nrec,
			nm_usuario_nrec)
		values (
			nr_sequencia_w,
			nr_seq_audit_pront_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_item_w,
			null,
			null,
			nr_seq_estrut_w,
			0,
			clock_timestamp(),
			nm_usuario_p);
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_gerar_item_avaliar_pront ( nr_seq_audit_pront_p bigint, nr_seq_tipo_p bigint, nm_usuario_p text) FROM PUBLIC;

