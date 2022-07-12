-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verifica_permissao_perfil (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(10) := 'N';
ie_permissao_w varchar(10) := null;

c01 CURSOR FOR
SELECT 	ie_permissao
from	protocolo_integrado_lib
where	nr_seq_protocolo_integrado = nr_sequencia_p
and		((cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento)
		 or (cd_especialidade in (select cd_especialidade
									  from medico_especialidade
									  where cd_pessoa_fisica = obter_pf_usuario(wheb_usuario_pck.get_nm_usuario, 'C')))
		 or (cd_perfil = wheb_usuario_pck.get_cd_perfil)
		 or 	(cd_time in (select 	nr_sequencia
														from	protocolo_integrado_time a
														where 	a.nr_sequencia = cd_time
														and 	a.dt_liberacao <= clock_timestamp()
														and (a.dt_validade >= clock_timestamp() or coalesce(a.dt_validade::text, '') = '')
														and exists (select 1
																	from protocolo_integrado_partic b
																	where b.nr_seq_equipe = a.nr_sequencia
																	and b.cd_pessoa_fisica = obter_pf_usuario(wheb_usuario_pck.get_nm_usuario, 'C')
																	and ((coalesce(dt_validade::text, '') = '') or (dt_validade > clock_timestamp()))
																	and (dt_liberacao < clock_timestamp())))));

ie_consultation_w varchar(5) := 'N';
ie_review_w varchar(5) := 'N';
ie_request_w varchar(5) := 'N';
ie_suspend_w varchar(5) := 'N';
ie_edit_w varchar(5) := 'N';


BEGIN
	open c01;
		loop
			fetch c01 into	
				ie_permissao_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */	

			if (ie_permissao_w = 'C') then
				ie_consultation_w := 'S';
			elsif (ie_permissao_w = 'R') then
				ie_review_w := 'S';
			elsif (ie_permissao_w = 'A') then
				ie_request_w := 'S';
			elsif (ie_permissao_w = 'S') then
				ie_suspend_w := 'S';
			elsif (ie_permissao_w = 'E') then
				ie_edit_w := 'S';
			end if;

		end loop;
	close c01;

	if (ie_consultation_w = 'S') then
		ds_retorno_w := ds_retorno_w || 'C';
	end if;
	if (ie_review_w = 'S') then
		ds_retorno_w := ds_retorno_w || 'R';
	end if;
	if (ie_request_w = 'S') then
		ds_retorno_w := ds_retorno_w || 'A';
	end if;
	if (ie_suspend_w = 'S') then
		ds_retorno_w := ds_retorno_w || 'S';
	end if;
	if (ie_edit_w = 'S') then
		ds_retorno_w := ds_retorno_w || 'X';
	end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verifica_permissao_perfil (nr_sequencia_p bigint) FROM PUBLIC;
