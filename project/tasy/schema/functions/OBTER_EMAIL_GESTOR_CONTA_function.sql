-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_email_gestor_conta ( nr_seq_ordem_serv_p bigint) RETURNS varchar AS $body$
DECLARE

	ds_retorno_w		varchar(4000);
	nr_seq_cliente_w	com_cliente.nr_sequencia%type;
	nm_usuario_gestor_w	varchar(100);
	

BEGIN

select	obter_usuario_gestor_conta(nr_seq_ordem_serv_p, 'S')
into STRICT	nm_usuario_gestor_w
;

select	coalesce(substr(obter_dados_usuario_opcao(nm_usuario_gestor_w,'E'),1,255),'X')
into STRICT	ds_retorno_w
;

return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_email_gestor_conta ( nr_seq_ordem_serv_p bigint) FROM PUBLIC;

