-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_categ_conv_protocolo ( NR_SEQ_PROTOCOLO_P bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(100);


BEGIN 
 
select	substr(obter_categoria_convenio(CD_CONVENIO_PARAMETRO,CD_CATEGORIA_PARAMETRO),1,100) 
into STRICT	ds_retorno_w 
from	conta_paciente 
where	nr_interno_conta = 	(SELECT	max(nr_interno_conta) 
				from	conta_paciente 
				where	nr_seq_protocolo = nr_seq_protocolo_p);
 
RETURN ds_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_categ_conv_protocolo ( NR_SEQ_PROTOCOLO_P bigint) FROM PUBLIC;
