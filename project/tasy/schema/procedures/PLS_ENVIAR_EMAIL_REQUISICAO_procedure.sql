-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_enviar_email_requisicao ( nr_seq_requisicao_p bigint, ie_tipo_p bigint, nr_seq_regra_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*
IE_TIPO_P
   1 - Envio do e-mail para os auditories estipulantes

*/
ds_email_dest_w			varchar(150);
ds_email_remetente_w		varchar(150);
cd_cgc_estipulante_w		varchar(15);
cd_pf_estipulante_w		varchar(15);
ds_texto_email_w		varchar(4000);
cd_estabelecimento_w		bigint;
nr_seq_segurado_w		bigint;
nr_seq_contrato_w		bigint;
nr_seq_intercambio_w		bigint;
ie_tipo_segurado_w		varchar(10);
ds_assunto_w			varchar(255);
nr_seq_pessoa_juridica_compl_w	pessoa_juridica_compl.nr_sequencia%type;


BEGIN

/* Obter dados da requisicao*/

begin
select	nr_seq_segurado,
	cd_estabelecimento
into STRICT	nr_seq_segurado_w,
	cd_estabelecimento_w
from	pls_requisicao
where	nr_sequencia	= nr_seq_requisicao_p;
exception
when others then
	nr_seq_segurado_w	:= 0;
end;

/* Obter dados do segurado */

begin
select	ie_tipo_segurado,
	nr_seq_contrato,
	nr_seq_intercambio
into STRICT	ie_tipo_segurado_w,
	nr_seq_contrato_w,
	nr_seq_intercambio_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_w;
exception
when others then
	ie_tipo_segurado_w	:= 'P';
end;

if (ie_tipo_p = 1) then
	if (ie_tipo_segurado_w <> 'P') then
		begin
		if (coalesce(nr_seq_contrato_w,0) > 0) then
			select	cd_cgc_estipulante,
				cd_pf_estipulante
			into STRICT	cd_cgc_estipulante_w,
				cd_pf_estipulante_w
			from	pls_contrato
			where	nr_sequencia		= nr_seq_contrato_w;
		elsif (coalesce(nr_seq_intercambio_w,0) > 0) then
			select	cd_cgc,
				cd_pessoa_fisica
			into STRICT	cd_cgc_estipulante_w,
				cd_pf_estipulante_w
			from	pls_intercambio
			where	nr_sequencia		= nr_seq_intercambio_w;
		end if;
		exception
		when others then
			cd_cgc_estipulante_w := '';
			cd_pf_estipulante_w := '';
		end;

		/*begin
		select	max(ds_email)
		into	ds_email_dest_w
		from	pls_contrato_contato
		where	nr_seq_contrato = nr_seq_contrato_w;
		exception
		when others then
			ds_email_dest_w := '';
		end;*/
		--if	(nvl(ds_email_dest_w,'0') =  '0') then
			if (coalesce(cd_cgc_estipulante_w,'0') <> '0') then
				begin
					select	max(nr_sequencia)
					into STRICT	nr_seq_pessoa_juridica_compl_w
					from	pessoa_juridica_compl
					where	cd_cgc	= cd_cgc_estipulante_w
					and	ie_tipo_complemento = 3;
				exception
				when others then
					nr_seq_pessoa_juridica_compl_w	:= null;
				end;

				if (coalesce(nr_seq_pessoa_juridica_compl_w::text, '') = '') then
					begin
						select	max(nr_sequencia)
						into STRICT	nr_seq_pessoa_juridica_compl_w
						from	pessoa_juridica_compl
						where	cd_cgc	= cd_cgc_estipulante_w;
					exception
					when others then
						nr_seq_pessoa_juridica_compl_w	:= null;
					end;
				end if;

				begin
					select	substr(ds_email,1,150)
					into STRICT	ds_email_dest_w
					from	pessoa_juridica_compl
					where	cd_cgc		= cd_cgc_estipulante_w
					and	nr_sequencia 	= nr_seq_pessoa_juridica_compl_w;
				exception
				when others then
					ds_email_dest_w := '';
				end;
			elsif (coalesce(cd_pf_estipulante_w,'0') <> '0') then
				begin
					select	ds_email
					into STRICT	ds_email_dest_w
					from	compl_pessoa_fisica
					where	cd_pessoa_fisica = cd_pf_estipulante_w
					and	ie_tipo_complemento = 1;
				exception
				when others then
					ds_email_dest_w := '';
				end;
			end if;
		--end if;
		ds_email_remetente_w :=	pls_obter_dados_outorgante(cd_estabelecimento_w,'EM');

		--insert into alexandre (ds_texto) values (ds_assunto_w ||' - '||ds_texto_email_w||' - '||ds_email_remetente_w||' - '||ds_email_dest_w||' - ');
		if (coalesce(ds_email_dest_w,'0') <> '0') and (coalesce(ds_email_remetente_w,'0') <> '0') then
			begin
			select	ds_assunto,
				ds_email
			into STRICT	ds_assunto_w,
				ds_texto_email_w
			from	pls_tipo_pos_estabelecido
			where	nr_sequencia	= nr_seq_regra_p;
			exception
			when others then
				ds_assunto_w	 := 'X';
				ds_texto_email_w := 'X';
			end;

			if (ds_assunto_w <> 'X') and (ds_texto_email_w <> 'X') then
				CALL enviar_email(	ds_assunto_w,
						ds_texto_email_w,
						ds_email_remetente_w,
						ds_email_dest_w,
						nm_usuario_p,
						'M');
			end if;
		end if;
	end if;
end if;

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_enviar_email_requisicao ( nr_seq_requisicao_p bigint, ie_tipo_p bigint, nr_seq_regra_p bigint, nm_usuario_p text) FROM PUBLIC;

