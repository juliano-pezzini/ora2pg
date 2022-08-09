-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_gerar_novo_equip_plano ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_tipo_equip_w	bigint;
nr_seq_plano_inspecao_w	bigint;

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	man_plano_inspecao a
	where	a.ie_situacao = 'A'
	and	exists (	SELECT	1
			from	man_plano_insp_item x
			where	x.nr_seq_plano_inspecao = a.nr_sequencia
			and	x.nr_seq_tipo_equip = nr_seq_tipo_equip_w);


BEGIN

if (nr_sequencia_p > 0) then

	select	a.nr_seq_tipo_equip
	into STRICT	nr_seq_tipo_equip_w
	from	man_equipamento a
	where	a.nr_sequencia = nr_sequencia_p;

	open C01;
	loop
	fetch C01 into
		nr_seq_plano_inspecao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		insert into man_plano_insp_item(
			nr_sequencia,
			nr_seq_plano_inspecao,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_equipamento,
			nr_seq_tipo_equip,
			ie_participa,
			ie_origem)
		values (	nextval('man_plano_insp_item_seq'),
			nr_seq_plano_inspecao_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_sequencia_p,
			null,
			'S',
			'S');
		end;
	end loop;
	close C01;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_gerar_novo_equip_plano ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
