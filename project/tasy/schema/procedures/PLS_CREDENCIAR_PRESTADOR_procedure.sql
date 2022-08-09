-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_credenciar_prestador ( nr_seq_prestador_p bigint, ie_tipo_prestador_p bigint, nm_usuario_p text, dt_credenciamento_p timestamp, ds_erro_p INOUT text) AS $body$
DECLARE

			 
/* IE_TIPO_P 
	1 - PLS_PRESTADOR 
	2 - PLS_PRESTADOR_MEDICO 
*/
 
 
ds_erro_w		varchar(255)	:= '';
nr_seq_prestador_w	bigint;
nr_seq_prest_medico_w	bigint;
cd_pessoa_fisica_w	varchar(10);
nm_pessoa_fisica_w	varchar(60);
cd_estabelecimento_w	smallint;
nr_seq_prestador_hist_w	bigint := '';


BEGIN 
 
if (ie_tipo_prestador_p	= 1) then 
	/* Obter o profissional da PLS_PRESTADOR */
 
	select	cd_pessoa_fisica, 
		substr(obter_nome_pf(cd_pessoa_fisica),1,60), 
		nr_sequencia 
	into STRICT	cd_pessoa_fisica_w, 
		nm_pessoa_fisica_w, 
		nr_seq_prestador_hist_w 
	from	pls_prestador 
	where	nr_sequencia	= nr_seq_prestador_p;
elsif (ie_tipo_prestador_p	= 2) then 
	/* Obter o profissional da PLS_PRESTADOR_MEDICO */
 
	select	cd_medico, 
		substr(obter_nome_pf(cd_medico),1,60), 
		nr_seq_prestador 
	into STRICT	cd_pessoa_fisica_w, 
		nm_pessoa_fisica_w, 
		nr_seq_prestador_hist_w 
	from	pls_prestador_medico 
	where	nr_sequencia	= nr_seq_prestador_p;
end if;
/* 
alterração feita pelo usuario: cabelli 
N° Ordem: 218456 
 
select	nvl(max(nr_sequencia),0) 
into	nr_seq_prestador_w 
from	pls_prestador 
where	cd_pessoa_fisica	= cd_pessoa_fisica_w 
and	ie_tipo_vinculo		= 'C'; 
 
select	nvl(max(nr_seq_prestador),0) 
into	nr_seq_prest_medico_w 
from	pls_prestador_medico 
where	cd_medico		= cd_pessoa_fisica_w 
and	ie_tipo_vinculo		= 'C'; 
 
if	(nr_seq_prestador_w	> 0) then 
	ds_erro_w	:= wheb_mensagem_pck.get_texto(280352, 'NM_PESSOA_FISICA_P=' || nm_pessoa_fisica_w || 
					';CD_PESSOA_FISICA_P=' || cd_pessoa_fisica_w || 
					';NR_SEQ_PRESTADOR_P=' || nr_seq_prestador_w); 
elsif	(nr_seq_prest_medico_w	> 0) then 
	ds_erro_w	:= wheb_mensagem_pck.get_texto(280352, 'NM_PESSOA_FISICA_P=' || nm_pessoa_fisica_w || 
					';CD_PESSOA_FISICA_P=' || cd_pessoa_fisica_w || 
					';NR_SEQ_PRESTADOR_P=' || nr_seq_prest_medico_w); 
else 
*/
 
	if (ie_tipo_prestador_p	= 1) then 
		update	pls_prestador 
		set	ie_tipo_vinculo	= 'C', 
			nm_usuario	= nm_usuario_p, 
			dt_atualizacao	= clock_timestamp() 
		where	nr_sequencia	= nr_seq_prestador_p 
		and	(cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '');
		 
		CALL pls_altera_vinculo_prof(nr_seq_prestador_p,'C');
		 
	elsif (ie_tipo_prestador_p	= 2) then 
		update	pls_prestador_medico 
		set	ie_tipo_vinculo	= 'C', 
			nm_usuario	= nm_usuario_p, 
			dt_atualizacao	= clock_timestamp() 
		where	nr_sequencia	= nr_seq_prestador_p;
	end if;
	 
	/* Obter o estabelecimento do prestador */
 
	select	coalesce(max(cd_estabelecimento),1) 
	into STRICT	cd_estabelecimento_w 
	from	pls_prestador 
	where	nr_sequencia	= nr_seq_prestador_hist_w;
	 
	/* Gravar histórico da ação */
 
	insert into pls_credenciamento_hist(nr_sequencia, 
		cd_estabelecimento, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_seq_prestador, 
		cd_pessoa_fisica, 
		ie_tipo_historico, 
		dt_historico) 
	values (	nextval('pls_credenciamento_hist_seq'), 
		cd_estabelecimento_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_seq_prestador_hist_w, 
		cd_pessoa_fisica_w, 
		'C', 
		dt_credenciamento_p);
	 
	commit;
--end if; 
 
ds_erro_p	:= ds_erro_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_credenciar_prestador ( nr_seq_prestador_p bigint, ie_tipo_prestador_p bigint, nm_usuario_p text, dt_credenciamento_p timestamp, ds_erro_p INOUT text) FROM PUBLIC;
