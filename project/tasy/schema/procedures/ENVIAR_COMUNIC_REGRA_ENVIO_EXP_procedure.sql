-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_comunic_regra_envio_exp () AS $body$
DECLARE

 
ds_usuario_envio_w		varchar(255);
cd_setor_atendimento_w		integer;
ie_situacao_w			varchar(1);
ie_geral_w			varchar(20):= 'N';
nm_pessoa_fisica_w		varchar(255) := '';
nm_pessoa_fisica_ww		varchar(2000) := '';

c01 CURSOR FOR 
	SELECT	replace(ds_usuario_envio,';',',')||',', 
		cd_setor_atendimento 
	from	regra_envio_experiencia_pf 
	where	ie_situacao = 'A';
	
c02 CURSOR FOR 
	SELECT	substr(obter_nome_pf(cd_pessoa_fisica),1,255) 
	from	pessoa_fisica 
	where	trunc(dt_fim_experiencia) = trunc(clock_timestamp() + interval '5 days') 
	or	trunc(dt_fim_prorrogacao) = trunc(clock_timestamp() + interval '5 days');

BEGIN
 
open c01;
loop 
fetch c01 into 
	ds_usuario_envio_w, 
	cd_setor_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	 
	open c02;
	loop 
	fetch c02 into 
		nm_pessoa_fisica_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin 
		 
		nm_pessoa_fisica_ww := nm_pessoa_fisica_ww || chr(13) || chr(10) || nm_pessoa_fisica_w;
		 
		end;
	end loop;
	close c02;
	 
	 
	 
	if (nm_pessoa_fisica_ww IS NOT NULL AND nm_pessoa_fisica_ww::text <> '') then 
		if (coalesce(cd_setor_atendimento_w::text, '') = '') and (ds_usuario_envio_w = ',') then 
			ie_geral_w := 'S';
		end if;
		 
		if	((coalesce(cd_setor_atendimento_w,0) <> 0) or (coalesce(ds_usuario_envio_w,'X') <> 'X')) then 
			CALL gerar_comunic_padrao(	clock_timestamp(), 
						--'Fim da experiência de funcionário(s)' 
						wheb_mensagem_pck.get_texto(298670), 
						--'Informamos que o período de experiência do(s) funcionário(s) abaixo irá expirar em 5 dias: ' 
						wheb_mensagem_pck.get_texto(298681) ||chr(13)||chr(10)||nm_pessoa_fisica_ww, 
						'Tasy', 
						ie_geral_w, 
						ds_usuario_envio_w, 
						'N', 
						null, 
						null, 
						wheb_usuario_pck.get_cd_estabelecimento, 
						cd_setor_atendimento_w||',', 
						clock_timestamp(), 
						null, 
						null);
		end if;
	end if;
	end;
end loop;
close c01;
 
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_comunic_regra_envio_exp () FROM PUBLIC;
