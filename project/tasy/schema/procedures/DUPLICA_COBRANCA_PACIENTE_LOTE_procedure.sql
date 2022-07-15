-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplica_cobranca_paciente_lote ( nr_seq_lote_p bigint, nm_usuario_p text, nr_seq_lote_novo_p INOUT bigint) AS $body$
DECLARE

ie_tipo_lote_w		varchar(1);
nr_titulo_w		bigint;
nr_conta_w		bigint;
nr_seq_lote_novo_w	bigint;

C01 CURSOR FOR 
SELECT	a.nr_titulo 
from	cobranca_paciente_titulo a 
where	a.nr_seq_lote = nr_seq_lote_p 
and	exists (	SELECT	1 
		from	titulo_receber b 
		where	a.nr_titulo = b.nr_titulo 
		and	b.ie_situacao not(2,3)) 
order by a.nr_titulo;

C02 CURSOR FOR 
SELECT	a.nr_interno_conta 
from	cobranca_paciente_conta a 
where	a.nr_seq_lote = nr_seq_lote_p 
and	exists (	SELECT	1 
		from	conta_paciente b 
		where	a.nr_interno_conta = b.nr_interno_conta) 
order by a.nr_interno_conta;


BEGIN 
 
select	coalesce(ie_tipo_lote,'') 
into STRICT	ie_tipo_lote_w 
from	cobranca_paciente_lote 
where	nr_sequencia = nr_seq_lote_p;
 
select	nextval('cobranca_paciente_lote_seq') 
into STRICT	nr_seq_lote_novo_w
;
 
insert	into cobranca_paciente_lote( 
	nr_sequencia, 
	cd_estabelecimento, 
	dt_atualizacao, 
	dt_atualizacao_nrec, 
	nm_usuario, 
	nm_usuario_nrec, 
	ie_tipo_lote, 
	ds_lote, 
	ie_status_lote, 
	nr_seq_historico) 
SELECT	nr_seq_lote_novo_w, 
	cd_estabelecimento, 
	clock_timestamp(), 
	clock_timestamp(), 
	nm_usuario_p, 
	nm_usuario_p, 
	ie_tipo_lote, 
	ds_lote, 
	'A', 
	nr_seq_historico 
from	cobranca_paciente_lote 
where	nr_sequencia = nr_seq_lote_p;
 
if (ie_tipo_lote_w = 'T') then 
	open C01;
	loop 
	fetch C01 into	 
		nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		CALL gravar_documentos_lote_cobr(	nr_seq_lote_novo_w, 
						nr_titulo_w, 
						'T', 
						nm_usuario_p);
		end;
	end loop;
	close C01;
	 
elsif (ie_tipo_lote_w = 'C') then 
 
	open C02;
	loop 
	fetch C02 into	 
		nr_conta_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		CALL gravar_documentos_lote_cobr(	nr_seq_lote_novo_w, 
						nr_conta_w, 
						'C', 
						nm_usuario_p);
		end;
	end loop;
	close C02;
 
end if;
 
nr_seq_lote_novo_p	:= nr_seq_lote_novo_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplica_cobranca_paciente_lote ( nr_seq_lote_p bigint, nm_usuario_p text, nr_seq_lote_novo_p INOUT bigint) FROM PUBLIC;

