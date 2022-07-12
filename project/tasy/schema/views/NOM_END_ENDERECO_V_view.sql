-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW nom_end_endereco_v (cd_endereco_catalogo, ds_endereco, ie_informacao) AS SELECT	D.CD_ENDERECO_CATALOGO,
	D.DS_ENDERECO,
	D.IE_INFORMACAO
FROM	CAT_PAIS A,
	PAIS B,
	END_CATALOGO C,
	END_ENDERECO D
WHERE	A.CD_PAIS = B.NR_SEQ_CAT_PAIS
AND	B.NR_SEQUENCIA = C.NR_SEQ_PAIS
AND	C.NR_SEQUENCIA = D.NR_SEQ_CATALOGO
AND	A.CD_ORDEM_PAIS = '1'
AND	B.IE_SITUACAO = 'A'
AND	C.DT_INICIO_VIGENCIA <= LOCALTIMESTAMP
AND	LOCALTIMESTAMP <= coalesce(C.DT_FIM_VIGENCIA,LOCALTIMESTAMP);

