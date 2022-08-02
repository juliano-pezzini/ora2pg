-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rop_gerar_kit_lote_movto ( nr_Seq_lote_p bigint, nr_seq_kit_p bigint, qt_kit_movto_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_roupa_w	bigint;
qt_roupa_mult_w	double precision;
qt_roupa_w		double precision;

c01 CURSOR FOR
	SELECT	nr_seq_roupa,
	   	qt_roupa
	from	rop_componente_kit
	where	nr_seq_kit = nr_seq_kit_p;


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_roupa_w,
	qt_roupa_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	qt_roupa_mult_w:= qt_roupa_w * coalesce(qt_kit_movto_p,1);

	insert into rop_movto_roupa(
		nr_sequencia,
		nr_seq_lote,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_roupa,
		dt_origem,
		cd_estabelecimento,
		ie_oper_correta,
		qt_roupa)
	values (	nextval('rop_movto_roupa_seq'),
		nr_Seq_lote_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_roupa_w,
		clock_timestamp(),
		cd_estabelecimento_p,
		'N',
		qt_roupa_mult_w);

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rop_gerar_kit_lote_movto ( nr_Seq_lote_p bigint, nr_seq_kit_p bigint, qt_kit_movto_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

