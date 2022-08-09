-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_log_pessoa_terceiro (nr_seq_terceiro_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) AS $body$
DECLARE

 
nm_pessoa_fisica_w	varchar(60);
nm_terceiro_w		varchar(255);


BEGIN 
 
select	max(substr(obter_nome_pf(a.cd_pessoa_fisica), 1, 255)) 
into STRICT	nm_pessoa_fisica_w 
from	pessoa_fisica a 
where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p;
 
if (coalesce(nr_seq_terceiro_p,0) <> 0) then 
	nm_terceiro_w := substr(obter_nome_terceiro(nr_seq_terceiro_p),1,255);
end if;
 
insert	into fin_log_repasse(cd_log, 
	ds_log, 
	dt_atualizacao, 
	nm_usuario) 
values (1, 
	substr(wheb_mensagem_pck.get_texto(303970,'NM_PESSOA_FISICA=' || nm_pessoa_fisica_w || ';NM_TERCEIRO=' || nm_terceiro_w),1,2000), 
	clock_timestamp(), 
	nm_usuario_p);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_log_pessoa_terceiro (nr_seq_terceiro_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) FROM PUBLIC;
