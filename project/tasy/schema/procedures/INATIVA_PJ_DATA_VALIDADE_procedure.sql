-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inativa_pj_data_validade () AS $body$
DECLARE


type cd_cgc_t 		is table of pessoa_juridica.cd_cgc%type;
type ds_razao_social_t 	is table of pessoa_juridica.ds_razao_social%type;

nm_usuario_w 		regra_envio_email_inat_pj.nm_usuario%type;
cd_perfil_w 		regra_envio_email_inat_pj.cd_perfil%type;
cd_pessoa_fisica_w 	regra_envio_email_inat_pj.cd_pessoa_fisica%type;
cd_estabelecimento_w 	regra_envio_email_inat_pj.cd_estabelecimento%type;
email_origem_w        usuario.ds_email%type;
email_destino_w 	varchar(255);
ds_assunto_w		varchar(50);
mensagem_w 		varchar(4000);
cd_cgc_w		cd_cgc_t;
ds_razao_social_w	ds_razao_social_t;

c1 CURSOR FOR
SELECT distinct cd_estabelecimento
from regra_envio_email_inat_pj;

c2 CURSOR(cd_perfil_p  usuario_perfil.cd_perfil%type) FOR
SELECT u.ds_email
from   usuario u,
       usuario_perfil p
where  u.nm_usuario = p.nm_usuario
and    p.cd_perfil  = cd_perfil_p;

c3 CURSOR FOR
SELECT	cd_cgc, ds_razao_social
from	pessoa_juridica
where	(dt_validade_pj IS NOT NULL AND dt_validade_pj::text <> '')
and	dt_validade_pj 	<= clock_timestamp()
and	ie_situacao 	<> 'I';
BEGIN
	ds_assunto_w := wheb_mensagem_pck.get_texto(1148113);
	mensagem_w   := wheb_mensagem_pck.get_texto(1148110) || chr(10);

	open c3;
	loop
	fetch c3
	bulk collect into cd_cgc_w, ds_razao_social_w
	limit 500;
	exit when cd_cgc_w.count = 0;
		begin
		forall i in 1 .. cd_cgc_w.count save exceptions
			update  pessoa_juridica
			set     ie_situacao 	= 'I',
				dt_atualizacao 	= clock_timestamp(),
				nm_usuario 	= 'Tasy'
			where   cd_cgc 		= cd_cgc_w(i);
		exception
			when others then
				for i in 1 .. sql%bulk_exceptions.count
				loop
					RAISE NOTICE '%: %',
					    sql%bulk_exceptions[i].error_index, sql%bulk_exceptions[i].error_code
					;
				end loop;
		end;
		
		for i in 1 .. ds_razao_social_w.count
		loop
			mensagem_w := mensagem_w || chr(10) || '- ' || ds_razao_social_w(i);
		end loop;
	end loop;
	
	open c1;
	loop
	fetch c1 into cd_estabelecimento_w;
	EXIT WHEN NOT FOUND; /* apply on c1 */
		begin
			select 	 u.nm_usuario,
				 r.cd_perfil,
				 r.cd_pessoa_fisica,
				 u.ds_email
			into STRICT   	 nm_usuario_w,
				 cd_perfil_w,
				 cd_pessoa_fisica_w,
				 email_origem_w
			from   	 regra_envio_email_inat_pj r,
				 usuario u
			where  	 r.ie_situacao 		= 'A'
			and    	 r.cd_estabelecimento 	= cd_estabelecimento_w
			and    	 r.nm_usuario 		= u.nm_usuario
			order by r.nr_sequencia desc LIMIT 1;

			if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
				select max(ds_email)
				into STRICT   email_destino_w
				from   compl_pessoa_fisica
				where  cd_pessoa_fisica = cd_pessoa_fisica_w
				and    ie_tipo_complemento in (1, 2, 8, 9);

				CALL enviar_email(
				  ds_assunto_w,
				  mensagem_w,
				  email_origem_w,
				  email_destino_w,
				  nm_usuario_w,
				  'M'
				);

				select nm_usuario_princ_ci
				into STRICT   nm_usuario_w
				from   pessoa_fisica
				where  cd_pessoa_fisica = cd_pessoa_fisica_w;
        
				if (coalesce(nm_usuario_w::text, '') = '') then
					select max(nm_usuario)
					into STRICT   nm_usuario_w
					from   usuario
					where  cd_pessoa_fisica = cd_pessoa_fisica_w;
				end if;

				insert into comunic_interna(
				       dt_comunicado,	
				       ds_titulo,	
				       ds_comunicado,	
				       nm_usuario,
				       dt_atualizacao,	
				       ie_geral,	
				       nr_sequencia, 
				       ie_gerencial,
				       dt_liberacao,
				       nm_usuario_destino)
				values (clock_timestamp(),	
				       ds_assunto_w,
				       mensagem_w,	
				       nm_usuario_w,
				       clock_timestamp(),	
				       'N',	
				       nextval('comunic_interna_seq'),
				       'N',	
				       clock_timestamp(),
				       nm_usuario_w);
			else if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') then
				open c2(cd_perfil_w);
				loop
				fetch c2 into email_destino_w;
				EXIT WHEN NOT FOUND; /* apply on c2 */
					begin
					    CALL enviar_email(
					      ds_assunto_w,
					      mensagem_w,
					      email_origem_w,
					      email_destino_w,
					      nm_usuario_w,
					      'M'
					    );
					end;
				end loop;
				close c2;
			end if;
			end if;
		end;
	end loop;
	close c1;

	commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inativa_pj_data_validade () FROM PUBLIC;
