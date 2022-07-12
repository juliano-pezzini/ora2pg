-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_item_sem_cod_concat (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w varchar(4000);
ds_item_w  varchar(255);
qt_item_w  varchar(20);
ds_fornec_w	varchar(255);

expressao1_w	varchar(255) := obter_desc_expressao_idioma(774292, null, wheb_usuario_pck.get_nr_seq_idioma);--Mat. 
expressao2_w	varchar(255) := obter_desc_expressao_idioma(296944, null, wheb_usuario_pck.get_nr_seq_idioma);--QTDE 
expressao3_w	varchar(255) := obter_desc_expressao_idioma(630398, null, wheb_usuario_pck.get_nr_seq_idioma);--Fornec. 
C01 CURSOR FOR 
	SELECT a.qt_quantidade, 
		SUBSTR(DS_MATERIAL,1,255), 
		CASE WHEN coalesce(CD_CGC::text, '') = '' THEN substr(DS_FORNECEDOR,1,254)  ELSE substr(obter_dados_pf_pj(null,	CD_CGC, 'N'),1,254) END  
	FROM  AGENDA_PAC_DESC_MATERIAL a 
	WHERE  a.nr_seq_agenda  = nr_sequencia_p;


BEGIN 
 
ds_retorno_w := '';
ds_item_w := '';
qt_item_w := '';
 
OPEN C01;
LOOP 
FETCH C01 INTO 
 qt_item_w, 
 ds_item_w, 
 ds_fornec_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
 BEGIN 
 ds_retorno_w := ds_retorno_w ||'  '||expressao1_w||': '|| ds_item_w || '  '||expressao2_w||': '|| qt_item_w||'  '||expressao3_w||' '|| ds_fornec_w || chr(13);
 END;
END LOOP;
CLOSE C01;
 
RETURN ds_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_item_sem_cod_concat (nr_sequencia_p bigint) FROM PUBLIC;
