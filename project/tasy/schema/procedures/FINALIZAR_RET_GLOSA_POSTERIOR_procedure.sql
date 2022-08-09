-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE finalizar_ret_glosa_posterior (nr_seq_retorno_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ds_erro_w	varchar(255);


BEGIN 
 
CALL consistir_retorno_convenio(nr_seq_retorno_p,nm_usuario_p,'N','N');
 
ds_erro_w := baixa_titulo_convenio(nr_seq_retorno_p, nm_usuario_p, null, ds_erro_w, null, null, 'N', null, null);
 
update	convenio_retorno 
set	dt_fim_glosa	= clock_timestamp(), 
	ie_tipo_glosa	= 'P' 
where	nr_sequencia	= nr_seq_retorno_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE finalizar_ret_glosa_posterior (nr_seq_retorno_p bigint, nm_usuario_p text) FROM PUBLIC;
