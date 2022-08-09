-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pcs_duplica_lista_tasy (nr_seq_lista_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_empresa_w		smallint;
ds_lista_w		varchar(255);
dt_liberacao_w		timestamp;
nm_usuario_lib_w	varchar(15);
nr_seq_lista_w		bigint;
qt_entrega_sc_w		integer;
qt_intervalo_entrega_w	integer;
ds_atributo_w		varchar(255);
ds_cadastro_w		varchar(255);
ds_coluna_w		varchar(255);
ds_valor_padrao_cad_w	varchar(255);
ds_valor_padrao_fixo_w	varchar(255);
ie_permite_alterar_w	varchar(1);
ie_situacao_w		varchar(1);
ie_valor_obrigatorio_w	varchar(1);
nr_seq_apres_w		integer;
nr_seq_formula_w	bigint;
nr_seq_lista_item_w	bigint;

C01 CURSOR FOR
	SELECT	ds_atributo,
		ds_cadastro,
		ds_coluna,
		ds_valor_padrao_cad,
		ds_valor_padrao_fixo,
		ie_permite_alterar,
		ie_situacao,
		ie_valor_obrigatorio,
		nr_seq_apres,
		nr_seq_formula
	from	pcs_listas_colunas
	where	nr_seq_lista = nr_seq_lista_p;


BEGIN

select	cd_empresa,
        ds_lista,
        dt_liberacao,
        ie_situacao,
        nm_usuario_lib,
        qt_entrega_sc,
        qt_intervalo_entrega
into STRICT	cd_empresa_w,
	ds_lista_w,
	dt_liberacao_w,
	ie_situacao_w,
	nm_usuario_lib_w,
	qt_entrega_sc_w,
	qt_intervalo_entrega_w
from	pcs_listas
where	nr_sequencia = nr_seq_lista_p;

select	nextval('pcs_listas_seq')
into STRICT	nr_seq_lista_w
;

insert into pcs_listas(
	cd_empresa,
	ds_lista,
	dt_atualizacao,
	dt_atualizacao_nrec,
	dt_liberacao,
	ie_situacao,
	nm_usuario,
	nm_usuario_lib,
	nm_usuario_nrec,
	nr_sequencia,
	qt_entrega_sc,
	qt_intervalo_entrega)
values (	cd_empresa_w,
	ds_lista_w,
	clock_timestamp(),
	clock_timestamp(),
	null,
	ie_situacao_w,
	nm_usuario_p,
	null,
	nm_usuario_p,
	nr_seq_lista_w,
	qt_entrega_sc_w,
	qt_intervalo_entrega_w);

open C01;
loop
fetch C01 into
	ds_atributo_w,
	ds_cadastro_w,
	ds_coluna_w,
	ds_valor_padrao_cad_w,
	ds_valor_padrao_fixo_w,
	ie_permite_alterar_w,
	ie_situacao_w,
	ie_valor_obrigatorio_w,
	nr_seq_apres_w,
	nr_seq_formula_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	nextval('pcs_listas_colunas_seq')
	into STRICT	nr_seq_lista_item_w
	;

	insert into pcs_listas_colunas(
		ds_atributo,
		ds_cadastro,
		ds_coluna,
		ds_valor_padrao_cad,
		ds_valor_padrao_fixo,
		dt_atualizacao,
		dt_atualizacao_nrec,
		ie_permite_alterar,
		ie_situacao,
		ie_valor_obrigatorio,
		nm_usuario,
		nm_usuario_nrec,
		nr_seq_apres,
		nr_seq_formula,
		nr_seq_lista,
		nr_sequencia)
	values (	ds_atributo_w,
		ds_cadastro_w,
		ds_coluna_w,
		ds_valor_padrao_cad_w,
		ds_valor_padrao_fixo_w,
		clock_timestamp(),
		clock_timestamp(),
		ie_permite_alterar_w,
		ie_situacao_w,
		ie_valor_obrigatorio_w,
		nm_usuario_p,
		nm_usuario_p,
		nr_seq_apres_w,
		nr_seq_formula_w,
		nr_seq_lista_w,
		nr_seq_lista_item_w);

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pcs_duplica_lista_tasy (nr_seq_lista_p bigint, nm_usuario_p text) FROM PUBLIC;
