-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_retirar_concentrado (nr_seq_maquina_p bigint, nr_seq_ponto_acesso_p bigint, nm_usuario_p text, ie_assinar_p text default 'S') AS $body$
DECLARE

 
qt_itens_w			bigint;
nr_seq_dialise_w		hd_dialise_concentrado.nr_seq_dialise%type;
nr_seq_concentrado_ret_w	hd_dialise_concentrado.nr_sequencia%type;
nr_lista_concentrado_ret_w	varchar(2000);

c01 CURSOR FOR 
	SELECT	nr_sequencia, 
		nr_seq_dialise 
	from	hd_dialise_concentrado 
	where	nr_sequencia in (	 
				SELECT nr_sequencia 
				from 	hd_dialise_concentrado 
				where 	nr_seq_maquina		= nr_seq_maquina_p 
				and	nr_seq_ponto_acesso	= nr_seq_ponto_acesso_p 
				and	coalesce(dt_retirada::text, '') = '');
				

BEGIN 
 
select 	count(*) 
into STRICT	qt_itens_w 
from	HD_DIALISE_CONCENTRADO 
where	nr_seq_maquina		=	nr_seq_maquina_p 
and	nr_seq_ponto_acesso	=	nr_seq_ponto_acesso_p 
and	coalesce(dt_retirada::text, '') = '';
 
if (qt_itens_w = 0) then 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(264176);
end if;
 
open	c01;
loop 
fetch	c01 into 
	nr_seq_concentrado_ret_w, 
	nr_seq_dialise_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
 
	if (coalesce(nr_lista_concentrado_ret_w::text, '') = '') then 
		nr_lista_concentrado_ret_w 	:= to_char(nr_seq_concentrado_ret_w);
	elsif (length(nr_lista_concentrado_ret_w || ',' || to_char(nr_seq_concentrado_ret_w)) < 2000) then 
		nr_lista_concentrado_ret_w 	:= nr_lista_concentrado_ret_w || ',' || to_char(nr_seq_concentrado_ret_w);
	end if;
	 
end loop;
close c01;
 
update	HD_DIALISE_CONCENTRADO 
set	dt_retirada 		= clock_timestamp(), 
	cd_pf_retirada		= substr(obter_pessoa_fisica_usuario(nm_usuario_p,'C'),1,10) 
where	nr_seq_maquina		= nr_seq_maquina_p 
and	nr_seq_ponto_acesso	= nr_seq_ponto_acesso_p 
and	coalesce(dt_retirada::text, '') = '';
 
if (ie_assinar_p = 'S') then	 
	CALL hd_gerar_assinatura(null, null, nr_seq_dialise_w, null, null, null, null, nr_lista_concentrado_ret_w, null, 'RC', nm_usuario_p, 'N');
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_retirar_concentrado (nr_seq_maquina_p bigint, nr_seq_ponto_acesso_p bigint, nm_usuario_p text, ie_assinar_p text default 'S') FROM PUBLIC;

