-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_dados_envio_fpo_dt (nr_seq_protocolo_p bigint) RETURNS timestamp AS $body$
DECLARE


ds_retorno_w		timestamp;
nm_usuario_w		varchar(15);
dt_atualizacao_w		timestamp;
ie_opcao_w		varchar(15)	:= 'D';



BEGIN

begin
select	max(dt_atualizacao)
into STRICT	dt_atualizacao_w
from	w_interf_sus_fpo_unif
where	nr_seq_protocolo = nr_seq_protocolo_p;
exception
when others then
	ie_opcao_w	:= 'X';
end;
if (ie_opcao_w	= 'D') then
	ds_retorno_w	:= dt_atualizacao_w;
END IF;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_dados_envio_fpo_dt (nr_seq_protocolo_p bigint) FROM PUBLIC;
