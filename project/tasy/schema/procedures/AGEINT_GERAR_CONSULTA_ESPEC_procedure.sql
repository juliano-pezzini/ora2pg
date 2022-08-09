-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_gerar_consulta_espec ( cd_agenda_p bigint, cd_pessoa_fisica_p text, dt_agenda_p timestamp, ie_forma_apres_p text, ie_tipo_agendamento_p text, cd_setor_exclusivo_p bigint, cd_estabelecimento_p bigint, nr_seq_area_p bigint, nr_seq_grupo_p bigint, nm_usuario_p text, cd_especialidade_p bigint, ie_espec_adic_agenda_p text default 'N', ie_clear_agenda_p text default 'S') AS $body$
DECLARE

			
cd_tipo_agenda_w		integer;
cd_agenda_w				bigint;
cd_estabelecimento_w	bigint;
			
C01 CURSOR FOR
	SELECT	a.cd_agenda
	from	agenda a
	where	a.cd_tipo_agenda = cd_tipo_agenda_w
	and 	((a.cd_especialidade = cd_especialidade_p) or (ie_espec_adic_agenda_p = 'S' and cd_especialidade_p in (SELECT b.cd_especialidade
																												   from agenda_cons_especialidade b
																												   where a.cd_agenda = b.cd_agenda)))
	and 	a.ie_situacao = 'A';
	
C02 CURSOR FOR
	SELECT	cd_agenda
	from	agenda
	where	cd_tipo_agenda = cd_tipo_agenda_w
	and 	ie_situacao = 'A';

BEGIN

if (ie_tipo_agendamento_p = 'E') then
	cd_tipo_agenda_w	:= 2;
elsif (ie_tipo_agendamento_p = 'C') then
	cd_tipo_agenda_w	:= 3;
elsif (ie_tipo_agendamento_p = 'S') then
	cd_tipo_agenda_w	:= 5;
end if;	

if (coalesce(ie_clear_agenda_p,'S') = 'S') then
	delete	FROM ageint_consulta_hor_usu
	where	nm_usuario	= nm_usuario_p;
end if;

cd_estabelecimento_w := coalesce(cd_estabelecimento_p,obter_estabelecimento_ativo);

if (cd_agenda_p = 0 AND cd_especialidade_p IS NOT NULL AND cd_especialidade_p::text <> '') then
	open C01;
		loop
		fetch C01 into	
			cd_agenda_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			CALL Ageint_Gerar_Cons_Hora_html(cd_agenda_w, cd_pessoa_fisica_p, dt_agenda_p, ie_forma_apres_p, ie_tipo_agendamento_p, cd_setor_exclusivo_p, cd_estabelecimento_w, nr_seq_area_p, nr_seq_grupo_p, nm_usuario_p, cd_especialidade_p);
			end;
		end loop;
		close C01;
elsif (coalesce(cd_agenda_p,0) <> 0) or (coalesce(cd_especialidade_p,0) <> 0) or (coalesce(cd_Setor_exclusivo_p,0) <> 0) then
	CALL Ageint_Gerar_Cons_Hora_html(cd_agenda_p, cd_pessoa_fisica_p, dt_agenda_p, ie_forma_apres_p, ie_tipo_agendamento_p, cd_setor_exclusivo_p, cd_estabelecimento_w, nr_seq_area_p, nr_seq_grupo_p, nm_usuario_p, cd_especialidade_p);
elsif (coalesce(cd_agenda_p,0) = 0) and (coalesce(cd_especialidade_p,0) = 0) and (coalesce(cd_Setor_exclusivo_p,0) = 0) then
	for c02_w in c02 loop
		CALL Ageint_Gerar_Cons_Hora_html(c02_w.cd_agenda, cd_pessoa_fisica_p, dt_agenda_p, ie_forma_apres_p, ie_tipo_agendamento_p, cd_setor_exclusivo_p, cd_estabelecimento_w, nr_seq_area_p, nr_seq_grupo_p, nm_usuario_p, cd_especialidade_p);
	end loop;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_gerar_consulta_espec ( cd_agenda_p bigint, cd_pessoa_fisica_p text, dt_agenda_p timestamp, ie_forma_apres_p text, ie_tipo_agendamento_p text, cd_setor_exclusivo_p bigint, cd_estabelecimento_p bigint, nr_seq_area_p bigint, nr_seq_grupo_p bigint, nm_usuario_p text, cd_especialidade_p bigint, ie_espec_adic_agenda_p text default 'N', ie_clear_agenda_p text default 'S') FROM PUBLIC;
