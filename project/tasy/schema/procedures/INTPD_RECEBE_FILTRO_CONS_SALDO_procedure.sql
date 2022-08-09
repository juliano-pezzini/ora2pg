-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_recebe_filtro_cons_saldo ( nr_sequencia_p bigint, xml_p xml) AS $body$
DECLARE


_ora2pg_r RECORD;
ie_conversao_w			intpd_eventos_sistema.ie_conversao%type;
nr_seq_sistema_w			intpd_eventos_sistema.nr_seq_sistema%type;
nr_seq_projeto_xml_w		intpd_eventos_sistema.nr_seq_projeto_xml%type;
nr_seq_regra_conv_w		conversao_meio_externo.nr_seq_regra%type;
ie_sistema_externo_w		varchar(15);
consulta_saldo_w			intpd_w_consulta_saldo_est%rowtype;
reg_integracao_w			gerar_int_padrao.reg_integracao_conv;
i				integer;
ds_id_origin_w			intpd_eventos_sistema.ds_id_origin%type;

c01 CURSOR FOR
SELECT	*
from	xmltable('/STRUCTURE/FILTERS/FILTER' passing xml_p columns
	cd_estabelecimento			varchar(40)	path	'CD_ESTABLISHMENT',
	dt_mesano_referencia		varchar(40)	path	'DT_REFERENCE_MONTH_YEAR',
	cd_local_estoque			varchar(40)	path	'CD_STOCK_LOCATION',
	cd_grupo_material			varchar(40)	path	'CD_MATERIAL_GROUP',
	cd_subgrupo_material		varchar(40)	path	'CD_MATERIAL_SUBGROUP',
	cd_classe_material			varchar(40)	path	'CD_MATERIAL_CLASS',
	cd_material			varchar(40)	path	'CD_MATERIAL',
	ie_consignado			varchar(40)	path	'IE_CONSIGNED',
	cd_fornecedor			varchar(40)	path	'CD_SUPPLIER');
c01_w	c01%rowtype;


BEGIN

select	id_origin
into STRICT	ds_id_origin_w
from	xmltable('/STRUCTURE' passing xml_p
	columns id_origin	varchar2(10) path 'ID_ORIGIN');

select	coalesce(b.ie_conversao,'I'),
	nr_seq_sistema,
	nr_seq_projeto_xml,
	nr_seq_regra_conv,
	coalesce(ds_id_origin,ds_id_origin_w)
into STRICT	ie_conversao_w,
	nr_seq_sistema_w,
	nr_seq_projeto_xml_w,
	nr_seq_regra_conv_w,
	ds_id_origin_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_sequencia_p;



ie_sistema_externo_w			:=	nr_seq_sistema_w;

reg_integracao_w.nr_seq_fila_transmissao	:=	nr_sequencia_p;
reg_integracao_w.ie_envio_recebe		:=	'R';
reg_integracao_w.ie_sistema_externo		:=	ie_sistema_externo_w;
reg_integracao_w.ie_conversao		:=	ie_conversao_w;
reg_integracao_w.nr_seq_projeto_xml		:=	nr_seq_projeto_xml_w;
reg_integracao_w.nr_seq_regra_conversao	:=	nr_seq_regra_conv_w;

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	reg_integracao_w.nm_tabela			:=	'INTPD_W_CONSULTA_SALDO_EST';
	reg_integracao_w.nm_elemento		:=	'FILTERS';
	reg_integracao_w.nr_seq_visao		:=	95670;

	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_ESTABELECIMENTO', c01_w.cd_estabelecimento, 'S', consulta_saldo_w.cd_estabelecimento) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; consulta_saldo_w.cd_estabelecimento := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DT_MESANO_REFERENCIA', c01_w.dt_mesano_referencia, 'N', consulta_saldo_w.dt_mesano_referencia) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; consulta_saldo_w.dt_mesano_referencia := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_LOCAL_ESTOQUE', c01_w.cd_local_estoque, 'S', consulta_saldo_w.cd_local_estoque) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; consulta_saldo_w.cd_local_estoque := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_GRUPO_MATERIAL', c01_w.cd_grupo_material, 'S', consulta_saldo_w.cd_grupo_material) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; consulta_saldo_w.cd_grupo_material := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_SUBGRUPO_MATERIAL', c01_w.cd_subgrupo_material, 'S', consulta_saldo_w.cd_subgrupo_material) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; consulta_saldo_w.cd_subgrupo_material := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_CLASSE_MATERIAL', c01_w.cd_classe_material, 'S', consulta_saldo_w.cd_classe_material) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; consulta_saldo_w.cd_classe_material := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_MATERIAL', c01_w.cd_material, 'S', consulta_saldo_w.cd_material) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; consulta_saldo_w.cd_material := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_CONSIGNADO', c01_w.ie_consignado, 'N', consulta_saldo_w.ie_consignado) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; consulta_saldo_w.ie_consignado := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_FORNECEDOR', c01_w.cd_fornecedor, 'S', consulta_saldo_w.cd_fornecedor) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; consulta_saldo_w.cd_fornecedor := _ora2pg_r.ds_valor_retorno_p;
	consulta_saldo_w.ie_sistema_externo		:= ie_sistema_externo_w;
	consulta_saldo_w.dt_atualizacao_nrec		:= clock_timestamp();
	consulta_saldo_w.nm_usuario_nrec		:= 'INTPD';
	consulta_saldo_w.dt_atualizacao		:= clock_timestamp();
	consulta_saldo_w.nm_usuario			:= 'INTPD';
	consulta_saldo_w.ds_id_origin		:= ds_id_origin_w;



	select	cd_material_estoque
	into STRICT	consulta_saldo_w.cd_material
	from	material
	where	cd_material = consulta_saldo_w.cd_material;

	if (reg_integracao_w.qt_reg_log = 0) then

		select	nextval('intpd_w_consulta_saldo_est_seq')
		into STRICT	consulta_saldo_w.nr_sequencia
		;

		insert into intpd_w_consulta_saldo_est values (consulta_saldo_w.*);

	end if;
	end;
end loop;
close C01;

if (reg_integracao_w.qt_reg_log > 0) then
	begin

	rollback;

	update intpd_fila_transmissao
	set	ie_status = 'E',
		ie_tipo_erro = 'F'
	where	nr_sequencia = nr_sequencia_p;

	for i in 0..reg_integracao_w.qt_reg_log-1 loop
		INTPD_GRAVAR_LOG_RECEBIMENTO(nr_sequencia_p,reg_integracao_w.intpd_log_receb[i].ds_log,'INTPDTASY');
	end loop;
	end;

else

	update	intpd_fila_transmissao
	set	ie_status = 'S',
		nr_seq_documento = consulta_saldo_w.nr_sequencia
	where	nr_sequencia = nr_sequencia_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_recebe_filtro_cons_saldo ( nr_sequencia_p bigint, xml_p xml) FROM PUBLIC;
