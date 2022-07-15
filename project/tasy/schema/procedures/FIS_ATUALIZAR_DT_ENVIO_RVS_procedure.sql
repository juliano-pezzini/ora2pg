-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_atualizar_dt_envio_rvs ( nm_usuario_p text, nr_sequencia_p bigint) AS $body$
DECLARE


cd_moeda_w		moeda.cd_moeda%type;
qt_registro_w		smallint;


BEGIN

select	max(cd_moeda)
into STRICT	cd_moeda_w
from	siscoserv_rvs
where	nr_sequencia = nr_sequencia_p;

if (coalesce(cd_moeda_w,0) = 0) then
	begin
	-- Deve ser informado a moeda para enviar o RVS!
	CALL wheb_mensagem_pck.exibir_mensagem_abort(338556,'NR_SEQ_RVS=' || nr_sequencia_p);
	end;
end if;

begin
select	1
into STRICT	qt_registro_w
from	siscoserv_rvs_operacao a
where	a.nr_seq_rvs = nr_sequencia_p  LIMIT 1;
exception
when others then
	qt_registro_w := 0;
end;
if (qt_registro_w = 0) then
	begin
	-- Deve ser informado pelo menos uma operação NBS para o cada RVS!
	-- RVS: #@NR_SEQ_RVS#@
	CALL wheb_mensagem_pck.exibir_mensagem_abort(338550,'NR_SEQ_RVS=' || nr_sequencia_p);
	end;
end if;

update	siscoserv_rvs
set	dt_atualizacao = clock_timestamp(),
	dt_envio = clock_timestamp(), -- Campo tirado fora
	dt_geracao = clock_timestamp(),
	nm_usuario = nm_usuario_p
where	nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_atualizar_dt_envio_rvs ( nm_usuario_p text, nr_sequencia_p bigint) FROM PUBLIC;

