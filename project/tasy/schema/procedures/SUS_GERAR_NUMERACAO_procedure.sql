-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gerar_numeracao ( nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_apac_aih_w	varchar(13);
nr_ano_w	varchar(2);
nr_digito_w	smallint;
vl_inicial_w	bigint;
qt_registros_w	bigint	:= 0;
vl_final_w	bigint;


BEGIN

select	substr(nr_final,1,12),
	substr(nr_inicial,1,12)
into STRICT	vl_final_w,
	vl_inicial_w
from	sus_lote_numeracao
where	nr_sequencia	= nr_seq_lote_p;

while(vl_inicial_w	<=vl_final_w) loop
	begin
	nr_apac_aih_w	:= substr(vl_inicial_w,1,12)||0;
	nr_digito_w	:= calcula_digito('AIH', nr_apac_aih_w);
	nr_apac_aih_w	:= substr(nr_apac_aih_w,1,12) || nr_digito_w;
	RAISE NOTICE '%', nr_apac_aih_w;
	vl_inicial_w	:= vl_inicial_w + 1;

	select	count(*)
	into STRICT	qt_registros_w
	from	sus_lote_numeracao_item
	where	nr_numeracao_sus	= nr_apac_aih_w;

	if (qt_registros_w	= 0) then
		insert into sus_lote_numeracao_item(	nr_sequencia,
								nr_seq_lote_numeracao,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								ie_utilizado,
								nr_numeracao_sus)
					values (	nextval('sus_lote_numeracao_item_seq'),
								nr_seq_lote_p,
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								'N',
								nr_apac_aih_w);

	end if;

	end;
end loop;

update	sus_lote_numeracao
set	dt_liberacao	= clock_timestamp()
where	nr_sequencia	= nr_seq_lote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gerar_numeracao ( nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;
