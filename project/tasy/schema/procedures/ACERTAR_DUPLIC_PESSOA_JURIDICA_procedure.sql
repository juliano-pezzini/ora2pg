-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE acertar_duplic_pessoa_juridica ( cd_cgc_origem_p text, cd_cgc_destino_p text, ie_acao_p text, nm_usuario_p text, dt_acerto_p timestamp) AS $body$
DECLARE

/* Ação a Tomar
	R - Devolve o numero de Registros por Tabela
	T - Transfere de uma pessoa para outra*/
ds_comando_w			varchar(2000);
ds_res_w				varchar(2000);
VarSql				varchar(1)		:= CHR(39);
qt_reg_w				bigint;
nm_tabela_w			varchar(50);
nm_atributo_w			varchar(50);
ie_tipo_pessoa_w			smallint;
nr_sequencia_w			bigint;
vl_retorno_w			double precision;
nr_soma_w			smallint := 20;
rowid_orig_w			oid;
rowid_dest_w			oid;
qt_estoque_w			double precision;

C01 CURSOR FOR
SELECT	a.nm_tabela,
	b.nm_atributo
from	integridade_atributo b,
	integridade_referencial a
where	a.nm_tabela 		= b.nm_tabela
and	a.nm_integridade_referencial	= b.nm_integridade_referencial
and	a.nm_tabela_referencia 	= 'PESSOA_JURIDICA'
order by 1;

C02 CURSOR FOR
SELECT	a.nr_sequencia
from	nota_fiscal a
where	a.cd_cgc_emitente = cd_cgc_origem_p
and exists (
	SELECT	1
	from	nota_fiscal b
	where	a.cd_estabelecimento = b.cd_estabelecimento
	and	a.cd_serie_nf = b.cd_serie_nf
	and	a.nr_nota_fiscal = b.nr_nota_fiscal
	and	a.nr_sequencia_nf = b.nr_sequencia_nf
	and	b.cd_cgc_emitente = cd_cgc_destino_p);

C03 CURSOR FOR
SELECT	a.oid,
	b.oid,
	a.qt_estoque
from	fornecedor_mat_consignado b,
	fornecedor_mat_consignado a
where	a.cd_fornecedor = cd_cgc_origem_p
and	b.cd_fornecedor = cd_cgc_destino_p
and	b.cd_estabelecimento	= a.cd_estabelecimento
and	b.cd_local_estoque		= a.cd_local_estoque
and	b.cd_material		= a.cd_material
and	b.dt_mesano_referencia	= a.dt_mesano_referencia;


BEGIN

vl_retorno_w := Obter_Valor_Dinamico('alter table COT_COMPRA_FORN_ITEM disable constraint COCOFOI_COCOFOR_FK', vl_retorno_w);
vl_retorno_w := Obter_Valor_Dinamico('alter table COT_COMPRA_FORN_ITEM_TR disable constraint COCOFOT_COCOFOI_FK', vl_retorno_w);
vl_retorno_w := Obter_Valor_Dinamico('alter table COT_COMPRA_ITEM disable constraint COCOITE_COCOFOA_FK', vl_retorno_w);
vl_retorno_w := Obter_Valor_Dinamico('alter table COT_COMPRA_ITEM disable constraint COCOITE_COCOFOS_FK', vl_retorno_w);

OPEN C01;
LOOP
FETCH C01 INTO
	nm_tabela_w,
	nm_atributo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	IF (ie_acao_p = 'R') THEN
		ds_comando_w	:= 'select count(*) from ' || nm_tabela_w ||
					   ' where ' || nm_atributo_w || ' = ' ||	VarSql || cd_cgc_origem_p || VarSql;
		qt_reg_w := obter_valor_dinamico(ds_comando_w, qt_reg_w);
		IF (qt_reg_w > 0) THEN
			ds_res_w	:= substr(ds_res_w || nm_tabela_w || '=' || qt_reg_w || ',',1,2000);
		END IF;
	ELSIF (ie_acao_p = 'T') THEN
		IF (nm_tabela_w = 'NOTA_FISCAL') AND (nm_atributo_w = 'CD_CGC_EMITENTE') THEN
			OPEN C02;
			LOOP
				FETCH C02 INTO nr_sequencia_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */

				nr_soma_w := 20;

				WHILE(nr_soma_w > 0) LOOP
					BEGIN
					UPDATE nota_fiscal
					SET	nr_sequencia_nf = nr_sequencia_nf + nr_soma_w,
						cd_cgc_emitente = cd_cgc_destino_p
					WHERE nr_sequencia = nr_sequencia_w;
					nr_soma_w := 0;
					EXCEPTION
						WHEN OTHERS THEN
							nr_soma_w := nr_soma_w + 20;
					END;
				END LOOP;
			END LOOP;
			CLOSE C02;
			UPDATE nota_fiscal
			SET	cd_cgc_emitente = cd_cgc_destino_p
			WHERE cd_cgc_emitente = cd_cgc_origem_p;
		ELSIF (nm_tabela_w = 'FORNECEDOR_MAT_CONSIGNADO') THEN
			OPEN C03;
			LOOP
				FETCH C03 INTO	rowid_orig_w,
							rowid_dest_w,
							qt_estoque_w;
				EXIT WHEN NOT FOUND; /* apply on C03 */

				UPDATE fornecedor_mat_consignado
				SET	qt_estoque	= qt_estoque + qt_estoque_w
				WHERE ROWID		= rowid_dest_w;

				DELETE FROM fornecedor_mat_consignado
				WHERE ROWID = rowid_orig_w;
			END LOOP;
			CLOSE C03;
			CALL Altera_Valor_Campo_Tabela(nm_tabela_w, nm_atributo_w, cd_cgc_origem_p, cd_cgc_destino_p);
		ELSE
			CALL Altera_Valor_Campo_Tabela(nm_tabela_w, nm_atributo_w, cd_cgc_origem_p, cd_cgc_destino_p);
		END IF;
	END IF;
END LOOP;
CLOSE C01;

INSERT INTO log_tasy(dt_atualizacao, nm_usuario, cd_log, ds_log)
		VALUES (dt_acerto_p, nm_usuario_p, 850, ds_res_w);


vl_retorno_w := Obter_Valor_Dinamico('alter table COT_COMPRA_FORN_ITEM enable constraint COCOFOI_COCOFOR_FK', vl_retorno_w);
vl_retorno_w := Obter_Valor_Dinamico('alter table COT_COMPRA_FORN_ITEM_TR enable constraint COCOFOT_COCOFOI_FK', vl_retorno_w);
vl_retorno_w := Obter_Valor_Dinamico('alter table COT_COMPRA_ITEM enable constraint COCOITE_COCOFOA_FK', vl_retorno_w);
vl_retorno_w := Obter_Valor_Dinamico('alter table COT_COMPRA_ITEM enable constraint COCOITE_COCOFOS_FK', vl_retorno_w);
COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE acertar_duplic_pessoa_juridica ( cd_cgc_origem_p text, cd_cgc_destino_p text, ie_acao_p text, nm_usuario_p text, dt_acerto_p timestamp) FROM PUBLIC;
