-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW local_estoque_v (cd_estabelecimento, cd_local_estoque, ds_local_estoque, ie_permite_digitacao, ie_situacao, dt_atualizacao, nm_usuario, cd_centro_custo, ie_tipo_local, ie_ponto_pedido, ie_req_automatica, ie_proprio, cd_comprador_consig, cd_pessoa_solic_consig, ie_req_mat_estoque, dt_atualizacao_nrec, nm_usuario_nrec, ie_centro_inventario, ie_baixa_disp, qt_dia_ajuste_minimo, qt_dia_ajuste_maximo, qt_dia_consumo, ie_permite_estoque_negativo, ie_centro_custo_ordem, ie_local_entrega_oc, ds_razao_social, ds_centro_custo) AS SELECT	A.CD_ESTABELECIMENTO,A.CD_LOCAL_ESTOQUE,A.DS_LOCAL_ESTOQUE,A.IE_PERMITE_DIGITACAO,A.IE_SITUACAO,A.DT_ATUALIZACAO,A.NM_USUARIO,A.CD_CENTRO_CUSTO,A.IE_TIPO_LOCAL,A.IE_PONTO_PEDIDO,A.IE_REQ_AUTOMATICA,A.IE_PROPRIO,A.CD_COMPRADOR_CONSIG,A.CD_PESSOA_SOLIC_CONSIG,A.IE_REQ_MAT_ESTOQUE,A.DT_ATUALIZACAO_NREC,A.NM_USUARIO_NREC,A.IE_CENTRO_INVENTARIO,A.IE_BAIXA_DISP,A.QT_DIA_AJUSTE_MINIMO,A.QT_DIA_AJUSTE_MAXIMO,A.QT_DIA_CONSUMO,A.IE_PERMITE_ESTOQUE_NEGATIVO,A.IE_CENTRO_CUSTO_ORDEM,A.IE_LOCAL_ENTREGA_OC,
	B.DS_RAZAO_SOCIAL,
	E.DS_CENTRO_CUSTO
FROM estabelecimento d, pessoa_juridica b, local_estoque a
LEFT OUTER JOIN centro_custo e ON (A.CD_CENTRO_CUSTO = E.CD_CENTRO_CUSTO)
WHERE A.CD_ESTABELECIMENTO	= D.CD_ESTABELECIMENTO AND D.CD_CGC		= B.CD_CGC AND A.IE_SITUACAO		= 'A';

