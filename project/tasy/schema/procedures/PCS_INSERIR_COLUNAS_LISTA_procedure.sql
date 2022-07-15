-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pcs_inserir_colunas_lista ( nr_seq_lista_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_sequencia_w	bigint;
ds_atributo_w	varchar(255);
ds_coluna_w		varchar(255);
nr_ordem_w		integer;

C01 CURSOR FOR
	SELECT	'CD_MATERIAL',
			wheb_mensagem_pck.get_texto(795556), --'Código do material',
			1
	
	
union	all

	PERFORM	'DS_MATERIAL',
			wheb_mensagem_pck.get_texto(795558), --'Descrição do material',
			2
	
	
union	all

	select	'CD_LOCAL_EST',
			wheb_mensagem_pck.get_texto(795560), --'Local de estoque',
			3
	
	
union all

	select	'QT_MATERIAL',
			wheb_mensagem_pck.get_texto(795561), --'Quantidade compra',
			4
	
	
union all

	select	'CD_ESTAB',
			wheb_mensagem_pck.get_texto(795562), --'Estabelecimento',
			5
	
	
union all

	select	'IE_TIPO_COMPRA',
			wheb_mensagem_pck.get_texto(795563), --'Tipo compra',
			6
	
		
union all

	select	'QT_LEAD_TIME',
			wheb_mensagem_pck.get_texto(795564), --'Lead Time',
			7
	
		
union all

	select	'NR_SEQ_MOTIVO_SOLIC',
			wheb_mensagem_pck.get_texto(795565), --'Motivo solicitação',
			8
	;


BEGIN

open C01;
loop
fetch C01 into
	ds_atributo_w,
	ds_coluna_w,
	nr_ordem_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	nextval('pcs_listas_colunas_seq')
	into STRICT	nr_sequencia_w
	;

	insert into pcs_listas_colunas(
			ds_coluna,
			ds_atributo,
			nr_seq_apres,
			nr_sequencia,
			dt_atualizacao,
			dt_atualizacao_nrec,
			nm_usuario,
			nm_usuario_nrec,
			ie_situacao,
			ie_permite_alterar,
			nr_seq_lista)
	values (	ds_coluna_w,
			ds_atributo_w,
			nr_ordem_w,
			nr_sequencia_w,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			'A',
			'S',
			nr_seq_lista_p);

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pcs_inserir_colunas_lista ( nr_seq_lista_p bigint, nm_usuario_p text) FROM PUBLIC;

