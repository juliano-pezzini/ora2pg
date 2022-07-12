-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nfes ( nr_seq_caixa_rec_p text) RETURNS varchar AS $body$
DECLARE

 
nr_nfe_w		varchar(255) := '';
ds_nfe_w		varchar(255):= '';
nr_interno_conta_w		bigint;

c01 CURSOR FOR 
SELECT 	a.nr_interno_conta 
FROM  	titulo_receber a, 
	titulo_receber_liq c 
WHERE 	a.nr_titulo		= c.nr_titulo 
AND	c.nr_seq_caixa_rec	= nr_seq_caixa_rec_p;

c02 CURSOR FOR 
SELECT	nr_nfe_imp 
FROM 	nota_fiscal 
WHERE 	nr_interno_conta	= nr_interno_conta_w;


BEGIN 
 
OPEN C01;
LOOP 
FETCH C01 INTO 
	nr_interno_conta_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
 
	OPEN C02;
	LOOP 
	FETCH C02 INTO 
		nr_nfe_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
 
 
		IF (coalesce(ds_nfe_w::text, '') = '') THEN 
			ds_nfe_w := SUBSTR(nr_nfe_w,1,254);
		ELSE 
			ds_nfe_w := SUBSTR(ds_nfe_w ||', '|| nr_nfe_w,1,254);
		END IF;
 
	END LOOP;
	CLOSE C02;
 
END LOOP;
CLOSE C01;
 
RETURN ds_nfe_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nfes ( nr_seq_caixa_rec_p text) FROM PUBLIC;

