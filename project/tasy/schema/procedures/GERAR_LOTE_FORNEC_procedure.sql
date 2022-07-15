-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_lote_fornec ( nr_lote_producao_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


dt_validade_w		timestamp;
dt_confirmacao_w		timestamp;
cd_material_w		integer;
cd_estabelecimento_w	smallint;
nr_seq_lote_w		bigint;
qt_material_w		double precision;
cd_cgc_w		varchar(14);
ds_retorno_w		varchar(255) := '';
ie_tipo_descricao_w	varchar(1);
ds_lote_fornec_w		varchar(20);
nr_seq_op_opm_w	bigint;


BEGIN

select	a.cd_material,
	a.dt_validade,
	a.qt_prevista,
	a.cd_estabelecimento,
	substr(obter_cgc_estabelecimento(a.cd_estabelecimento),1,14),
	coalesce(a.dt_confirmacao, clock_timestamp()),
   a.nr_seq_op_opm
into STRICT	cd_material_w,
	dt_validade_w,
	qt_material_w,
	cd_estabelecimento_w,
	cd_cgc_w,
	dt_confirmacao_w,
   nr_seq_op_opm_w
from	lote_producao a
where	a.nr_lote_producao = nr_lote_producao_p;

ie_tipo_descricao_w	:= coalesce(obter_valor_param_usuario(143, 111, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'L');

select	nextval('material_lote_fornec_seq')
into STRICT	nr_seq_lote_w
;

ds_retorno_w := nr_seq_lote_w;

ds_lote_fornec_w := substr(obter_desc_expressao(311816) || nr_seq_lote_w,1,20);

if (ie_tipo_descricao_w = 'P') then
	ds_lote_fornec_w := substr(obter_desc_expressao(311816) ||nr_lote_producao_p,1,20);
end if;

insert into material_lote_fornec(
	nr_sequencia,
	cd_material,
	ie_origem_lote,
	nr_digito_verif,
	dt_atualizacao,
	nm_usuario,
	ds_lote_fornec,
	dt_validade,
	cd_cgc_fornec,
	qt_material,
	cd_estabelecimento,
	ie_validade_indeterminada,
	ie_situacao,
	ie_bloqueio,
	nr_lote_producao,
	dt_fabricacao,
	dt_atualizacao_nrec,
	nm_usuario_nrec)
values (	nr_seq_lote_w,
	cd_material_w,
	'L',
	calcula_digito('Modulo11', nr_seq_lote_w),
	clock_timestamp(),
	nm_usuario_p,
	ds_lote_fornec_w,
	dt_validade_w,
	cd_cgc_w,
	qt_material_w,
	cd_estabelecimento_w,
	CASE WHEN coalesce(dt_validade_w::text, '') = '' THEN 'S'  ELSE 'N' END ,
	'A',
	'N',
	nr_lote_producao_p,
	dt_confirmacao_w,
	clock_timestamp(),
	nm_usuario_p);
commit;

if (coalesce(nr_seq_op_opm_w,0) > 0) then
   CALL gravar_status_op_opm(nr_seq_op_opm_w,'AGLF',null,nm_usuario_p,cd_estabelecimento_w);
end if;

ds_retorno_p	:= substr(ds_retorno_w,1,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_lote_fornec ( nr_lote_producao_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;

