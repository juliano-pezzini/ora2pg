-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_acesso_processo ( nr_seq_processo_p bigint, nr_seq_area_prep_p bigint, nm_usuario_p text) AS $body$
DECLARE

		 
nr_sequencia_w		bigint;
ds_usuario_w		varchar(255);

BEGIN
 
select 	coalesce(max(nr_sequencia),0) 
into STRICT	nr_sequencia_w 
from	adep_processo_controle 
where	nr_seq_processo = nr_seq_processo_p 
and		nm_usuario <> nm_usuario_p 
and		nr_seq_area_prep = nr_seq_area_prep_p 
and		dt_inicio > clock_timestamp() - interval '15 days'/1440;
 
if (nr_sequencia_w > 0) then 
 
	select 	max(SUBSTR(OBTER_NOME_PF(c.cd_pessoa_fisica), 0, 255)) 
	into STRICT	ds_usuario_w 
	from	adep_processo_controle a, 
			usuario b, 
			pessoa_fisica c 
	where	a.nm_usuario = b.nm_usuario 
	and		b.cd_pessoa_fisica = c.cd_pessoa_fisica 
	and		a.nr_seq_processo = nr_seq_processo_p 
	and		a.nm_usuario <> nm_usuario_p 
	and		a.nr_seq_area_prep = nr_seq_area_prep_p 
	and		a.nr_sequencia = nr_sequencia_w;
	 
	--O usuário #@DS_USUARIO#@ está Separando este processo! 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(297204,'DS_USUARIO='||ds_usuario_w);
	 
else 
	 
	select	nextval('adep_processo_controle_seq') 
	into STRICT	nr_sequencia_w 
	;
	 
	insert into adep_processo_controle( 
				nr_sequencia, 
				dt_inicio, 
				nm_usuario, 
				nr_seq_area_prep, 
				nr_seq_processo) 
			values ( 
				nr_sequencia_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_seq_area_prep_p, 
				nr_seq_processo_p);
	 
	commit;
	 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_acesso_processo ( nr_seq_processo_p bigint, nr_seq_area_prep_p bigint, nm_usuario_p text) FROM PUBLIC;
