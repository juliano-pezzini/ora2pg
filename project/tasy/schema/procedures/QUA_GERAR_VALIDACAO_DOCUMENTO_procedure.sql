-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_gerar_validacao_documento ( nr_seq_docto_p bigint, cd_pessoa_validacao_p text, dt_validacao_p timestamp, nm_usuario_p text) AS $body$
DECLARE

 
qt_existe_w		integer;
qt_existe_usu_valid_w 	integer;
nr_seq_valid_w		bigint;
cd_pessoa_doc_w		varchar(10);
cd_estabelecimento_w	smallint;
cd_cargo_w		bigint;
nr_seq_ordem_w		bigint;
nm_user_w		varchar(50);


BEGIN 
 
select 	substr(qua_obter_os_origem(nr_seq_docto_p), 1, 10) 
into STRICT	nr_seq_ordem_w
;
 
select	count(*) 
into STRICT	qt_existe_w 
from	qua_doc_validacao 
where	nr_seq_doc		= nr_seq_docto_p 
and	coalesce(dt_validacao::text, '') = '';
 
select	cd_estabelecimento 
into STRICT	cd_estabelecimento_w 
from	qua_documento 
where	nr_sequencia = nr_seq_docto_p;
 
select	max(a.cd_cargo) 
into STRICT	cd_cargo_w 
from	pessoa_fisica a, 
	usuario b 
where	a.cd_pessoa_fisica 	= b.cd_pessoa_fisica 
and	b.nm_usuario 	= nm_usuario_p;
 
select	username 
into STRICT	nm_user_w 
from	user_users;
 
/*Se não existir mais de um validador faz o processo normal*/
 
if (qt_existe_w = 0) then 
	begin 
	update	qua_documento 
	set	dt_atualizacao		= clock_timestamp(), 
		nm_usuario		= nm_usuario_p, 
		dt_validacao		= dt_validacao_p, 
		ie_status			= 'V', 
		nm_usuario_aprov		= nm_usuario_p 
	where	nr_sequencia 		= nr_seq_docto_p;
	end;
else 
	begin 
	/*Se existir mais de um validador, busca a sequencia de validação da pessoa que está validando*/
 
	select	count(*), 
		max(nr_sequencia) 
	into STRICT	qt_existe_w, 
		nr_seq_valid_w 
	from	qua_doc_validacao 
	where	nr_seq_doc		= nr_seq_docto_p 
	and	((cd_pessoa_validacao	= cd_pessoa_validacao_p) or (cd_cargo		= cd_cargo_w)) 
	and	coalesce(dt_validacao::text, '') = '';
	 
	if (qt_existe_w > 0) and (coalesce(nr_seq_valid_w,0) > 0) then 
		update	qua_doc_validacao 
		set	dt_atualizacao	= clock_timestamp(), 
			nm_usuario	= nm_usuario_p, 
			dt_validacao	= dt_validacao_p 
		where	nr_sequencia 	= nr_seq_valid_w;
		 
		/*Vê se existe alguma validação pendente ainda, senão, valida o documento*/
 
		select	count(*) 
		into STRICT	qt_existe_w 
		from	qua_doc_validacao 
		where	nr_seq_doc	= nr_seq_docto_p 
		and	coalesce(dt_validacao::text, '') = '';
		 
		select	count(*) 
		into STRICT 	qt_existe_usu_valid_w 
		from 	qua_documento 
		where 	nr_sequencia = nr_seq_docto_p 
		and 	coalesce(dt_validacao::text, '') = '' 
		and 	cd_pessoa_validacao = cd_pessoa_validacao_p;
 
		if (qt_existe_w = 0) and ((qt_existe_usu_valid_w > 0) or (nm_user_w != 'CORP'))then 
			begin 
			update	qua_documento 
			set	dt_atualizacao		= clock_timestamp(), 
				nm_usuario		= nm_usuario_p, 
				dt_validacao		= dt_validacao_p, 
				ie_status			= 'V', 
				nm_usuario_aprov		= nm_usuario_p 
			where	nr_sequencia 		= nr_seq_docto_p;
 
			CALL qua_gerar_envio_comunicacao(nr_seq_docto_p, '0', nm_usuario_p, '9', cd_estabelecimento_w, null, null, 'N');
			end;
		end if;
	end if;	
	end;	
end if;
 
if (qt_existe_w = 0 and (nr_seq_ordem_w IS NOT NULL AND nr_seq_ordem_w::text <> ''))then 
	CALL Qua_Inserir_Hist_Validacao(nm_usuario_p, wheb_mensagem_pck.get_texto(669984), nr_seq_ordem_w);
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_gerar_validacao_documento ( nr_seq_docto_p bigint, cd_pessoa_validacao_p text, dt_validacao_p timestamp, nm_usuario_p text) FROM PUBLIC;

