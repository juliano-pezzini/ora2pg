-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_item_fornecedor (NR_SEQ_LIC_P bigint, NM_USUARIO_P text, NR_SEQ_FORNEC_P bigint) AS $body$
DECLARE


NR_SEQ_W		integer;
NR_SEQ_ITEM_W		integer;

C01 CURSOR FOR
SELECT 	NR_SEQUENCIA
FROM	LIC_ITEM
WHERE	NR_SEQ_LICITACAO = NR_SEQ_LIC_P
AND	NR_SEQUENCIA NOT IN (SELECT NR_SEQ_ITEM FROM LIC_ITEM_FORNEC WHERE NR_SEQ_FORNEC = NR_SEQ_FORNEC_P);


BEGIN
open c01;
loop
fetch c01 into
	NR_SEQ_ITEM_W;
EXIT WHEN NOT FOUND; /* apply on c01 */
	SELECT 	nextval('lic_item_fornec_seq')
	INTO STRICT	NR_SEQ_W
	;
	INSERT	INTO LIC_ITEM_FORNEC(NR_SEQUENCIA,
					NR_SEQ_FORNEC,
					NR_SEQ_ITEM,
					DT_ATUALIZACAO,
					NM_USUARIO,
					VL_ITEM,
					IE_VENCEDOR)
	VALUES (NR_SEQ_W,
					NR_SEQ_FORNEC_P,
					NR_SEQ_ITEM_W,
					clock_timestamp(),
					NM_USUARIO_P,
					0,
					'N');
end loop;
close c01;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_item_fornecedor (NR_SEQ_LIC_P bigint, NM_USUARIO_P text, NR_SEQ_FORNEC_P bigint) FROM PUBLIC;
