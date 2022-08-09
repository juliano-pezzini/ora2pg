-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_hash_licenca (nr_sequencia_p bigint,ie_tipo_licenca_p text,ie_opcao_p text,ds_erro_p INOUT text) AS $body$
DECLARE


/*
ie_tipo_licenca_p
N - Normal
E - Emergencia

ie_opcao_p
G - Gerar Licença
V - Validar hash licença

*/
ds_hash_w 		varchar(32);
cd_cnpj_w		varchar(15);
ds_conteudo_lic_w	varchar(2000);
ds_contador_w		integer;
ds_hash_calc_w		varchar(32);


C01 CURSOR FOR
SELECT 	cd_cnpj
FROM	com_licenca_estab
WHERE	nr_seq_licenca = nr_sequencia_p;
BEGIN
	IF ( ie_tipo_licenca_p ='N') THEN
		SELECT 	ie_tipo ||  qt_usuario || qt_usuario_adic || dt_validade || cd_licenca
		INTO STRICT	ds_conteudo_lic_w
		FROM 	com_licenca
		WHERE	nr_sequencia = nr_sequencia_p;

		OPEN C01;
		LOOP
		FETCH C01 INTO
			cd_cnpj_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		BEGIN
			ds_conteudo_lic_w := ds_conteudo_lic_w || cd_cnpj_w;
		END;
		END LOOP;
		CLOSE C01;
	ELSIF ( ie_tipo_licenca_p = 'E' ) THEN

		SELECT 	a.ie_tipo ||  a.qt_usuario || a.qt_usuario_adic || c.dt_validade || c.cd_licenca || b.cd_cnpj
		INTO STRICT	ds_conteudo_lic_w
		FROM 	com_licenca a,
			com_licenca_estab b,
			com_licenca_emerg c
		WHERE	c.nr_sequencia 		= nr_sequencia_p
		and	c.nr_seq_lic_estab 	= b.nr_sequencia
		and	b.nr_seq_licenca 	= a.nr_sequencia;


	END IF;

	ds_hash_w := RAWTOHEX(dbms_obfuscation_toolkit.md5(input => encode(ds_conteudo_lic_w::bytea, 'hex')::bytea));

	FOR contador_w IN REVERSE 16..1 LOOP
		ds_hash_calc_w := ds_hash_calc_w || SUBSTR(ds_hash_w,contador_w,1);
	END LOOP;
	FOR contador_w IN REVERSE 32..17 LOOP
		ds_hash_calc_w := ds_hash_calc_w || SUBSTR(ds_hash_w,contador_w,1);
	END LOOP;

	IF ( ie_opcao_p = 'G' ) THEN
		IF ( ie_tipo_licenca_p ='N' ) THEN
			update 	com_licenca
			set	ds_hash 	= ds_hash_calc_w
			where	nr_sequencia 	= nr_sequencia_p;
		ELSIF ( ie_tipo_licenca_p = 'E' ) THEN
			update 	com_licenca_emerg
			set	ds_hash 	= ds_hash_calc_w
			where	nr_sequencia 	= nr_sequencia_p;
		END IF;
		commit;
	ELSE
		IF ( ie_tipo_licenca_p ='N' ) THEN
			select 	ds_hash
			into STRICT		ds_hash_w
			from		com_licenca
			where		nr_sequencia 	= nr_sequencia_p;
		ELSIF ( ie_tipo_licenca_p = 'E' ) THEN
			select  	ds_hash
			into STRICT		ds_hash_w
			from		com_licenca_emerg
			where		nr_sequencia 	= nr_sequencia_p;
		END IF;

		IF ( ds_hash_w <>  ds_hash_calc_w ) THEN
			ds_erro_p := wheb_mensagem_pck.get_texto(279604);
		END IF;

	END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_hash_licenca (nr_sequencia_p bigint,ie_tipo_licenca_p text,ie_opcao_p text,ds_erro_p INOUT text) FROM PUBLIC;
